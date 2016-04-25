Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.zener.es ([62.14.230.213]:33170 "EHLO zener.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbcDYODX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 10:03:23 -0400
From: Alejandro Vargas <anv@zener.es>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: empty disk reports full
Date: Mon, 25 Apr 2016 16:03:14 +0200
Message-ID: <2288281.DWWvr4SJAK@anv.localdomain>
In-Reply-To: <20160401100507.GP29474@carfax.org.uk>
References: <2879842.8EgedBzSUf@anv.localdomain> <20160401100507.GP29474@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El Viernes, 1 de abril de 2016 10:05:07 Hugo Mills escribió:
> On Fri, Apr 01, 2016 at 11:50:50AM +0200, Alejandro Vargas wrote:
> > I am using a 2Tb disk for incremental backups.
> > 
> > I use rsync for backing up to a subvolume, and each day I creates an
> > snapshot of the lastest snapshot and do rsync in this.
> > 
> > When the disk becomes nearly full (100Gb or less available) I deletes the
> > oldest subvolume (withbtrfs subvolume delete).
> > 
> > My problem is that *even removing ALL the subvolumes*, the free space does
> > not change. It continues reporting the same size (disk is nearly full).
> > 
> > I tried "btrfs balance start /mnt/backup" but it takes hours and hours.
> > 
> > I'm using linux 4.1.15
> > btrfs-progs v4.1.2
> 
>    Can you show us the output of both "sudo btrfs fi show" and "btrfs
> fi df /mnt/backup", please?

Before deleting subvolumes:

[root@backups ~]# df /mnt/backup
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdb1        1,9T   1,9T  5,0M 100% /mnt/backup


[root@backups ~]# ls -l /mnt/backup
total 0
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160318/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160328/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160330/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160401/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160404/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160406/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160408/


[root@backups ~]# btrfs fi show
Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
        Total devices 1 FS bytes used 1.80TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1

btrfs-progs v4.1.2

[root@backups ~]# btrfs fi df /mnt/backup
Data, single: total=1.79TiB, used=1.79TiB
System, DUP: total=32.00MiB, used=240.00KiB
Metadata, DUP: total=17.00GiB, used=15.83GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Now I remove the oldest subvolume:


[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160318/
Delete subvolume (no-commit): '/mnt/backup/back20160318'

[root@backups ~]# df  /mnt/backup
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdb1        1,9T   1,9T   22M 100% /mnt/backup

[root@backups ~]# btrfs fi show
Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
        Total devices 1 FS bytes used 1.80TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1

[root@backups ~]# btrfs fi show
Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
        Total devices 1 FS bytes used 1.80TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1

btrfs-progs v4.1.2
[root@backups ~]# btrfs fi df /mnt/backup
Data, single: total=1.79TiB, used=1.79TiB
System, DUP: total=32.00MiB, used=240.00KiB
Metadata, DUP: total=17.00GiB, used=15.83GiB
GlobalReserve, single: total=512.00MiB, used=102.53MiB



Now I remove 2 more subvolumes:

[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160328/
Delete subvolume (no-commit): '/mnt/backup/back20160328'
[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160330/
Delete subvolume (no-commit): '/mnt/backup/back20160330'

[root@backups ~]# df /mnt/backup/
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdb1        1,9T   1,9T  348M 100% /mnt/backup

[root@backups ~]# btrfs fi show
Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
        Total devices 1 FS bytes used 1.80TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1

btrfs-progs v4.1.2

Data, single: total=1.79TiB, used=1.79TiB
System, DUP: total=32.00MiB, used=240.00KiB
Metadata, DUP: total=17.00GiB, used=15.83GiB
GlobalReserve, single: total=512.00MiB, used=98.94MiB


[root@backups ~]# ls -l /mnt/backup/
total 0
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160401/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160404/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160406/
drwxr-xr-x 1 root root 86 mar 20 16:23 back20160408/


Now I will remove the resting subvolumes

[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160401/
Delete subvolume (no-commit): '/mnt/backup/back20160401'
[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160404/
Delete subvolume (no-commit): '/mnt/backup/back20160404'
[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160406/
Delete subvolume (no-commit): '/mnt/backup/back20160406'
[root@backups ~]# btrfs subvolume delete /mnt/backup/back20160408/
Delete subvolume (no-commit): '/mnt/backup/back20160408'

[root@backups ~]# ls -l /mnt/backup/
total 0

[root@backups ~]# df /mnt/backup/
S.ficheros     Tamaño Usados  Disp Uso% Montado en
/dev/sdb1        1,9T   1,9T  4,6G 100% /mnt/backup
[root@backups ~]# btrfs fi show
Label: 'disco_backup'  uuid: cbfe8735-9f53-46f5-be7e-40f6a61a5506
        Total devices 1 FS bytes used 1.80TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdb1

btrfs-progs v4.1.2

[root@backups ~]# btrfs fi df /mnt/backup
Data, single: total=1.79TiB, used=1.78TiB
System, DUP: total=32.00MiB, used=240.00KiB
Metadata, DUP: total=17.00GiB, used=15.55GiB
GlobalReserve, single: total=512.00MiB, used=37.72MiB



My mount options are this:

[root@backups ~]# cat /etc/fstab |grep backup
LABEL=disco_backup /mnt/backup btrfs  noauto,compress=zlib,compress-
force=zlib,commit=60,noatime 0 0



