Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36527 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbcATR2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 12:28:37 -0500
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
To: Roman Mamedov <rm@romanrm.net>
References: <20160120030223.22cc3ae0@natsu> <569EB653.9080700@redhat.com>
 <20160120040302.308f054e@natsu>
 <1185704624.11958670.1453278484410.JavaMail.zimbra@redhat.com>
 <20160120185810.2c566f98@natsu>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569FC3C1.2000804@redhat.com>
Date: Wed, 20 Jan 2016 18:28:33 +0100
MIME-Version: 1.0
In-Reply-To: <20160120185810.2c566f98@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20/01/2016 14:58, Roman Mamedov wrote:
> On Wed, 20 Jan 2016 03:28:04 -0500 (EST) Paolo Bonzini
> <pbonzini@redhat.com> wrote:
> 
>> Can you reproduce it on the host without QEMU in the middle?
> 
> I did not try to stress-test this on purpose yet, but this is an
> actively used system which is snapshotting its /home, VMs and root
> subvolumes every hour, so far no lock-ups of any other application
> than KVM, and with KVM it's trivially easy to hit, in fact first
> two lockups occured in the first two hours of using the kernel
> 4.4.0 at the hourly snapshots...
> 
>> Also, can you find the value of the "FUA" file in sysfs (e.g.
>> with "cat /sys/block/sda/device/scsi_disk/*/FUA")?
> 
> It is 0 both in IDE and SCSI modes.

And in the host?

Paolo
