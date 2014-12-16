Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12642 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974AbaLPA6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 19:58:36 -0500
Message-ID: <548F83B8.50901@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 08:58:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com> <CAL3q7H5TrEGT87by4Zgs_Gy-OagBBEQVdk0A54snC9334wRP1w@mail.gmail.com> <20141215173558.GS27601@twin.jikos.cz>
In-Reply-To: <20141215173558.GS27601@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + 
corrupt script fsck test case.
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Date: 2014年12月16日 01:35
> On Mon, Dec 15, 2014 at 09:36:51AM +0000, Filipe David Manana wrote:
>> So another thing I would like to see is doing a more comprehensive
>> verification that the repair code worked as expected. Currently we
>> only check that a readonly fsck, after running fsck --repair, returns
>> 0.
>>
>> For the improvements you've been doing, it's equally important to
>> verify that --repair recovered the inodes, links, etc to the
>> lost+found directory (or whatever is the directory's name).
>>
>> So perhaps adding a verify.sh script to the tarball for example?
> A verifier script would be good, but I'd rather not put it into the
> tarball. We might want to edit it, do cleanups etc, this would require
> to regenerate the image each time and the changes would be hard to
> review.
>
> We can use the base image name and add -verify.sh suffix instead, eg.
> 007-bad_root_items_fs_skinny.tar.xz and
> 007-bad_root_items_fs_skinny-verify.sh
>
>
I'd like to add verify script too, especially when it is put out of the 
tarball.

But to the leaf-corruption case, it seems a little overkilled for me.

1) The object of leaf-corrupt recover is not to salvage data.
Although most of the patches are trying its best to salvage as much data 
as possible ,
from ino to file type or even later extent data, but in fact, the 
patchset's main object is to make the metadata
of the btrfs consistent. The data recovery is just a optional addition.
(Original, it's designed to delete every inode whose metadata is lost in 
a corrupted leaf)
So the second btrfsck's return value instead of the contents in 
lost+found is the important.

2) The recovery is *lossy*, verify would better be called on *lossless* 
recovery
Leaf-corruption is based on the btree recovery, which will introduce 
data loss(at least a leaf),
so we can't ensure anything.
And in some case, repair_inode_backref() will even repair backref before 
nlink repair,
which may introduce some randomness
(if a inode_item is not corrupted in a leaf, then a backref maybe 
repaired without move it to lost+found dir)
So for *lossy* repair, I prefer not to add verify script.

I generally agree to add verify script support, but only for lossless 
recovery case.

Thanks,
Qu
