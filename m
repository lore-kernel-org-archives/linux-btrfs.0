From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Poor performance with qemu
Date: Mon, 29 Mar 2010 22:21:20 +0300
Message-ID: <bcf98daa1003291221h9ab2e05xe877ffc083e45266@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: diegocg@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>Hi, I'm using KVM, and the virtual disk (a 20 GB file using the "raw"
>qemu format according to virt-manager and, of course, placed on a btrfs
>filesystem, running the latest mainline git) is awfully slow, no matter
>what OS is running inside the VM. The PCBSD installer says it's copying
>data at a 40-50 KB/s rate. Is someone using KVM and having better numbers
>than me? How can I help to debug this workload?

Maybe cache=writeback helps?
-drive  file=image.raw,cache=writeback

-Markus
