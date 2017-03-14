Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbdCNOFg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 10:05:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 13A58AC3B
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 14:05:35 +0000 (UTC)
Date: Tue, 14 Mar 2017 15:04:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Change qgroup_meta_rsv to 64bit
Message-ID: <20170314140458.GC14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314102509.10648-1-rgoldwyn@suse.de>
 <20170314123042.GX14605@twin.jikos.cz>
 <4a12caba-15d3-ec94-86e0-3b196c56aaba@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a12caba-15d3-ec94-86e0-3b196c56aaba@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 08:31:26AM -0500, Goldwyn Rodrigues wrote:
> 
> 
> On 03/14/2017 07:30 AM, David Sterba wrote:
> > On Tue, Mar 14, 2017 at 05:25:09AM -0500, Goldwyn Rodrigues wrote:
> >> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >>
> >> Using an int value is causing qg->reserved to become negative and
> >> exclusive -EDQUOT to be reached prematurely.
> > 
> > V1 had a reproducer, I think it's fine to keep it here so I'll copy it.
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > 
> 
> I am adding a testcase in (x)fstests which covers both qgroup issues for
> which I have sent the patches. I am fine either ways.

The fstests testcase is orthogonal to the changelog describing the steps
to reproduce the bug (it could just roughly describe the idea), as it
helps to understand what's the patch going to fix.
