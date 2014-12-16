Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:46660 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbaLPTwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 14:52:46 -0500
Message-ID: <54908D8A.8040101@pobox.com>
Date: Tue, 16 Dec 2014 11:52:42 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com> <548EABBB.4060204@pobox.com> <548FA762.2070504@pobox.com> <549017E8.7060107@cn.fujitsu.com>
In-Reply-To: <549017E8.7060107@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2014 03:30 AM, Dongsheng Yang wrote:
>
> Hi Robert, thanx for your proposal about this.
>
> IMHO, output of df command shoud be more friendly to user.
> Well, I think we have a disagreement on this point, let's take a look at
> what the zfs is doing.
>
> /dev/sda7- 10G
> /dev/sda8- 10G
> # zpool create myzpool mirror /dev/sda7 /dev/sda8 -f
> # df -h /myzpool/
> Filesystem      Size  Used Avail Use% Mounted on
> myzpool         9.8G   21K  9.8G   1% /myzpool
>
> That said that df command should tell user the space info they can see.
> It means the output is the information from the FS level rather than
> device level or _storage_manager level.

That's great for ZFS, but ZFS isn't BTRFS. ZFS can't get caught halfway 
between existing modailties and sit there forever. ZFS doesn't 
restructure itself. So the simple answer you want isn't _possible_ 
outside very simple cases.

So again, you've displayed a _simple_ case as if it covers or addresses 
all the complex cases.

(I don't have the storage to actually do the exercise) But what do you 
propose the correct answer is for the following case:


/dev/sda - 7.5G
/dev/sdb - 7.5G

mkfs.btrfs /dev/sd{a,b} -d raid0
mount /dev/sda /mnt
dd if=/dev/urandom of=/mnt/consumed bs=1G count=7
btrfsck balance start -dconvert=raid1 -dlimit=1 /mnt
(wait)
/bin/df


The filesystem is now in a superposition where all future blocks are 
going to be written as raid1, one 2G stripe has been converted into two 
two-gig stripes that have been mirrored, and six gig is still RAID0.

In your proposal we now have
@size=7G
@used=??? (clearly 7G, at the least, is consumed)
@filesize[consumed]=7G

@available is really messed up since there is now _probably_ 1G of one 
of the original raid0 extents with free space and so available, almost 
all of the single RAID1 metadata block, Room for three more metadata 
stripes, and room for one more RAID1 extent.

so @available=2-ish gigs.

But since statfs() pivots on @size and @available /bin/df is going to 
report @used as 3-ish gigs even though we've got an uncompressed and 
uncompressable @7G file.

NOW waht if we went the _other_ way?

/dev/sda - 7.5G
/dev/sdb - 7.5G

mkfs.btrfs /dev/sd{a,b} -d raid1
mount /dev/sda /mnt
dd if=/dev/urandom of=/mnt/consumed bs=1G count=7
btrfsck balance start -dconvert=raid0 -dlimit=1 /mnt
(wait)
/bin/df

filesystem is _full_ when the convert starts.

@size=14Gig
@used=7G
@actual_available=0
@reported_available=??? (at least 2x1G extents are up for grabs so 
minimum 2G)
@reported_used=???
@calculated_used=???

We are either back to reporting available space when non-trivial 
allocation will report ENOSPC (if I did the math right etc).

Now do partial conversions to other formats and repeat the exercise.
Now add or remove storage here-or-there.

The "working set" and the "current model" are not _required_ to be in 
harmony at any given time, so trying to analyze the working set based on 
the current model is NP-complete.

In every modality we find that at some point we _can_ either report 0 
available and still have room, or we report non-zero available and the 
user's going to get an ENOSPC.


So fine, _IF_ btrfs disallowed conversion and fixed its overhead -- that 
is if it stopped bing btrfs -- we could safely report cooked numbers.

But at that point, why BTRFS at all?

As for being easier on the user, that just depends on which lie each 
user wants. People are smart enough to use a fair approximation, and the 
only fair approximation we have available are at the storage management 
level -- which is halfway between the raw blocks and the cooked 
file-system numbers.

A BTRFS filesystem just _isn't_ fully cooked until the last data extent 
is allocated, and because of COW that's over-cooked as well.


