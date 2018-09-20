Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37156 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbeITX0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:26:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id 2-v6so4772523pgo.4
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 10:41:26 -0700 (PDT)
Date: Thu, 20 Sep 2018 10:41:24 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 0/6] Btrfs: implement swap file support
Message-ID: <20180920174124.GB26479@vader>
References: <cover.1537419652.git.osandov@fb.com>
 <20180920172255.GE5847@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180920172255.GE5847@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 07:22:55PM +0200, David Sterba wrote:
> On Wed, Sep 19, 2018 at 10:02:11PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > Changes from v7 [1]:
> > 
> > - Expanded a few commit messages
> > - Added Johannes' acked-by on patches 1 and 2
> > - Rebased on v4.19-rc4
> 
> I've sent my comments, it's mostly about the usability or small
> enhancements. As you've got acks from MM people, I hope it would be ok
> if I add this series to for-next so we can give it some testing.

That'd be great. Feel free to grab it from my git tree
(https://github.com/osandov/linux/tree/btrfs-swap) if you want the
version with your comments addressed.

> The MM patches would better go separately to 4.20 via the mm tree.  I
> did only build tests so 4.20 target is still feasible but given that
> it's rc4 it's a bit too close. There are some limitations posed by the
> swapfiles so I'd like to have a chance to do some actual tests myself
> and check the usability status.

4.20 would be nice, but I could live with 4.21. I'll just be backporting
it to our internal kernel here anyways ;) Let me know how the tests go
and which way you want to go.

Thanks! It's nice to finally have the end in sight for this series, it's
almost 4 years old, although it's changed quite a bit since
https://lkml.org/lkml/2014/11/17/141.
