Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23495 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759356AbcJaGE0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 02:04:26 -0400
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
To: Marc MERLIN <marc@merlins.org>
References: <20161030183437.GA3287@merlins.org>
 <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com>
 <20161031020616.GH28648@merlins.org>
 <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
 <20161031054719.GN28648@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
Date: Mon, 31 Oct 2016 14:04:10 +0800
MIME-Version: 1.0
In-Reply-To: <20161031054719.GN28648@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/31/2016 01:47 PM, Marc MERLIN wrote:
> On Mon, Oct 31, 2016 at 01:27:56PM +0800, Qu Wenruo wrote:
>> Would you please dump the following bytes?
>> That's the chunk root tree block on your disk.
>>
>> offset: 13500329066496 length: 16384
>> offset: 13500330213376 length: 16384
>
> Sorry for asking, am I doing this wrong?
> myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32
> skip=26367830208
> dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000401393 s, 0.0 kB/s

So, the underlying MD RAID5 are complaining about some wrong data, and 
refuse to read out.

It seems that btrfs-progs can't handle read failure?
Maybe dm-error could emulate it.

And what about the 2nd range?

>
>> According to your fsck error output, I assume btrfs-progs fails to read
>> the first copy of chunk root, and due to a bug, it doesn't continue to
>> read 2nd copy.
>>
>> While kernel continues to read the 2nd copy and everything goes on.
>
> Ah, that would make sense.
> But from what you're saying, I should be able to do recovery by pointing
> to the 2nd copy of the chunk root, but somehow I haven't typed the right
> command to do so yet, correct?

Unfortunately, no the case.

For --chunk-root command, *logical* bytenr is specified.

We can only tell btrfs-progs(kernel is the same) to find tree root/chunk 
root at given *logical* bytenr.

But to read which *physical* copy, we can't specify.

Normally, btrfs-progs/kernel should find the correct physical copy 
without problem, but not this time for btrfs-progs.

And further more, all backup chunk root are in facts pointing to current 
chunk root, so --chunk-root doesn't work at all.

>
> Should I try another command offset than
> btrfs check -p --repair --chunk-root 13835462344704 /dev/mapper/crypt_bcache0
> ?
Nope, that bytenr is *physical* bytenr, not *logical* bytenr 
--chunk-root accepts.

But the read error for first tree block already gives some hint.
I'll try to emulate it.

Thanks,
Qu

>
> Or are you saying the btrfs progs bug causes it to fail to even try to read
> the 2nd copy of the chunk root even though it was given on the command line?
>
> Thanks,
> Marc
>


