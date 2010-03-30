From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance with qemu
Date: Tue, 30 Mar 2010 08:56:23 -0400
Message-ID: <20100330125623.GB13190@think>
References: <201003281718.03699.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003281718.03699.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 28, 2010 at 05:18:03PM +0200, Diego Calleja wrote:
> Hi, I'm using KVM, and the virtual disk (a 20 GB file using the "raw"
> qemu format according to virt-manager and, of course, placed on a btrfs
> filesystem, running the latest mainline git) is awfully slow, no matter
> what OS is running inside the VM. The PCBSD installer says it's copying
> data at a 40-50 KB/s rate. Is someone using KVM and having better numbers
> than me? How can I help to debug this workload?

The problem is that qemu uses O_SYNC by default, which makes btrfs do
log commits for every write.

Once the O_DIRECT read patch is in, you can switch to that, or tell qemu
to use a writeback cache instead.

-chris

