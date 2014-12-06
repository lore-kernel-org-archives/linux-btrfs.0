Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50942 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLFPRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Dec 2014 10:17:53 -0500
Date: Sat, 6 Dec 2014 15:17:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] Btrfs: fix fs corruption on transaction abort if device
 supports discard
Message-ID: <20141206151750.GV32735@carfax.org.uk>
References: <1417876914-26269-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KWhV7zotm6ea722p"
In-Reply-To: <1417876914-26269-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KWhV7zotm6ea722p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 06, 2014 at 02:41:24PM +0000, Filipe Manana wrote:
> When we abort a transaction we iterate over all the ranges marked as dirty
> in fs_info->freed_extents[0] and fs_info->freed_extents[1], clear them
> from those trees, add them back (unpin) to the free space caches and, if
> the fs was mounted with "-o discard", perform a discard on those regions.
> Also, after adding the regions to the free space caches, a fitrim ioctl call
> can see those ranges in a block group's free space cache and perform a discard
> on the ranges, so the same issue can happen without "-o discard" as well.
> 
> This causes corruption, affecting one or multiple btree nodes (in the worst
> case leaving the fs unmountable) because some of those ranges (the ones in
> the fs_info->pinned_extents tree) correspond to btree nodes/leafs that are
> referred by the last committed super block - breaking the rule that anything
> that was committed by a transaction is untouched until the next transaction
> commits successfully.
> 
> I ran into this while running in a loop (for several hours) the fstest that
> I recently submitted:
> 
>   [PATCH] fstests: add btrfs test to stress chunk allocation/removal and fstrim
> 
> The corruption always happened when a transaction aborted and then fsck complained
> like this:
> 
>    _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
>    *** fsck.btrfs output ***
>    Check tree block failed, want=94945280, have=0
>    Check tree block failed, want=94945280, have=0
>    Check tree block failed, want=94945280, have=0
>    Check tree block failed, want=94945280, have=0
>    Check tree block failed, want=94945280, have=0
>    read block failed check_tree_block
>    Couldn't open file system

   Ooh, this looks like the mystery bug we've seen a few times over
the last 9 months. The have=0, combined with SSDs, is exactly the
symptoms. I think you may have just relieved Josef of his current
number-one btrfs bug.

> In this case 94945280 corresponded to the root of a tree.
> Using frace what I observed was the following sequence of steps happened:
> 
>    1) transaction N started, fs_info->pinned_extents pointed to
>       fs_info->freed_extents[0];
> 
>    2) node/eb 94945280 is created;
> 
>    3) eb is persisted to disk;
> 
>    4) transaction N commit starts, fs_info->pinned_extents now points to
>       fs_info->freed_extents[1], and transaction N completes;
> 
>    5) transaction N + 1 starts;
> 
>    6) eb is COWed, and btrfs_free_tree_block() called for this eb;
> 
>    7) eb range (94945280 to 94945280 + 16Kb) is added to
>       fs_info->pinned_extents (fs_info->freed_extents[1]);
> 
>    8) Something goes wrong in transaction N + 1, like hitting ENOSPC
>       for example, and the transaction is aborted, turning the fs into
>       readonly mode. The stack trace I got for example:
> 
>       [112065.253935]  [<ffffffff8140c7b6>] dump_stack+0x4d/0x66
>       [112065.254271]  [<ffffffff81042984>] warn_slowpath_common+0x7f/0x98
>       [112065.254567]  [<ffffffffa0325990>] ? __btrfs_abort_transaction+0x50/0x10b [btrfs]
>       [112065.261674]  [<ffffffff810429e5>] warn_slowpath_fmt+0x48/0x50
>       [112065.261922]  [<ffffffffa032949e>] ? btrfs_free_path+0x26/0x29 [btrfs]
>       [112065.262211]  [<ffffffffa0325990>] __btrfs_abort_transaction+0x50/0x10b [btrfs]
>       [112065.262545]  [<ffffffffa036b1d6>] btrfs_remove_chunk+0x537/0x58b [btrfs]
>       [112065.262771]  [<ffffffffa033840f>] btrfs_delete_unused_bgs+0x1de/0x21b [btrfs]
>       [112065.263105]  [<ffffffffa0343106>] cleaner_kthread+0x100/0x12f [btrfs]
>       (...)
>       [112065.264493] ---[ end trace dd7903a975a31a08 ]---
>       [112065.264673] BTRFS: error (device sdc) in btrfs_remove_chunk:2625: errno=-28 No space left
>       [112065.264997] BTRFS info (device sdc): forced readonly
> 
>    9) The clear kthread sees that the BTRFS_FS_STATE_ERROR bit is set in
>       fs_info->fs_state and calls btrfs_cleanup_transaction(), which in
>       turn calls btrfs_destroy_pinned_extent();
> 
>    10) Then btrfs_destroy_pinned_extent() iterates over all the ranges
>        marked as dirty in fs_info->freed_extents[], and for each one
>        it calls discard, if the fs was mounted with "-o discard", and
>        adds the range to the free space cache of the respective block
>        group;
> 
>    11) btrfs_trim_block_group(), invoked from the fitrim ioctl code path,
>        sees the free space entries and performs a discard;
> 
>    12) After an umount and mount (or fsck), our eb's location on disk was full
>        of zeroes, and it should have been untouched, because it was marked as
>        dirty in the fs_info->pinned_extents tree, and therefore used by the
>        trees that the last committed superblock points to.

   Wow. Nice one, Filipe.

   Hugo.

-- 
Hugo Mills             | Startle, startle, little twink. How I wonder what
hugo@... carfax.org.uk | you think.
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--KWhV7zotm6ea722p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUgx4dAAoJEFheFHXiqx3kKU8P/2sgzM8dcbBoQfeJPtLtpMOS
TqpNHt+JCMx4hiEI1RuagG6XxezQhppMLHQYxEfO6Y/7FP1lBA7RbICp3fuGtCTC
S5pUp8YqT+8MAF261npmUzVo70K/ude8npqQtJ6fwQyKJNRIe86du0KjU15qLrSm
36NoOXuORTPSOSaOeiPVePhkcmZEJ5NW5U70NM/b50tsSnp9ILfq/MKUsW1NSmfK
sjYEBrorcQ5bFgIVoVaBdecx4z65V7iKRyRgmFwLqQi1gOoG1AXlRIm7Q6asflvC
eGszjmllPLKXkY6wJh+MUd/Xd2Rftt2NqpQCNsQ/G/eGoAko5vx2EEwEFrTNF/qK
GqBHpDW+XhVfqdr/JPy29FDK0sAAm/J3nEXcqBo+3bYyy0cUVH5U9XHMKHlwQ4HP
jM2o+31Qyjck4Ep9KbHTcDaE3txjvOIh/Lq5zaG7apGqKPTVG/coqv12+amnYFsD
hKXVGWX0/bSAm0EhUtxdvDtBWvALh8QsdVNvOL+7gAzB8GsRedA5egWWyL7X4TVd
pfC/8XoWb14HdU+mEMk8B34fq/zIdaa2Ck+JrXIT35kSX+Xzhr88WWGunjHD068f
u6t7HIDY9cpwTPvBMoaO9gj0QIDV4vg5D+2X9reoG7Up3AaWvoI+0JNE9ZCRfk09
n2rinrQl136rpJ0p/4gW
=kgwt
-----END PGP SIGNATURE-----

--KWhV7zotm6ea722p--
