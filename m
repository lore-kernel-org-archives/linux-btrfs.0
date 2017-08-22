Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:43465 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932825AbdHVNab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:30:31 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 4188B26C6
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 15:30:30 +0200 (MEST)
Date: Tue, 22 Aug 2017 15:30:30 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822133030.GE14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (09:27), Austin S. Hemmelgarn wrote:

> >>> root@fex:~# df -T
> >>> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> >>> -              -    1073740800 104244552 967773976  10% /local/.backup/home
> >>
> >>     I've never seen the "- -" output from df before. Is this a bind
> >> mount or something?
> > 
> > No, /local/.backup/home is just a btrfs subvolume
> 
> It arguably shouldn't be showing up here then if it's not been 
> explicitly mounted.  I'm betting you're running OpenSUSE or SLES

No:

root@fex:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="14.04.5 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.5 LTS"
VERSION_ID="14.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"

root@fex:~# df -T /local/.backup/home
Filesystem     Type  1K-blocks      Used Available Use% Mounted on
-              -    1073740800 104252160 967766336  10% /local/.backup/home

root@fex:~# type df
df is hashed (/bin/df)

root@fex:~# dpkg -S /bin/df
coreutils: /bin/df

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
