From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 17/35] btrfs: split extent_state ops
Date: Wed, 21 Mar 2012 22:35:26 -0400
Message-ID: <4F6A8FEE.50105@suse.com>
References: <20120322011104.212214639@suse.com> <20120322011135.373316482@suse.com> <4F6A86D6.8040109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>,
	David Sterba <dsterba@suse.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F6A86D6.8040109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/21/2012 09:56 PM, Liu Bo wrote:
> On 03/22/2012 09:11 AM, Jeff Mahoney wrote:
>> set_extent_bit can do exclusive locking but only when called by
>> lock_extent*,
>> 
>> Drop the exclusive bits argument except when called by
>> lock_extent.
>> 
> 
> Hi Jeff,
> 
> I have to say this is not a good cleanup, any benefits?

Yeah, it eliminates an argument that's only used by a single caller.

- -Jeff

>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
>> fs/btrfs/extent_io.c |   36 +++++++++++++++++++++++------------- 
>> fs/btrfs/extent_io.h |    2 +- fs/btrfs/inode.c     |    2 +- 3
>> files changed, 25 insertions(+), 15 deletions(-)
>> 
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c index
>> 0112c02..ffa7cc3 100644 --- a/fs/btrfs/extent_io.c +++
>> b/fs/btrfs/extent_io.c @@ -721,9 +721,10 @@ static void
>> uncache_state(struct extent_state **cached_ptr) * [start, end] is
>> inclusive This takes the tree lock. */
>> 
>> -int set_extent_bit(struct extent_io_tree *tree, u64 start, u64
>> end, -		   int bits, int exclusive_bits, u64 *failed_start, -
>> struct extent_state **cached_state, gfp_t mask) +static int
>> __must_check +__set_extent_bit(struct extent_io_tree *tree, u64
>> start, u64 end, +		 int bits, int exclusive_bits, u64
>> *failed_start, +		 struct extent_state **cached_state, gfp_t
>> mask) { struct extent_state *state; struct extent_state *prealloc
>> = NULL; @@ -917,6 +918,15 @@ search_again: goto again; }
>> 
>> +int set_extent_bit(struct extent_io_tree *tree, u64 start, u64
>> end, int bits, +		   u64 *failed_start, struct extent_state
>> **cached_state, +		   gfp_t mask) +{ +	return
>> __set_extent_bit(tree, start, end, bits, 0, failed_start, +
>> cached_state, mask); +} + + /** * convert_extent - convert all
>> bits in a given range from one bit to another * @tree:	the io
>> tree to search @@ -1111,14 +1121,14 @@ search_again: int
>> set_extent_dirty(struct extent_io_tree *tree, u64 start, u64
>> end, gfp_t mask) { -	return set_extent_bit(tree, start, end,
>> EXTENT_DIRTY, 0, NULL, +	return set_extent_bit(tree, start, end,
>> EXTENT_DIRTY, NULL, NULL, mask); }
>> 
>> int set_extent_bits(struct extent_io_tree *tree, u64 start, u64
>> end, int bits, gfp_t mask) { -	return set_extent_bit(tree, start,
>> end, bits, 0, NULL, +	return set_extent_bit(tree, start, end,
>> bits, NULL, NULL, mask); }
>> 
>> @@ -1133,7 +1143,7 @@ int set_extent_delalloc(struct
>> extent_io_tree *tree, u64 start, u64 end, { return
>> set_extent_bit(tree, start, end, EXTENT_DELALLOC |
>> EXTENT_UPTODATE, -			      0, NULL, cached_state, mask); +
>> NULL, cached_state, mask); }
>> 
>> int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
>> u64 end, @@ -1147,7 +1157,7 @@ int clear_extent_dirty(struct
>> extent_io_tree *tree, u64 start, u64 end, int
>> set_extent_new(struct extent_io_tree *tree, u64 start, u64 end, 
>> gfp_t mask) { -	return set_extent_bit(tree, start, end,
>> EXTENT_NEW, 0, NULL, +	return set_extent_bit(tree, start, end,
>> EXTENT_NEW, NULL, NULL, mask); }
>> 
>> @@ -1155,7 +1165,7 @@ int set_extent_uptodate(struct
>> extent_io_tree *tree, u64 start, u64 end, struct extent_state
>> **cached_state, gfp_t mask) { return set_extent_bit(tree, start,
>> end, EXTENT_UPTODATE, 0, -			      NULL, cached_state, mask); +
>> cached_state, mask); }
>> 
>> static int clear_extent_uptodate(struct extent_io_tree *tree, u64
>> start, @@ -1176,9 +1186,9 @@ int lock_extent_bits(struct
>> extent_io_tree *tree, u64 start, u64 end, int err; u64
>> failed_start; while (1) { -		err = set_extent_bit(tree, start,
>> end, EXTENT_LOCKED | bits, -				     EXTENT_LOCKED,
>> &failed_start, -				     cached_state, GFP_NOFS); +		err =
>> __set_extent_bit(tree, start, end, EXTENT_LOCKED | bits, +
>> EXTENT_LOCKED, &failed_start, +				       cached_state,
>> GFP_NOFS); if (err == -EEXIST) { wait_extent_bit(tree,
>> failed_start, end, EXTENT_LOCKED); start = failed_start; @@
>> -1199,8 +1209,8 @@ int try_lock_extent(struct extent_io_tree
>> *tree, u64 start, u64 end) int err; u64 failed_start;
>> 
>> -	err = set_extent_bit(tree, start, end, EXTENT_LOCKED,
>> EXTENT_LOCKED, -			     &failed_start, NULL, GFP_NOFS); +	err =
>> __set_extent_bit(tree, start, end, EXTENT_LOCKED, EXTENT_LOCKED, 
>> +			       &failed_start, NULL, GFP_NOFS); if (err == -EEXIST) { 
>> if (failed_start > start) clear_extent_bit(tree, start,
>> failed_start - 1, diff --git a/fs/btrfs/extent_io.h
>> b/fs/btrfs/extent_io.h index 439e183..3a171c2 100644 ---
>> a/fs/btrfs/extent_io.h +++ b/fs/btrfs/extent_io.h @@ -209,7
>> +209,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64
>> start, u64 end, int set_extent_bits(struct extent_io_tree *tree,
>> u64 start, u64 end, int bits, gfp_t mask); int
>> set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, -
>> int bits, int exclusive_bits, u64 *failed_start, +		   int bits,
>> u64 *failed_start, struct extent_state **cached_state, gfp_t
>> mask); int set_extent_uptodate(struct extent_io_tree *tree, u64
>> start, u64 end, struct extent_state **cached_state, gfp_t mask); 
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c index
>> d16bf3f..593a2c3 100644 --- a/fs/btrfs/inode.c +++
>> b/fs/btrfs/inode.c @@ -6233,7 +6233,7 @@ static ssize_t
>> btrfs_direct_IO(int rw, struct kiocb *iocb, if (writing) { 
>> write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING; ret =
>> set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend, -
>> EXTENT_DELALLOC, 0, NULL, &cached_state, +
>> EXTENT_DELALLOC, NULL, &cached_state, GFP_NOFS); if (ret) { 
>> clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> 
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPao/tAAoJEB57S2MheeWyHZkP/RCG1BbvwnFdjtP4/0MYarUM
qrulbycGo/Xqod3hXZcGPPxAlxDNOB+mVGxKdHGbKE4t+uvIB9owD0ypWrQf1LP4
ODhEZUzvk0vZ02GnXDyKn6vY30ux1QiSfEKIzDfoZA5iMTz1+zFKesvBFn0HO3Qd
bbDQ9QS0ikAsumWY4wiO7huLDhmeBdRU4gwLWiax1kKuudfxgJ1S3Galg7yGz9t9
zmx6bwkNbJ5UbhR5vAaemMTt+CJ199yTvjppuAOGYxM+WSt9gLCRwVJcCEShJ0fV
XAiT4PlF9xpT9EPiwQqZnnT4SgPlR+mhaS28afeROoMcBulc4P/BC82dJX3BtkRC
V+If5vJCBiVeR6BOU3bmOpDEj0WzZ/QAHiHXIA/2mUnFT1gtjUh3GKD57Z3NzKvw
wXQuCgI7FqDMdUVYckyY1ghWjnHofgbJFtFF8EElaQioFqrzE5UtJrS6CiyRpZ/R
RLIld6owKYLD8dhD5718qhBAoZTL3vkZnBy4jSHS7hJkOVwmjedAgwBKtzTaBRiR
jE3O9qEM5FIVMzqxsLkA1pGPQd3acB4hh6Vc7SkXSF5NljM9kF0fpeR1Medhm7nm
WGkBsDYylxvrMFkOVH1mfxOZ3Pw9wcuUJxVn02DjbaEcWj7TBj03HYdjiwXqiFWB
IyqwzSy4+0tebs8U2NaG
=GDqG
-----END PGP SIGNATURE-----
