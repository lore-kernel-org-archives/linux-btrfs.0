Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:49598 "EHLO
        mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdGDPhy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jul 2017 11:37:54 -0400
Date: Tue, 4 Jul 2017 17:37:51 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Commit edf064e7c (btrfs: nowait aio support) breaks shells
Message-ID: <20170704153751.GA273@x4>
References: <20170704042306.GA274@x4>
 <20170704074505.GA277@x4>
 <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017.07.04 at 10:31 -0500, Goldwyn Rodrigues wrote:
> 
> 
> On 07/04/2017 02:45 AM, Markus Trippelsdorf wrote:
> > On 2017.07.04 at 06:23 +0200, Markus Trippelsdorf wrote:
> >> commit edf064e7c6fec3646b06c944a8e35d1a3de5c2c3 (HEAD, refs/bisect/bad)
> >> Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >> Date:   Tue Jun 20 07:05:49 2017 -0500
> >>
> >>     btrfs: nowait aio support
> >>
> >> apparently breaks several shell related features on my system.
> > 
> > Here is a simple testcase:
> > 
> >  % echo "foo" >> test
> >  % echo "foo" >> test
> >  % cat test
> >  foo
> >  %
> > 
> 
> Thanks for testing.
> Yes, pos must be set with iocb->ki_pos for appends. I should not have
> removed the initialization. Could you try this patch?

It fixes the issue. Thank you.

-- 
Markus
