Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35275 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbcIUIQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 04:16:35 -0400
Date: Wed, 21 Sep 2016 10:14:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
Message-ID: <20160921081435.GB16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
 <793b8de8-e612-d075-8764-0ef59963cf4a@fb.com>
 <b7b5552a-c6ff-369a-a4cd-a1f9182dea9d@fb.com>
 <20160914181904.GB32358@localhost.localdomain>
 <20160915190108.GA23660@localhost.localdomain>
 <cc03eaca-a75e-b80c-9440-c2f07306bfee@fb.com>
 <20160919180105.GQ16983@twin.jikos.cz>
 <20160919231144.GA28802@localhost.localdomain>
 <20160920080343.GV16983@suse.cz>
 <20160920175959.GB3319@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920175959.GB3319@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:59:59AM -0700, Liu Bo wrote:
> On Tue, Sep 20, 2016 at 10:03:43AM +0200, David Sterba wrote:
> > On Mon, Sep 19, 2016 at 04:11:44PM -0700, Liu Bo wrote:
> > > > > That's EIO.  Sometimes the EIO is big enough we have to abort, but 
> > > > > really the abort is just adding bonus.
> > > > 
> > > > I think we misuse the EIO where we should really return EFSCORRUPTED
> > > > that's an alias for EUCLEAN, looking at xfs or ext4. EIO should be
> > > > really a message that the hardware is bad.
> > > 
> > > I love this idea, but one quick question, when returning EUCLEAN, what
> > > message do users get? 
> > > 
> > > "#define EUCLEAN         117     /* Structure needs cleaning */"
> > 
> > strerror(EUCLEAN) -> "Structure needs cleaning"
> 
> Hmm, if I was the user, I'm not sure how to deal with "Structure needs
> cleaning", so still need to take a glance at dmesg log.

I understand that, it's not descriptive at all. We could remap it to EIO
once it goes outside of btrfs module, so it would be only internal
error.  The commit that introduces it to xfs is 10 years old,
da2f4d679c8070ba5b6a920281e495917b293aa0 and mentions something like
that.

