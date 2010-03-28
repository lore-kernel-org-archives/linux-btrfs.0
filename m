From: Diego Calleja <diegocg@gmail.com>
Subject: Poor performance with qemu
Date: Sun, 28 Mar 2010 17:18:03 +0200
Message-ID: <201003281718.03699.diegocg@gmail.com>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I'm using KVM, and the virtual disk (a 20 GB file using the "raw"
qemu format according to virt-manager and, of course, placed on a btrfs
filesystem, running the latest mainline git) is awfully slow, no matter
what OS is running inside the VM. The PCBSD installer says it's copying
data at a 40-50 KB/s rate. Is someone using KVM and having better numbers
than me? How can I help to debug this workload?
