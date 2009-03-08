From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: Entirely unexpected ENOSPC?
Date: Sun, 8 Mar 2009 19:35:44 +1100
Message-ID: <3a7f57190903080035lf10104fq87eca697cc4dfb43@mail.gmail.com>
References: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/3/8 Yien Zheng <esprout@gmail.com>:
> On Wed, 04 Mar 2009 14:48:43 -0600, Hugo Mills <hugo-lkml@carfax.org.uk> wrote:
> I just started playing with btrfs on my SSD drive last week and
> encountered the out of space problem using VirtualBox .vdi disks on
> the btrfs partition.

This is just a hunch, but maybe the handling of spare files (such as
.vdi) is not ideal or not what we're used to with extN. Normally
"skipped" blocks do not count towards the disk full size, but given
btrfs' nature they may count as a reservation that would certainly
cause an early ENOSPC.

You can try to narrow down the problem using qemu-img or dd. Example:

qemu-img create -f raw test.img 16G

See if it counts towards the disk fill count and ENOSPC threshold. See
if it even completes at all :P

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
