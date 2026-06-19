Received: from mail-qk2-f4.google.com (unknown [74.125.230.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D99394783
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.196
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875704; cv=pass; b=GBXjU6zOKERllNvCejbS/lqyEcUdR06XFHxweEyqQ1JowQMEevf75A7UcsmevSk4XKIRHZ5F7kdXZuD2pNCx8b4Fl/tqtJUP1EIxMJDJozKVAcz2UYGCH+0yo6TsVCTyuNkBcO7P/GrboZ+Ytp+cSh/C0Q0HdFOPmadl1/oh9Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875704; c=relaxed/simple;
	bh=oe/NPl591JvG5D7qhzE08MRLADXnuWiAWnd9Dkm2oZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=suQkas7gmqCgyxwXtpzGI4TJGoiq0oHOGIjlfz/XF9erN8E6zTp9fIJMSWB1gtYXCBmnb1kVCLweYlYUs8ksM2tE1V5Xy2ln2DvQpI7o9lgIUksaylGieEVxgLvY1bALskk0MelyuTWmdm04jIXWu/xFGAOb0Ai2MIDdq6l+YcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcXev4ZL; arc=pass smtp.client-ip=74.125.230.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcXev4ZL"
Received: by mail-qk2-f4.google.com with SMTP id d75a77b69052e-519bd35cf15so27151cf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 06:28:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781875702; cv=none;
        d=google.com; s=arc-20240605;
        b=RakU+1tGwn5vET/+BGKkDjGQpy4ETk2HLDq6+ZzLSW6dUhb/igHshGFXNKx1j9DhGI
         XpwLDCK2jvGXfmZwZfwl/ii6w0xq2fcSwtLEb6PTLnkMG2PcrDpmg4PxV/JedNcb2rgo
         3htMBdfZApRBjm+d8HUqFov7bix4FJ0LX+syLGAJJytpyBMjXg/n8uLw7S76X2wPK5hY
         r75KNB5Y/XSmmnq+okK/kKDoQEq+ZGRgNFb+gHWaJf3oUU8+FBuqQ+GOGKQDI21fndjJ
         6fMDhFNZ2OIIjmcnRN4zHj213hhfSgt/jGWMEw/gfQPh7Mlh2K0RBmJVPs7419/z1GSv
         qOiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=3Q3R9ouG4/tkro+cOtUhcXkG7MH/+bbKO4N52V3uA9k=;
        fh=yjjWs7MNFwuz+85IKwjKeWfNe8t1wX1tLl0Rbvnwpqk=;
        b=lI3tF1D30sFQB9xVQ/tuZz6j1B1Y1Jh7ye8od1c8DJr+GP19YR32E1AXFx4nz+UY3R
         ICU3b2kMgYnJM/lIYQRvghZuu3hvHSWqpjxLWeEErO/Rp+YnoX3T3/vT9bNoB9WgivWs
         UJs+UjY63jot3jCxD48ik3Nie9VLtq7qpiygug8rXi5GvsoqLHavS0tZB4KLPm6eMl8Y
         px//GZXJo9gyqpDE9ICYmQdkmCg/3mWOzRgIgqmuHbH1oq953HCJvIodqZ5Mv99/xj6u
         njVdGoVcLldJMavi3b4FMakjM+oLd8IHBj4cLBBhya5CfUTjjVNGTiyKejDKQpSJ2VRk
         pwIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781875702; x=1782480502; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Q3R9ouG4/tkro+cOtUhcXkG7MH/+bbKO4N52V3uA9k=;
        b=jcXev4ZLvVGu/m6xCN2H85MKCZ8vmEEKf2ULD00yBMpy1W/oWNnH84HjwlkK3h/InM
         T95+fqY8puX8KdDZh1+Frf1vaFT7hqCwVwl6HuQknkNl9yvry0/4FwZHn4Z3KCWSJ1uc
         f8JvG5mIwfbJMhb29CfABX2iQsl9LxQckhC3w0DDk4OcmEaP4IOmt2hr+06Kc8iN4jm0
         5fdKQwxCi77sNKVeS2NHAZUmsedlqp6QDVz3cwfdUvvyo8Q/ej9cfVjZc3zhQP3HkTfY
         YpLPu8pb9ImaC2QzRgm/CwlvO3UnWl+ddiDMlqsCXCSoOdS/rR81aTcWX1bKpgFXSiwD
         Fl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875702; x=1782480502;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Q3R9ouG4/tkro+cOtUhcXkG7MH/+bbKO4N52V3uA9k=;
        b=tYfTXS9VAPvFLkRxC88rMxmwGblRJ08yek2ATv/47ByXETOer7Md38mc/5zdt99B3n
         fZTbCGmeAeeDlkcUNuRWSahcWnIW3HGN5M23plaiOanjTsELjFJS2a36OR33DtNqTA8T
         n19iaEDSL8mLr7d6njx6kn/2RkwV8hndwbn5qVy1EWyH/cVbh/TWo36v+D6LDZ0K6lY9
         CfTUvqdkr/URgN0iyCc1MgmJklT4vBAuLRZ+eihy0vdbRAos2CgUPIpaO2gVhHKaYEmj
         zeLz9ZZu+oQJQCIbcj4vkcOqUL8PfkwRhEhPeMpRsPs11D2e9PKHAEe+Slzip8GIELSB
         jq0Q==
X-Forwarded-Encrypted: i=1; AFNElJ9KZRFE4DblMi+Ui6loMN2CpoyllNhRKa/gdLLgOR0g+OM+YM6JBrX4ZrioBDyFmrSx0nKRqJy1VGzV1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfmtmTY1ixlwHvK7sb+GhNJk5Dg5BVI6AtTFoIcGDmdlIVZp2+
	rI5jVrLXs47olzbFy+kxDoG1+agp8eMbHb8zeCePGi/5QcO2hkFu5ABlS4VmS0qh09B1Nb6+e8s
	rcPXGJQB3zM/56rgAKU5zGYGvAeVBsr3YiZhodLYgMGiM
X-Gm-Gg: AfdE7cn986CqC2bLVXuCce2UQZHaM6yuugWuETso8MHYqraWVtzuucgM9UkVDUXSto7
	MrqblOi5TPBDXZDbOAB4SHBp3K1DEf9UQvNaupoqZpHiuDZYFfxMuQGKmMD31EphBsBYJDjRxxP
	a1irVIKsQabfROJADJ7AnHL1dErPrgU0iTSSGAo68CO+sgHcOv0N06I41x9ay01XnMeOLN43XuF
	abir/2dRV4BzQq7MxngOk/YeDPNULqXlYuJTE66X6o9lywaLSuNwMrElUfyqwRmiQqkCPGT6DhQ
	LiljW8GTPHIO1XkK0WOdP05l1K5P5Q==
X-Received: by 2002:ac8:7d91:0:b0:517:5e32:f3c2 with SMTP id
 d75a77b69052e-519febcfc63mr7194071cf.1.1781875701685; Fri, 19 Jun 2026
 06:28:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
From: sun k <sunk67188@gmail.com>
Date: Fri, 19 Jun 2026 21:28:10 +0800
X-Gm-Features: AVVi8CdkQ2pvXMIS6cXuR11VsV0DHaQKnrvh549JXXf0Wp8HuFZSVqxrp5X6QvU
Message-ID: <CAAuSuOqD+=nHVZu3czFe5JfQ3m1RDt0sWibVjPZdh4HeOom=Fw@mail.gmail.com>
Subject: Re: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned + non-zoned)
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

Glad to know that you're working on btrfs's raid56 and raid stripe tree.
This really a big change and it will really take me quite some time to
dive into the code implementation.

Before going into code details, I take a glance on the total design and
it seems nice for me. But there's still some details that I'm currently
not sure so please correct me if I got anything wrong.

First is about partial update. With this RFC they'll not updated
in-place(overwrite) anymore, but use a cow method instead, which means
... we'll write that data elsewhere on disk, but still share the
previous logical address? This will change address mapping for a
blockgroup while current existing blockgroup profiles will not change
the address mapping in their entire lifetime IIRC so I have no idea if
current free space management things can works with this.

Second is about the new key type in raid stripe tree. It makes the tree
search more complex as we've discussed before. So I wonder if it will
work just putting the parity stripe into RAID_STRIPE_KEY item, and using
the last 1 stripe for parity on raid5, the last 2 on raid6.

Third is about the partial tail. If we have 4 disks for raid 5 setup,
and the extent only fills one and a half stripe, how will things work in
this RFC? And why use file size to decide it is a genuine tail? I have
no idea why it makes sense.

BTW, this might be a little off-topic but I've just read closure.h
recently and I wonder if we could use that to make bio related things
more readable and easier to work with in btrfs.

Thanks,
Sun YangKai




On 2026/6/19 17:01, Johannes Thumshirn wrote:
> This purely RFC series teaches btrfs to run RAID5/6 on top of the RAID
> stripe-tree (RST), both on zoned devices (ZNS / SMR, the primary target)
> and on regular non-zoned devices. Write-hole-free RAID5 for ordinary
> disks is an explicit goal here, not just a side effect of the zoned
> work.
>
> It is send as an early feedback/design review and not intended to be
> used, therefore I deliberately did not include the btrfs-progs part of
> it.
>
> Motivation
> ==========
>
> Classic btrfs RAID56 derives the data/parity device and offset for each
> stripe from a fixed geometric rotation and overwrites parity in place.
> That model has two problems:
>
>   1) It cannot work on zoned devices, which forbid in-place overwrite
>   2) In-place parity update is the source of the RAID56 write hole
>
> The RAID stripe-tree already maps a logical address to a per-device
> physical address for each stripe of a profile. Building RAID5 on the RST
> means every stripe's location is recorded rather than computed, so data
> and parity can land anywhere (e.g. wherever a zone-append put them) and
> stripes are written copy-on-write. That removes the write hole and makes
> RAID5 expressible on zoned devices.
>
> How it works
> ============
>
> Write:
> ------
> A RAID5 write does not assemble a full stripe up front. Each data bbio
> folds its column into a shared, zeroed per-stripe parity buffer held by
> a struct btrfs_stripe_set (keyed by full_stripe_logical), accounting the
> folded bytes. The parity is submitted by btrfs_stripe_set_finalize():
>
> - eagerly, once all nr_data columns are folded (a full stripe, even if
>    it was split across two ordered extents); or
> - for a partial tail (a stripe that never fills), from the
>    ordered-extent completion in btrfs_rst_raid56_finish_ordered(), using
>    i_size to decide it is a genuine tail.
>
> The actual zone-append physical for both data and parity is recorded into the
> RST from the bio completion, so reads resolve by lookup and the append may
> land anywhere. btrfs_stripe_set_calc_parity() dispatches on the parity count
> and currently has a RAID6 (or higher order parity) placeholder.
>
> Read:
> -----
> btrfs_rst_raid56_read() reads the target data column directly when its device
> is present, and reconstructs it from the other columns + parity (xor_gen)
> only when the target column's device is missing or on a repair retry. RAID56
> lookups trust the recorded (devid, physical) and resolve the device from the
> recorded devid rather than from a geometric rotation: a zoned RST RAID5 data
> column is a contiguous zone-append run, so a single data extent can span what
> the geometric model treats as multiple rotated rows, and geometry would
> resolve a read to the wrong device.
>
> Delete / partial free:
> ----------------------
> btrfs_delete_raid_extent() removes a RAID56 stripe's data+parity only for a
> full stripe entirely covered by the freed range; a partial free retains the
> items (so survivors still reconstruct), and the leftovers are reclaimed when
> the block-group is removed.
>
> Testing
> =======
>
> Verified on QEMU NVMe ZNS, zloop and emulated SMR (SCSI ZBC), and on
> regular non-zoned loop devices:
>
>   1) full-stripe writes (128K..32M) and sub-stripe writes round-trip cache-cold
>      and across umount/remount
>   2) in-kernel sanity tests pass
>   3) on-disk parity content is verified (a half-stripe write's recorded parity
>      equals the data column)
>   4) non-zoned RAID5-RST: mkfs/mount, cache-cold read, overwrite, single-device
>      corrupt + degraded reconstruct, btrfs check
>
> Limitations / open work
> =======================
>
>   1) Partial stripe (over)write is different from my original idea to pad
>      to BTRFS_STRIPE_LEN with 0 bytes and then compute parity. This
>      totally broke space accounting (obviously afterwards *facepalm*)
>   2) RAID6 is not implemented; the parity computation has a single-parity
>      (RAID5) implementation and a RAID6 placeholder.
>   3) Reconstruct soundness for non-stripe-aligned, row-spanning data
>      extents is not yet fully verified end to end (degraded reconstruct
>      works for single-extent stripes).
>   4) Reflink handling is not very well tested yet
>   5) No NOCOW testing and I'm leaning to make a global no-NOCOW for RST
>   6) Full fstests run still pending
>   7) Testing, testing, testing
>
> Johannes Thumshirn (15):
>    btrfs: factor out filling a single raid_stride
>    btrfs: pass the key type to btrfs_insert_one_raid_extent()
>    btrfs: introduce BTRFS_RAID_STRIPE_PARITY_KEY
>    btrfs: zoned: align max_zone_append_size to the stripe length for RST
>    btrfs: load raid56 block-groups
>    btrfs: allow RAID56 for data block groups with stripe-tree
>    btrfs: don't call into regular raid56 if we're using RST
>    btrfs: implement RAID stripe-tree RAID5 writes
>    btrfs: implement basic RAID stripe-tree RAID5 read
>    btrfs: fix RAID stripe-tree lookup across leaf boundaries
>    btrfs: tests: add a RAID5 RAID-stripe-tree read test
>    btrfs: compute RAID stripe-tree RAID5 parity for sub-stripe writes
>    btrfs: implement delete of parity stripes
>    btrfs: tests: add RAID5 RAID-stripe-tree create/update/delete tests
>    btrfs: search commit root when relocating on RST
>
>   fs/btrfs/bio.c                          | 100 ++-
>   fs/btrfs/block-group.c                  |  15 +
>   fs/btrfs/disk-io.c                      |  16 +
>   fs/btrfs/fs.h                           |   3 +
>   fs/btrfs/inode.c                        |   7 +
>   fs/btrfs/print-tree.c                   |   2 +
>   fs/btrfs/raid-stripe-tree.c             | 805 +++++++++++++++++++++++-
>   fs/btrfs/raid-stripe-tree.h             |  22 +-
>   fs/btrfs/super.c                        |   9 +
>   fs/btrfs/tests/raid-stripe-tree-tests.c | 344 +++++++++-
>   fs/btrfs/volumes.c                      |  13 +
>   fs/btrfs/zoned.c                        |  76 +++
>   include/trace/events/btrfs.h            |  24 +
>   include/uapi/linux/btrfs_tree.h         |   1 +
>   14 files changed, 1395 insertions(+), 42 deletions(-)
>
