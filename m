Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933381AbeFKQTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 12:19:49 -0400
Date: Mon, 11 Jun 2018 18:16:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates for 4.18
Message-ID: <20180611161508.GA24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1528125657.git.dsterba@suse.com>
 <CAL3q7H7iLCPxA01811RJK-bEiRPAGJdTrHLogJr2a3Sq1g0k4g@mail.gmail.com>
 <e315b073-05f9-7280-d1ee-4d0456085720@oracle.com>
 <CAL3q7H6EwxMVCM7-cfwb119eCaYAaVo3Go64jE99Z9y04igV5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6EwxMVCM7-cfwb119eCaYAaVo3Go64jE99Z9y04igV5w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 11, 2018 at 10:50:54AM +0100, Filipe Manana wrote:
> >>>        btrfs: replace uuid_mutex by device_list_mutex in
> >>> btrfs_open_devices

> >>   *
> >>   * the mutex can be very coarse and can cover long-running operations
> >>   *
> >>   * protects: updates to fs_devices counters like missing devices, rw
> >> devices,
> >>   * seeding, structure cloning, openning/closing devices at mount/umount
> >> time
> >>
> >> generates some confusion since btrfs_open_devices(), after that
> >> commit, no longer takes the uuid_mutex and it
> >> updates some fs_devices counters (opened, open_devices, etc).
> >
> >  As uuid_mutex is a global fs_uuids lock for the per fsid operations
> >  doesn't make any sense.
> >
> >  This problem is reproducible only for-4.18, misc-next if fine.
> >  I am looking deeper.
> 
> What about the unprotected updates (increments) to fs_devices->opened
> and fs_devices->open_devices?
> Other functions are accessing/updating them while holding the uuid mutex.

The goal is to reduce usage of uuid_mutex only to protect search or
update of the fs_uuids list, everything else should be protected by the
device_list_mutex.

The commit 542c5908abfe84f7 (use device_list_mutex in
btrfs_open_devices) implements that but then the access to the ->opened
member is not protected consistently. There are patches that convert the
use to device_list_mutex but haven't been merged due to refinements or
pending review.

At this point I think we should revert the one commit 542c5908abfe84f7
as it introduces the locking problems and revisit the whole fs_devices
locking scheme again in the dex dev cycle. That will be post rc1 as
there might be more to revert.
