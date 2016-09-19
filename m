Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35162 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbcISXMD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 19:12:03 -0400
Date: Mon, 19 Sep 2016 16:11:44 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
Message-ID: <20160919231144.GA28802@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
 <793b8de8-e612-d075-8764-0ef59963cf4a@fb.com>
 <b7b5552a-c6ff-369a-a4cd-a1f9182dea9d@fb.com>
 <20160914181904.GB32358@localhost.localdomain>
 <20160915190108.GA23660@localhost.localdomain>
 <cc03eaca-a75e-b80c-9440-c2f07306bfee@fb.com>
 <20160919180105.GQ16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160919180105.GQ16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 08:01:05PM +0200, David Sterba wrote:
> On Thu, Sep 15, 2016 at 02:58:12PM -0400, Chris Mason wrote:
> > 
> > 
> > On 09/15/2016 03:01 PM, Liu Bo wrote:
> > > On Wed, Sep 14, 2016 at 11:19:04AM -0700, Liu Bo wrote:
> > >> On Wed, Sep 14, 2016 at 01:31:31PM -0400, Josef Bacik wrote:
> > >>> On 09/14/2016 01:29 PM, Chris Mason wrote:
> > >>>>
> > >>>>
> > >>>> On 09/14/2016 01:13 PM, Josef Bacik wrote:
> > >>>>> On 09/14/2016 12:27 PM, Liu Bo wrote:
> > >>>>>> While updating btree, we try to push items between sibling
> > >>>>>> nodes/leaves in order to keep height as low as possible.
> > >>>>>> But we don't memset the original places with zero when
> > >>>>>> pushing items so that we could end up leaving stale content
> > >>>>>> in nodes/leaves.  One may read the above stale content by
> > >>>>>> increasing btree blocks' @nritems.
> > >>>>>>
> > >>>>>
> > >>>>> Ok this sounds really bad.  Is this as bad as I think it sounds?  We
> > >>>>> should probably fix this like right now right?
> > >>>>
> > >>>> He's bumping @nritems with a fuzzer I think?  As in this happens when someone
> > >>>> forces it (or via some other bug) but not in normal operations.
> > >>>>
> > >>>
> > >>> Oh ok if this happens with a fuzzer than this is fine, but I'd rather do
> > >>> -EIO so we know this is something bad with the fs.
> > >>
> > >> -EIO may be more appropriate to be given while reading btree blocks and
> > >> checking their validation?
> > >
> > > Looks like EIO doesn't fit into this case, either, do we have any errno
> > > representing 'corrupted filesystem'?
> > 
> > That's EIO.  Sometimes the EIO is big enough we have to abort, but 
> > really the abort is just adding bonus.
> 
> I think we misuse the EIO where we should really return EFSCORRUPTED
> that's an alias for EUCLEAN, looking at xfs or ext4. EIO should be
> really a message that the hardware is bad.

I love this idea, but one quick question, when returning EUCLEAN, what
message do users get? 

"#define EUCLEAN         117     /* Structure needs cleaning */"

Thanks,

-liubo
