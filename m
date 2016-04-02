Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37641 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcDBTly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Apr 2016 15:41:54 -0400
Received: by mail-ig0-f175.google.com with SMTP id l20so28696330igf.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 12:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160401055725.GA9342@torres.zugschlus.de>
References: <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
	<56F7E65C.7020300@gmx.com>
	<20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
	<56FC7E6D.8010805@cn.fujitsu.com>
	<56FC8C15.5060002@cn.fujitsu.com>
	<20160331210004.GZ9342@torres.zugschlus.de>
	<20160331231630.7b4ceda9@jupiter.sol.kaishome.de>
	<20160401055725.GA9342@torres.zugschlus.de>
Date: Sat, 2 Apr 2016 13:41:53 -0600
Message-ID: <CAJCQCtQu=OD9bep2r5xYc1Nt7DZis-1g2aj6BkyeNThrJzD9pw@mail.gmail.com>
Subject: Re: bad metadata crossing stripe boundary
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 11:57 PM, Marc Haber
<mh+linux-btrfs@zugschlus.de> wrote:
> On Thu, Mar 31, 2016 at 11:16:30PM +0200, Kai Krakow wrote:
>> Am Thu, 31 Mar 2016 23:00:04 +0200
>> schrieb Marc Haber <mh+linux-btrfs@zugschlus.de>:
>> > I find it somewhere between funny and disturbing that the first call
>> > of btrfs check made my kernel log the following:
>> > Mar 31 22:45:36 fan kernel: [ 6253.178264] EXT4-fs (dm-31): mounted
>> > filesystem with ordered data mode. Opts: (null) Mar 31 22:45:38 fan
>> > kernel: [ 6255.361328] BTRFS: device label fanbtr devid 1 transid
>> > 67526 /dev/dm-31
>> >
>> > No, the filesystem was not converted, it was directly created as
>> > btrfs, and no, I didn't try mounting it.
>>
>> I suggest that your partition contained ext4 before, and you didn't run
>> wipefs before running mkfs.btrfs.
>
> I cryptsetup luksFormat'ted the partition before I mkfs.btrfs'ed it.
> That should do a much better job than wipefsing it, shouldnt it?

Not really. The first btrfs super is at 64K. The second at 64M. The
third at 256G. While wipefs will remove the magic only on the first,
mkfs.btrfs will take care of all three. And luksFormat only overwrites
the first 132K of a block device. There's a scant chance of bugs
related to previous filesystems not being erased, I think this is more
likely when mixing and matching filesystems just because the
superblocks for each filesystem aren't in the same location.

If you're concerned about traces of previous file systems, then use
the dmcrypt device itself, rather than merely using the original block
device where merely 132K at the beginning has been overwritten.
Everytime you format a device, the resulting dmcrypt logical device is
in effect full of completely random data. A new random key is
generated each time you use luksFormat, even if you're using the same
passphrase.

-- 
Chris Murphy
