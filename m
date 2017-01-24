Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33838 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdAXAFw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 19:05:52 -0500
Received: by mail-pf0-f169.google.com with SMTP id e4so44860160pfg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 16:05:51 -0800 (PST)
Date: Mon, 23 Jan 2017 16:05:24 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170124000524.GC11778@vader.DHCP.thefacebook.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com>
 <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 04:48:54PM -0700, Chris Murphy wrote:
> On Mon, Jan 23, 2017 at 3:04 PM, Omar Sandoval <osandov@osandov.com> wrote:
> > On Mon, Jan 23, 2017 at 02:55:21PM -0700, Chris Murphy wrote:
> >> On Mon, Jan 23, 2017 at 2:50 PM, Chris Murphy
> >> > I haven't found the commit for that patch, so maybe it's something
> >> > with the combination of that patch and the previous commit.
> >>
> >> I think that's provably not the case based on the bisect log, because
> >> I hit the problem with kernel that has only the commit, as well as the
> >> commit plus the updated patch. So the patch neither causes nor fixes
> >> the problem I'm experiencing.
> >>
> >> If it's useful the btrfs-image is here; mentioned in a previous
> >> thread, this image mounts find, btrfs check --mode=original has no
> >> complaints, but btrfs check --mode=lowmem has complaints. There's no
> >> problem using the parent subvolume as rootfs. Only snapshots of that
> >> subvolume result in the problem.
> >> https://drive.google.com/open?id=0B_2Asp8DGjJ9ZmNxdEw1RDBPcTA
> >
> > What I meant to ask was if there were false positives/false negatives in
> > booting from the subvolume that would lead you to doubt the results of
> > the git bisect, but it sounds like it's 100% reproducible for you?
> 
> OH I see. Yes. It happens within 60 seconds, during startup or shortly
> after gnome-shell login. So it's really clear that it definitely
> happens or does not happen. But it requires two things to be true:
> kernel version 4.9 or higher *and* a normal rw snapshot is used as
> rootfs. If either of those things is not true, then the problem
> doesn't happen.
> 
> I've also tried building a 4.9 kernel with CONFIG_BTRFS_DEBUG and
> CONFIG_BTRFS_FS_CHECK_INTEGRITY with check_int, but the results are
> the same - no additional debug info shown by dmesg.
> 
> 
> > I'll take a look at the image. In the meantime, could you try booting
> > with https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4
> > applied on top of 4.9 so we can hopefully narrow it down? It'd also be
> > great to know if it always fails the same way or if it varies.
> 
> Appears to always fail the same way.
> 
> [chris@f25h ~]$ dmesg | grep -i btrfs
> [    2.705333] Btrfs loaded, crc32c=crc32c-intel
> [    2.705905] BTRFS: device label fedora devid 1 transid 113458 /dev/nvme0n1p4
> [    2.764563] BTRFS: device label fedora devid 2 transid 113458 /dev/nvme0n1p6
> [    3.990957] BTRFS info (device nvme0n1p6): disk space caching is enabled
> [    3.990988] BTRFS info (device nvme0n1p6): has skinny extents
> [    4.010618] BTRFS info (device nvme0n1p6): detected SSD devices,
> enabling SSD mode
> [    4.551046] BTRFS info (device nvme0n1p6): disk space caching is enabled
> [   13.906182] btrfs_update_delayed_inode() -> -2
> [   13.906261] WARNING: CPU: 0 PID: 488 at
> fs/btrfs/delayed-inode.c:1179 __btrfs_run_delayed_items+0x1b7/0x660
> [btrfs]
> [   13.906266] BTRFS: Transaction aborted (error -2)
> [   13.906460]  tpm_tis acpi_thermal_rel lis3lv02d tpm_tis_core
> input_polldev acpi_pad wmi nfs_acl hp_wireless tpm lockd grace sunrpc
> btrfs i915 xor raid6_pq i2c_algo_bit drm_kms_helper drm crc32c_intel
> nvme serio_raw nvme_core i2c_hid video fjes
> [   13.906635]  [<ffffffffc05417a0>] ?
> __btrfs_release_delayed_node+0x70/0x1c0 [btrfs]
> [   13.906690]  [<ffffffffc0542467>]
> __btrfs_run_delayed_items+0x1b7/0x660 [btrfs]
> [   13.906743]  [<ffffffffc0542fd3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [   13.906793]  [<ffffffffc04e502a>]
> btrfs_commit_transaction+0x23a/0xa20 [btrfs]
> [   13.906853]  [<ffffffffc050345c>] ?
> btrfs_wait_ordered_range+0x7c/0x100 [btrfs]
> [   13.906910]  [<ffffffffc04fe07b>] btrfs_sync_file+0x2fb/0x3e0 [btrfs]
> [   13.906970] BTRFS: error (device nvme0n1p6) in
> __btrfs_run_delayed_items:1179: errno=-2 No such entry
> [   13.906976] BTRFS info (device nvme0n1p6): forced readonly
> [   13.906982] BTRFS warning (device nvme0n1p6): Skipping commit of
> aborted transaction.
> [   13.906989] BTRFS: error (device nvme0n1p6) in
> cleanup_transaction:1850: errno=-2 No such entry
> [   13.907943] BTRFS info (device nvme0n1p6): delayed_refs has NO entry
> 
> Complete dmesg tags/v4.9 + osandov/9f223b
> https://drive.google.com/open?id=0B_2Asp8DGjJ9N1g5Wm9lVHpGWG8

Thanks! Hmm, okay, so it's coming from btrfs_update_delayed_inode()...
That's probably us failing btrfs_lookup_inode(), but just to make sure,
could you apply the updated diff at the same link as before
(https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4)? If
that's the case, I'm even more confused about what xattrs have to do
with it.
