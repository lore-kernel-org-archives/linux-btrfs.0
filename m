Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933557AbeFRNfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 09:35:21 -0400
Date: Mon, 18 Jun 2018 15:32:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: clm@fb.com, dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        anand.jain@oracle.com
Subject: Re: general protection fault in find_device
Message-ID: <20180618133228.GL24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <000000000000e5da7e056ee43449@google.com>
 <45200a61-58c3-b7f0-d8e4-5108f8369ac5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45200a61-58c3-b7f0-d8e4-5108f8369ac5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 10:03:18AM +0300, Nikolay Borisov wrote:
> So this suggests some inconsistency on fs_devices->devices list. On a
> quick look indeed it doesn't seem clear what the locking rules for this
> list are. In device_list_add in the !device case a device is added with
> fs_devices->device_list_Mutex held and using list_add_rcu. In the same
> function if we want to read the list ie invoke find_devices (because we
> have found an fsid) we are using plain list_for_each_entry (ie not the
> _rcu version and i don't see device_list_mutex being held while
> iterating the list). Additionally in btrfs_free_extra_devids the
> fs_devices->devices list is iterated with uuid_mutex being held and not
> device_list_mutex. In open_fs_devices we don't get any protection
> whatsoever while reading the list.

The uuid_mutex or device_list_mutex is provided by a caller up the
stack.

> Same thing in
> btrfs_find_next_active_device. If the list is supposed to be
> RCU-protected then the rules are:
> 
> 1. There needs to be an out of band (ie not RCU) mutual exclusion of
> modifiers

that's device_list_mutex for fs_devices::devices

> 2. Iterating the list should use _rcu list primitives.
> 
> Currently I don't see those 2 invariants being enforced in every code path.

Where is it not enforced for example?

If the device_list_mutex is held, list traversal does not use
list_for_each_entry_rcu, otherwise it does (eg the DEV_INFO ioctl or
btrfs_show_devname).

The problem that triggers this report is IMO in device_list_add that
uses the device list unprotected. Anand sent patches for that, but they
were titled as 'cleanups' so I skipped them for the merge window.

Candidate fixes are:

https://patchwork.kernel.org/patch/10437705/
https://patchwork.kernel.org/patch/10437713/
