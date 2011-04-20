###
Bettertabs jQuery plugin v0.1

jQuery(selector).bettertabs(); adds javascript to change content when click on tabs.

Markup needed, the same that is generated by the rails bettertabs helper, added by the bettertabs plugin
   https://github.com/agoragames/bettertabs

Events: Each time a tab is selected, some events are fired, so you can easily activate
    behavior from another jquery script (using .bind); The available events are:
          'bettertabs-before-deactivate': fired on the tab or content that is active and will be deactivated
          'bettertabs-before-activate': fired on the tab or content that will be activated
          'bettertabs-after-deactivate': fired on the tab or content that was deactivated
          'bettertabs-after-activate': fired on the tab or content that was activated

###

$ = jQuery

tab_type_attr = 'data-tab-type' # attribute on tab links that indicate the tab type
show_content_id_attr = 'data-show-content-id' # attribute on tab links that indicate the related content id
tab_type_of = ($tab_link) -> $tab_link.attr(tab_type_attr)
content_id_from = ($tab_link) -> $tab_link.attr(show_content_id_attr)

before_deactivate_event = 'bettertabs-before-deactivate'
before_activate_event = 'bettertabs-before-activate'
after_deactivate_event = 'bettertabs-after-deactivate'
after_activate_event = 'bettertabs-after-activate'

$.fn.bettertabs = () ->
  @each ->
    mytabs = $(this)
    tabs = mytabs.find 'ul.tabs > li'
    tabs_links = mytabs.find 'ul.tabs > li > a'
    tabs_contents = mytabs.children '.content'
    tabs_and_contents = tabs.add tabs_contents
    
    tabs_links.click (event) ->
      this_link = $(this)
      if tab_type_of(this_link) isnt 'link'
        event.preventDefault()
        this_tab = this_link.parent()
        if not this_tab.is('.active')
          this_tab_content = tabs_contents.filter "##{content_id_from this_link}"
          this_tab_and_content = this_tab.add this_tab_content
          previous_active_tab = tabs.filter '.active'
          previous_active_tab_content = tabs_contents.filter '.active'
      
          # trigger before-events
          previous_active_tab_content.trigger before_deactivate_event
          this_tab_content.trigger before_activate_event
      
          # Activate selected tab content
          tabs_and_contents.removeClass('active').addClass('hidden')
          this_tab_and_content.removeClass('hidden').addClass('active')
      
          # trigger after-events
          previous_active_tab_content.trigger after_deactivate_event
          this_tab_content.trigger after_activate_event

