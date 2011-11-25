From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 03/99] btrfs: Panic on bad rbtree operations
Date: Thu, 24 Nov 2011 21:13:13 -0500
Message-ID: <4ECEF9B9.1050403@suse.com>
References: <20111124003533.395674389@suse.com> <20111124004220.164950979@suse.com> <20111124234151.GG12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124234151.GG12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2011 06:41 PM, David Sterba wrote:
> On Wed, Nov 23, 2011 at 07:35:36PM -0500, Jeff Mahoney wrote:
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c 
>> index a1c9404..5a53d94 100644 --- a/fs/btrfs/ordered-data.c +++
>> b/fs/btrfs/ordered-data.c @@ -59,6 +59,14 @@ static struct
>> rb_node *tree_insert(struct rb_root *root, u64 file_offset, 
>> return NULL; }
>> 
>> +NORET_TYPE static void ordered_data_tree_panic(struct inode
>> *inode, int errno, +					       u64 offset) +{ +	struct
>> btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb)->fs_info; +
>> btrfs_panic(fs_info, errno, "Inconsistency in ordered tree at
>> offset " +		    "%llu\n", offset);
> ^^^^ this will need a cast to (unsigned long long)
> 
>> +} + /* * look for a given offset in the tree, and if it can't be
>> found return the * first lesser offset ---
>> a/fs/btrfs/relocation.c +++ b/fs/btrfs/relocation.c @@ -326,6
>> +326,19 @@ static struct rb_node *tree_search(struct rb_root
>> *root, u64 bytenr) return NULL; }
>> 
>> +NORET_TYPE static void backref_tree_panic(struct rb_node
>> *rb_node, int errno, +					  u64 bytenr) +{ + +	struct
>> btrfs_fs_info *fs_info = NULL; +	struct backref_node *bnode =
>> rb_entry(rb_node, struct backref_node, +					      rb_node); +	if
>> (bnode->root) +		fs_info = bnode->root->fs_info; +
>> btrfs_panic(fs_info, errno, "Inconsistency in backref cache " +
>> "found at offset %llu\n", bytenr);
> 
> same here
> 
>> +} +
> 


Thanks. Fixed.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzvm5AAoJEB57S2MheeWyQfcQAJXzeVYbLwLoJ0EqUSZBRzSZ
L5s4qWNTgdf6XVl4ZE8WgDJNDq1gMbdsjCug40QtQR8/f9btqbcz7oPnNeQDgfD8
PxZCiarOsm4fAiWDkchm/JDah9YTQCRzvV7Pg/362FnJJl7+a2muecvEMuXXgPdD
otE5BgYz7mJ5imZxpg3JnGwGXUhSiQD4tsprorY8A5I64QUSfGDBkdHNqRe2sVWn
PdN95UZb1z1wz3KZokslczJFsiOQkiOGurvnO+2J8L/+HH6pItKymT7j2F9q3EzQ
vtFP7tFFINfgdJUJyhpDRanhETfuAfwAuSqKVDFmujsPM38zdglSk3nXhh6yIucz
k067pYzHBA2gSJ2ZjRUgMlSMfcbiiYLuXhgFSMZosemoKBpn9RNW8hfxvX3kvBuh
w+oPmaOobRnwQV+ImPQlug2k7a1XpZUbrnJHoflbzEs2APrsmL863B4xHhb8vp+C
7SnlbGmW1Fk2vmsDfTWZHz7/Eb8atTZSdz3m/8lO6S420oBJ3xh7NIWq3sQLUnvg
+kDUfn3FjSRUwq4J/ETAf8fxarCuhDLpUo9MU11oaJ2qz50QUQI5W21bgrvBhbq7
fkQTZoAGirBIK3KIeV1cqeVDFkc5WilOc/moECX1Vicf1TUaUYe/A+Jko+6ObE5K
RH+fOkuY34cb34ccxV9r
=jxMY
-----END PGP SIGNATURE-----
