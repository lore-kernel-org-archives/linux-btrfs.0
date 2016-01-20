Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37339 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbcATUin (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 15:38:43 -0500
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
To: Roman Mamedov <rm@romanrm.net>
References: <20160120030223.22cc3ae0@natsu> <569EB653.9080700@redhat.com>
 <20160120040302.308f054e@natsu>
 <1185704624.11958670.1453278484410.JavaMail.zimbra@redhat.com>
 <20160120185810.2c566f98@natsu> <569FC3C1.2000804@redhat.com>
 <20160120234638.39695c15@natsu>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569FF04F.7080507@redhat.com>
Date: Wed, 20 Jan 2016 21:38:39 +0100
MIME-Version: 1.0
In-Reply-To: <20160120234638.39695c15@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20/01/2016 19:46, Roman Mamedov wrote:
> On Wed, 20 Jan 2016 18:28:33 +0100 Paolo Bonzini
> <pbonzini@redhat.com> wrote:
> 
>>>> Also, can you find the value of the "FUA" file in sysfs
>>>> (e.g. with "cat /sys/block/sda/device/scsi_disk/*/FUA")?
>>> 
>>> It is 0 both in IDE and SCSI modes.
>> 
>> And in the host?
> 
> On the host the backing block device for the host filesystem is an
> MD RAID6, it does not have the FUA setting. For the actual sdX
> disks, it's all 0 as well.
> 
> As I said this might be not KVM-specific, but rather a Btrfs-only
> related issue. That KVM with IDE doesn't show the problem, might be
> a coincidence since as you mentioned it doesn't load the disks as
> heavily.
> 
> If you're interested in my reproducer outside of KVM, I started a
> new thread: 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/52369

Oh that's great.  Indeed the "info status" output would have pointed
at an ENOSPC.  It's definitely not KVM specific.

Paolo
