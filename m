From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 0/9] some fixes for bugs spotted by valgrind
Date: Tue, 31 May 2011 22:10:37 +0300
Message-ID: <20110531221037.0454f16e@sf>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5T+W+7oHA1bmv6d__7c=xlf"; protocol="application/pgp-signature"
Cc: Sergei Trofimovich <slyfox@gentoo.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/5T+W+7oHA1bmv6d__7c=xlf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Some clarifications:

> Patchset based on 'tmp' branch e6bd18d8938986c997c45f0ea95b221d4edec095.
All patches are against btrfs-progs.

=3D=3D=3D=3D

The rest of rambling is about kernel code, which handles supers.
I have read what I've wrote last night (braindump of insane!)
and will try to elaborate a bit:

> Poking at valgrind warnings I have noticed very worrying problem.
> When we (over)write superblock we take 4096 continuous bytes in memory.

The common pattern in disk-io.c is the following:

    struct btrfs_super_block *sb =3D root->fs_info->sb // or ->sb_for_commit
    memcpy(dest, sb, BTRFS_SUPER_INFO_SIZE /* 4096 */);

With a memcpy we go out of sizeof(*sb) (~2.5K) and pick more fields from fs=
_info struct.
Let's look at them:
struct btrfs_fs_info {
...
        struct btrfs_super_block super_copy;
        struct btrfs_super_block super_for_commit;
        struct block_device *__bdev;
        struct super_block *sb;
        struct inode *btree_inode;
        struct backing_dev_info bdi;
        struct mutex trans_mutex;
        struct mutex tree_log_mutex;
        struct mutex transaction_kthread_mutex;
        struct mutex cleaner_mutex;
        struct mutex chunk_mutex;
        struct mutex volume_mutex;
        struct mutex ordered_operations_mutex;
        struct rw_semaphore extent_commit_sem;

        struct rw_semaphore cleanup_work_sem;

        struct rw_semaphore subvol_sem;
        struct srcu_struct subvol_srcu;

        struct list_head trans_list;
        struct list_head hashers;
        struct list_head dead_roots;
        struct list_head caching_block_groups;

        spinlock_t delayed_iput_lock;
        struct list_head delayed_iputs;

        atomic_t nr_async_submits;
...
So we copyout (and even checksum!) atomic counters and other volatile stuff
(I haven't looked at mutexes and semaphores, but i'm sure there is yet some
volatile stuff)=20

> In kernel the structures reside in btrfs_fs_info structure, so we compute
> CRC for:
>     struct btrfs_super_block super_copy;
>     struct btrfs_super_block super_for_commit;
> and then write it to disk. [H]ere we have 2 issues:
> 1. kernel pointers and other random stuff leaks out to kernel.
>    It's nondeterministic and leaks out data (not too bad,
>    as it should be accessible only for root, but still)
> 2. more serious: is there guarantee, that noone will kick-in
>    between CRC computation and superblock outwrite?
>=20
>    What if some of mutexes, semaphores or lists will change
>    it's internal state? Some async thread will kick it
>    an we will end-up writing superblock with invalid CRC!
>    This might well be the cause of recend superblock
>    corruptions under heavy load + hangup retorted to the list.
>=20
> Consider the following call chain:
> [somewhere in write_dev_supers ...]
>=20
>                         bh->b_end_io =3D btrfs_end_buffer_write_sync;
>                         crc =3D ~(u32)0;
>                         crc =3D btrfs_csum_data(NULL, (char *)sb +
>                                               BTRFS_CSUM_SIZE, crc,
>                                               BTRFS_SUPER_INFO_SIZE -
>                                               BTRFS_CSUM_SIZE);
>                         btrfs_csum_final(crc, sb->csum);

Now the problem should be a bit more clear: sb is a thing pointing to the m=
iddle
of fs_info. We checksum it with data after it in fs_info.

>                         bh =3D __getblk(device->bdev, bytenr / 4096,
>                                       BTRFS_SUPER_INFO_SIZE);
>=20
>                         memcpy(bh->b_data, sb, BTRFS_SUPER_INFO_SIZE);

and here we write all the checksummed contents. Is there guard, which
prevents things from updating fs_info?

>=20
>                         /* one reference for submit_bh */
>                         get_bh(bh);
>=20
>                         set_buffer_uptodate(bh);
>                         lock_buffer(bh);
>                         bh->b_end_io =3D btrfs_end_buffer_write_sync;

Am I too paranoid about the issue?

Thanks!

--=20

  Sergei

--Sig_/5T+W+7oHA1bmv6d__7c=xlf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3lPTAACgkQcaHudmEf86rmfQCggcWC3gnld7MB48KkOrD7/MX6
F6QAn1HCQe+04r4jc1pP1q4NoB0WG1eX
=V3ON
-----END PGP SIGNATURE-----

--Sig_/5T+W+7oHA1bmv6d__7c=xlf--
