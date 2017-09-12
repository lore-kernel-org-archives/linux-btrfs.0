Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751575AbdILSJY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 14:09:24 -0400
Date: Tue, 12 Sep 2017 20:07:53 +0200
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
Message-ID: <20170912180753.GI29043@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
 <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
 <20170912170304.GD29043@twin.jikos.cz>
 <0a949fd9-f0cf-22c5-4e91-ebb1bfad1355@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0a949fd9-f0cf-22c5-4e91-ebb1bfad1355@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 07:50:19PM +0200, Goffredo Baroncelli wrote:
> On 09/12/2017 07:03 PM, David Sterba wrote:
> > Say I want to prepare a minimal image but will provide a large file 
>                                                 ^^^^^^^^^^^^^^^^^^^^^^
> 
> I think that if the target is a file AND --minimize is passed, it is a
> reasonable expectation that the file is created "on the fly" and grown
> up to what needed.  
> 
> What I mean is that "--minimize" is passed (and a file is passed), mkfs.btrfs should 
> a) create the file if it doesn't exist, and avoid any check about its length
> b) truncate the file at the end

I think the farthest-offset write will extend the file size, so we
should not truncate it, in the sense 'make it smaller than it is', but
rather 'align it to the size where the filesystem expects live data".

Eg. if we write a blockgroup header to the beginning of 256MB, but fill
only a few kilobytes, effectively writing to some range, say, [0..32MB].
Then reads past the 32MB (eg. through loop device) would fail.

As long as the file is zero, minimizing will be implicit. My example
with the provided large file was wrong in retrospect. I'll think about
that more.
