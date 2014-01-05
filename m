Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44488 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaAEEe5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jan 2014 23:34:57 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so16778496pdj.25
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 20:34:56 -0800 (PST)
Received: from [10.27.206.105] ([1.23.65.92])
        by mx.google.com with ESMTPSA id ju10sm119224238pbd.33.2014.01.04.20.34.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 04 Jan 2014 20:34:55 -0800 (PST)
Message-ID: <52C8E0D1.2070904@gmail.com>
Date: Sun, 05 Jan 2014 10:04:25 +0530
From: "dhan.war" <wardhan.v.1.0@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: how to properly mount an external usb hard drive & other questions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi all

i am using up to date debian sid with xfce desktop environment. i am 
using Linux 3.13-rc6-amd64 #1 SMP Debian 3.13~rc6-1~exp1 (2013-12-30) 
x86_64 GNU/Linux from experimental.
i have installed usbmount to auto mount all the devices connected 
through USB.

[cmd# 1] i have created btrfs partition on my external USB hard drive 
using the following command :

# mkfs.btrfs -f -L btrfs -m single /dev/sdc
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
fs created label btrfs on /dev/sdc
	nodesize 16384 leafsize 16384 sectorsize 4096 size 931.51GiB
Btrfs v3.12

[cmd# 2] my permissions of the device :
# ls -l /dev/sdc
brw-rw---- 1 root floppy 8, 32 Jan  5 09:47 /dev/sdc

my questions :
[a] does the partition created by me is appropriate ?
[b] how do i specify lzo compression in fstab ? last time when i tried 
to create entry fstab it is complaining about the auto mounting of the 
device by automount.
[c] what compression method is used by btrfs by default for the 
partitions created using the command mentioned above. [ cmd# 1]
[d] does the file permissions for my device are accurate ? [ cmd# 2]
[e] what is the appropriate fstab entry for my device ? [ i don't want 
to remove usbmount].
[f] should i use single or dup for the device ?

please provide suggestions for configuring my device appropriately. 
thank you for reading the message patiently.

please alway cc me.

regards,
wardhan.
