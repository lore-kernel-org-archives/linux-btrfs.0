Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937568AbeE1Ms5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 08:48:57 -0400
Subject: Re: Questions from aspiring btrfs mini-debugger/mini-developer
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f790eb48-480c-5798-8b75-847da22b8623@gmx.com>
Date: Mon, 28 May 2018 20:48:46 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RZw81IkhvnvjDMVh1n45QD7LA878MPUg7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RZw81IkhvnvjDMVh1n45QD7LA878MPUg7
Content-Type: multipart/mixed; boundary="fA3t0FYpG5NsgYgwREI5tkgHLnJLvb96S";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <f790eb48-480c-5798-8b75-847da22b8623@gmx.com>
Subject: Re: Questions from aspiring btrfs mini-debugger/mini-developer
References: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
In-Reply-To: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>

--fA3t0FYpG5NsgYgwREI5tkgHLnJLvb96S
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8828=E6=97=A5 17:21, james harvey wrote:
> I'm tracking down some more bugs.

Yeah, more bugs for us to fix.

>=20
> Useful information for you to track down these bugs isn't in this
> email.  This is more about an aspiring btrfs
> mini-debugger/mini-developer asking for some guidance, to be able to
> get the more useful information.
>=20
> I ran across some mirrored files that are nodatacow/nodatasum, with
> differing mirrored extents.  UNLIKE BEFORE, these are uncompressed.
> Mostly /var/cache/samba and /var/lib/mysql files.  This also happened
> during my recent btrfs replace.  Luckily for me, I had the unmodified
> original images, so when I re-did this with a btrfs device add /
> remove, the new ones are fine.

That's the best practice.

>=20
> I'm almost positive I have extents with checksums, where its inode is
> marked nodatacow.  This would be a bug, right?  (Confirming before I
> look into this much more.)

Yes, we're aware of this bug, and working on it.

>=20
>=20
>=20
> I've spent a few days familiarizing myself with btrfs (kernel and
> -progs) internals and source.
>=20
> I've made some additions to btrfs-progs, that I'll submit once
> finished.  One of them compares mirrored extents, looking for
> differences.

This is a good extension to the original --check-datasum option.

Although I have submitted some patches to enhance --check-datasum to do
better check ("[PATCH 0/4] btrfs check --check-data-csum enhancement
for"), I didn't consider the case of nodatasum case.
It makes sense, and hope the existing patchset could give some clue for y=
ou.

>  If I have it check all extents, it brings up every
> problematic file I've found, and the few I mentioned above that I
> wasn't aware of because they were uncompressed.  I'll give more on
> this once I have the details.  I think this must mean scrub doesn't
> verify extents with checksums that are marked nodatacow,

I'm not pretty sure about this.
AFAIK scrub doesn't care about the owner (until it needs to output the
file name), it just iterate through extent tree and compare data with
its data sum.

But I can be totally wrong.

> since it's
> not expecting them to have checksums.
>=20
>=20
>=20
> I have a few questions that would greatly help having answered.
>=20
> Am I right that an inode has a single set of btrfs flags (things like
> nodatacow, nodatasum, etc) accessable through btrfs_inode_flags()?

Yes. And you can also check the flags by checking the following pattern
of btrfs-debug-tree (btrfs inspect dump-tree).
------
        item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
                generation 10 transid 10 size 262144 nbytes 1310720
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 5 flags
0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
------

>  I
> want to make sure extents within the same file can't have any varying
> flags, and that a file and its extents across multiple snapshots all
> share the same.
>=20
> What about deduplicated extents?  If there's a file whose inode says
> it has checksums, and another file whose inode has nodatasum, and
> there's duplicate blocks, are they deduplicated, or does deduplication
> see this and skip it because of the mismatch?

For deduplicated extents (or called reflink), if an inode has NODATACOW
kernel won't allow reflink from/to it.

And further more, NODATACOW flag can't be set/clear for a non-empty
inode, it should not happen.

>=20
> I have files that have some extents compressed, and others without.
> Is this allowed?

Not really defined. I need to double check about how kernel handles
NOCOMPRESS flag.
But it's always good to have define the expected behavior.

