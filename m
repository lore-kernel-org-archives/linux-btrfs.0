Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24099 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbCLEHR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 00:07:17 -0400
Date: Thu, 12 Mar 2015 12:07:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: is cryptographically secure integrity checking possible with
 btrfs?
Message-ID: <20150312040706.GA26641@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1426131319.2574.18.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426131319.2574.18.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

On Thu, Mar 12, 2015 at 04:35:19AM +0100, Christoph Anton Mitterer wrote:
> Hey.
> 
> For encryption we have dm-crypt and in principle I'm happy with having
> that at the block device level below the filesystem - perhaps except for
> any possible performance issues, especially when used with software RAID
> (regardless of whether MD or btrfs')[0].
> 
> But obviously integrity protection is still missing... and I guess for
> many people this would actually be much more interesting than
> encryption.
> 
> 
> Now as far as I understand btrfs, everything, data and metadata is
> checksummed (right now only with CRC32, but enough space would be left
> for something "better"). And further, these checksums are verified on
> each read.
> 
> Are these checksums chained? I.e. when a datablock is written/changed,
> not only its checksum is affected, but also those of all meta-data
> blocks up to the super blocks?

checksum is updated along with the corresponding datablock's change, but
updating the super block depends on when btrfs starts committing
transaction.

> 
> If so, one could perhaps use this like git for integrity protection.
> 
> For example when unmounting a btrfs filesystem, it could print the final
> checksum of the superblock.
> The user could store this on some safe device (for the paranoid one e.g.
> on a USB stick that always travels along and that by coincidence also
> contains boot loader, kernel+initrd and the dm-crypt keys necessary to
> decrypt the fully encrypted system).
> 
> 
> On mount one could then specify the expected checksum for the
> superblock. If it differs already, then the mount should obviously fails
> right away (or try backup superblocks and that like, but again only use
> them if they match the sum).

That's exactly what we have now in btrfs, but the superblock checksum is only to
verify superblock itself, nothing more.

> 
> Obviously one would also need an operation mode in which btrfs dies with
> bells and red signs as soon as something (data or metadata) is read
> afterwards, which doesn't match the expected checksums.
> again, RAID copies, etc. could of course be tried - but if no valid copy
> is found, then it should assume compromise and the read operation should
> error out and not deliver any data at all (it may be compromised and
> nothing should use it).

Okay, if you kept using btrfs for a while, you can figure out the above
is basically true, but there are some differences,
a) if we find a metadata checksum mismatch, we do go to
get another copy(we usually have two copies for metadata) for good copy
if it is, and if no, we dont make btrfs die but throw a warning(actually
it can refuse to mount if you got such errors during mount and couldnt
find good copies).
b) if we find a data checksum mismatch, we do the same thing, but throw
bad news into dmesg logs and return EIO.


> 
> Of course people might still want to read such "compromised" blocks
> (e.g. when they are sure that they've only suffered from accidental data
> corruption and try to rescue as much as possible), but that should then
> require a special mount option.

So you're asking for a strict mode, but for datablock corruption, is it
OK for you to just flip btrfs into readonly mode instead of making it
die?

> 
> 
> Well I'm not that crypto expert,... and btrfs would probably at least
> need more than CRC32.
> Unfortunately the 512bit version of Keccak wouldn't fit in, would it? ;)

IIRC, we have only 256bit space, so 512bit may need some other tricks.

Thanks,

-liubo
> 
> 
> Cheers,
> Chris.
> 
> 
> [0] Does anyone know the current status of this? When I have say a btrfs
> RAID6 with n disks, each actually being a dm-crypt device... will this
> run all in one IO thread killing the performance?

