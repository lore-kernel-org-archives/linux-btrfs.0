Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50655 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964879AbcJQPpA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:45:00 -0400
Date: Mon, 17 Oct 2016 08:44:44 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
Message-ID: <20161017154443.GA13942@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
 <1472844934-32343-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
 <20160906215151.GB31641@localhost.localdomain>
 <CAL3q7H7GEDy-NfPgWE7BN_+M8-hRPJ77BKgbrhbkhTcnjAQ7nQ@mail.gmail.com>
 <20161013003725.GA21350@localhost.localdomain>
 <CAL3q7H4XtHdr+PmCO-ExqJrpYrf6Zuh=jCWL_5jZV06kCtx_KA@mail.gmail.com>
 <20161017130025.GI11398@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161017130025.GI11398@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 17, 2016 at 03:00:25PM +0200, David Sterba wrote:
> On Thu, Oct 13, 2016 at 09:47:11AM +0100, Filipe Manana wrote:
> > > Since the crash is similar to the call chains from Jeff's report,
> > > ie.
> > > btrfs_del_csums
> > >   -> btrfs_search_slot
> > >      -> btrfs_cow_block
> > >         -> btrfs_mark_buffer_dirty
> > >
> > > I just wonder that whether 4.8.0-rc8-btrfs-next-35+ has
> > >
> > > "[PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty" ?
> > 
> > It isn't there, this 4.8.0-rc8-btrfs-next-35+ is a checkout of Chris'
> > for-linus-4.9 branch.
> > That patch should have been there, I was convinced that all these
> > related patches were already there, as it's impossible to run xfstests
> > with the integrity checker enabled.
> 
> The referenced patch is the one in this thread, no? You've reported that
> even with that applied you can still reproduce a crash with integrity
> checker enabled. I haven't queued it as it seems it's an incomplete fix,
> thus waiting for another version.

Yes, it's one of three patches in this thread, and they fixed different
problems,

- the original patch and its v2 are to make check_leaf check non-root
leaf with zero-item,
- "[PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty" is to fix
check_leaf, which fixes the crash from Jeff's.
- "[PATCH] Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf"
 is targeting a different crash with check integrity enabled, which
comes from Filipe's report.

So to make sure I understand the whole thing, Filipe, can you reproduce the
crash around btrfs_del_csums() after applying this patch
 "[PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty"?

Thanks,

-liubo
