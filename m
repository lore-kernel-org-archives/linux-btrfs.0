From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 0/3] btrfs: extended inode refs
Date: Wed, 11 Apr 2012 15:11:46 +0200
Message-ID: <4F858312.6090905@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <4F7E0AF9.7070305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7E0AF9.7070305@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On 05.04.2012 23:13, Jeff Mahoney wrote:
>> As a result, we must use a different addressing scheme. Extended
>> ref keys look like:
> 
>> (inode objectid, BTRFS_INODE_EXTREF_KEY, hash)
> 
>> Where hash is defined as a function of the parent objectid and link
>> name.
> 
> I think this is effective. It will essentially have the same
> properties as a dirent but seeds the hash at objectid instead of ~1.

The objectid is already part of the key. What's the point in seeding it
to crc32 instead of ~1?

>> Right now there is a limitation for extrefs in that we're not
>> handling the possibility of a hash collision. There are two ways I
>> see we can deal with this:
> 
>> We can use a 56-bit hash and keep a generation counter in the lower
>> 8 bits of the offset field.  The cost would be an additional tree
>> search (between offset <hash>00 and <hash>FF) if we don't find
>> exactly the name we were looking for.
> 
>> An alternative solution to dealing with collisions could be to
>> emulate the dir-item insertion code - specifically something like
>> insert_with_overflow() which will stuff multiple items under one
>> key. I tend to prefer the idea of
> 
> I vote for this option.

Having more than one way to deal with hash collisions for keys doesn't
feel right. Let's find out which works best and use it in both places.
If the current insert_with_overflow style is best, please use that for
extrefs as well. If it isn't, can we replace it with something that
works for both?

> The code for insert_with_overflow is already
> well tested

I'm looking forward to seeing tests or references to the archives
discussing this. Do you have a link for me?

> and anything that will generate a collision in dirent
> insertion will generate a collision for the backref insertion. The
> dirent structure is larger than the extref structure, so there should
> always be space to match the dirent leaf so that a failure occurs
> there first.

I agree with that bit.

-Jan
