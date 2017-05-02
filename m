Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22431 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdEBDVY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 23:21:24 -0400
Subject: Re: Can I see what device was used to mount btrfs?
To: Andrei Borzenkov <arvidjaar@gmail.com>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <a38ecb14-c9f3-cd80-1dca-12ca388e0482@oracle.com>
Date: Tue, 2 May 2017 11:26:57 +0800
MIME-Version: 1.0
In-Reply-To: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 04/30/2017 01:47 PM, Andrei Borzenkov wrote:
> I'm chasing issue with btrfs mounts under systemd
> (https://github.com/systemd/systemd/issues/5781) - to summarize, systemd
> waits for the final device that makes btrfs complete and mounts it using
> this device name.


> But in /proc/self/mountinfo we actually see another
> device name.


> Due to peculiarities of systemd implementation this device
> "does not exist" from systemd PoV.
>
> Looking at btrfs code I start to suspect that we actually do not know
> what device was used to mount it at all. I.e.

  Actually it does not matter. right ?

> static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
> {
> ...
>         while (cur_devices) {
>                 head = &cur_devices->devices;
>                 list_for_each_entry(dev, head, dev_list) {
>                         if (dev->missing)
>                                 continue;
>                         if (!dev->name)
>                                 continue;
>                         if (!first_dev || dev->devid < first_dev->devid)
>                                 first_dev = dev;
>                 }
>                 cur_devices = cur_devices->seed;
>         }
>
>         if (first_dev) {
>                 rcu_read_lock();
>                 name = rcu_dereference(first_dev->name);
>                 seq_escape(m, name->str, " \t\n\\");
>                 rcu_read_unlock();
> ...
>
>
> So we always show device with the smallest devid, irrespectively of what
> device was actually used to mount it.
>
> Am I correct? What I have here is


> localhost:~ # ll /dev/disk/by-label/
> total 0
> lrwxrwxrwx 1 root root 10 Apr 30 08:03 Storage -> ../../dm-1
> localhost:~ # systemctl --no-pager status thin.mount
> ● thin.mount - /thin
>    Loaded: loaded (/etc/fstab; generated; vendor preset: disabled)
>    Active: active (mounted) since Sun 2017-04-30 08:03:07 MSK; 6min ago
>     Where: /thin
>      What: /dev/dm-0
>      Docs: man:fstab(5)
>            man:systemd-fstab-generator(8)
>   Process: 982 ExecMount=/usr/bin/mount /dev/disk/by-label/Storage /thin
> -t btrfs (code=exited, status=0/SUCCESS)
>     Tasks: 0 (limit: 4915)
>    CGroup: /system.slice/thin.mount
>
> Apr 30 08:03:07 localhost systemd[1]: Mounting /thin...
> Apr 30 08:03:07 localhost systemd[1]: Mounted /thin.
>
>
> bur mountinfo shows
>
> localhost:~ # grep /thin /proc/self/mountinfo
> 96 59 0:63 / /thin rw,relatime shared:47 - btrfs /dev/dm-0
> rw,space_cache,subvolid=5,subvol=/
>
> which matches the above algorithm
>
> localhost:~ # btrfs fi show /thin
> Label: 'Storage'  uuid: a6f9dd05-460c-418b-83ab-ebdf81f2931a
> 	Total devices 2 FS bytes used 640.00KiB
> 	devid    1 size 20.00GiB used 2.01GiB path /dev/mapper/vg01-storage1
> 	devid    2 size 10.00GiB used 2.01GiB path /dev/mapper/vg01-storage2
>
> localhost:~ # ll /dev/mapper/
> total 0
> crw------- 1 root root 10, 236 Apr 30 08:03 control
> lrwxrwxrwx 1 root root       7 Apr 30 08:03 vg01-storage1 -> ../dm-0
> lrwxrwxrwx 1 root root       7 Apr 30 08:03 vg01-storage2 -> ../dm-1
>
> The original device is presumably stored in kernel somewhere but I do
> not know how can I query it?


  Hm, actually we don't know the order in which devices were scanned
  and used for the mount, or it does not matter for the btrfs.

  HTH

Thanks,
Anand



> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
