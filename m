Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41189 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933285AbeFVLmQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 07:42:16 -0400
Date: Fri, 22 Jun 2018 13:39:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        anand.jain@oracle.com
Subject: Re: [PATCH 0/7] Fix locking when scanning devices
Message-ID: <20180622113920.GA24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1529516226.git.dsterba@suse.com>
 <1448cdb0-4cf8-c773-ea55-29152adc3df6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448cdb0-4cf8-c773-ea55-29152adc3df6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 21, 2018 at 10:48:27AM +0300, Nikolay Borisov wrote:
> 
> 
> On 20.06.2018 20:51, David Sterba wrote:
> > This patchset fixes the bugs recently reported by syzbot. I've tried to
> > use patches from Anand [1] to fix that but in the end there were fixes
> > not suitable for merging to 4.18 and my final fix took a different
> > approach.
> > 
> > In short, fs_devices::opened is protected by uuid_mutex and this mutex
> > can be used to exclude mount and scanning to interfere.
> > 
> > The fstests pass and 2 syzbot reproducers reported no problems. I'd like
> > to push the patchset to 4.18 but not rc2 as it's too close. I'll add the
> > patchset to for-next soon if there are no major problems found, but
> > otherwise I'm open to comments.
> > 
> > [1]
> > https://patchwork.kernel.org/patch/10446779/
> > https://patchwork.kernel.org/patch/10437707/ 1-6
> > 
> > David Sterba (7):
> >   btrfs: restore uuid_mutex in btrfs_open_devices
> >   btrfs: extend critical section when scanning a new device
> >   btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
> >   btrfs: lift uuid_mutex to callers of btrfs_open_devices
> >   btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
> >   btrfs: reorder initialization before the mount locks uuid_mutex
> >   btrfs: fix mount and ioctl device scan ioctl race
> > 
> >  fs/btrfs/super.c   | 38 +++++++++++++++++++++++++-------------
> >  fs/btrfs/volumes.c | 11 ++++++-----
> >  2 files changed, 31 insertions(+), 18 deletions(-)
> > 
> It's good you've added lockdep asserts in functions whose locking is
> lifted to the caller. However, I'm a bit hesitant about extending the
> locking section so much. I.e i parse_early_opt you are covering quite
> some string manipulation functionality and only the single call to
> btrfs_scan_one_device.

Are string manipulations under a lock a problem? I'd be more worried
about memory allocations or IO that could hold the lock and block other
mount or scan.

As both are very infrequent operations and callers need to wait anyway,
I don't think this will be noticeable in practice.

> I wonder if the whole device scanning/mounting
> code could be refactored to not rely on 2 locks (device list mutex +
> uuid mutex, and that's after you merged your series refactoring locking).

>From what I've seen, there's not much potential for significant changes.
We need the locks to prevent either the data structures or for the
operation exclusion. The rest would be reducing the size of the critical
sections by moving unrelated calls out.
