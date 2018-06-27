Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:63527 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752230AbeF0I3r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:29:47 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 29BFFAC02DD
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 17:29:43 +0900 (JST)
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Nikolay Borisov <nborisov@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <02577dd9-af06-95a6-77b4-954b583536e8@suse.com>
 <60daf28c-b76c-60b7-34b4-88ea2e5d8ae3@jp.fujitsu.com>
 <b44d6839-3db3-ff29-a5ca-519185b601b4@suse.com>
 <b9fad77c-c55d-5ca3-5ea8-17b8b2861225@jp.fujitsu.com>
 <0f013914-2bb5-1050-49bb-39cd2bbc993a@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <42475e7e-fbe6-1166-e958-45dd4ca1a92f@jp.fujitsu.com>
Date: Wed, 27 Jun 2018 17:29:37 +0900
MIME-Version: 1.0
In-Reply-To: <0f013914-2bb5-1050-49bb-39cd2bbc993a@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/06/27 17:22, Nikolay Borisov wrote:
> 
> 
> On 27.06.2018 11:20, Misono Tomohiro wrote:
>> I can see the failure with or without options...
>> maybe it depends on machine spec?
> 
> I'm testing in a virtual machine: 
> 
> qemu-system-x86_64 -smp 6 -kernel /home/nborisov/projects/kernel/source/arch/x86_64/boot/bzImage -append root=/dev/vda rw -enable-kvm -m 4096 -drive file=/home/nborisov/projects/qemu/rootfs/ubuntu15.img,if=virtio -virtfs local,id=fsdev1,path=/mnt/vm_share,security_model=passthrough,mount_tag=hostshare -drive file=/home/nborisov/scratch/scratch-images/btrfs-test.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch2.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch3.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch4.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch5.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch6.img,if=virtio -redir tcp:1235::22 -daemonize
> 
> Perhaps it's not visible on slow storage. Are you testing on NVME or something like that? 

No, I use sata ssd and hdd and the problem can be seen on both.

