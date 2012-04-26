From: David Bruzos <David.Bruzos@jaxport.com>
Subject: Optionally enforced time-based ACLs for BTRFS
Date: Thu, 26 Apr 2012 15:30:39 -0400
Message-ID: <DE6EA944EF16AF4CA4C0D1856C83808006C7F05E96@ex7>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi BTRFS folks:
	In my organization, many use cases exist for a time-based honoring  field for FS ACLs.  I've done some brief research regarding this topic, but I was unable to find any reference to such a thing in any file system.
	I understand that a feature like time-based honoring for ACLs may arguably be something that should exist in higher layers (E.G. some document management system), but on the other hand, I see no real reason that an extra ACL field that would allow for time-based granting/removing of permissions to some user would be a problem.

* The logic would go something like this (ACE means Access control Entry):
	If ACE.time = 0 or ACE.time > current_time; then
		Honor ACE 
	Elif Ace.time < 0 and (current.time+ACE.time) > 0; then
		Honor ACE
	Else
		not honor ACE
	fi

	for uses like company-wide file servers, etc, a little feature like that could go very far in long-term management of file system permissions.  You could easily and non-hackeshly temporarily grant access to file system objects, without having to makemodifications to applications, system utilities,or system libraries.  The behavior could be easily controled by mount options (could be off by default) and a small utility or function of the standard file system's utilities could allow for easy management of the value in the time fields (change, expire, etc).
	Of course, acurit time would then be crutial to system security, but today acurit time is crytical on servers anyway in most situations.  Besides, it would definitly be an optional feature, enabled at the user's choice.
	If we add a second field, then both expire time and activation time could be set for a given access control entry at the same time.  In that case, negative values for the fields could indicate things like restrict access to ---, r-x, etc, regardless of the ACE's actual content.  Basically, it would be something like XFS's mask entry, but applying to the ACE itself not the entire list.


	Any thoughts, suggestions, ideas?
	Am I just plain crazy?

Thanks for the great work you're doing.

David Bruzos (Systems Administrator)
2831 Talleyrand Ave.
Jacksonville, FL  32206
Office: (904) 357-3069


________________________________________________________________________________________________

Please note that under Florida's public records law (F.S. 668.6076), most written communications 
to or from the Jacksonville Port Authority are public records, available to the public and media 
upon request. Your email communications may therefore be subject to public disclosure. If you have 
received this email in error, please notify the sender by return email and delete immediately 
without forwarding to others.


