Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36740 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcDCS3N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Apr 2016 14:29:13 -0400
Received: by mail-ig0-f178.google.com with SMTP id f1so45114967igr.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 11:29:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160403085149.GU9342@torres.zugschlus.de>
References: <20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
	<56F7E65C.7020300@gmx.com>
	<20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
	<56FC7E6D.8010805@cn.fujitsu.com>
	<56FC8C15.5060002@cn.fujitsu.com>
	<20160331210004.GZ9342@torres.zugschlus.de>
	<20160331231630.7b4ceda9@jupiter.sol.kaishome.de>
	<20160401055725.GA9342@torres.zugschlus.de>
	<CAJCQCtQu=OD9bep2r5xYc1Nt7DZis-1g2aj6BkyeNThrJzD9pw@mail.gmail.com>
	<20160403085149.GU9342@torres.zugschlus.de>
Date: Sun, 3 Apr 2016 12:29:12 -0600
Message-ID: <CAJCQCtQcfYQDsuZcnEUGD54W=h7VT+xyydwUwTrMkaJa0ws9uQ@mail.gmail.com>
Subject: Re: bad metadata crossing stripe boundary
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 3, 2016 at 2:51 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Sat, Apr 02, 2016 at 01:41:53PM -0600, Chris Murphy wrote:

>> > I cryptsetup luksFormat'ted the partition before I mkfs.btrfs'ed it.
>> > That should do a much better job than wipefsing it, shouldnt it?
>>
>> Not really. The first btrfs super is at 64K. The second at 64M. The
>> third at 256G. While wipefs will remove the magic only on the first,
>> mkfs.btrfs will take care of all three. And luksFormat only overwrites
>> the first 132K of a block device. There's a scant chance of bugs
>> related to previous filesystems not being erased, I think this is more
>> likely when mixing and matching filesystems just because the
>> superblocks for each filesystem aren't in the same location.
>
> If I do:
>
> umount /dev/mapper/foo
> cryptsetup close /dev/mapper/foo
> cryptsetup luksFormat /dev/mapper/pv-c_foo
> cryptsetup open /dev/mapper/pv-c_foo foo
>
> and the contents of /dev/mapper/foo would randomly resemble its
> previous contents afterwards, I would be _very_ disturbed.


You wrote "luksFormat the partition, then mkfs.btrfs it" and then also
"wipefs it" where in each case "it" sounded to me like you're
referring to the same partition. But your example makes it more clear
you're referring to mkfs.btrfs being done not on the partition, but on
the dmcrypt device.



> During the
> luksFormat process, a new random symmetric key is created, and
> overwrites the old random symmetric key in the LUKS header. Therefore,
> the following crypto operations are _very_ unlikely to produce
> something that resembles an ext4 fileystem.

All the primates on the planet have a better chance of writing
Shakespeare, this year.

>
> Even if I did:
>
> umount /dev/mapper/foo
> cryptsetup close /dev/mapper/foo
> mkfs.btrfs /dev/mapper/pv-c_foo
>
> (assuming I previously did cryptsetup open /dev/mapper/pv-c_foo foo)
>
> I would be _very_ surprised if the kernel would find something
> resembling and ext4 file system on /dev/mapper/pv-c_foo.

I don't follow that at all, really. It's a sequence, vaguely modified
by a parenthetical in a way that I do not understand, with an outcome
that can't be confirmed or denied because mkfs.ext4 isn't in your
sequence anywhere.

If you  were to see (encrypted) writes to the LV, you could identify
the file system being used based on the write pattern. While the
writes themselves are ciphertext and therefore you don't know what is
being written, the write pattern is not obfuscated by dmcrypt so you
could infer what is doing the writing by that pattern (probably both
application and the filesystem could be identified).


-- 
Chris Murphy
