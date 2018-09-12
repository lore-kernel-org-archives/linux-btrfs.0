Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727417AbeILWwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 18:52:01 -0400
Date: Wed, 12 Sep 2018 19:46:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/36] btrfs: only count ref heads run in
 __btrfs_run_delayed_refs
Message-ID: <20180912174622.GO2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-6-josef@toxicpanda.com>
 <20180911230730.GC26631@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911230730.GC26631@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 04:07:30PM -0700, Omar Sandoval wrote:
> On Tue, Sep 11, 2018 at 01:57:36PM -0400, Josef Bacik wrote:
> > We pick the number of ref's to run based on the number of ref heads, and
> > only make the decision to stop once we've processed entire ref heads, so
> > only count the ref heads we've run and bail once we've hit the number of
> > ref heads we wanted to process.
> 
> Despite Nikolay's comment, it seems wrong to me to split this patch up
> from the previous one. After the first one, you have this nonsensical
> middle ground where the counter is number of heads but this counter is
> number of refs.

If the changes now split in two are really just one, then this needs to
be explained in the changelog. Nikolay's comment can be read in two
ways, split the unrelated change, or add the reason why.

https://patchwork.kernel.org/patch/10534671/

As v1 od the patch says "We use this number ..." and the patch changes
two variables, I find it ambiguous. Though the last sentence looks like
it refers to the 'count', it's not very clear and I got lost there too.
