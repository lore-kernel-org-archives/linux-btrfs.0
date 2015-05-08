Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35275 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbbEHVSw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 17:18:52 -0400
Date: Fri, 8 May 2015 21:18:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anthony Plack <anthony@plack.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel Dump scanning directory
Message-ID: <20150508211850.GN18480@carfax.org.uk>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
 <4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
 <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
 <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wmhq21yAGFMoSpeN"
In-Reply-To: <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wmhq21yAGFMoSpeN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 08, 2015 at 11:44:39AM -0500, Anthony Plack wrote:
> > On May 7, 2015, at 4:30 PM, Anthony Plack <anthony@plack.net> wrote:
> > On May 7, 2015, at 9:33 AM, Anthony Plack <anthony@plack.net> wrote:
> >> Okay, trying my programming skills at this unfamiliar code.
> >> 
> >> Okay so this looks like an IO error, then an abort transaction.  Is it a fair assumption that a normal transaction abort marks the volume as read-only, undoes the transaction, and then marks the transaction as read-write?  Therefore, because of the dump, in the middle of the undo, the volume remains read-only?
> >> 
> >>> On May 6, 2015, at 4:56 PM, Anthony Plack <anthony@plack.net> wrote:
> >> 
> >> This next one seems a little more obvious.
> >> 
> >> 0x12d4 is in btrfs_select_ref_head (fs/btrfs/delayed-ref.c:438).
> >> 433			head = rb_entry(node, struct btrfs_delayed_ref_head,
> >> 434					href_node);
> >> 435		}
> >> 436	
> >> 437		head->processing = 1;
> >> 438		WARN_ON(delayed_refs->num_heads_ready == 0);
> >> 439		delayed_refs->num_heads_ready--;
> >> 440		delayed_refs->run_delayed_start = head->node.bytenr +
> >> 441			head->node.num_bytes;
> >> 442		return head;
> >> 
> >> Because there are not heads ready, we are getting a warning.
> >> 
> >> So the real question is how do I know what is generating the IO error?  The rsync -nav is not changing the the volume, it is reading from it.
> >> 
> >> The devices are not showing errors in the log or in the "device stat" view.
> >> 
> >> What seems to be interesting is that whatever is generating the IO errors (which seems to be in the extents), triggers the Warning, which by default flips the whole volume to read-only.
> > 
> > Okay, so I ran btrfs-debug-tree /dev/sdm.  Most of the leaves looked okay until it got to one where it gave me this and quit:
> > 
> > 	item 35 key (2685703434240 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
> > 		extent refs 1 gen 150619 flags TREE_BLOCK
> > 		tree block key (4231221 DIR_ITEM 1140804831) level 0
> > 		tree block backref root 5
> > parent transid verify failed on 94238015488 wanted 150690 found 150691
> > parent transid verify failed on 94238015488 wanted 150690 found 150691
> > parent transid verify failed on 94238015488 wanted 150690 found 150691
> > parent transid verify failed on 94238015488 wanted 150690 found 150691
> > Ignoring transid failure
> > print-tree.c:1091: btrfs_print_tree: Assertion failed.
> > btrfs-debug-tree[0x418539]
> > btrfs-debug-tree[0x41a53a]
> > btrfs-debug-tree(btrfs_print_tree+0x1eb)[0x41a40b]
> > btrfs-debug-tree(main+0x704)[0x407d04]
> > /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2936a42a85]
> > btrfs-debug-tree[0x40812d]
> > 
> > So it looks like the IO error is really just a bad extent, which makes sense from the warnings from the kernel.
> 
> Okay, updated the btrfs-progs to 4.0.  No change.  Scrub runs fine, 6 uncorrectable errors.
> 
> I have a new drive, and the worst drive in the list is /dev/sdl.  So I started a replace operation on sdl figuring that if I can replace the drive causing the bad IO, I can fix the issue.
> 
> btrfs replace start -f /dev/sdu /dev/sdl /mnt/data
> 
> This generated another warning (and read-only location)
> 
> May  8 11:22:05 fatdrive kernel: BTRFS: dev_replace from /dev/sdl (devid 10) to /dev/sdu started
> May  8 11:22:13 fatdrive kernel: BTRFS: btrfs_scrub_dev(/dev/sdl, 10, /dev/sdu) failed -5
> May  8 11:22:13 fatdrive kernel: ------------[ cut here ]------------
> May  8 11:22:13 fatdrive kernel: WARNING: CPU: 0 PID: 8719 at fs/btrfs/dev-replace.c:425 btrfs_dev_replace_start+0x345/0x370()
> May  8 11:22:13 fatdrive kernel: Modules linked in: ntfs nfsd exportfs r8169 mii kvm_amd kvm k10temp ata_generic acpi_cpufreq
> May  8 11:22:13 fatdrive kernel: CPU: 0 PID: 8719 Comm: btrfs Tainted: G        W       4.0.0-gentoo #2
> May  8 11:22:13 fatdrive kernel: Hardware name: BIOSTAR Group TA880G HD/TA880G HD, BIOS 080015  11/11/2011
> May  8 11:22:13 fatdrive kernel:  ffffffff81a98eea ffff880214a9bcb8 ffffffff817e6934 0000000000000000
> May  8 11:22:13 fatdrive kernel:  0000000000000000 ffff880214a9bcf8 ffffffff81049e60 ffff880214a9bcc8
> May  8 11:22:13 fatdrive kernel:  ffff88020fdf2000 00000000fffffffb ffff88020c89d000 ffff88020c89dda8
> May  8 11:22:13 fatdrive kernel: Call Trace:
> May  8 11:22:13 fatdrive kernel:  [<ffffffff817e6934>] dump_stack+0x45/0x57
> May  8 11:22:13 fatdrive kernel:  [<ffffffff81049e60>] warn_slowpath_common+0x90/0xd0
> May  8 11:22:13 fatdrive kernel:  [<ffffffff81049f45>] warn_slowpath_null+0x15/0x20
> May  8 11:22:13 fatdrive kernel:  [<ffffffff81377d75>] btrfs_dev_replace_start+0x345/0x370
> May  8 11:22:13 fatdrive kernel:  [<ffffffff8133f41b>] btrfs_ioctl+0x1a2b/0x2a90
> May  8 11:22:13 fatdrive kernel:  [<ffffffff8110e92b>] ? unlock_page+0x6b/0x70
> May  8 11:22:13 fatdrive kernel:  [<ffffffff8110f30a>] ? filemap_map_pages+0x1ba/0x210
> May  8 11:22:13 fatdrive kernel:  [<ffffffff811349c3>] ? handle_mm_fault+0x733/0xef0
> May  8 11:22:13 fatdrive kernel:  [<ffffffff81170b00>] do_vfs_ioctl+0x2e0/0x4e0
> May  8 11:22:13 fatdrive kernel:  [<ffffffff813957bf>] ? file_has_perm+0x8f/0xa0
> May  8 11:22:13 fatdrive kernel:  [<ffffffff81170d89>] SyS_ioctl+0x89/0xa0
> May  8 11:22:13 fatdrive kernel:  [<ffffffff8103e9fc>] ? do_page_fault+0xc/0x10
> May  8 11:22:13 fatdrive kernel:  [<ffffffff817eea32>] system_call_fastpath+0x12/0x17
> May  8 11:22:13 fatdrive kernel: ---[ end trace 205223c7c401157e ]---
> May  8 11:25:39 fatdrive kernel: device: 'btrfs-6': device_unregister
> May  8 11:25:39 fatdrive kernel: PM: Removing info for No Bus:btrfs-6
> May  8 11:25:39 fatdrive kernel: device: 'btrfs-6': device_create_release
> 
> 
> Now I need to figure out error -5.  The Warning is a thrown warning.
> 
>         /* the disk copy procedure reuses the scrub code */
>         ret = btrfs_scrub_dev(fs_info, src_device->devid, 0,
>                               btrfs_device_get_total_bytes(src_device),
>                               &dev_replace->scrub_progress, 0, 1);
> 
>         ret = btrfs_dev_replace_finishing(root->fs_info, ret);
>         /* don't warn if EINPROGRESS, someone else might be running scrub */
>         if (ret == -EINPROGRESS) {
>                 args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
>                 ret = 0;
>         } else {
>                 WARN_ON(ret);
>         }
> 
> 
> I am close to zeroing the log at this point.  It is sad that we cannot fix the transaction log instead of just flushing it.

   That's not likely to make any difference here. If the FS mounts OK