>  This might just be on nodatacow files defragmented
> and compressed, so maybe that process left some extents uncompressed.
> Wondering if this is allowed before I dig more to see if it's on files
> that haven't been through that process.
>=20
>=20
>=20
> extent_offset isn't making sense to me.  I have a file whose filefrag i=
ncludes:
>=20
>   28:      896..     919:     596954..    596977:     24:     596978:
> encoded,shared
>   29:      920..    1023:     580304..    580407:    104:     596978: s=
hared
>   30:     1024..    1055:     596961..    596992:     32:     580408:
> encoded,shared

When compression is involved, old filefrag really doesn't make much sense=
=2E

>=20
> #29, through btrfs-tree-debug, is:
>=20
>         item 49 key (71469 EXTENT_DATA 3768320) itemoff 13232 itemsize =
53
>                 generation 218 type 1 (regular)
>                 extent data disk byte 2373160960 nr 8384512
>                 extent data offset 3764224 nr 425984 ram 8384512
>                 extent compression 0 (none)
>=20
> Its extents without a data offset (i.e. filefrag #30) look like:
>=20
>         item 50 key (71469 EXTENT_DATA 4194304) itemoff 13179 itemsize =
53
>                 generation 310 type 1 (regular)
>                 extent data disk byte 2445152256 nr 49152
>                 extent data offset 0 nr 131072 ram 131072
>                 extent compression 2 (lzo)
>=20
> So, item 49 is saying there's 8,384,512 bytes on disk, but for this
> file extent, only read starting 3,764,224 into the extent_data, and
> only read 425,984 bytes?

Yep, reading from on-disk logical address 2373160960 + 3764224, len 42598=
4.

>  This is a snapshotted file.  At first, I was
> thinking this might mean most of this extent had changed, but 425,984
> bytes in the "middle" were the same, so btrfs was re-using that
> portion.  Is that's why data_offset is used?

Yep.

>  In this case, there is
> the file in its normal location plus 43 older snapshots.  All of the
> files are completely identical.  It's always possible there could have
> been a deleted snapshot that was different, so maybe that's why I'm
> not seeing a difference, and maybe it made sense in this way when it
> was done.
>=20
>=20
>=20
> extent_offset on prealloc data makes even less sense to me, like:
>=20
>         item 47 key (71469 EXTENT_DATA 42098688) itemoff 13739 itemsize=
 53
>                 generation 293 type 2 (prealloc)
>                 prealloc data disk byte 2426286080 nr 8388608
>                 prealloc data offset 155648 nr 8232960
>=20
> Am I right that preallocated means no data has actually been written
> there?

Yes, but space must be allocated for later possible write.
That's why we call it pre-allocated.

>  Why does it even have a disk byte then, isn't that taking up
> disk space?

Yes, it's taking space.

Unlike holes, which on-disk bytenr is always 0, and doesn't take space
on disk.

>  And, why would it have a data offset of 155648 after that
> disk byte location if there's no data there?

It is possible that the offset [0, 155648) is written.
(That's why we pre-allocate space, because we may later write data into
that space)

>=20
>=20
>=20
> In the context of uncompressed extents, what's the difference between
> extent num_bytes and extent_ram_bytes?  They're usually the same, but
> sometimes different:
>=20
>         item 126 key (275 EXTENT_DATA 12288) itemoff 9867 itemsize 53
>                 generation 98 type 1 (regular)
>                 extent data disk byte 1656295424 nr 8192
>                 extent data offset 0 nr 4096 ram 8192
>                 extent compression 0 (none)
>=20
> I understand for compressed extents, the disk byte line nr is showing
> size on disk, offset line nr is showing uncompressed size and ram is
> showing uncompressed size.  But, this one's uncompressed and still
> showing a data offset line nr value half the size (4096) of the ram
> and disk byte line nr values (8192.)

This only refers to part of a larger extent.

For example, one file has a large (8K) extent. And then snapshot or
reflink happens.
And then someone writes some space into the later 4K half, which will
get CoWed. Cause the first 4K only refers to the beginning 4K of the
original larger 8K extent.

>=20
>=20
>=20
> Given an extent_buffer, btrfs_item, slot, and btrfs_file_extent_item,
> if the extent type is BTRFS_FILE_EXTENT_INLINE, how would one get the
> on-disk (so if compressed, in compressed format) data?

Read from the leaf.
Just as the name inline, the data directly recorded into the leaf, and
there is no need to use disk_bytenr.
In fact starting from the offset of where disk_bytenr should be, inlined
data is recorded there directly.

>  With
> non-inline, non-prealloc extents, I'm using bytenr as location and
> num_bytes as length, and code based off btrfs-map-logical, which winds
> up using read_extent_data with a mirror number argument, which uses
> btrfs_map_block() on that logical address and mirror and pread64() to
> do the read.  For inline data, there's no logical address.
>=20
>=20
>=20
> I'm going to be writing and submitting useful things I'll submit, like
> a "btrfs inspect-internal lsattr" which will show btrfs attributes
> lsattr doesn't.  List all files marked nodatasum or nodatacow, etc.
> I'm starting simpler by writing a non-useful thing, my own version of
> inspect-internal inode-resolve-mine.  (Actual version uses a totally
> different way.)  I'm not getting btrfs_search_slot() to work as
> expected.

This wiki should help.
https://btrfs.wiki.kernel.org/index.php/Code_documentation#Tree_Searching=


>  I wrote mine first, but after not getting it working, found
> the only btrfs-progs place a BTRFS_INODE_REF_KEY is used for
> btrfs_search_slot is in inode-item.c::btrfs_lookup_inode_ref.  Calling
> this function (code to do so not shown below) doesn't work, either.
> It still returns 1, indicating not found.
>=20
> First, can you have btrfs_search_slot() look for a specified type, and
> either a specified objectid or offset field?

It doesn't care. Btrfs tree search is just handling the whole (objectid,
type, offset) as a large u132 (64 + 8 + 64), and do a normal B-tree searc=
h.

