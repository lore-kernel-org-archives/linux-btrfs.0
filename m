Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36742 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbbGTFPq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 01:15:46 -0400
Received: by obnw1 with SMTP id w1so95535015obn.3
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jul 2015 22:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150715214913.GG5274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba> <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org> <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
 <20150715031412.GZ5274@merlins.org> <20150715080057.GA15200@panda>
 <CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
 <CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com> <20150715214913.GG5274@merlins.org>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Mon, 20 Jul 2015 00:15:26 -0500
Message-ID: <CAC=t97CcemZzBjABSLS5etSF6B-67SvwL25q62hxv2de3zLPbw@mail.gmail.com>
Subject: Re: Anyone tried out btrbk yet?
To: Marc MERLIN <marc@merlins.org>
Cc: sander@humilis.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm starting to think there's something wrong with creating and
removing snapshots that leaves btrfs-cleaner either locked up or
nearly so.  If the btrfs-cleaner process was hard-disk limited I
should be seeing some HDD I/O to coincide but I don't.

So far btrfs-cleaner is has been using lots of CPU for 1900+ hours and
my disk I/O is basically idle.  My hourly snaps via cronjob stalled 11
hours ago.

Otherwise attempts to read/write to the filesystem appear to be
perfectly normal.

[root@san01 virtual_machines]# ps aux | grep btrfs-cleaner
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      1292     0.0      0.0      0     0     ?        S    Jul16
     0:01   [btrfs-cleaner]
root      5796     0.0      0.0      0     0     ?        S    Jul16
     0:00   [btrfs-cleaner]
root      6005     21.3    0.0      0     0     ?        S    Jul16
 943:34   [btrfs-cleaner]
root     14040    43.3    0.0      0     0     ?        R    Jul16
1916:05   [btrfs-cleaner]

[root@san01 virtual_machines]# ls -lah /run | grep backup
-rw-r--r--   1 root     root       11 Jul 20 00:00 backup.home.daily
-rw-r--r--   1 root     root       11 Jul 20 00:00 backup.root.daily
-rw-r--r--   1 root     root       11 Jul 20 00:01 backup.store.daily
-rw-r--r--   1 root     root       11 Jul 19 13:00 backup.store.hourly
-rw-r--r--   1 root     root       11 Jul 20 00:01 backup.virtual_machines.daily
-rw-r--r--   1 root     root       11 Jul 19 13:00
backup.virtual_machines.hourly
[root@san01 virtual_machines]# date
Mon Jul 20 00:14:05 CDT 2015

On Wed, Jul 15, 2015 at 4:49 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Jul 15, 2015 at 01:02:29PM -0500, Donald Pearson wrote:
>> BTW, is anybody else experiencing btrfs-cleaner consuming heavy
>> resources for a very long time when snapshots are removed?
>
> Yes, that's normal. It spends a long time to reclaim blocks and free
> them, especially if they are on a hard drive and not SSD.
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
