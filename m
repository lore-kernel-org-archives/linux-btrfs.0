Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933502AbeCGQFJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:05:09 -0500
Date: Wed, 7 Mar 2018 17:02:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
Message-ID: <20180307160248.GG23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180221201921.17944-1-jeffm@suse.com>
 <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
 <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>
 <ac3ffb4b-c60a-fd1e-be50-db99376a6e1e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ac3ffb4b-c60a-fd1e-be50-db99376a6e1e@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 10:05:36AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年02月22日 09:50, Jeff Mahoney wrote:
> > On 2/21/18 8:36 PM, Qu Wenruo wrote:
> >>
> >>
> >> On 2018年02月22日 04:19, jeffm@suse.com wrote:
> >>> From: Jeff Mahoney <jeffm@suse.com>
> >>>
> >>> There are several places where we call btrfs_qgroup_reserve_meta and
> >>> assume that a return value of 0 means that the reservation was successful.
> >>>
> >>> Later, we use the original bytes value passed to that call to free
> >>> bytes during error handling or to pass the number of bytes reserved to
> >>> the caller.
> >>>
> >>> This patch returns -ENODATA when we don't perform a reservation so that
> >>> callers can make the distinction.  This also lets call sites not
> >>> necessarily care whether qgroups are enabled.
> >>
> >> IMHO if we don't need to reserve, returning 0 seems good enough.
> >> Caller doesn't really need to care if it has reserved some bytes.
> >>
> >> Or is there any special case where we need to distinguish such case?
> > 
> > Anywhere where the reservation takes place prior to the transaction
> > starting, which is pretty much everywhere.  We wait until transaction
> > commit to flip the bit to turn on quotas, which means that if a
> > transaction commits that enables quotas lands in between the reservation
> > being take and any error handling that involves freeing the reservation,
> > we'll end up with an underflow.
> 
> So the same case as btrfs_qgroup_reserve_data().
> 
> In that case we could use ret > 0 to indicates the real bytes we
> reserved, instead of -ENODATA which normally means error.
> 
> > 
> > This is the first patch of a series I'm working on, but it can stand
> > alone.  The rest is the patch set I mentioned when we talked a few
> > months ago where the lifetimes of reservations are incorrect.  We can't
> > just drop all the reservations at the end of the transaction because 1)
> > the lifetime of some reservations can cross transactions and 2) because
> > especially in the start_transaction case, we do the reservation prior to
> > waiting to join the transaction.  So if the transaction we're waiting on
> > commits, our reservation goes away with it but we continue on as if we
> > still have it.
> 
> Right, the same problem I also addressed in patchset "[PATCH v2 00/10]
> Use split qgroup rsv type".
> 
> In 6th patch, "[PATCH v2 06/10] btrfs: qgroup: Use
> root->qgroup_meta_rsv_* to record qgroup meta reserved space" qgroup
> meta reserve will only be increased if we succeeded in reserving
> metadata, so later free won't underflow that number.

What should we do now when there are 2 different fixes? Applying Jeff's
patch on top of your qgroup-types patches causes some conflicts that do
not seem to be difficult, but the end result might not work as expected.

The changes do not seem to be fundamentally conflicting, would it make
sense to merge both? The patchset has been in for-next for a while but I
don't run qgroup specific tests besides what's in fstests. Also the
patchset fixes more problems so I think we need to merge it at some
point and now it's a good time about deciding whether it'd go to 4.17.

I did a pass through the patches, there are some minor things to fix but
a review from somebody with qgroup knowledge would be still desirable.
