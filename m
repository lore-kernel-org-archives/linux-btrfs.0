Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from h218.18.88.75.static.ip.windstream.net ([75.88.18.218]:47166
	"EHLO suse102.ad.techspace.cc" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751952AbbF1AwT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 20:52:19 -0400
Received: from esilinux2.ad.techspace.cc (esilinux2.ad.techspace.cc [192.168.10.56])
	(authenticated bits=0)
	by suse102.ad.techspace.cc (8.14.9/8.14.4/SuSE Linux 0.8) with ESMTP id t5S0qGjk023940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2015 19:52:16 -0500
Reply-To: moby@mobsternet.com
Subject: Re: Fwd: btrfs replace seems to corrupt the file system
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
 <CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
To: linux-btrfs@vger.kernel.org
From: Moby <moby@mobsternet.com>
Message-ID: <558F4540.4050808@mobsternet.com>
Date: Sat, 27 Jun 2015 19:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/27/2015 06:17 PM, Mordechay Kaganer wrote:
> B.H.
>
> Hello. I'm running our backup archive on btrfs. We have MD-based RAID5
> array with 4 6TB disks then LVM on top of it, and btrfs volume on the
> LV (we don't use btrfs's own RAID features because we want RAID5 and
> as far as i understand the support is only partial).
>
> I wanted to move the archive to another MD array of 4 8TB drives (this
> time without LVM). So i did:
>
> btrfs replace start 1 /dev/md1 <mount_point>
>
> Where 1 is the only devid that was present and /dev/md1 is the new array.
>
> The replace run successfully until finished after more than 5 days.
> The system downloaded some fresh backups and created new snapshots
> during the ongoing replace. I've go 2 kernel warnings about replace
> task waiting for more than 120 seconds in the middle, but process
> seamed to go on anyway.
>
> After the replace have finished i did btrfs fi resize 1:max
> <mount_point> then unmounted and mounted again using the new drive.
>
> Then i've run a scrub on the FS - and got a lot of checksum errors.
> Messages like this:
>
> BTRFS: checksum error at logical 5398405586944 on dev /dev/md1, sector
> 10576283152, root 12788, inode 4512290, offset 23
> 592960, length 4096, links 1 (path: XXXXXXXXX)
> BTRFS: bdev /dev/md1 errs: wr 0, rd 0, flush 0, corrupt 67165, gen 0
> BTRFS: unable to fixup (regular) error at logical 5398405586944 on dev /dev/md1
>
> Is there any way to fix this? I still have the old array available but
> replace have wiped out it's superblock so it's not mountable.
>
> # uname -a
> Linux <hostname> 3.16.0-41-generic #57~14.04.1-Ubuntu SMP Thu Jun 18
> 18:01:13 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> Btrfs v3.12
>
I was seeing insane behavior with btrfs and kernel versions from the 
stock/update distros.  Upgrading the kernel to stable 
(4.1.0-1.gfcf8349-default as of today) and btrfs progs btrfs-progs 
v4.1+20150622
resolved the insane (such as negative left percentages during tasks etc) 
behavior and errors I was seeing.

-- 
--Moby

They that can give up essential liberty to obtain a little temporary safety deserve neither liberty nor safety.  -- Benjamin Franklin

