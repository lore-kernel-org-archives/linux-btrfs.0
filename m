Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44578 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaLPNzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 08:55:47 -0500
Received: by mail-lb0-f172.google.com with SMTP id u10so10968259lbd.31
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 05:55:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <548F83B8.50901@cn.fujitsu.com>
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H5TrEGT87by4Zgs_Gy-OagBBEQVdk0A54snC9334wRP1w@mail.gmail.com>
	<20141215173558.GS27601@twin.jikos.cz>
	<548F83B8.50901@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 13:55:46 +0000
Message-ID: <CAL3q7H6oEQp1JC-Omm41LtHqLcZM85Gk1CF43gqxB6eR8HjQLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 16, 2014 at 12:58 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
> -------- Original Message --------
> Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
> script fsck test case.
> From: David Sterba <dsterba@suse.cz>
> To: Filipe David Manana <fdmanana@gmail.com>
> Date: 2014年12月16日 01:35
>>
>> On Mon, Dec 15, 2014 at 09:36:51AM +0000, Filipe David Manana wrote:
>>>
>>> So another thing I would like to see is doing a more comprehensive
>>> verification that the repair code worked as expected. Currently we
>>> only check that a readonly fsck, after running fsck --repair, returns
>>> 0.
>>>
>>> For the improvements you've been doing, it's equally important to
>>> verify that --repair recovered the inodes, links, etc to the
>>> lost+found directory (or whatever is the directory's name).
>>>
>>> So perhaps adding a verify.sh script to the tarball for example?
>>
>> A verifier script would be good, but I'd rather not put it into the
>> tarball. We might want to edit it, do cleanups etc, this would require
>> to regenerate the image each time and the changes would be hard to
>> review.
>>
>> We can use the base image name and add -verify.sh suffix instead, eg.
>> 007-bad_root_items_fs_skinny.tar.xz and
>> 007-bad_root_items_fs_skinny-verify.sh
>>
>>
> I'd like to add verify script too, especially when it is put out of the
> tarball.
>
> But to the leaf-corruption case, it seems a little overkilled for me.
>
> 1) The object of leaf-corrupt recover is not to salvage data.
> Although most of the patches are trying its best to salvage as much data as
> possible ,
> from ino to file type or even later extent data, but in fact, the patchset's
> main object is to make the metadata
> of the btrfs consistent. The data recovery is just a optional addition.
> (Original, it's designed to delete every inode whose metadata is lost in a
> corrupted leaf)
> So the second btrfsck's return value instead of the contents in lost+found
> is the important.
>
> 2) The recovery is *lossy*, verify would better be called on *lossless*
> recovery
> Leaf-corruption is based on the btree recovery, which will introduce data
> loss(at least a leaf),
> so we can't ensure anything.
> And in some case, repair_inode_backref() will even repair backref before
> nlink repair,
> which may introduce some randomness
> (if a inode_item is not corrupted in a leaf, then a backref maybe repaired
> without move it to lost+found dir)
> So for *lossy* repair, I prefer not to add verify script.

>From the moment we have code that accomplishes something, it doesn't
matter if it was part of a primary or secondary goal of a patch, nor
if it does full or partial recovery. If we have code that does
something (intentionally) we should always try to have tests for it -
if we don't care about what the code does exactly, then we probably
shouldn't have it in the first place.
Otherwise code will break more easily with future changes. Having
manual tests done on each release (or ideally after each btrfs-progs
or fsck at least) is error prone...

>
> I generally agree to add verify script support, but only for lossless
> recovery case.
>
> Thanks,
> Qu



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