with -o ro, then zeroing the log might be useful. Otherwise, it won't
e (a read-only mount won't replay the log; if it mounts without
replaying the log, the problem is in the log, and it should be
dropped; if not, then the problem is nothing to do with the log).

   Dropping the log is *not* a panacea to all btrfs problems. It's
there for a very limited class of issues, which rarely show up these
days. I wish there were some way of editing the internet(*) to remove the
idea that btrfs-zero-log will magically fix everything. It won't.

(*) https://www.xkcd.com/386/ is probably appropriate here.

> Once again btrfsck --repair /dev/sdm ended with
> 
> parent transid verify failed on 94238015488 wanted 150690 found 150691
> Ignoring transid failure
> 
> no attempt to actually repair the volume.  No indication from the tools why.

   A transid failure means that the superblock has been written out to
disk *before* a part of the metadata that forms that transaction, and
then the machine has crashed in some way that prevented the
late-arriving metadata from hitting the disk. There are two ways that
this can happen: it's a bug in the kernel, or the hardware lies about
having written data. Both are possible, but the former is more likely.

   Once this failure has happened, the FS is corrupt in a way that's
hard to repair reliably. I did raise this question with Chris a while
ago, and my understanding from the conversation was that he didn't
think that it was possible to fix transid failures in btrfsck.

