Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349AbbFJWw2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 18:52:28 -0400
Message-ID: <5578BFA8.6010802@suse.com>
Date: Wed, 10 Jun 2015 18:52:24 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: add missing discards when unpinning extents
 with -o discard
References: <1433342874-7099-1-git-send-email-jeffm@suse.com>	<1433342874-7099-4-git-send-email-jeffm@suse.com> <CAL3q7H6OOP+CYwYc9tjb7brSYtbkLmYwqipv7grFkAULh8SXaw@mail.gmail.com> <55775116.1080201@suse.com> <55777F56.3060303@suse.com>
In-Reply-To: <55777F56.3060303@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/9/15 8:05 PM, Jeff Mahoney wrote:
> On 6/9/15 4:48 PM, Jeff Mahoney wrote:
>> On 6/8/15 10:12 AM, Filipe David Manana wrote:
>>> Running the following in a loop until it returns failure ($?
>>> != 0) triggers an apparent corruption issue most of the time:
> 
>> Ok, I didn't have my test environment set up to do the
>> multidevice tests by default, and definitely didn't have it set
>> up to do 065, since that requires 5+ devices of identical size.
>> Now that I do have that set up, I see this:
> 
>> 8,37   2     1442    22.727796582 15400  D   D 419434496 + 8192 
>> [umoun t]
> 
>> 419434496 is the start of /dev/sdc5 and we're blowing away 4 MB. 
>> That happens to coincide with the system (single) block group.
>> In my testing, I found (IIRC) that system (single) and metadata 
>> (single) were always in the unused list but were getting skipped
>> by the cleaner thread.  It looks like the cleanup block groups
>> on close_ctree is misbehaving.  Whatever condition that was
>> causing those to be skipped must be unset for 065.  It wasn't a
>> problem during normal runtime, but now that it's called in
>> close_ctree, it's introducing a problem.  I'll start digging.
> 
>> Thanks for the review!
> 
> <...>-5472  [014] ....   390.430881: btrfs_chunk_free: root = 
> 3(CHUNK_TREE), offset = 0, size = 4194304, num_stripes = 1, 
> sub_stripes = 0, type = SYSTEM
> 
> That'd do it. If I do a btrfs-debug-tree on the file system
> without discard, it works fine because the superblock doesn't get
> discarded. That 0-4MB chunk _is_ released and unused.

I have a patch up and running that skips the superblock (and mirrors)
during discard.  The superblocks are a special case in how we handle
blocks on the file system.  They exist in the middle of and completely
separate from the block groups.  The blocks are claimed when we read
in the block group by pinning them, but they aren't actually reserved
on disk via a proper extent.

My patch adds a filter to btrfs_issue_discard so that we skip the
superblocks.  Since the superblock locations are per-physical device
and are set whether or not there's a block group on top of them, it
made sense to put the filter there so that both fstrim and -odiscard
skip them without any other special code.

I'm running xfstests now and will post once that's completed.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVeL+oAAoJEB57S2MheeWyYjIP/iefOYjXc0iYHl3aZLZXz/o0
2a4RcE1AntLCZMs5t6m2LLXfScVyYR84f26bQNdJOvIpMYj7ChMpKqyEQ582eGwD
DDAFwi1zGLATdLIDJSkL3U2YZfklTIoX8G3KJgSUA/rhiRV3bl37HnGqxpGIIlym
O2rNiMmF4iqdbF+e0ZpNmLWQ3wwmwDRyHM67nyIboe0Lui41le2EhLng4OFhJ/Qr
Ldnh58cPZs+hvOtW641SBgxvtt8NEDeVjbfJijSY/KgloAcbFq1hM7AKs51+HjPA
zzvHCvhLh5WCcorlpLz/a+Iy9QOx8Tbw5Ef6zOlvWQqPPEj/Q+PROeL6BK+KIDUh
BvaStlYCA68JmyLeSN1EpXvS2MNILVEWGqxcqC8F9JpgYC4/SzLQPAXLgL63UtQm
XQ/n3rg7P4BMegTfEqh57ExhDUUsorN29/2m4kHu1I19OQzIY0a3QTbJYBH1jTvB
nfBivkC6kyIc6aZBrOHY7M0mIzeAq+mCqbYvMWeYVruK+3iW8Vc9PKlE+RgvFvFP
JX7+v/N9Jl2GBObzGPBLUpxdvaU518sKMF/knZfH+8uVKLlDlWFDsH9ZroKp5TBj
GD0u03qiKESq3Z4MEqizHt0+FRwBbWmIEG+5YcNcKrL0gc6ljHoEn6Xp3SPtZkxn
w6Wo0XZyp+rIkxb5peBa
=Iv+E
-----END PGP SIGNATURE-----
