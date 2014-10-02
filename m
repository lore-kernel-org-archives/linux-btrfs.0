Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-chadwick.wadns.net ([41.185.62.109]:19438 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbaJBGFY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 02:05:24 -0400
Message-ID: <542CE7CC.4020904@swiftspirit.co.za>
Date: Thu, 02 Oct 2014 07:51:08 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check segfaults after flipping 2 Bytes
References: <542C6443.1010809@niklasfi.de> <pan$36400$3ee14aa9$ee1e5a94$415ce7b2@cox.net>
In-Reply-To: <pan$36400$3ee14aa9$ee1e5a94$415ce7b2@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/10/02 01:31, Duncan wrote:
> Niklas Fischer posted on Wed, 01 Oct 2014 22:29:55 +0200 as excerpted:
>
>> I was trying to determine how btrfs reacts to disk errors, when I
>> discovered, that flipping two Bytes, supposedly inside of a file can
>> render the filesystem unusable. Here is what I did:
>>
>> 1. dd if=/dev/zero of=/dev/sdg2 bs=1M
>> 2. mkfs.btrfs /dev/sdg2
>> 3. mount /dev/sdg2 /tmp/btrfs
>> 4. echo "hello world this is some text" > /tmp/btrfs/hello
>> 5. umount /dev/sdg2
> Keep in mind that on btrfs, small enough files will not be written to
> file extents but instead will be written directly into the metadata.
>
> That's a small enough file I guess that's what you were seeing, which
> would explain the two instances of the string, since on a single device
> btrfs, metadata is dup mode by default.
>
> That metadata block would then fail checksum, and an attempt would be
> made to use the second copy, which of course would fail it the same way.
At least a very unlikely scenario in production.
> And that being the only file in the filesystem, I'd /guess/ (not being a
> developer myself, just a btrfs testing admin and list regular) that
> metadata block is still the original one, which very likely contains
> critical filesystem information as well, thus explaining the mount
> failure when the block failed checksum verify.
This is a possible use-case for an equivalent to ZFS's ditto blocks. An 
alternative strategy would be to purposefully "sparsify" early metadata 
blocks (this is thinking out loud - whether or not that is a viable or 
easy strategy is debatable).
> In theory at least, with a less synthetic test case there'd be enough
> more metadata on the filesystem that the affected metadata block would be
> further down the chain, and corrupting it wouldn't corrupt critical
> filesystem information as it wouldn't be in the same block.
>
> That might explain the problem, but I don't know enough about btrfs to
> know how reasonable a solution would be.
> [snip]
A reasonable workaround to get the filesystem back into a usable or 
recoverable state might be to mount read-only and ignore checksums. That 
would keep the filesystem intact, though the system has no way to know 
whether or not the folder structures are also corrupt.

I'm not sure if there is a mount option for this use case however. The 
option descriptions for "nodatasum" and "nodatacow" imply that *new* 
checksums are not generated. In this case the checksums already exist.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

