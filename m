Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:32481 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbcATB5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 20:57:05 -0500
Date: Tue, 19 Jan 2016 16:19:44 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120001944.GA9884@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160120030223.22cc3ae0@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160120030223.22cc3ae0@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 03:02:23AM +0500, Roman Mamedov wrote:
> Hello,
> 
> I'm facing a strange issue:
> 
> Starting with the kernel 4.4.0, a KVM guest stored on a Btrfs filesystem,
> if it's using the "virtio-scsi" disk backend, will hard lock-up instantly,
> as soon as the Btrfs subvolume which contains its backing file is snapshotted.
> 
> There's nothing in dmesg neither on the guest, nor on the host;
> the KVM process can be killed from the host just fine and then restarted,
> so it doesn't seem to be a kernel-side deadlock of any sort.
> 
> KVM disk controller which exhibits the problem:
> 
>  -device virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd \
> 
> The alternative which works fine:
> 
>  -device ide-hd,drive=hd,bus=ide.0 \
> 
> The disk device line is common to both cases:
> 
>  -drive if=none,id=hd,cache=writeback,aio=threads,format=raw,file=$NAME.img,discard=unmap,detect-zeroes=unmap \
> 
> Also tried aio=native with the problematic variant, no change.
> 
> Both variants work fine and unaffected by snapshotting on kernel 3.18.25.
> 
> Any ideas?

What about 'btrfs fi df' 's output on the directory where $NAME.img is
located?

According to my experience, kvm guest can be 'no response' when no space
on the backend's filesystem, but you said that the alternative way
work, so it doesn't look like a no space issue.

Thanks,

-liubo
> 
> -- 
> With respect,
> Roman


