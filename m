Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390357AbeIUVG7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 17:06:59 -0400
Date: Fri, 21 Sep 2018 17:17:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 0/6] Btrfs: implement swap file support
Message-ID: <20180921151735.GK5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1537419652.git.osandov@fb.com>
 <20180920172255.GE5847@twin.jikos.cz>
 <20180920174124.GB26479@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180920174124.GB26479@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 10:41:24AM -0700, Omar Sandoval wrote:
> On Thu, Sep 20, 2018 at 07:22:55PM +0200, David Sterba wrote:
> > On Wed, Sep 19, 2018 at 10:02:11PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > Changes from v7 [1]:
> > > 
> > > - Expanded a few commit messages
> > > - Added Johannes' acked-by on patches 1 and 2
> > > - Rebased on v4.19-rc4
> > 
> > I've sent my comments, it's mostly about the usability or small
> > enhancements. As you've got acks from MM people, I hope it would be ok
> > if I add this series to for-next so we can give it some testing.
> 
> That'd be great. Feel free to grab it from my git tree
> (https://github.com/osandov/linux/tree/btrfs-swap) if you want the
> version with your comments addressed.

Updates looks good, branch added to the for-next snapshot and will be in
upcoming for-next.

> > The MM patches would better go separately to 4.20 via the mm tree.  I
> > did only build tests so 4.20 target is still feasible but given that
> > it's rc4 it's a bit too close. There are some limitations posed by the
> > swapfiles so I'd like to have a chance to do some actual tests myself
> > and check the usability status.
> 
> 4.20 would be nice, but I could live with 4.21. I'll just be backporting
> it to our internal kernel here anyways ;) Let me know how the tests go
> and which way you want to go.

Backporting to your kernel is fine, your users will complain to you, but
once it's in the mainline the complaints will go my way :)

As for the merge of the non-btrfs patches, I checked again and there are
the VFS/documentation patches that haven't been CCed to the relvant
people.  For that reason I'm not much comfortable to take them through
my tree for the final merge. The MM part looks fine from that
perspective.
