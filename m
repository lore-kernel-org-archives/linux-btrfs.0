Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail.aei.mpg.de ([194.94.224.6]:38448 "EHLO umail.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaATO5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 09:57:45 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs and ECC RAM
From: Ian Hinder <ian.hinder@aei.mpg.de>
In-Reply-To: <52DC9453.4000705@gmail.com>
Date: Mon, 20 Jan 2014 15:57:42 +0100
Cc: George Eleftheriou <eleftg@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com> <52DC9453.4000705@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 20 Jan 2014, at 04:13, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 01/19/2014 07:17 PM, George Eleftheriou wrote:
>> I have been wondering the same thing for quite some time after
>> having read this post (which makes a pretty clear case in favour of
>> ECC RAM)...
>> 
>> hxxp://forums.freenas.org/threads/ecc-vs-non-ecc-ram-and-zfs.15449/
>> 
>> ... and the ZFS on Linux FAQ 
>> hxxp://zfsonlinux.org/faq.html#DoIHaveToUseECCMemory
>> 
>> Moreover, the ZFS community seem to cite this article quite often: 
>> hxxp://research.cs.wisc.edu/adsl/Publications/zfs-corruption-fast10.pdf
>> 
>> Without having further knowledge on that matter, I tend to
>> believe (but I hope I'm wrong) that BTRFS is as vulnerable as ZFS
>> to memory errors. Since I upgraded recently, it's a bit too late
>> for purchasing ECC-capable infrastructure (change of CPU +
>> motherboard + RAM) so I just chose to ignore this risk by
>> performing a memtest86 right before every scrub (and having my
>> regular backups ready). I've been using ZFS on Linux for almost 5
>> months (having occasional issues with kernel updates) until last
>> week that I finally switched to BTRFS and I'm happy.
> AFAIK, ZFS does background data scrubbing without user intervention
> (which on a separate note can make it a huge energy hog) to correct
> on-disk errors.  For performance reasons though, it has no built-in
> check to make sure that there really is an error, it just assumes that
> if the checksum is wrong, the data on the disk must be wrong.  This is
> fine for enterprise level hardware with ECC RAM, because the disk IS
> more likely to be wrong in that case than the RAM is.  This assumption
> falls apart though on commodity hardware (ie, no ECC RAM), hence the
> warnings about using ZFS without ECC RAM.

In hxxp://forums.freenas.org/threads/ecc-vs-non-ecc-ram-and-zfs.15449, they talk about reconstructing corrupted data from parity information:

> Ok, no problem. ZFS will check against its parity. Oops, the parity failed since we have a new corrupted bit. Remember, the checksum data was calculated after the corruption from the first memory error occurred. So now the parity data is used to "repair" the bad data. So the data is "fixed" in RAM.

i.e. that there is parity information stored with every piece of data, and ZFS will "correct" errors automatically from the parity information.  I start to suspect that there is confusion here between checksumming for data integrity and parity information.  If this is really how ZFS works, then if memory corruption interferes with this process, then I can see how a scrub could be devastating.  I don't know if ZFS really works like this.  It sounds very odd to do this without an additional checksum check.  This sounds very different to what you say below that btrfs does, which is only to check against redundantly-stored copies, which I agree sounds much safer.  

The second link above from the ZFS FAQ just says that if you place a very high value on data integrity, you should be using ECC memory anyway, which I'm sure we can all agree with.

hxxp://zfsonlinux.org/faq.html#DoIHaveToUseECCMemory:

> 1.16 Do I have to use ECC memory for ZFS?
> Using ECC memory for ZFS is strongly recommended for enterprise environments where the strongest data integrity guarantees are required. Without ECC memory rare random bit flips caused by cosmic rays or by faulty memory can go undetected. If this were to occur ZFS (or any other filesystem) will write the damaged data to disk and be unable to automatically detect the corruption.

i.e. if the data is bad in RAM, the checksumming in ZFS isn't going to help you, but it also isn't going to make things worse.  It doesn't say that a scrub can kill all your data, like the previous link does.  

In hxxp://research.cs.wisc.edu/adsl/Publications/zfs-corruption-fast10.pdf, they essentially say that memory errors can cause problems, and it would be nice if filesystems used their checksumming to also checksum memory locations etc, which would help to detect and mitigate these.

On 20 Jan 2014, at 04:13, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> BTRFS however works differently, it only scrubs data when you tell it
> to.  If it encounters a checksum or read error on a data block, it
> first tries to find another copy of that block elsewhere (usually on
> another disk), if it still sees a wrong checksum there, or gets
> another read error, or can't find another copy, then it returns a read
> error to userspace, usually resulting in the program reading the data
> crashing.  In most environments other than HA clustering, this is an
> excellent compromise that still protects data integrity.

Yes, this sounds fine.

-- 
Ian Hinder
http://numrel.aei.mpg.de/people/hinder

