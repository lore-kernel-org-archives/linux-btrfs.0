Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:47797 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3CPTdi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 15:33:38 -0400
Received: by mail-we0-f169.google.com with SMTP id t11so4073718wey.28
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 12:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130307115526.GL21081@twin.jikos.cz>
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
	<1362154654-17655-1-git-send-email-dsterba@suse.cz>
	<CAOcd+r2_8sXRgQ2EnLBQhKR0kOZz-PEOXUhLy7GmS7oS-8y0Dw@mail.gmail.com>
	<20130306180915.GD21081@twin.jikos.cz>
	<20130307031211.GC13323@shiny.masoncoding.com>
	<20130307115526.GL21081@twin.jikos.cz>
Date: Sat, 16 Mar 2013 21:33:36 +0200
Message-ID: <CAOcd+r2KejGCFGXwGm2UqJUFizu--xi=HMUrs6woih-B3Oo6rA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: clean snapshots one by one
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Thu, Mar 7, 2013 at 1:55 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Mar 06, 2013 at 10:12:11PM -0500, Chris Mason wrote:
>> > > Also, I want to ask, hope this is not inappropriate. Do you also agree
>> > > with Josef, that it's ok for BTRFS_IOC_SNAP_DESTROY not to commit the
>> > > transaction, but just to detach from it? Had we committed, we would
>> > > have ensured that ORPHAN_ITEM is in the root tree, thus preventing
>> > > from subvol to re-appear after crash.
>> > > It seems a little inconsistent with snap creation, where not only the
>> > > transaction is committed, but delalloc flush is performed to ensure
>> > > that all data is on disk before creating the snap.
>> >
>> > That's another question, can you please point me to the thread where
>> > this was discussed?
http://www.spinics.net/lists/linux-btrfs/msg22256.html


>>
>> That's a really old one.  The original snapshot code expected people to
>> run sync first, but that's not very user friendly.  The idea is that if
>> you write a file and then take a snapshot, that file should be in the
>> snapshot.
>
> The snapshot behaviour sounds ok to me.
>
> That a subvol/snapshot may appear after crash if transation commit did
> not happen does not feel so good. We know that the subvol is only
> scheduled for deletion and needs to be processed by cleaner.
>
> From that point I'd rather see the commit to happen to avoid any
> unexpected surprises.  A subvolume that re-appears still holds the data
> references and consumes space although the user does not assume that.
>
> Automated snapshotting and deleting needs some guarantees about the
> behaviour and what to do after a crash. So now it has to process the
> backlog of previously deleted snapshots and verify that they're not
> there, compared to "deleted -> will never appear, can forget about it".

Exactly. Currently, the user space has no idea when the deletion will
start, or when it is completed (it has to track the ROOT_ITEM, drop
progress, ORPHAN_ITEM etc.). That's why I was thinking, that at least
committing a transaction on snap_destroy could ensure that deletion
will not be reverted.

Thanks,
Alex.
