From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Wed, 26 Oct 2011 11:18:42 -0400
Message-ID: <4EA824D2.6070801@suse.com>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com> <20111026151024.GB5914@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111026151024.GB5914@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/26/2011 11:10 AM, David Sterba wrote:
> Hi,
> 
> I've tested it and still crashes in xfstets/113, but this time I
> know what to look for :)
> 
> On Mon, Oct 24, 2011 at 09:02:43PM -0400, Jeff Mahoney wrote:
>> --- a/fs/btrfs/extent_io.h +++ b/fs/btrfs/extent_io.h @@ -200,10
>> +200,10 @@ void free_extent_state(struct extent_sta int
>> test_range_bit(struct extent_io_tree *tree, u64 start, u64 end, 
>> int bits, int filled, struct extent_state *cached_state); int
>> clear_extent_bits(struct extent_io_tree *tree, u64 start, u64
>> end, -		      int bits, gfp_t mask); +		      int bits, gfp_t
>> mask) __must_check;
> ^^^^^^^^^^^^ this
> 
>> int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64
>> end, -		     int bits, int wake, int delete, struct extent_state
>> **cached, -		     gfp_t mask); +		     int bits, int wake, int
>> delete, +		     struct extent_state **cached, gfp_t mask)
>> __must_check;
> ^^^^^^^^^^^^ this
> 
>> int set_extent_bits(struct extent_io_tree *tree, u64 start, u64
>> end, int bits, gfp_t mask) __must_check; int
>> set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, 
>> @@ -218,7 +218,7 @@ int set_extent_new(struct extent_io_tree int
>> set_extent_dirty(struct extent_io_tree *tree, u64 start, u64
>> end, gfp_t mask) __must_check; int clear_extent_dirty(struct
>> extent_io_tree *tree, u64 start, u64 end, -		       gfp_t mask); 
>> +		       gfp_t mask) __must_check;
> ^^^^^^^^^^^^ shouldn't this be placed at the beginning of the
> prototype?

I don't see why that would need to be the case. It needs to be at the
beginning of the prototype if it's the actual function definition but
not when it's a prototype.

>> @@ -6250,19 +6265,23 @@ static ssize_t btrfs_direct_IO(int rw, s 
>> btrfs_submit_direct, 0);
>> 
>> if (ret < 0 && ret != -EIOCBQUEUED) { -
>> clear_extent_bit(&BTRFS_I(inode)->io_tree, offset, -
>> offset + iov_length(iov, nr_segs) - 1, -			      EXTENT_LOCKED |
>> write_bits, 1, 0, -			      &cached_state, GFP_NOFS); +		ret =
>> clear_extent_bit(&BTRFS_I(inode)->io_tree, offset, +
>> offset + iov_length(iov, nr_segs) - 1, +				       EXTENT_LOCKED
>> | write_bits, 1, 0, +				       &cached_state, GFP_NOFS); +
>> BUG_ON(ret < 0); +		ret = 0;
> ^^^^^^^^ this
> 
>> } else if (ret >= 0 && ret < iov_length(iov, nr_segs)) { /* *
>> We're falling back to buffered, unlock the section we didn't * do
>> IO on. */ -		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset +
>> ret, -			      offset + iov_length(iov, nr_segs) - 1, -
>> EXTENT_LOCKED | write_bits, 1, 0, -			      &cached_state,
>> GFP_NOFS); +		ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
>> offset + ret, +				       offset + iov_length(iov, nr_segs) - 1, 
>> +				       EXTENT_LOCKED | write_bits, 1, 0, +
>> &cached_state, GFP_NOFS); +		BUG_ON(ret < 0); +		ret = 0;
> ^^^^^^^^
> 
> and this clobber the original ret value which is returned a few
> lines below and used in the caller.
> 
>> } out: free_extent_state(cached_state);
> 
> return ret; }

*smack*

Ugh. You're right. It avoids the corruption but signals a short write.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOqCTSAAoJEB57S2MheeWyV7kP/RvVD7qI4clRtXlmw4MI7WwA
xzdc6bykBe6hV3/lhXmsIW0T1ox6x2OazS7d+jp3tGcrBo8NcVuXa9hM40/YtP3y
drbF3aP0eNOs35qxFTehjCh5ZZH/U8+S9EWNSklbIYKwko2hBVSV/0q7G7VFJPa/
GwzNRc+QWXTKNwwNMiONXwCMw/wDA0w2i2zsBr+Rf4HCRb4WHzslFFlqQvc9eD1b
mdE6qIZBLRAkyoPyXpJeMbPRn41PSpEHuOUcKgiYA5t52+b3QNvkyNiPPHNWzIyI
Bf6q8NdEnSPx1idcLTxB8Hh2cV6ITf6SQ6CGZjr1nkF/vJaNX/xip5FaAcDtyhZC
UWeQP0ZiYez86Xz7J/lE/vyP47yqrz8fKRDjCQ35ylF3Ctuf8Lpqjrt8UaawAV7z
VukuuBJ3IxTiUI2IXacKWwrbMO6bKC7WgMOpR/nzETHqE8H8rVKvKiI50S8v140G
dNNOu5BBMw4btqd87edr/J/wXBk5xXJZ29eYkAiaPPt63rpXP+/ppakqCf+AwjyF
3gkyxrj/rYAlRvsLZ6glN3Wowqe3y8Vun9Hq3Occ1+exDtdE7/bh6tVlh1wqaNGo
nZIYPXVBzqmr4ltp0FKJY5vb7MNOeh2QcbKSnSu41s7Xs4pcITyhtbVKxkgWSZlJ
/YDmGztQOu64yUWWm/PR
=BlwO
-----END PGP SIGNATURE-----
