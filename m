Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34708 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183AbcASWTD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 17:19:03 -0500
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org,
        kvm@vger.kernel.org
References: <20160120030223.22cc3ae0@natsu>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569EB653.9080700@redhat.com>
Date: Tue, 19 Jan 2016 23:18:59 +0100
MIME-Version: 1.0
In-Reply-To: <20160120030223.22cc3ae0@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19/01/2016 23:02, Roman Mamedov wrote:
> Hello,
> 
> I'm facing a strange issue:
> 
> Starting with the kernel 4.4.0, a KVM guest stored on a Btrfs
> filesystem, if it's using the "virtio-scsi" disk backend, will hard
> lock-up instantly, as soon as the Btrfs subvolume which contains
> its backing file is snapshotted.

So this is kernel 4.4 on the host, and virtio-scsi in the guest.  What
about virtio-blk in the guest?

The only difference I can see between ide and virtio-* is that IDE
only has a queue depth of 1.


> There's nothing in dmesg neither on the guest, nor on the host; the
> KVM process can be killed from the host just fine and then
> restarted, so it doesn't seem to be a kernel-side deadlock of any
> sort.
> 
> KVM disk controller which exhibits the problem:
> 
> -device virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd \
> 
> The alternative which works fine:
> 
> -device ide-hd,drive=hd,bus=ide.0 \
> 
> The disk device line is common to both cases:
> 
> -drive
> if=none,id=hd,cache=writeback,aio=threads,format=raw,file=$NAME.img,discard=unmap,detect-zeroes=unmap
> \

So you're snapshotting the subvolume that includes $NAME.img?

Paolo
