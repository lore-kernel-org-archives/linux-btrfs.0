Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:44044 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932946AbdHVNxC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:53:02 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 1E8C1293E
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 15:53:01 +0200 (MEST)
Date: Tue, 22 Aug 2017 15:53:01 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822135301.GF14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
 <20170822133030.GE14804@rus.uni-stuttgart.de>
 <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (09:37), Austin S. Hemmelgarn wrote:

> > root@fex:~# df -T /local/.backup/home
> > Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> > -              -    1073740800 104252160 967766336  10% /local/.backup/home
> 
> Hmm, now I'm really confused, I just checked on the Ubuntu 17.04 and 
> 16.04.3 VM's I have (I only run current and the most recent LTS 
> version), and neither of them behave like this.

I have this kind of output on all of my Ubuntu hosts:

root@moep:~# grep PRETTY_NAME /etc/os-release
PRETTY_NAME="Ubuntu 16.04.3 LTS"

root@moep:~# df -T /usb/UF/tmp/blubb
Filesystem     Type 1K-blocks    Used Available Use% Mounted on
-              -     12581888 3690524   7253700  34% /usb/UF/tmp/blubb

root@moep:~# btrfs subvolume show /usb/UF/tmp/blubb
/usb/UF/tmp/blubb
        Name:                   blubb
        UUID:                   ecf8c804-d4a3-9948-89fe-b0c1971c25cb
        Parent UUID:            -
        Received UUID:          -
        Creation time:          2017-08-22 12:54:16 +0200
        Subvolume ID:           262
        Generation:             23
        Gen at creation:        22
        Parent ID:              5
        Top level ID:           5
        Flags:                  -
        Snapshot(s):

root@moep:~# dpkg -l | grep btrfs
ii  btrfs-tools                                 4.4-1ubuntu1                                 amd64        Checksumming Copy on Write Filesystem utilities


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
