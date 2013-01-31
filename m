Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51723 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3AaPkI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 10:40:08 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so1409034bku.41
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 07:40:07 -0800 (PST)
MIME-Version: 1.0
From: Christopher Thorjussen <joffer@onlinebackupcompany.com>
Date: Thu, 31 Jan 2013 16:39:52 +0100
Message-ID: <CAFKW2=ETvfXTyth9jHoc=6yZQDLj+5c8kRTZd4+79zVbs4LU-w@mail.gmail.com>
Subject: btrfs subvolume list - with three subvolumes, the second is
 missing/not showing
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've created a large btrfs volume out of two large raid-60 devices. On
there I've created three subvolumes. When I do a list of those the 2nd
isn't displayed. If I however add a fouth subvol they all gets listed.

This is on a HP DL360 running RHEL6.3 with a P411 SAS Raid controller
connected to a HP MD600 (70 x 2TB NL-SAS).
I've installed kernel-ml v3.7.4 from elrepo and also installed
btrfs-progs-0.19-12.el6.x86_64

root@data01:/opt/data# btrfs fi sh
failed to read /dev/sr0
Label: none  uuid: 786684d1-95fa-4809-8fca-e17e37a79999
        Total devices 2 FS bytes used 816.00KB
        devid    1 size 54.58TB used 2.03GB path /dev/sdb
        devid    2 size 54.58TB used 2.01GB path /dev/sdc

Btrfs Btrfs v0.19

root@data01:/opt/data# ls -l
total 0
drwxr-xr-x 1 root root 0 Jan 31 15:55 buffer
drwxr-xr-x 1 root root 0 Jan 31 15:55 consolidated
drwxr-xr-x 1 root root 0 Jan 31 15:55 staging

root@data01:/opt/data# btrfs subvolume list .
ID 265 top level 5 path consolidated
ID 267 top level 5 path buffer

root@data01:/opt/data# btrfs subvolume create 4thsubvol
Create subvolume './4thsubvol'

root@data01:/opt/data# btrfs subvolume list .
ID 265 top level 5 path consolidated
ID 266 top level 5 path staging
ID 267 top level 5 path buffer
ID 272 top level 5 path 4thsubvol

root@data01:/opt/data# rpm -qa | grep btrfs
btrfs-progs-0.19-12.el6.x86_64

It surely is a bug, but has it been reported and/or fixed? I wasn't
able to find out by googling just now.



Med vennlig hilsen / kind regards

Christopher Thorjussen
System Administrator, VCP4/VCP5
The Online Backup Company AS
http://www.onlinebackupcompany.no

"Backup isn't the real concern. Restoring normal business is."