> Maybe I am over hoping for a COW transaction system to actually have
> the ability to fix transaction issues since there is little to no
> documentation other than zero the log.  I am also wondering why we
> have a log in the file system if the fix is to just flush it.

   Once again: zeroing the log won't help. It doesn't fix everything.
In fact, it rarely fixes anything.

   The reason there's no documentation on fixing transid failures is
because there's no good fix for them.

   Hugo.

-- 
Hugo Mills             | To an Englishman, 100 miles is a long way; to an
hugo@... carfax.org.uk | American, 100 years is a long time.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Earle Hitchner

--wmhq21yAGFMoSpeN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVTSg6AAoJEFheFHXiqx3kK8oP/0FQGdvbFhGzsPNNSmGeHVWm
+vttp6umCYETlQxydmhPx5LSp6WlFg1s21d1uHwZ+uJ76NAQGBhBeCxAL7crh0IG
MP16wUzFD6W3Sjk8r5Np4I3FRwneZp3O6QpvhVWH2yoyo4Y88FptgxsboXBb8fvS
eQs6FhieL1gkeUA9PK7861jWnsTvS/qDDkG2pLTstl/17oU+Z3wYEVfvwFB0lSBx
HmH8Ohv32ihnXNxlexNy6TMPEUT/5S4LMEZvBO89FaVTsbOI3O+2COSkY5gfaee+
evxRq0P0QpBC1JrBtQPbjK7aU+OoymuVHXn134AE1KrmrhgLmbTWSAHRUT1TU+hC
kr8qykFxHhTiL0gOkC53+8OctLK/ucc4AotBYgLIeU6Uk7BF0P8ZpnkrB8ta+tSf
gO+GjB8JPL+PxoYsN/eh5XXiUP0Pfov5X0Hb64QTkKplf4feeMnsoGGJDFpPyGKY
jf8BKO9JITJyD+zTouSBHmJ3tgWFlEFmOGngMBUGQak93EYhiDdlYiWXFFxv5vnP
GNqzbbmNfYX/qAGzX9sMdXDy63T8hypnjqqnymQkHdaXGsTZS8qiz3pGXsUXsrRm
6cb88t0SCir4ziH/X81Pl0WbXinlh+2UM4TrmW1Qeko+KPtHuIjT0OBq0cw97qXu
xMpUojXkoDGtaVSSNRKG
=3MfD
-----END PGP SIGNATURE-----

--wmhq21yAGFMoSpeN--
