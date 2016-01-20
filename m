Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:51617 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbcATI2I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 03:28:08 -0500
Date: Wed, 20 Jan 2016 03:28:04 -0500 (EST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Message-ID: <1185704624.11958670.1453278484410.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160120040302.308f054e@natsu>
References: <20160120030223.22cc3ae0@natsu> <569EB653.9080700@redhat.com> <20160120040302.308f054e@natsu>
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hello,
> 
> On Tue, 19 Jan 2016 23:18:59 +0100
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > So this is kernel 4.4 on the host, and virtio-scsi in the guest.  What
> > about virtio-blk in the guest?
> 
> Tried with:
> 
>   -device virtio-blk-pci,drive=hd,scsi=off
> 
> it locks up as well.
> 
> In fact turns out it's not 100% lock-up, more like 50-80% chance.
> 
> But it certainly happens if I trigger heavy disk activity in the guest:
> 
>   while true; do dd if=/dev/zero of=zerofile count=1024 bs=1M; sync; done
> 
> ...at the same time repeatedly snapshotting the subvolume on the host.
> 
> Could not trigger it even once with IDE so far.

With IDE it's pretty much impossible to trigger heavy disk activity
(which comes from the sync more than the dd).

Can you reproduce it on the host without QEMU in the middle?  Also,
can you find the value of the "FUA" file in sysfs (e.g. with
"cat /sys/block/sda/device/scsi_disk/*/FUA")?

Paolo

> > > -drive
> > > if=none,id=hd,cache=writeback,aio=threads,format=raw,file=$NAME.img,discard=unmap,detect-zeroes=unmap
> > > \
> > 
> > So you're snapshotting the subvolume that includes $NAME.img?
> 
> Yes
> 
> 
> --
> With respect,
> Roman
> 
