Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752600AbdKFPLJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:11:09 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C5B70AC0C
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 15:11:07 +0000 (UTC)
Date: Mon, 6 Nov 2017 16:09:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/11] btrfs: document device locking
Message-ID: <20171106150916.GH28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1509471604.git.dsterba@suse.com>
 <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
 <eb745210-9d49-1d74-5715-9fc29f6cb3c1@suse.com>
 <20171106135156.GD28789@suse.cz>
 <5661b2a4-3f0d-281e-6472-66cd48e08eca@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5661b2a4-3f0d-281e-6472-66cd48e08eca@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 05:02:21PM +0200, Nikolay Borisov wrote:
> Right, I did a fresh read and indeed the structure now makes sense. I
> have completely missed the nesting though. Maybe you can nest more
> agressively, now every sentence is aligned to the header, perhaps we
> want to have it one level deeper? Or use more than one - at the mutex
> level ? I don't really have a clear-cut answer for you.

How about that:

/*
 * Device locking
 * ==============
 *
 * There are several mutexes that protect manipulation of devices and low-level
 * structures like chunks but not block groups, extents or files
 *
 * uuid_mutex (global lock)
 * ------------------------
 * protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
 * the SCAN_DEV ioctl registration or from mount either implicitly (the first
 * device) or requested by the device= mount option
 *
 * the mutex can be very coarse and can cover long-running operations
 *
 * protects: updates to fs_devices counters like missing devices, rw devices,
 * seeding, structure cloning, openning/closing devices at mount/umount time
 *
 * global::fs_devs - add, remove, updates to the global list
 *
 * does not protect: manipulation of the fs_devices::devices list!
 *
 * btrfs_device::name - renames (write side), read is RCU
 *
 * fs_devices::device_list_mutex (per-fs, with RCU)
 * ------------------------------------------------
 * protects updates to fs_devices::devices, ie. adding and deleting
 *
 * simple list traversal with read-only actions can be done with RCU protection
 *
 * may be used to exclude some operations from running concurrently without any
 * modifications to the list (see write_all_supers)
 *
 * volume_mutex
 * ------------
 * coarse lock owned by a mounted filesystem; used to exclude some operations
 * that cannot run in parallel and affect the higher-level properties of the
 * filesystem like: device add/deleting/resize/replace, or balance
 *
 * balance_mutex
 * -------------
 * protects balance structures (status, state) and context accessed from
 * several places (internally, ioctl)
 *
 * chunk_mutex
 * -----------
 * protects chunks, adding or removing during allocation, trim or when a new
 * device is added/removed
 *
 * cleaner_mutex
 * -------------
 * a big lock that is held by the cleaner thread and prevents running subvolume
 * cleaning together with relocation or delayed iputs
 *
 *
 * Lock nesting
 * ============
 *
 * uuid_mutex
 *   volume_mutex
 *     device_list_mutex
 *       chunk_mutex
 *     balance_mutex
 */
