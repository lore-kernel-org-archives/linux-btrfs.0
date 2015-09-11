Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:12862 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbIKEzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 00:55:40 -0400
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
To: Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>,
        linux-kernel.bfrz@manchmal.in-ulm.de
References: <55D8B193.8010906@profihost.ag> <20150825090030.GF31630@lst.de>
 <20150825135146.GE7176@ret.masoncoding.com>
 <590FB3C7-8BCA-4B04-BBB0-92863E02A89C@profihost.ag>
 <20150901000610.GC5136@ret.masoncoding.com> <55F20276.1050209@suse.com>
From: Stefan Priebe <s.priebe@profihost.ag>
Message-ID: <55F25ED1.3060107@profihost.ag>
Date: Fri, 11 Sep 2015 06:55:45 +0200
MIME-Version: 1.0
In-Reply-To: <55F20276.1050209@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 11.09.2015 um 00:21 schrieb Jeff Mahoney:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 8/31/15 8:06 PM, Chris Mason wrote:
>> On Mon, Aug 31, 2015 at 07:32:09PM +0200, Stefan Priebe -
>> Profihost AG wrote:
>>>> Am 25.08.2015 um 15:51 schrieb Chris Mason <clm@fb.com>:
>>>>
>>>>> On Tue, Aug 25, 2015 at 11:00:30AM +0200, Christoph Hellwig
>>>>> wrote: I think this is btrfs using a struct block_device
>>>>> that doesn't have a valid queue pointer in it's gendisk for
>>>>> ->s_bdev.  And there are some fishy looking ->s_bdev
>>>>> assignments in the code which I suspect are related to it:
>>>>>
>>>>> fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev ==
>>>>> src_device->bdev) fs/btrfs/dev-replace.c: fs_info->sb->s_bdev
>>>>> = tgt_device->bdev; fs/btrfs/volumes.c: if (device->bdev ==
>>>>> root->fs_info->sb->s_bdev) fs/btrfs/volumes.c:
>>>>> root->fs_info->sb->s_bdev = next_device->bdev;
>>>>> fs/btrfs/volumes.c:     if (tgtdev->bdev ==
>>>>> fs_info->sb->s_bdev) fs/btrfs/volumes.c: fs_info->sb->s_bdev
>>>>> = next_device->bdev;
>>>>
>>>> We've had trouble with this in the past, I'll take a look.
>>>
>>> Any news?
>>
>> Haven't been able to reproduce yet, I'll try again in the morning.
>
> I'm unable to reproduce it as well and I'm hearing about people
> hitting it in different forums.
>
> Can you describe your storage configuration?   There's a gendisk
> without a queue sneaking in somehow.  There are some spots in dm where
> the mddev gets a new queue assigned to it but the old queue associated
> with the gendisk is left behind so that's not it.

I'm hitting this inside a debian buil VM using schroot. So the disk is a 
simple plain qemu emulated scsi disk (virtio-pci-scsi).

 >  If you're able to
> reproduce it reliably with this configuration, that's certainly
> interesting.  I'm wondering if the case is that vgcfgbackup is
> iterating over devices and causing something that might not have been
> previously scanned to be scanned and added to the btrfs device list.

I'm not the guy from the kernel bug report - so i'm only using debian 
schroot not vgcfgbackup.

I can trigger it 100% by using schroot with sbuild using debian or ubuntu.

> Are there any messages above the oops indicating when a device is
> added?  Could you post your complete dmesg somewhere?

Sure:
http://pastebin.com/raw.php?i=bG6bZUPA

Thanks!

Greets,
Stefan

> Thanks,
>
> - -Jeff
>
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
>
> iQIcBAEBAgAGBQJV8gJ2AAoJEB57S2MheeWyEP4QALvIXZGIqkXhUBZEYvLC+rnD
> Q79chLpbt8x52xtFoav78i3nG24SMXV5NbhFlGNnr6xt/CQtKSzBuDyJ+nigkyy+
> bTtHbwkMqNddrqKJ3r928nKwz1IOyU4J58l7hGyC0owSA3mDxyI7+yS16OXFwc1S
> 6lxtV4ljf6nqobA+rVyC3n3BU6CF1aL45V2FpM/m4OHL/Xqv97Xg2tGlysnk8RPD
> dRvz5fs2T75B0eBsK4xWHKEgKKWdVYaKqlySRXUJQpnNJTlJltW5HzL8RnR47brt
> LLaOCD4jcLlEtGhTi6wEN6BlEYbgDx/1yjQs5zxLG0vbTUi5ZcTeT82d5+Hh4WMD
> HyLfE4pwFUZXTHvcIoQ51wPLS/tWMVJXnleQKBrDT+WcsKPr5yuwUZpwfrOBfjol
> Qan13/mIcmvFsz2yVWnoZJWU5osnhe+frBsVFlIFLNXp50QVXk+WvruPDOsoY2eQ
> J8L20LhY5e0dgJseXWkAAy68mJ0/rrkX0iAdiED/WEsBdjy7QuOomJqPyQQEPplm
> d+tIkDR77Biajket2tNEXK1m14f7QvFUFojI0NwegcmZT3iJ7BBWD6wjxIvh3KqE
> LqHIcTaECU9XSg9x9E3N416hCbclC9xeosxaJB1iN+EvpaD7CBA+V+onkNMN6Fu4
> J0aVUYlZuLcqkEs/BuNL
> =BRtR
> -----END PGP SIGNATURE-----
>
