Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37853 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751510AbeDXPvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 11:51:24 -0400
Date: Tue, 24 Apr 2018 17:48:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: update uuid_mutex and device_list_mutex comments
Message-ID: <20180424154848.GK21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180418095631.9977-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180418095631.9977-1-anand.jain@oracle.com>

On Wed, Apr 18, 2018 at 05:56:31PM +0800, Anand Jain wrote:
> @@ -155,29 +155,26 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>   *
>   * uuid_mutex (global lock)
>   * ------------------------
> - * protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
> + * Protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
>   * the SCAN_DEV ioctl registration or from mount either implicitly (the first
> - * device) or requested by the device= mount option
> - *
> - * the mutex can be very coarse and can cover long-running operations
> - *
> - * protects: updates to fs_devices counters like missing devices, rw devices,
> - * seeding, structure cloning, openning/closing devices at mount/umount time
> + * device) or requested by the device= mount option.
>   *
>   * global::fs_devs - add, remove, updates to the global list
              ^^^^^^^

My typo, this should be fs_uuids.

>   * fs_devices::device_list_mutex (per-fs, with RCU)
>   * ------------------------------------------------
> - * protects updates to fs_devices::devices, ie. adding and deleting
> + * Protects updates to fs_devices::devices, ie. adding and deleting, and its
> + * counters like missing devices, rw devices, seeding, structure cloning,
> + * openning/closing devices at mount/umount time.
>   *
> - * simple list traversal with read-only actions can be done with RCU protection
> + * Simple list traversal with read-only actions can be done with RCU protection.
>   *
> - * may be used to exclude some operations from running concurrently without any
> - * modifications to the list (see write_all_supers)
> + * May be used to exclude some operations from running concurrently without any
> + * modifications to the list (see write_all_supers).

The uuid_mutex usage is a bit muddy, so far I think that most uses are
not necessary so this is in line with this patchset. In some cases we
might need to add the device_list_mutex once uuid mutex is gone.

The clear usage of the uuid_mutex is when a new fs_devices is added to
the global fs_uuids, to prevent concurrent access by device scan and
mount. Another one is the seed fs manipulation, that on the higher level
works on the linked fs_devices. And the last one is the device renames
that happen after a device appears under a different name.

So far I haven't noticed any problems during tests of for-next with this
patchset, so I guess we'd have to try harder to trigger the potential
races. Thre's no device add/delete/replace/scan stress tests. The
seeding is not very well covered by tests, so I'll keep the branch in
for-next, but more tests are welcome.
