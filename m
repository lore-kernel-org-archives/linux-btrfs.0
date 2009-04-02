From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: too many links when creating 40 000 dirs
Date: Thu, 2 Apr 2009 11:36:06 +0200
Message-ID: <2db2c6b80904020236s447e798esd1109554a4b6d146@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

i have problems creating more than 39 999 subdirectories in the same
directory in btrfs. i'm using version from kernel 2.6.29 and
mkfs.btrfs 0.18

linux:/t # mount|grep btrfs
/dev/mapper/sys-test on /t type btrfs (rw)
linux:/t # ls|wc -l
31999
linux:/t # mkdir test123
mkdir: cannot create directory `test123': Too many links
linux:/t #

any idea why?
