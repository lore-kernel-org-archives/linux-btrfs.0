From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [PATCH 0/3] btrfs: extended inode refs
Date: Thu, 05 Apr 2012 17:13:29 -0400
Message-ID: <4F7E0AF9.7070305@suse.de>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333656543-4843-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/05/2012 04:09 PM, Mark Fasheh wrote:
> Currently btrfs has a limitation on the maximum number of hard
> links an inode can have. Specifically, links are stored in an array
> of ref items:
> 
> struct btrfs_inode_ref { __le64 index; __le16 name_len; /* name
> goes here */ } __attribute__ ((__packed__));
> 
> The ref arrays are found via key triple:
> 
> (inode objectid, BTRFS_INODE_EXTREF_KEY, parent dir objectid)
> 
> Since items can not exceed the size of a leaf, the total number of
> links that can be stored for a given inode / parent dir pair is
> limited to under 4k. This works fine for the most common case of
> few to only a handful of links. Once the link count gets higher
> however, we begin to return EMLINK.
> 
> 
> The following patches fix this situation by introducing a new ref
> item:
> 
> struct btrfs_inode_extref { __le64 parent_objectid; __le64 index; 
> __le16 name_len; __u8   name[0]; /* name goes here */ }
> __attribute__ ((__packed__));
> 
> Extended refs behave differently from ref arrays in several key
> areas.

Thanks for digging into this. It's been heating up on the list lately.

> Each extended refs is it's own item so there is no ref array (and 
> therefore no limit on size).
> 
> As a result, we must use a different addressing scheme. Extended
> ref keys look like:
> 
> (inode objectid, BTRFS_INODE_EXTREF_KEY, hash)
> 
> Where hash is defined as a function of the parent objectid and link
> name.

I think this is effective. It will essentially have the same
properties as a dirent but seeds the hash at objectid instead of ~1.

> This effectively fixes the limitation, though we have a slightly
> less efficient packing of link data. To keep the best of both
> worlds then, I implemented the following behavior:
> 
> Extended refs don't replace the existing ref array. An inode gets
> an extended ref for a given link _only_ after the ref array has
> been filled.  So the most common cases shouldn't actually see any
> difference in performance or disk usage as they'll never get to the
> point where we're using an extended ref.
> 
> It's important while reading the patches however that there's still
> the possibility that we can have a set of operations that grow out
> an inode ref array (adding some extended refs) and then remove only
> the refs in the array.  I don't really see this being common but
> it's a case we always have to consider when coding these changes.
> 
> Right now there is a limitation for extrefs in that we're not
> handling the possibility of a hash collision. There are two ways I
> see we can deal with this:
> 
> We can use a 56-bit hash and keep a generation counter in the lower
> 8 bits of the offset field.  The cost would be an additional tree
> search (between offset <hash>00 and <hash>FF) if we don't find
> exactly the name we were looking for.
> 
> An alternative solution to dealing with collisions could be to
> emulate the dir-item insertion code - specifically something like
> insert_with_overflow() which will stuff multiple items under one
> key. I tend to prefer the idea of

I vote for this option. The code for insert_with_overflow is already
well tested and anything that will generate a collision in dirent
insertion will generate a collision for the backref insertion. The
dirent structure is larger than the extref structure, so there should
always be space to match the dirent leaf so that a failure occurs
there first.

- -Jeff
- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPfgr5AAoJEB57S2MheeWyt6cQAJPHUlCtB3+huJTodA7ow+jy
3WPhrbTPYME6lLpC/JQH8XbogKL1IqLbsvl9M3KzHMZAJ4fRzNJXmMCFgIou4cgu
v2cnNwkU1r5LJF/M3HMk1nhxABCeSONNTFqDbEp/eiTbI7X/UsM6q0vdPpj0vYih
20kWZhazmgx4pUPrtldKU+k91jjsZRoZyn8Bx6lEYPKIx1RQuBDPDH8q3ep5og2d
OQHDfMVNEJJ9Mz9lv+BZDqx/Q2Om8wyaM5GfjhtSocT+XrpTT4tC8FnKiUuOE1Ej
dy1Td43t+cCWvglGRDFj5I6ObfW7x4aUDTizo1hMUuGEQFQVc3vGY3OtDuqPxwoV
XS/4XRR3GU2cmsyjTky4Twa+81RF84cUl05+gM9VMaD7BJX60kIp1SXnE/TpyVUd
oVgZsgkV75R4XmjBp1zDrDRHTzpsgxm+zaVhSTxOKWhnV1bWLZ36SXw/1LRr0IVP
K+0xbnds7WWoRJNMSpJTBgAr7N4A5QEYvIUSQEO4UpgX4EXHYkfWstvvYNx1vUOT
HiHtS3ZKbrfzcmD1ZNSOPAcxold5BsVisuBwoyJnvOyCFeCi+Q+S0W8wA0kI6iS8
57nWYZfGelKLm/ATL8vPkpj6BCkFfhAK8neNdd80v1SpkUJOZr5tMTxaYO1r3QvC
T0e3jAC32pgrJ/2fByT+
=dx+I
-----END PGP SIGNATURE-----
