From: Abhinav Duggal <abhinavduggal@gmail.com>
Subject: Help in understanding a memory barrier used in btrfs
Date: Sun, 21 Mar 2010 03:13:10 -0400
Message-ID: <3d81e70e1003210013u29bfc3b5g46cf23603cbadb00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I am trying to understand the memory barriers used in
btrfs_defrag_root in fs/btrfs/transaction.c.The kernel version I am
looking at is 2.6.34-rc2.
In this function
=A0=A0int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
=A0=A0{
=A0struct btrfs_fs_info *info =3D root->fs_info;
=A0=A0int ret;
=A0=A0struct btrfs_trans_handle *trans;
=A0=A0unsigned long nr;
=A0=A0smp_mb();
=A0=A0if (root->defrag_running)
=A0=A0 =A0return 0;
=A0=A0trans =3D btrfs_start_transaction(root, 1);
=A0=A0while (1) {
=A0=A0 =A0root->defrag_running =3D 1;
=A0=A0 =A0ret =3D btrfs_defrag_leaves(trans, root, cacheonly);
=A0=A0 =A0nr =3D trans->blocks_used;
=A0=A0 =A0btrfs_end_transaction(trans, root);
=A0=A0 =A0btrfs_btree_balance_dirty(info->tree_root, nr);
=A0=A0 =A0cond_resched();

=A0=A0 =A0trans =3D btrfs_start_transaction(root, 1);
=A0=A0 =A0if (root->fs_info->closing || ret !=3D -EAGAIN)
=A0=A0 =A0 =A0break;
=A0=A0}
=A0=A0root->defrag_running =3D 0;
=A0=A0smp_mb();
=A0=A0btrfs_end_transaction(trans, root);
=A0=A0return 0;
}
Is the barrier here being used to provide some kind of ordering
constraints between defrag_running and any common memory accessed in
btrfs_start_transaction function and btrfs_end_transaction
function?But these start and end transaction functions take and
release a mutex which should help in ordering as they act as barriers.
Or is it the case when the defrag_running is set to 0 and if it
remains in the write buffer, the barrier helps the check of
defrag_running on some other CPU to gets the updated value of
0.Thus,the barrier seems to provide ordering constraint for accessing
a single variable which is defrag_running.Can I say it is in some way
helping the read to get last updated value thus providing some kind of
write atomicity?
Also,why isn't a barrier taken after setting the value of defrag_runnin=
g to 1?
My understanding of barriers is that it enforces ordering constraints
between instructions before and after the barrier and are used for
instructions involving different memory locations.
Are barriers also used to get the most updated value?I saw a comment
in an old kernel release in file fs/btrfs/disk-io.c function
'btrfs_unplug_io_fn' as
=A0=A0/*
=A0=A0 * page->mapping may change at any time. =A0Get a consistent copy
=A0=A0 * and use that for everything below
=A0=A0 */
=A0=A0smp_mb();
=A0=A0mapping =3D page->mapping;
=A0=A0if (!mapping)
=A0=A0 =A0return;
Here from the comment it seems that this barrier is used to get the
most updated value of page mapping.
=A0I am sorry but my understanding of barriers is not very clear.I have
gone through the kernel documentation on memory barriers but they do
not mention anything on barriers being used to get the most updated
value before a read. I am trying understand the use of barriers in the
Linux kernel and I was puzzled by this example.Any help would be
great.
Thanks.
-Abhinav.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
