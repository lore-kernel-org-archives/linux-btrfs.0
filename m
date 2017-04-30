Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35269 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424400AbdD3Frs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 01:47:48 -0400
Received: by mail-lf0-f42.google.com with SMTP id 75so49928200lfs.2
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 22:47:47 -0700 (PDT)
Received: from [192.168.1.2] (ppp109-252-90-100.pppoe.spdop.ru. [109.252.90.100])
        by smtp.gmail.com with ESMTPSA id t6sm1955456lfd.44.2017.04.29.22.47.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Apr 2017 22:47:45 -0700 (PDT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Can I see what device was used to mount btrfs?
Message-ID: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
Date: Sun, 30 Apr 2017 08:47:43 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm chasing issue with btrfs mounts under systemd
(https://github.com/systemd/systemd/issues/5781) - to summarize, systemd
waits for the final device that makes btrfs complete and mounts it using
this device name. But in /proc/self/mountinfo we actually see another
device name. Due to peculiarities of systemd implementation this device
"does not exist" from systemd PoV.

Looking at btrfs code I start to suspect that we actually do not know
what device was used to mount it at all. I.e.

static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
{
...
        while (cur_devices) {
                head = &cur_devices->devices;
                list_for_each_entry(dev, head, dev_list) {
                        if (dev->missing)
                                continue;
                        if (!dev->name)
                                continue;
                        if (!first_dev || dev->devid < first_dev->devid)
                                first_dev = dev;
                }
                cur_devices = cur_devices->seed;
        }

        if (first_dev) {
                rcu_read_lock();
                name = rcu_dereference(first_dev->name);
                seq_escape(m, name->str, " \t\n\\");
                rcu_read_unlock();
...


So we always show device with the smallest devid, irrespectively of what
device was actually used to mount it.

Am I correct? What I have here is

localhost:~ # ll /dev/disk/by-label/
total 0
lrwxrwxrwx 1 root root 10 Apr 30 08:03 Storage -> ../../dm-1
localhost:~ # systemctl --no-pager status thin.mount
● thin.mount - /thin
   Loaded: loaded (/etc/fstab; generated; vendor preset: disabled)
   Active: active (mounted) since Sun 2017-04-30 08:03:07 MSK; 6min ago
    Where: /thin
     What: /dev/dm-0
     Docs: man:fstab(5)
           man:systemd-fstab-generator(8)
  Process: 982 ExecMount=/usr/bin/mount /dev/disk/by-label/Storage /thin
-t btrfs (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 4915)
   CGroup: /system.slice/thin.mount

Apr 30 08:03:07 localhost systemd[1]: Mounting /thin...
Apr 30 08:03:07 localhost systemd[1]: Mounted /thin.


bur mountinfo shows

localhost:~ # grep /thin /proc/self/mountinfo
96 59 0:63 / /thin rw,relatime shared:47 - btrfs /dev/dm-0
rw,space_cache,subvolid=5,subvol=/

which matches the above algorithm

localhost:~ # btrfs fi show /thin
Label: 'Storage'  uuid: a6f9dd05-460c-418b-83ab-ebdf81f2931a
	Total devices 2 FS bytes used 640.00KiB
	devid    1 size 20.00GiB used 2.01GiB path /dev/mapper/vg01-storage1
	devid    2 size 10.00GiB used 2.01GiB path /dev/mapper/vg01-storage2

localhost:~ # ll /dev/mapper/
total 0
crw------- 1 root root 10, 236 Apr 30 08:03 control
lrwxrwxrwx 1 root root       7 Apr 30 08:03 vg01-storage1 -> ../dm-0
lrwxrwxrwx 1 root root       7 Apr 30 08:03 vg01-storage2 -> ../dm-1

The original device is presumably stored in kernel somewhere but I do
not know how can I query it?
