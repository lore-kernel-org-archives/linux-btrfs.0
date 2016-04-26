Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34041 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcDZGIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 02:08:50 -0400
Received: by mail-oi0-f43.google.com with SMTP id k142so4903701oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 23:08:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2288281.DWWvr4SJAK@anv.localdomain>
References: <2879842.8EgedBzSUf@anv.localdomain>
	<20160401100507.GP29474@carfax.org.uk>
	<2288281.DWWvr4SJAK@anv.localdomain>
Date: Tue, 26 Apr 2016 00:08:49 -0600
Message-ID: <CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
Subject: Re: empty disk reports full
From: Chris Murphy <lists@colorremedies.com>
To: Alejandro Vargas <anv@zener.es>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2016 at 8:03 AM, Alejandro Vargas <anv@zener.es> wrote:
> El Viernes, 1 de abril de 2016 10:05:07 Hugo Mills escribió:
>> On Fri, Apr 01, 2016 at 11:50:50AM +0200, Alejandro Vargas wrote:
>> > I am using a 2Tb disk for incremental backups.
>> >
>> > I use rsync for backing up to a subvolume, and each day I creates an
>> > snapshot of the lastest snapshot and do rsync in this.
>> >
>> > When the disk becomes nearly full (100Gb or less available) I deletes the
>> > oldest subvolume (withbtrfs subvolume delete).
>> >
>> > My problem is that *even removing ALL the subvolumes*, the free space does
>> > not change. It continues reporting the same size (disk is nearly full).
>> >
>> > I tried "btrfs balance start /mnt/backup" but it takes hours and hours.
>> >
>> > I'm using linux 4.1.15
>> > btrfs-progs v4.1.2
>>
>>    Can you show us the output of both "sudo btrfs fi show" and "btrfs
>> fi df /mnt/backup", please?
>
> Before deleting subvolumes:
>
> [root@backups ~]# df /mnt/backup
> S.ficheros     Tamaño Usados  Disp Uso% Montado en
> /dev/sdb1        1,9T   1,9T  5,0M 100% /mnt/backup
>
>
> [root@backups ~]# ls -l /mnt/backup
> total 0
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160318/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160328/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160330/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160401/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160404/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160406/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160408/
>
>
> [root@backups ~]# btrfs fi show
> Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
>         Total devices 1 FS bytes used 1.80TiB
>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1
>
> btrfs-progs v4.1.2
>
> [root@backups ~]# btrfs fi df /mnt/backup
> Data, single: total=1.79TiB, used=1.79TiB
> System, DUP: total=32.00MiB, used=240.00KiB
> Metadata, DUP: total=17.00GiB, used=15.83GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> Now I remove the oldest subvolume:
>
>
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160318/
> Delete subvolume (no-commit): '/mnt/backup/back20160318'
>
> [root@backups ~]# df  /mnt/backup
> S.ficheros     Tamaño Usados  Disp Uso% Montado en
> /dev/sdb1        1,9T   1,9T   22M 100% /mnt/backup
>
> [root@backups ~]# btrfs fi show
> Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
>         Total devices 1 FS bytes used 1.80TiB
>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1
>
> [root@backups ~]# btrfs fi show
> Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
>         Total devices 1 FS bytes used 1.80TiB
>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1
>
> btrfs-progs v4.1.2
> [root@backups ~]# btrfs fi df /mnt/backup
> Data, single: total=1.79TiB, used=1.79TiB
> System, DUP: total=32.00MiB, used=240.00KiB
> Metadata, DUP: total=17.00GiB, used=15.83GiB
> GlobalReserve, single: total=512.00MiB, used=102.53MiB
>
>
>
> Now I remove 2 more subvolumes:
>
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160328/
> Delete subvolume (no-commit): '/mnt/backup/back20160328'
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160330/
> Delete subvolume (no-commit): '/mnt/backup/back20160330'
>
> [root@backups ~]# df /mnt/backup/
> S.ficheros     Tamaño Usados  Disp Uso% Montado en
> /dev/sdb1        1,9T   1,9T  348M 100% /mnt/backup
>
> [root@backups ~]# btrfs fi show
> Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
>         Total devices 1 FS bytes used 1.80TiB
>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1
>
> btrfs-progs v4.1.2
>
> Data, single: total=1.79TiB, used=1.79TiB
> System, DUP: total=32.00MiB, used=240.00KiB
> Metadata, DUP: total=17.00GiB, used=15.83GiB
> GlobalReserve, single: total=512.00MiB, used=98.94MiB
>
>
> [root@backups ~]# ls -l /mnt/backup/
> total 0
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160401/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160404/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160406/
> drwxr-xr-x 1 root root 86 mar 20 16:23 back20160408/
>
>
> Now I will remove the resting subvolumes
>
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160401/
> Delete subvolume (no-commit): '/mnt/backup/back20160401'
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160404/
> Delete subvolume (no-commit): '/mnt/backup/back20160404'
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160406/
> Delete subvolume (no-commit): '/mnt/backup/back20160406'
> [root@backups ~]# btrfs subvolume delete /mnt/backup/back20160408/
> Delete subvolume (no-commit): '/mnt/backup/back20160408'
>
> [root@backups ~]# ls -l /mnt/backup/
> total 0
>
> [root@backups ~]# df /mnt/backup/
> S.ficheros     Tamaño Usados  Disp Uso% Montado en
> /dev/sdb1        1,9T   1,9T  4,6G 100% /mnt/backup
> [root@backups ~]# btrfs fi show
> Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
>         Total devices 1 FS bytes used 1.80TiB
>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1
>
> btrfs-progs v4.1.2
>
> [root@backups ~]# btrfs fi df /mnt/backup
> Data, single: total=1.79TiB, used=1.78TiB
> System, DUP: total=32.00MiB, used=240.00KiB
> Metadata, DUP: total=17.00GiB, used=15.55GiB
> GlobalReserve, single: total=512.00MiB, used=37.72MiB


This is an awfully full filesystem. Since ancient times it's been
considered best to avoid getting a file system even 95% full let alone
100% full. It's an interesting test case, but I think if you're doing
this on a file system you care about it's asking for trouble. There's
almost 1.5GiB of unused space in metadata chunks, so yes it should
start to delete things.

Surely you've waited a good long while for it to try to start deleting
things, does the top command ever show btrfs-cleaner process doing
anything. On an otherwise idle system it'll be one of the top 10
processes usually.


> [root@backups ~]# cat /etc/fstab |grep backup
> LABEL=disco_backup /mnt/backup btrfs  noauto,compress=zlib,compress-
> force=zlib,commit=60,noatime 0 0

When I delete subvolumes, I see it takes up to the commit time for the
delete transaction to be committed, and it can be longer than this by
up to a minute before the btrfs-cleaner process starts to work on
freeing up extents. It's probably unrelated to the problem, but what's
the use case for choosing a commit time of 60? Also there are two
compress mount options that conflict with each other, is this
intentional?

I suggest unmounting and running 'btrfs check' (without repair) and
see if that gives any new information.



-- 
Chris Murphy
