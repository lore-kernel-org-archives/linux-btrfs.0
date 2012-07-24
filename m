Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35192 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2GXH42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 03:56:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Tue, 24 Jul 2012 09:56:26 +0200
Cc: Marc MERLIN <marc@merlins.org>
References: <20120202124241.GW16796@shiny> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> (sfid-20120723_085957_182641_9A4DF9AC)
In-Reply-To: <20120723064202.GB6931@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207240956.26495.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 23. Juli 2012 schrieb Marc MERLIN:
> I just realized that the older thread got a bit confusing, so I'll keep
> problems separate and make things simpler :)
> 
> On an _unencrypted_ partition on the SSD, running du -sh on a directory
> with 15K files, takes 23 seconds on unencrypted SSD and 4 secs on
> encrypted spinning drive, both with a similar btrfs filesystem, and
> the same kernel (3.4.4).
> 
> Unencrypted btrfs on SSD:
> gandalfthegreat:~# mount -o
> compress=lzo,discard,nossd,space_cache,noatime /dev/sda2 /mnt/mnt2
> gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du
> -sh src 514M	src
> real	0m22.667s
> 
> Encrypted btrfs on spinning drive of the same src directory:
> gandalfthegreat:/var/local# echo 3 > /proc/sys/vm/drop_caches; time du
> -sh src 514M	src
> real	0m3.881s

find is fast, du is much slower:

merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time ( find /usr | wc -l )
404166
( find /usr | wc -l; )  0,03s user 0,07s system 1% cpu 9,212 total
merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time ( du -sh /usr )      
11G     /usr
( du -sh /usr; )  1,00s user 19,07s system 41% cpu 48,886 total


Now I try to find something with less files.

merkaba:~> find /usr/share/doc | wc -l                                   
50715
merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time ( find /usr/share/doc 
| wc -l )
50715
( find /usr/share/doc | wc -l; )  0,00s user 0,02s system 1% cpu 1,398 
total
merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time ( du -sh 
/usr/share/doc )      
606M    /usr/share/doc
( du -sh /usr/share/doc; )  0,20s user 3,63s system 35% cpu 10,691 total

merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time du -sh /usr/share/doc   
606M    /usr/share/doc
du -sh /usr/share/doc  0,19s user 3,54s system 35% cpu 10,386 total


Anyway thats still much faster than your measurements.



merkaba:~> df -hT /usr                
Dateisystem    Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/dm-0      btrfs   19G     11G  5,6G   67% /
merkaba:~> btrfs fi sh                                                           
failed to read /dev/sr0
Label: 'debian'  uuid: […]
        Total devices 1 FS bytes used 10.25GB
        devid    1 size 18.62GB used 18.62GB path /dev/dm-0

Btrfs Btrfs v0.19
merkaba:~> btrfs fi df /   
Data: total=15.10GB, used=9.59GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.75GB, used=670.43MB
Metadata: total=8.00MB, used=0.00


merkaba:~> grep btrfs /proc/mounts
/dev/dm-0 / btrfs rw,noatime,compress=lzo,ssd,space_cache,inode_cache 0 0


Somewhat aged BTRFS filesystem on ThinkPad T520, Intel SSD 320, kernel 
3.5.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
