Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.zener.es ([62.14.230.213]:55871 "EHLO zener.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942AbcD0J3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 05:29:42 -0400
From: Alejandro Vargas <anv@zener.es>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: empty disk reports full
Date: Wed, 27 Apr 2016 11:29:31 +0200
Message-ID: <17848457.cMlg96Ju9J@anv.localdomain>
In-Reply-To: <CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
References: <2879842.8EgedBzSUf@anv.localdomain> <2288281.DWWvr4SJAK@anv.localdomain> <CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El Martes, 26 de abril de 2016 00:08:49 Chris Murphy escribió:

> > [root@backups ~]# btrfs fi df /mnt/backup
> > Data, single: total=1.79TiB, used=1.78TiB
> > System, DUP: total=32.00MiB, used=240.00KiB
> > Metadata, DUP: total=17.00GiB, used=15.55GiB
> > GlobalReserve, single: total=512.00MiB, used=37.72MiB
> 
> This is an awfully full filesystem. Since ancient times it's been
> considered best to avoid getting a file system even 95% full let alone
> 100% full.

Hummm... the problem is that in a big filesystem, 5% of space is very much 
space... I will modify my scripts for leaving a percent of space instead of a 
fixed size in bytes.


> Surely you've waited a good long while for it to try to start deleting
> things,

My backup script checks for the available space and deletes the oldest 
snapshot when the free space is less than 100Gb. 

What sould be the calculation that tells me I am nearly running out of space 
and I need to remove the oldest snapshot? The answer of "df" is enoug or I 
should do some calculation including data and metadata?


> > [root@backups ~]# cat /etc/fstab |grep backup
> > LABEL=disco_backup /mnt/backup btrfs  noauto,compress=zlib,compress-
> > force=zlib,commit=60,noatime 0 0
> 
> When I delete subvolumes, I see it takes up to the commit time for the
> delete transaction to be committed, and it can be longer than this by
> up to a minute before the btrfs-cleaner process starts to work on
> freeing up extents. It's probably unrelated to the problem, but what's
> the use case for choosing a commit time of 60?

The intention was to improve the speed. The wiki says the default is 30 
seconcs and it prints a warning when the value is above 300 seconcs. Then I 
thought 60 should be a good value for speeding up the writing. Do you think I 
should use a lower value?

May be this?

btrfs fi usage /mnt/backup -b | awk '
      {
        if ($1 " " $2 == "Device size:")  size=$3;
        if ($1 " " $2 == "Device allocated:") alloc=$3; 
       }
    END {
         print alloc*100/size
         }
'


> Also there are two
> compress mount options that conflict with each other, is this
> intentional?

I did not thought that compress and compress-force are incompatible... The 
intention is to force it to compress the data for using lower disk space. 
Compress-force should be enough?

