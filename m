Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbeF0IWS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:22:18 -0400
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <02577dd9-af06-95a6-77b4-954b583536e8@suse.com>
 <60daf28c-b76c-60b7-34b4-88ea2e5d8ae3@jp.fujitsu.com>
 <b44d6839-3db3-ff29-a5ca-519185b601b4@suse.com>
 <b9fad77c-c55d-5ca3-5ea8-17b8b2861225@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0f013914-2bb5-1050-49bb-39cd2bbc993a@suse.com>
Date: Wed, 27 Jun 2018 11:22:16 +0300
MIME-Version: 1.0
In-Reply-To: <b9fad77c-c55d-5ca3-5ea8-17b8b2861225@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.06.2018 11:20, Misono Tomohiro wrote:
> I can see the failure with or without options...
> maybe it depends on machine spec?

I'm testing in a virtual machine: 

qemu-system-x86_64 -smp 6 -kernel /home/nborisov/projects/kernel/source/arch/x86_64/boot/bzImage -append root=/dev/vda rw -enable-kvm -m 4096 -drive file=/home/nborisov/projects/qemu/rootfs/ubuntu15.img,if=virtio -virtfs local,id=fsdev1,path=/mnt/vm_share,security_model=passthrough,mount_tag=hostshare -drive file=/home/nborisov/scratch/scratch-images/btrfs-test.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch2.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch3.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch4.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch5.img,if=virtio -drive file=/home/nborisov/scratch/scratch-images/scratch6.img,if=virtio -redir tcp:1235::22 -daemonize

Perhaps it's not visible on slow storage. Are you testing on NVME or something like that? 