If found, return it.
If not found, return the slot where it should be inserted.

>  Like, for
> BTRFS_INODE_REF_KEY, could you have it search for an inode (putting
> that in objectid) but telling it you don't know and don't care about
> the parent inode (putting something like 0 in offset?)  Neither way
> works for me, just wondering if you can do this.

Since it's a u132, and objectid is the highest 64 bits, it's impossible
to do such search using btrfs_search_slot().

You could search using (0, INODE_REF_KEY, 0), and iterate forward until
you find a INODE_REF_KEY item or hit the tail of the tree.

>=20
>=20
>=20
> # mount /dev/lvm/btrfs /mnt/btrfs
> # ls -la /mnt/btrfs
> total 2136
> drwxr-xr-x 1 root root      84 May 23 23:44 .
> drwxr-xr-x 1 root root     140 May 28 01:50 ..
> -rw-r--r-- 1 root root      11 May 23 23:05 compressed
> -rw-r--r-- 1 root root 1048576 May 23 23:44 nocow
> -rw-r--r-- 1 root root      13 May 23 23:05 uncompressed
> -rw-r--r-- 1 root root 1048576 May 23 23:43 urandom.1m
> -rw-r--r-- 1 root root   65536 May 23 23:29 zeros
> # /usr/bin/btrfs inspect-internal dump-tree /dev/lvm/btrfs
> ...
>         item 2 key (256 DIR_ITEM 1378320618) itemoff 16076 itemsize 35
>                 location key (259 INODE_ITEM 0) type FILE
>                 transid 10 data_len 0 name_len 5
>                 name: zeros
> ...
>         item 9 key (256 DIR_INDEX 4) itemoff 15802 itemsize 35
>                 location key (259 INODE_ITEM 0) type FILE
>                 transid 10 data_len 0 name_len 5
>                 name: zeros
> ...
>         item 19 key (259 INODE_REF 256) itemoff 15124 itemsize 15
>                 index 4 namelen 5 name: zeros
> ...
> # # so, there's a BTRFS_INODE_REF_KEY with objectid 259 (inode) and
> offset 256 (parent inode.)
> # ./btrfs inspect-internal inode-resolve-mine 259 /dev/lvm/btrfs
> Looking for inode 259
> At dev /dev/lvm/btrfs
> ERROR: Did not find inode 259
> extent buffer leak: start 30457856 len 16384
>=20
>=20
>=20
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index afd7fe48..01c69fd0 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -122,6 +122,68 @@ static int cmd_inspect_inode_resolve(int argc, cha=
r **argv)
>=20
>  }
>=20
> +static const char * const cmd_inspect_inode_resolve_mine_usage[] =3D {=

> +       "btrfs inspect-internal inode-resolve-mine <inode> <device>",
> +       "Get file system paths for the given inode, my way",
> +       NULL
> +};
> +
> +static int cmd_inspect_inode_resolve_mine(int argc, char **argv)
> +{
> +       u64 inode;
> +       char *dev;
> +       struct btrfs_fs_info *info;
> +       unsigned open_ctree_flags;
> +       int ret;
> +       struct btrfs_key key;
> +       struct btrfs_path path;
> +
> +       open_ctree_flags =3D OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_G=
ROUPS;
> +
> +       if (check_argc_exact(argc - optind, 2))
> +               usage(cmd_inspect_inode_resolve_mine_usage);
> +
> +       inode =3D arg_strtou64(argv[optind]);
> +       dev =3D argv[optind+1];
> +
> +       printf("Looking for inode %llu\n", inode);
> +       printf("At dev %s\n", dev);
> +
> +       ret =3D check_arg_type(dev);
> +       if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
> +               error("not a block device or regular file: %s", dev);
> +               goto out;
> +       }
> +
> +       info =3D open_ctree_fs_info(dev, 0, 0, 0, open_ctree_flags);
> +       if (!info) {
> +               error("unable to open %s", dev);
> +               goto out;
> +       }
> +
> +       key.objectid =3D inode;
> +       key.type =3D BTRFS_INODE_REF_KEY; // have also tried
> BTRFS_INODE_ITEM_KEY, and BTRFS_EXTENT_DATA_KEY
> +       key.offset =3D 0; // I'm hoping you can have search ignore this=

