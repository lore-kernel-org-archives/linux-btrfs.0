Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43297 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaK3MwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 07:52:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xv3z3-0008Fc-GS
	for linux-btrfs@vger.kernel.org; Sun, 30 Nov 2014 13:52:13 +0100
Received: from 213.47.207.20 ([213.47.207.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 13:52:13 +0100
Received: from wertstoffe by 213.47.207.20 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 13:52:13 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>
Subject: Re: Skript for backup btrfs on external HD
Date: Sun, 30 Nov 2014 11:42:43 +0100
Message-ID: <3u8rkb-psc.ln1@venus.xundeenergie.ssh22.net>
References: <p6npkb-0nh.ln1@venus.xundeenergie.ssh22.net> <20141129211154.GY8916@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <20141129211154.GY8916@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2014-11-29 um 22:11 schrieb Marc MERLIN:
> On Sat, Nov 29, 2014 at 09:34:01PM +0100, Jakob Schürz wrote:
>> Hi there!
>>
>> I made a script to do backup with btrfs on a external HD.
>> You can see the function, how it works, and how it's to be used on
>> my site http://linux.xundeenergie.at/doku.php?id=mkbtrbackup
>> The site is in german. An english one will follow later.
>>
>> Do you want some explanations?
>
> Sure, how is it different from those 3?
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Available_Backup_Tools

Wheter i haven't seen it, or this scripts can't do recursive backup...

If you have subvolumes in subvolumes (for example: /home, /home/user1, 
/home/user2 /var, /var/spool, /var/lib are extra subvolumes IN the 
normal filetree from linux), my script takes them all.
It looks on the external storage, if there's an older snapshot (i call 
all subvolumes together in this case a snapshot!!) which is also on the 
local machine. If so, is makes a incremental backup. If not, a initial 
transfer is started. For each subvolume in the snapshot!

And my script changes the fstab-entry in the new snapshot.
The original has the option "subvol=@SUBVOL", where @SUBVOL is the name 
of the original system.
It changes the @SUBVOLUME to the subvolume-id, so you can mount your 
snapshot easy.

One Point is missing... Modifying of grub to serve boot-menu-entries for 
older snapshots.

You get a systemd-unit, in the tarball, which makes a snapshot from your 
system, on successful boot, so you can switch back fast, if an update 
destroyed your system.

And it is for minimal-systems... no python, no perl, no java... only 
shell(bash) :-)

regards
jakob


-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

