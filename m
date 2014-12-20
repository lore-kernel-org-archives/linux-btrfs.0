Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4615 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752448AbaLTL22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 06:28:28 -0500
Message-ID: <54955D56.20900@fb.com>
Date: Sat, 20 Dec 2014 06:28:22 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
CC: Daniele Testa <daniele.testa@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com> <54949454.9020601@fb.com> <549495D4.9030800@fb.com> <20141220055242.GB436@hungrycats.org>
In-Reply-To: <20141220055242.GB436@hungrycats.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/20/2014 12:52 AM, Zygo Blaxell wrote:
> On Fri, Dec 19, 2014 at 04:17:08PM -0500, Josef Bacik wrote:
>>> And for your inode you now have this
>>>
>>> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
>>> disklen 4k
>>> inode 256, file offset 4k, size 302g-4k, offset 4k, diskbytenr 123,
>>> disklen 302g
>>>
>>> and in your extent tree you have
>>>
>>> extent bytenr 123, len 302g, refs 1
>>> extent bytenr whatever, len 4k, refs 1
>>>
>>> See that?  Your file is still the same size, it is still 302g.  If you
>>> cp'ed it right now it would copy 302g of information.  But what you have
>>> actually allocated on disk?  Well that's now 302g + 4k.  Now lets say
>>> your virt thing decides to write to the middle, lets say at offset 12k,
>>> now you have this
>>>
>>> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
>>> disklen 4k
>>> inode 256, file offset 4k, size 3k, offset 4k, diskbytenr 123, disklen 302g
>>> inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever,
>>> disklen 4k
>>> inode 256, file offset 16k, size 302g - 16k, offset 16k, diskbytenr 123,
>>> disklen 302g
>>>
>>> and in the extent tree you have this
>>>
>>> extent bytenr 123, len 302g, refs 2
>>> extent bytenr whatever, len 4k, refs 1
>>> extent bytenr notimportant, len 4k, refs 1
>>>
>>> See that refs 2 change?  We split the original extent, so we have 2 file
>>> extents pointing to the same physical extents, so we bumped the ref
>>> count.  This will happen over and over again until we have completely
>>> overwritten the original extent, at which point your space usage will go
>>> back down to ~302g.
>
> Wait, *what*?
>
> OK, I did a small experiment, and found that btrfs actually does do
> something like this.  Can't argue with fact, though it would be nice if
> btrfs could be smarter and drop unused portions of the original extent
> sooner.  :-P
>

So we've thought about changing this, and will eventually, but it's kind 
of difficult.  Above is an example of what happens currently, so the 
split code for file extents is kind of big and scary, check 
__btrfs_drop_extents.  We would have to fix that to adjust the 
disk_bytenr and disk_num_bytes, which isn't too bad since we already are 
doing this dance and adjusting offset.  The trick would be when updating 
the extent references, we would have to split those extents.  So say we 
have a 128mb extent and we write 4k at 1mb.  If we split the extent refs 
we'd have this afterwards

(note this isn't how they'd be ordered on disk, just written this way so 
it makes logical sense)

extent bytenr 0, len 1mb, refs 1
extent bytenr 128mb, len 4k, refs 1
extent bytenr 1mb+4k, len 128mb-4k, refs 1

Ok so now we have 3 extents in the extent tree to describe essentially 2 
ranges that are in use, but we get back the 4k so that's nice.  But wait 
there's more!  What if we're snapshotted?  We can't just drop that 4k 
because somebody else has a reference to it.  So what do we do?  Well we 
could do something like this

extent bytenr 0, len 1mb, refs 1
extent bytenr 0, len 128mb, refs 1
extent bytenr 128mb, len 4k, refs 1
extent bytenr 1mb+4k, len 128mb-4k, refs 1

This creates all sorts of problems for us.  We now have two extents with 
the same bytenr but with different lengths.  This could be ok, we'd have 
to add a bunch of checks to make sure we're looking at the right extent, 
but it wouldn't be horrible.  I imagine we'd be fixing weird corruption 
bugs for a few releases though while we found all of the corner cases we 
missed.

Then there is the problem of actually returning the free space.  Now if 
we drop all of the refs for an extent we know the space is free and we 
return it to the allocator.  With the above example we can't do that 
anymore, we have to check the extent tree for any area that is left 
overlapping the area we just freed.  This add's another search to every 
btrfs_free_extent operation, which slows the whole system down and again 
leaves us with weird corner cases and pain for the users.  Plus this 
would be an incompatible format change so would require setting a 
feature flag in the fs and rolled to voluntarily.

Now I have another solution, but I'm not convinced it's awesome either. 
  Take the same example above, but instead we split the original extent 
in the extent tree so we avoid all the mess of having overlapping ranges 
and get this instead

extent bytenr 0, len 1mb, refs 2
extent bytenr 1mb, len 4k, refs 1  <-- part of the original extent
					pointed to by the snapshot
extent bytenr 128mb, len 4k, refs 1
extent bytenr 1mb+4k, len 128mb-4k, refs 2

So yay we've solved the problem of overlapping extents and bonus this is 
backwards compatible.  So why don't we do this?  Well all the reasons I 
listed above about corner cases and much pain for our users.  This 
wouldn't require a format change so everybody would get this behaviour 
as soon as we turned it on, and I feel I would be doing a lot of fsck 
work for the next 6 months.  Plus we would have to add a 'split' 
operation to the extent operations that copies all of the extent 
references around and drops the proper reference.  Keep in mind that 
I've been showing a dumbed down version of extent refs, what it would 
really look like is this

extent bytenr 0, len 128mb, refs 2
	root 5, owner 256, refs 1
	root 256, owner 256, refs 1

So when we do our split operation we'd copy this extent entry twice, 
update the two sides with their new offset and len, and drop the 
original inode from the middle thing, and finally add our new extent. 
That is a lot more work for one operation than just adding a new entry 
or removing an old entry.  Not only is it more work but it adds more 
metadata to the extent root, which makes extent operations more 
expensive which again slows the whole file system down.

Welcome to file system development, you spin the giant wheel of trade 
offs and decide which sucks less for you and your users.  Years ago we 
chose simplicity in one of the more complex areas of btrfs for wasting 
space in overwrites.  It's not super clear that was the right choice so 
we're considering changing it, but as you can see it ain't going to be 
fun, and will require other trade offs which may have unintended 
consequences later on.  Thanks,

Josef
