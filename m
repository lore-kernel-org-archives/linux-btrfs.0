Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933729AbbIVQXX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 12:23:23 -0400
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <56018074.5000305@suse.com>
Date: Tue, 22 Sep 2015 12:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <5601596B.1020607@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/22/15 9:36 AM, Holger Hoffstätte wrote:
> On 09/22/15 14:59, Jeff Mahoney wrote: (snip)
>> So if they way we want to prevent the loss of raid type info is
>> by maintaining the last block group allocated with that raid
>> type, fine, but that's a separate discussion.  Personally, I
>> think keeping 1GB
> 
> At this point I'm much more surprised to learn that the RAID type
> can apparently get "lost" in the first place, and is not persisted 
> separately. I mean..wat?
> 
>> allocated as a placeholder is a bit much.  Beyond that, I've
>> been
> 
> Can you explain why keeping at least one data chunk (or the
> appropriate number across devices, depending on RAID level..) is "a
> bit much"? IMHO this would have no real negative impact on end
> users (who think in terms of overall filesystem space, not how much
> of that has been lazily touched), nor for more obscure use cases
> like sparse images - which would still be sparsely reserved. So
> there would not be any actual downside that I can see. From a fs
> consistency point of view it sounds much more sane to assume that
> at least a basic set of data chunks always need to exist. I know I
> was very surprised recently to see all my data chunks cleaned up on
> an otherwise empty fs. I mean..it's good to see that the house
> cleaning works, but you also gotta know when to stop!

Ok, say you have a file system populated entirely with ~ 3k files.
You won't actually need a data chunk at all and you'd just waste that
chunk.  A file system like that wouldn't need a data chunk at all.
It's a contrived case, sure, but not an unrealistic one.  We've
already seen workloads like this.

>> thinking casually about ways to direct the allocator to use
>> certain devices for certain things (e.g. in a hybrid system with
>> SSDs and HDDs, always allocate metadata on the SSD) and there's
>> some overlap there.  As it stands, we can fake that in mkfs but
>> it'll get stomped by balance nearly immediately.
> 
> Please share those casual thoughts with the group. :)

The simplest way would be to add a flag to disallow removal of block
groups.  If the goal is to say "this device is only to be used for
metadata at X RAID level" then it's enough to say that chunks on that
device can't be balanced away.

Beyond that, we start to run into the same problems we have with RAID
levels now.  The disk format technically supports multiple RAID levels
simultaneously for both data and metadata.  How that would work in
practice gets a little tricky.  Maybe, as David said, something like
object properties are the answer.  If a subvolume is annotated as
needing storage of a particular description, then we can create chunks
meeting that requirement as required.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJWAYB0AAoJEB57S2MheeWyrjcP/2tnnrkV3Ghxpr5rglfiPEDB
ma2OS17FJHkWcPAGlw/KMsxXxU2UX8QNuX9R39Dp+seWprplMPMQQqD12dMZGd9M
4ZeXcv6AzSWW+aE3O1cnXZK4sJMHkb+t5Tk4nRBHY+wf9VIy1bBWwbnfde8jbau0
WubvjDQeCM4AjMbKOhqTsfWtCNXv6pbPzrBI070JQkIvLyvDNVNQ37XQ76The1tW
W/urZecv0Efw9fXruGZcvXPKkUOuc/Fh6xsWBQyDqjU0EDx9TyX27ZCSLYmPON6E
Ihlk3BY96TV8AeFH0IAbFyWfaYL4pokPF+hW06hjPSgMBOEE8NKnL1SyLFU7xNTt
pcQ7KISxGPvLiNyeN0ESDU7WoifmEO0wr/dNSKd4iFJxRi9pImKYViscgNTkPmAt
hkFNKANGTwa7/YBXYVwctfYbSdF0DFHakvG4PTtiucjTW04BhIlU8UC/eUqGbpol
CRQZY/JPy80Sgc/dNktY3srMfgeWhcu7E+Q6ogS4LQ//5ry1NlxB34nTMVEdjR5v
yivkvxjMXZHKxC8CBOF5xDP7ILq5Zf9m+mozjnEI6flto72t4N6TB70Zwj3+3mSw
vG3k/kZCqSF6tfNoPUibOuLpZsA9KVpTMtZfU6niOSOuvPBZHyjwR6ErtZoQt+VJ
jL+GQMaHE28HjEQ2z64D
=9oFr
-----END PGP SIGNATURE-----
