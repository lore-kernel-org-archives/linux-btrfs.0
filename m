Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51963 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755596AbcITSAM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 14:00:12 -0400
Date: Tue, 20 Sep 2016 10:59:59 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
Message-ID: <20160920175959.GB3319@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
 <793b8de8-e612-d075-8764-0ef59963cf4a@fb.com>
 <b7b5552a-c6ff-369a-a4cd-a1f9182dea9d@fb.com>
 <20160914181904.GB32358@localhost.localdomain>
 <20160915190108.GA23660@localhost.localdomain>
 <cc03eaca-a75e-b80c-9440-c2f07306bfee@fb.com>
 <20160919180105.GQ16983@twin.jikos.cz>
 <20160919231144.GA28802@localhost.localdomain>
 <20160920080343.GV16983@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920080343.GV16983@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:03:43AM +0200, David Sterba wrote:
> On Mon, Sep 19, 2016 at 04:11:44PM -0700, Liu Bo wrote:
> > > > That's EIO.  Sometimes the EIO is big enough we have to abort, but 
> > > > really the abort is just adding bonus.
> > > 
> > > I think we misuse the EIO where we should really return EFSCORRUPTED
> > > that's an alias for EUCLEAN, looking at xfs or ext4. EIO should be
> > > really a message that the hardware is bad.
> > 
> > I love this idea, but one quick question, when returning EUCLEAN, what
> > message do users get? 
> > 
> > "#define EUCLEAN         117     /* Structure needs cleaning */"
> 
> strerror(EUCLEAN) -> "Structure needs cleaning"

Hmm, if I was the user, I'm not sure how to deal with "Structure needs cleaning", so still need to take a glance at dmesg log.

Thanks,

-liubo
