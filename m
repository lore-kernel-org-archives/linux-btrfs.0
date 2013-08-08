Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f67.google.com ([209.85.216.67]:59258 "EHLO
	mail-qa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966139Ab3HHUXX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 16:23:23 -0400
Received: by mail-qa0-f67.google.com with SMTP id o13so259762qaj.10
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 13:23:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130808194015.GH16712@localhost.localdomain>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
	<20130808194015.GH16712@localhost.localdomain>
Date: Thu, 8 Aug 2013 13:23:22 -0700
Message-ID: <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
Subject: Re: Why does btrfs benchmark so badly in this case?
From: John Williams <jwilliams4200@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 8, 2013 at 12:40 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Thu, Aug 08, 2013 at 09:13:04AM -0700, John Williams wrote:
>> Phoronix periodically runs benchmarks on filesystems, and one thing I
>> have noticed is that btrfs always does terribly on their fio "Intel
>> IOMeter fileserver access pattern" benchmark:
>>
>> http://www.phoronix.com/scan.php?page=article&item=linux_310_10fs&num=2

> So the reason this workload sucks for btrfs is because we fall back on buffered
> IO because fio does not do block size aligned writes for this workload.  If you
> add
>
> ba=4k
>
> to the iometer fio file then we go the same speed as xfs and ext4.  Not a whole
> lot we can do about this since unaligned writes means we have to read in pages
> to cow the block properly, which is why we fall back to buffered.  Once we do
> that we end up having a lot of page locking stuff that gets in the way and makes
> us twice as slow.  Thanks,

Thanks for looking into it.

So I guess the reason that ZFS does well with that workload is that
ZFS is using smaller blocks, maybe just 512B ?

I wonder how common these type of non-4K aligned workloads are.
Apparently, people with such workloads should avoid btrfs, but maybe
these types of workloads are very rare?
