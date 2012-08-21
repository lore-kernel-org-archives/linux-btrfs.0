Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.hushmail.com ([65.39.178.134]:46720 "EHLO
	smtp2.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2HUT2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 15:28:23 -0400
Received: from smtp2.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp2.hushmail.com (Postfix) with SMTP id 03379E6BB9
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2012 19:28:23 +0000 (UTC)
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 15:28:22 -0400
To: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: How to get Btrfs on 2nd partition of USB HDD to automount as read/write
From: "dg1727" <dg1727@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120821192822.90CF1A6E3F@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20120821153618.GM17430@twin.jikos.cz>

On Tue, 21 Aug 2012 11:36:32 -0400 David Sterba <dave@jikos.cz> 
wrote:
>On Sun, Aug 19, 2012 at 03:05:11PM -0500, C Anthony Risinger 
>wrote:
>> On Sun, Aug 19, 2012 at 2:51 PM, dg1727 <dg1727@hushmail.com> 
>> wrote:
>> > permissions of the directories in /dev are drwx------ for the 
>> > NTFS and dr-xr-xr-x for the Btrfs.
>> >
>> > How can the OS be set up so that the Btrfs will automount
>> > read/write?
>> 
>> try:
>> 
>> chmod u+w /path/to/btrfs/mount
>> 
>> ... for whatever reason mkfs.btrfs created new subvolumes (but 
>> not snapshots!) with 555 perms, which essentially says "writable 
>> to nobody at all" ... IIRC, this was changed within the last 
>> year or so.
>
>The issue with subvols pemr 0700 was indeed fixed, on the kernel 
>side.
>
>The problem with missing 'w' (ie mode 555) on a freshly mkfs'ed 
>image is still present and it's the user-space tools (mkfs) 
>proble. Patch has been sent some time ago
>
>http://www.spinics.net/lists/linux-btrfs/msg17909.html
>
>The workaround is to chmod as you suggested and is permanent once 
>done.

Thanks a lot for these answers.  As an exercise, how would I track 
that patch so I can tell when it has been released?  Pointing me to 
a webpage that covers this would be fine.  

-dg1727 