> field, so parent id can be unknown, but I've also tried 256 here
> +       btrfs_init_path(&path);
> +       ret =3D btrfs_search_slot(NULL, info->tree_root, &key, &path, 0=
,
> 0); // also tried info->fs_root
> +       if (ret < 0) {
> +               error("Error looking for inode %llu", inode);
> +               goto close_root;
> +       } else if (ret =3D=3D 1) {
> +               error("Did not find inode %llu", inode);
> +               goto release_path;

Of course you won't find it.
You need to get the key of the slot, and determine if you need to go
next or previous or just this slot.

One example can be found in btrfs-progs/inode.c::check_dir_conflict().

BTW, normally we don't use offset 0 and iterate forward, but use offset
u64(-1) and iterate backward.

Thanks,
Qu

> +       }
> +
> +       printf("Success!\n");
> +
> +release_path:
> +       btrfs_release_path(&path);
> +close_root:
> +       ret =3D close_ctree(info->fs_root);
> +out:
> +       return !!ret;
> +}
> +
>  static const char * const cmd_inspect_logical_resolve_usage[] =3D {
>         "btrfs inspect-internal logical-resolve [-Pv] [-s bufsize]
> <logical> <path>",
>         "Get file system paths for the given logical address",
> @@ -633,6 +695,8 @@ const struct cmd_group inspect_cmd_group =3D {
>         inspect_cmd_group_usage, inspect_cmd_group_info, {
>                 { "inode-resolve", cmd_inspect_inode_resolve,
>                         cmd_inspect_inode_resolve_usage, NULL, 0 },
> +               { "inode-resolve-mine", cmd_inspect_inode_resolve_mine,=

> +                       cmd_inspect_inode_resolve_mine_usage, NULL, 0 }=
,
>                 { "logical-resolve", cmd_inspect_logical_resolve,
>                         cmd_inspect_logical_resolve_usage, NULL, 0 },
>                 { "subvolid-resolve", cmd_inspect_subvolid_resolve,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--fA3t0FYpG5NsgYgwREI5tkgHLnJLvb96S--

--RZw81IkhvnvjDMVh1n45QD7LA878MPUg7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsL+q4ACgkQwj2R86El
/qj+YAgAnyoZCl+XFpUeSivAHNdVIUJbu4730kSUuet0C/LINGhOGptpBPnhc69b
ppiGDIvJoS0HVhOEiN53zIy3cuffCGU3Riir9vdNVJ4D1X6Myp82p59m6eWKGWAS
j0jSQf9meM/JR9S80toxc3CZJyrfyxvpV6A17ln9dG7e5DWogtKzLFP9tXN2GRt0
mV2cQbM6ZfXfN3V9oePv/g6gWufIwQu/2onq6AdhJzjsEHq89Cds/UKRPBWnfWvz
k84005LWZoz/MS8A9XiPIKHBKcCIlGqo+6DnsuKWzcafGn0gVVwO0byY4rwF9gGS
UZX58ifqyzd0lfsjKVXBvZKsqQWozw==
=x4hi
-----END PGP SIGNATURE-----

--RZw81IkhvnvjDMVh1n45QD7LA878MPUg7--
