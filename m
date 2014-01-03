Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:47203 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaACXER (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 18:04:17 -0500
Received: by mail-ee0-f50.google.com with SMTP id c41so6873781eek.37
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 15:04:15 -0800 (PST)
Message-ID: <52C741F5.7030106@gmail.com>
Date: Sat, 04 Jan 2014 00:04:21 +0100
From: =?ISO-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>
MIME-Version: 1.0
To: Jim Salter <jim@jrs-s.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com> <52C7402A.7050605@jrs-s.net>
In-Reply-To: <52C7402A.7050605@jrs-s.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 03.01.2014 23:56, schrieb Jim Salter:
> I actually read the wiki pretty obsessively before blasting the list -
> could not successfully find anything answering the question, by scanning
> the FAQ or by Googling.
> 
> You're right - mount -t btrfs -o degraded /dev/vdb /test worked fine.
don't forget to
btrfs device delete missing <path>
See
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
> 
> HOWEVER - this won't allow a root filesystem to mount. How do you deal
> with this if you'd set up a btrfs-raid1 or btrfs-raid10 as your root
> filesystem? Few things are scarier than seeing the "cannot find init"
> message in GRUB and being faced with a BusyBox prompt... which is
> actually how I initially got my scare; I was trying to do a walkthrough
> for setting up a raid1 / for an article in a major online magazine and
> it wouldn't boot at all after removing a device; I backed off and tested
> with a non root filesystem before hitting the list.
Add -o degraded to the boot-options in GRUB.

If your filesystem is more heavily corrupted then you either need the
btrfs tools in your initrd or a rescue cd
> 
> I did find the -o degraded argument in the wiki now that you mentioned
> it - but it's not prominent enough if you ask me. =)
> 
> 

[snip]

Joshua
