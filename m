Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54729 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaH3UMu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 16:12:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XNp0x-0004sz-Ox
	for linux-btrfs@vger.kernel.org; Sat, 30 Aug 2014 22:12:47 +0200
Received: from 137.163.185.203.dsl.dyn.mana.pf ([203.185.163.137])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 22:12:47 +0200
Received: from jd.girard by 137.163.185.203.dsl.dyn.mana.pf with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 22:12:47 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Undelete files / directory
Date: Sat, 30 Aug 2014 10:12:34 -1000
Message-ID: <lttb7j$ef$1@ger.gmane.org>
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net> <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com> <ltnnfo$a57$1@ger.gmane.org> <54002E66.703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <54002E66.703@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/08/2014 21:40, Konstantinos Skarlatos a écrit :
> On 28/8/2014 8:04 μμ, Jean-Denis Girard wrote:
>> Hi Chris,
>>
>> Thanks for your detailed answer.
>>
>> Le 28/08/2014 06:25, Chris Murphy a écrit :
>>> 9. btrfs-find-root /dev/sdc
>>> Super think's the tree root is at 29917184, chunk root 20987904
>>> Well block 4194304 seems great, but generation doesn't match, have=2,
>>> want=9 level 0
>>> Well block 4243456 seems great, but generation doesn't match, have=3,
>>> want=9 level 0
>>> Well block 29376512 seems great, but generation doesn't match,
>>> have=4, want=9 level 0
>>> Well block 29474816 seems great, but generation doesn't match,
>>> have=5, want=9 level 0
>>> Well block 29556736 seems great, but generation doesn't match,
>>> have=6, want=9 level 0
>>> Well block 29736960 seems great, but generation doesn't match,
>>> have=7, want=9 level 0
>>> Well block 29900800 seems great, but generation doesn't match,
>>> have=8, want=9 level 0
> Hi all,
> 
> I did a successful btrfs restore a few months ago, saving all of my
> deleted files except 2 (So i lost about 1GB on a 4TB filesystem)
> Here is what i did (this is from memory and from my .zsh_history file,
> so i may be missing something)
> 
> btrfs-find-root  /dev/sdd -o 5 > b1.txt
> I think the -o 5 option is quite important here.

Thanks for the reply, but for some reason btrfs-fins-root does not work
on this file system. Here is what I get:

[jdg@tiare tmp]$ btrfs-find-root x220_home.img -o 5
Super think's the tree root is at 115230801920, chunk root 131072
Went past the fs size, exiting[jdg@tiare tmp]$

I can mount the file system, access the files, though obviously not the
deleted directory.



Regards,
Jean-Denis Girard

