Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33176 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3JFLKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Oct 2013 07:10:50 -0400
Received: by mail-qc0-f174.google.com with SMTP id n9so3978406qcw.5
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Oct 2013 04:10:49 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 6 Oct 2013 13:10:49 +0200
Message-ID: <CAKZ=RP9a6A8ni-4s7WdUWfqUhhRHyFGFVkN42kmYOJqnu=4dyA@mail.gmail.com>
Subject: btrfs device delete problem
From: Alfredo Esteban <aedelatorre@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm getting an error when trying to delete a device from a raid1 (data
and metadata mirrored).

> btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: 78b5162b-489e-4de1-a989-a47b91adef50
    Total devices 2 FS bytes used 107.64GB
    devid    2 size 149.05GB used 109.01GB path /dev/sdh1
    devid    1 size 156.81GB used 109.03GB path /dev/sdb6

Btrfs v0.20-rc1

> btrfs device delete /dev/sdh1 /mnt/raid-data/
ERROR: error removing the device '/dev/sdh1' - Inappropriate ioctl for device

Raid has been working fine for a long time. Both devices are present
but /dev/sdh1 is a new empty btrfs partition at the moment.

I should like to know whether this is an error or "btrfs device
delete" command is not the appropriate one. I just want to know how to
delete sdh1 from raid, add a new partition and balance.

My kernel version is: 3.8.0-31

Thanks,

Alfredo
