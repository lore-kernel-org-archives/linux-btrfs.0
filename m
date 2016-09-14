Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48395 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbcINST4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 14:19:56 -0400
Date: Wed, 14 Sep 2016 11:19:04 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
Message-ID: <20160914181904.GB32358@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
 <793b8de8-e612-d075-8764-0ef59963cf4a@fb.com>
 <b7b5552a-c6ff-369a-a4cd-a1f9182dea9d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b7b5552a-c6ff-369a-a4cd-a1f9182dea9d@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 01:31:31PM -0400, Josef Bacik wrote:
> On 09/14/2016 01:29 PM, Chris Mason wrote:
> > 
> > 
> > On 09/14/2016 01:13 PM, Josef Bacik wrote:
> > > On 09/14/2016 12:27 PM, Liu Bo wrote:
> > > > While updating btree, we try to push items between sibling
> > > > nodes/leaves in order to keep height as low as possible.
> > > > But we don't memset the original places with zero when
> > > > pushing items so that we could end up leaving stale content
> > > > in nodes/leaves.  One may read the above stale content by
> > > > increasing btree blocks' @nritems.
> > > > 
> > > 
> > > Ok this sounds really bad.  Is this as bad as I think it sounds?  We
> > > should probably fix this like right now right?
> > 
> > He's bumping @nritems with a fuzzer I think?  As in this happens when someone
> > forces it (or via some other bug) but not in normal operations.
> > 
> 
> Oh ok if this happens with a fuzzer than this is fine, but I'd rather do
> -EIO so we know this is something bad with the fs. 

-EIO may be more appropriate to be given while reading btree blocks and
checking their validation?

> And change the changelog
> to make it explicit that this is the result of fs corruption, not normal
> operation.  Then you can add
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>

OK, make sense.

Thanks,

-liubo
