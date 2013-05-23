Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:43598 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab3EWNWp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 09:22:45 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r4NDMg1A001758
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 15:22:43 +0200
Message-ID: <519E1821.5070507@itwm.fraunhofer.de>
Date: Thu, 23 May 2013 15:22:41 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid6: rmw writes all the time?
References: <knl3ke$n7t$1@ger.gmane.org> <20130523131118.4907.45217@localhost.localdomain>
In-Reply-To: <20130523131118.4907.45217@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2013 03:11 PM, Chris Mason wrote:
> Quoting Bernd Schubert (2013-05-23 08:55:47)
>> Hi all,
>>
>> we got a new test system here and I just also tested btrfs raid6 on
>> that. Write performance is slightly lower than hw-raid (LSI megasas) and
>> md-raid6, but it probably would be much better than any of these two, if
>> it wouldn't read all the during the writes. Is this a known issue? This
>> is with linux-3.9.2.
>
> Hi Bernd,
>
> Any time you do a write smaller than a full stripe, we'll have to do a
> read/modify/write cycle to satisfy it.  This is true of md raid6 and the
> hw-raid as well, but their reads don't show up in vmstat (try iostat
> instead).

Yeah, I know and I'm using iostat already. md raid6 does not do rmw, but 
does not fill the device queue, afaik it flushes the underlying devices 
quickly as it does not have barrier support - that is another topic, but 
was the reason why I started to test btrfs.

>
> So the bigger question is where are your small writes coming from.  If
> they are metadata, you can use raid1 for the metadata.

I used this command

/tmp/mkfs.btrfs -L test2 -f -d raid6 -m raid10 /dev/sd[m-x]

so meta-data should be raid10. And I'm using this iozone command:


> iozone -e -i0 -i1 -r1m -l 5 -u 5 -s20g -+n \
>         -F /data/fhgfs/storage/md126/testfile1 /data/fhgfs/storage/md126/testfile2 /data/fhgfs/storage/md126/testfile3 \
>            /data/fhgfs/storage/md127/testfile1 /data/fhgfs/storage/md127/testfile2 /data/fhgfs/storage/md127/testfile3


Higher IO sizes (e.g. -r16m) don't make a difference, it goes through 
the page cache anyway.
I'm not familiar with btrfs code at all, but maybe writepages() submits 
too small IOs?

Hrmm, just wanted to try direct IO, but then just noticed it went into 
RO mode before already:

> May 23 14:59:33 c8220a kernel: WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction+0xdf/0x100 [btrfs]()

> ay 23 14:59:33 c8220a kernel: [<ffffffff8105db76>] warn_slowpath_fmt+0x46/0x50
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b5428a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b4e18f>] __btrfs_abort_transaction+0xdf/0x100 [btrfs]
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b70b2f>] btrfs_save_ino_cache+0x22f/0x310 [btrfs]
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b793e2>] commit_fs_roots+0xd2/0x1c0 [btrfs]
> May 23 14:59:33 c8220a kernel: [<ffffffff815eb3fe>] ? mutex_lock+0x1e/0x50
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b7a555>] btrfs_commit_transaction+0x495/0xa40 [btrfs]
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b7af7b>] ? start_transaction+0xab/0x4d0 [btrfs]
> May 23 14:59:33 c8220a kernel: [<ffffffff81082f30>] ? wake_up_bit+0x40/0x40
> May 23 14:59:33 c8220a kernel: [<ffffffffa0b72b96>] transaction_kthread+0x1a6/0x220 [btrfs]

> May 23 14:59:33 c8220a kernel: ---[ end trace 3d91874abeab5984 ]---
> May 23 14:59:33 c8220a kernel: BTRFS error (device sdx) in btrfs_save_ino_cache:471: error 28
> May 23 14:59:33 c8220a kernel: btrfs is forced readonly
> May 23 14:59:33 c8220a kernel: BTRFS warning (device sdx): Skipping commit of aborted transaction.
> May 23 14:59:33 c8220a kernel: BTRFS error (device sdx) in cleanup_transaction:1455: error 28

errno 28 - out of disk space?

Going to recreate it and will play with it later on again.


Thanks,
Bernd
