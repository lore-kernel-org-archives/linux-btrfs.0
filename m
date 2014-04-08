Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbaDHRAG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 13:00:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXZNU-0005zW-2l
	for linux-btrfs@vger.kernel.org; Tue, 08 Apr 2014 19:00:04 +0200
Received: from apersaud.dhcp.lbl.gov ([128.3.5.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 19:00:04 +0200
Received: from apersaud by apersaud.dhcp.lbl.gov with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 19:00:04 +0200
To: linux-btrfs@vger.kernel.org
From: Arun Persaud <apersaud@lbl.gov>
Subject: Re: error 2001, no inode item
Date: Tue, 08 Apr 2014 09:56:45 -0700
Message-ID: <li19og$m51$1@ger.gmane.org>
References: <53433170.5030806@lbl.gov> <pan$5202e$e473aa9d$bec69d4b$f69d4a7c@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$5202e$e473aa9d$bec69d4b$f69d4a7c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

On 04/08/2014 05:10 AM, Duncan wrote:
>[...]
>> I
>> copied all the files from my old HD using dd, converted and then resized
>> the file system. However, my old drive already had some errors.
> 
> There's a page on the wiki specifically covering conversion.  Please read 
> it carefully and follow the recommendations, as the post-ext4-subvolume-
> delete defrag and balance it recommends can prevent problems later.
> 
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

I did follow instructions from a similar website. The fsck on the ext4
system didn't work though. I also ran the balance command on btrfs, but
I'm not sure anymore, if I ran the defrag.

> [...]
>> Btrfs v3.12+20131125

that's the version I have installed at the moment.

> FWIW, there's a new btrfs-progs v3.14 version available.  [...]
> 
>>> uname -a
>> Linux apersaud 3.14.0-23.gfa168d7-desktop #1 SMP PREEMPT Tue Apr 1
>> 12:54:08 UTC 2014 (fa168d7) x86_64 x86_64 x86_64 GNU/Linux
> 
> Looks like you're up on the kernel, anyway. =:^)
> 
>> I'm running opensuse/Tumbleweed.

I'll see if I can get an update for btrfs-progs.

>[...]
> Don't run btrfs check --repair unless you're either told to do so by a 
> dev after examining the errors you are seeing, or it's the last desperate 
> step before you scrap the filesystem and mkfs anyway, so there's nothing 
> to lose.

OK, good to know ;)

>[...]
> And one more thing as a hint to save you some trouble.  Strongly consider 
> both the noatime (mainly performance) and the autodefrag mount options, 

I have noatime, but I'll add autodefrag.

Thanks

Arun

