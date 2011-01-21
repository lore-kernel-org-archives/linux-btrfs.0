From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Adding a disk fails
Date: 21 Jan 2011 07:57:00 +0100
Message-ID: <BeHbtWOT1uB@helmut.hullen.de>
References: <4D38B382.1050709@libero.it>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D38B382.1050709@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 20.01.11:

> To add another disk you don't have to run mkfs.btrfs. For example:

> # add the first disk
> mkfs.btrfs /dev/sdb
> # mount the disk
> mount /dev/sdb /media/backups

> # add another disk to the first one
> btrfs device add /dev/sdc /media/backup

                                   ^backups

> Note1: the filesystem has to be mounted
> Note2: the medatada will be in raid1, the data in raid0

And there seems to be an error; some options tell the sum of the sizes  
of /dev/sdb and /dev/sdc as available size, but perhaps you can only use  
the size of the smaller of the two devices - the system seems to work in  
a kind of RAID1.

The error is known but not yet fixed.

Viele Gruesse!
Helmut
