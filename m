Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.jellyfishnet.co.uk ([93.91.20.10]:34023 "EHLO
	mail2.jellyfishnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3HWJOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 05:14:05 -0400
From: Mark Ridley <mark@backupsystems.co.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 23 Aug 2013 10:14:02 +0100
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Message-ID: <CE3CE57C.3C441%mark@backupsystems.co.uk>
In-Reply-To: <pan$e0fe5$102b89f1$6420a15b$7c2eaf18@cox.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That would be fine, but nodatacow (according to the btrfs wiki) stops
compression, so I might as well get the speed benefits of 'strict allocate
= yes' which also disables compression.

If you want to use BTRFS to store backups then compression has be turned
on.

Database files like MSSQL usually compress down by 7-10 times, so its a
shame to not get this benefit.


On 23/08/2013 10:08, "Duncan" <1i5t5.duncan@cox.net> wrote:

>Mark Ridley posted on Fri, 23 Aug 2013 09:20:04 +0100 as excerpted:
>
>> I don't want to try nodatacow (which would probably fix the issue), but
>> you lose compression on the whole filesystem, autodefrag doesn't fix it
>> either.
>
>I don't do servantware (in the context of my sig) and thus don't do samba
>here, so I'll just black-box that side of things entirely.
>
>But from the btrfs side, are you considering nodatacow at the filesystem
>or individual file level?  It seems doing it at the individual file level
>might be what you need.
>
>Note that nodatacow must be set on the file at creation in ordered to
>work, which is impractical to do directly.  However, if you can arrange
>for the files in question to appear in a particular directory, you can
>set the nodatacow attribute on the directory, and files created within it
>will inherit that.
>
>It seems to me that should do what you need, PROVIDED that you can
>arrange for the files to appear in a particular dir/dir-tree, not more or
>less randomly written throughout the entire (btrfs) filesystem.
>
>-- 
>Duncan - List replies preferred.   No HTML msgs.
>"Every nonfree program has a lord, a master --
>and if you use the program, he is your master."  Richard Stallman
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

