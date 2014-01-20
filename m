Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail.aei.mpg.de ([194.94.224.6]:42577 "EHLO umail.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaATP17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 10:27:59 -0500
Received: from [172.16.22.49] (unknown [172.16.22.49])
	by umail.aei.mpg.de (Postfix) with ESMTPSA id 11D3B200C6C
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 16:27:58 +0100 (CET)
From: Ian Hinder <ian.hinder@aei.mpg.de>
Content-Type: text/plain; charset=us-ascii
Subject: Re: btrfs and ECC RAM
Message-Id: <A206B26E-5CB3-4507-9177-7E7A7DE73FBB@aei.mpg.de>
Date: Mon, 20 Jan 2014 16:27:57 +0100
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(apologies for messing up the threading; I thought I could get away with not subscribing.  I've subscribed now.)

> Martin Steigerwald <Martin <at> lichtvoll.de> wrote:Am Samstag, 18. Januar 2014, 07:16:42 schrieb :
> I think Ian refers to the slight chance that BTRFS assumes the checksum on one 
> disk to be incorrect due to a memory error 
> *and*
>  on another disk to be correct 
> due to another memory error 
> *and*
>  will silently rewrite the incorrect data to 
> the correct data.
> 
> AFAIK BTRFS still does not correct such errors automatically, but only on a 
> scrub. There this 
> *could*
>  happen theoretically.
> 
> My gut feeling is, that this is highly, highly unlikely.
> 
> At least not more likely than a controller writing out garbage or other such 
> hardware issues.

Actually, I hadn't fully understood this scenario; I was just asking because of what some of the ZFS people were saying.  

To clarify, what you describe could happen like this (is this what you meant?):

- Checksum is computed
- Checksum and data written to locations A and B, but location B suffers a memory corruption of the data en-route (maybe in some intermediate buffer) so is stored incorrectly on disk
- btrfs scrub then reads A, but suffers a memory error, and thinks the good data is bad
- Hence B is read, but another memory error causes the checksum to pass
- Since the checksum passed, B is written to A, overwriting the data

This requires a collision in the checksumming algorithm, so I don't think we need to worry about this case. It's at least as what could happen by chance with a random disk error, but the chance is negligible.

Another possibility is that A and B are both correctly written.  A memory error then happen when reading A from disk, triggering a read of B, which passes its checksum.  B is then written to A, but another memory error in some buffer causes a corruption.  This doesn't require a checksum collision, just frequent memory errors.  But it could indeed lead to trashing the whole FS during a scrub if memory errors are sufficiently frequent perhaps?  If you have memory errors occurring sufficiently frequently that you get two errors while processing a single block during a scrub, then your memory is probably very far gone.  On the other hand, if btrfs is reusing the same two memory buffers for reads and writes, and you happen to have errors in those buffers, then maybe this isn't so unlikely?  This could maybe be mitigated by cancelling the scrub if there are too many errors requiring rewrites.  

-- 
Ian Hinder
http://numrel.aei.mpg.de/people/hinder

