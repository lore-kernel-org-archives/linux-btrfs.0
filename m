Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34640 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbcAAMQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 07:16:29 -0500
Received: by mail-qg0-f42.google.com with SMTP id 6so136691048qgy.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 04:16:28 -0800 (PST)
MIME-Version: 1.0
Reply-To: matianfu@gmail.com
Date: Fri, 1 Jan 2016 20:16:28 +0800
Message-ID: <CAEgruXuFNsumiyBXrWwiu47WVuukSHLynMJHN7e3E1cYWn3QnQ@mail.gmail.com>
Subject: how btrfs uses devid?
From: UGlee <matianfu@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all:

If a btrfs device is missing, the command tool tells user the devid of
the missing devices.

I understand that each device (disk) in a btrfs volume has been
assigned a uuid (UUID_SUB field in udevadm info output). If the device
is missing, it's hard to tell user to input such uuid string in
command line. So devid is for convenience.

In our product, we want to record all disk information of a volume in
a file. If a disk is missing, not because it's broken, but because the
user has so many disks and in some cases they may put back the wrong
one. In this scenario, we can provide the disk information (such as
serial number) to user and help them to check if they did something
wrong.

My question is: is the devid just an alias to sub uuid? for a given
disk device, it is never changed during any btrfs operation, including
add, remove, balance and replace? or it may be changed, and when?

One more question just for curiosity. I checked the source code of
btrfs-progs briefly. It seems that there is no data structure in
superblock recording all sub-uuids or all devids for the volume, so
how does btrfs figure out the missing devid? since they are not always
sequential integers, for example, after one device is removed, the
devid is simply removed and the devid of other device is not
re-numbered.

matianfu
