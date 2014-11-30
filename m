Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53965 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaK3K5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 05:57:08 -0500
Received: from venus.xundeenergie.ssh22.net ([213.47.207.20]) by mail.gmx.com
 (mrgmx101) with ESMTPSA (Nemesis) id 0LkTSx-1YRcBW3qBf-00cShZ for
 <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 11:57:05 +0100
Received: from localhost ([127.0.0.1])
	by venus.xundeenergie.ssh22.net with esmtp (Exim 4.84)
	(envelope-from <wertstoffe@nurfuerspam.de>)
	id 1Xv2B2-0003Tg-4l
	for linux-btrfs@vger.kernel.org; Sun, 30 Nov 2014 11:56:28 +0100
Received: from venus.xundeenergie.ssh22.net ([IPv6:::1])
	by localhost (localhost [IPv6:::1]) (amavisd-new, port 10024)
	with ESMTP id QsSIiX7PLaLj for <linux-btrfs@vger.kernel.org>;
	Sun, 30 Nov 2014 11:56:28 +0100 (CET)
Received: from Debian-exim by venus.xundeenergie.ssh22.net with spam-scanned (Exim 4.84)
	(envelope-from <wertstoffe@nurfuerspam.de>)
	id 1Xv2Aw-0003Ww-M5
	for linux-btrfs@vger.kernel.org; Sun, 30 Nov 2014 11:56:22 +0100
Message-ID: <547AF7CE.2060103@nurfuerspam.de>
Date: Sun, 30 Nov 2014 11:56:14 +0100
From: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Skript for backup btrfs on external HD
References: <p6npkb-0nh.ln1@venus.xundeenergie.ssh22.net> <20141129211154.GY8916@merlins.org> <547A3FCC.1050806@nurfuerspam.de> <20141129221807.GA8916@merlins.org>
In-Reply-To: <20141129221807.GA8916@merlins.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2014-11-29 um 23:18 schrieb Marc MERLIN:
> On Sat, Nov 29, 2014 at 10:51:08PM +0100, Jakob Schürz wrote:
>> Am 2014-11-29 um 22:11 schrieb Marc MERLIN:
>>> On Sat, Nov 29, 2014 at 09:34:01PM +0100, Jakob Schürz wrote:
>>>> Hi there!
>>>>
>>>> I made a script to do backup with btrfs on a external HD.
>>>> You can see the function, how it works, and how it's to be used on
>>>> my site http://linux.xundeenergie.at/doku.php?id=mkbtrbackup
>>>> The site is in german. An english one will follow later.
>>>>
>>>> Do you want some explanations?
>>>
>>> Sure, how is it different from those 3?
>>> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Available_Backup_Tools
>>
>> Wheter i haven't seen it, or this scripts can't do recursive backup...
>
> That's probably right, at least not automatically.

And that's why i made the script. :)

>
>> If you have subvolumes in subvolumes (for example: /home,
>> /home/user1, /home/user2 /var, /var/spool, /var/lib are extra
>> subvolumes IN the normal filetree from linux), my script takes them
>> all.
>
> For me, they are all subvolumes also mounted on /mnt/btrfs_poolx
> so I backup from there.

That's also possible with my skript, because you can control it with an 
config-file.
For example you have
/
|-@
|-@home
`-@var

And you want all your snapshots of this 3 subvolumes in separate 
directories with timestamp (and maybe .hourly_X-Tag)
put in the config:

SNPMNT=/path/to/btrfs-poolmount
BKPMNT=/path/to/external/HD/mountpoint

backup	@	roots	backup/roots
backup	@home	homes	backup/homes
backup	@var	vars	backup/vars

start the skript with
mkbtrbackup create --interval hourly -c /path/to/backupconfig

you get in /path/to/btrfs-poolmount 3 directories (roots, homes and 
vars), and on /path/to/external/HD/mountpoint one directoriy "backup", 
including also the three given subdirectories from the 4th coloumn 
(leave this coloumn blank, no auto-transfer to the external HD!!!)

in this subdirectories you get subvolumes like
@.20141130-115001.hourly_0
@home.20141130-115001.hourly_0
@var.20141130-115001.hourly_0

AND they are rotated automatically.

>
>> And my script changes the fstab-entry in the new snapshot.
>> The original has the option "subvol=@SUBVOL", where @SUBVOL is the
>> name of the original system.
>
> I don't need to do that, my script updates a symlink pointing to the
> last snapshot, and you can use subvol=symlink-name

I'm trying on this, it's not finished. There are many discussions about. 
What is better... modify grub.cfg on each snapshot, work with symlinks...

I create one symlink @*.CURRENT. I will rename it to .LAST... so i can 
do the same with a static grub-entry

>
>> You get a systemd-unit, in the tarball, which makes a snapshot from
>> your system, on successful boot, so you can switch back fast, if an
>> update destroyed your system.
>>
>> And it is for minimal-systems... no python, no perl, no java... only
>> shell(bash) :-)
>
> That makes sense, thanks for explaining.

For example... on an raspberry Pi it would be a good thing. :)

Hope, you try it, and give me some feedback. ;-)

Jakob
