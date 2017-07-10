Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753907AbdGJMeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 08:34:25 -0400
Date: Mon, 10 Jul 2017 14:33:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Commit edf064e7c (btrfs: nowait aio support) breaks shells
Message-ID: <20170710123309.GK2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170704042306.GA274@x4>
 <20170704074505.GA277@x4>
 <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
 <c57bf8a7-fb0d-1a53-814d-bb4fba4b246b@kernel.dk>
 <c7a5dfba-b69a-3915-9533-93b683230738@suse.de>
 <1c8b96b6-eab0-b24e-75e1-bd3de16a0a20@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1c8b96b6-eab0-b24e-75e1-bd3de16a0a20@kernel.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 07, 2017 at 08:09:28PM -0600, Jens Axboe wrote:
> On 07/07/2017 07:51 PM, Goldwyn Rodrigues wrote:
> > On 07/04/2017 05:16 PM, Jens Axboe wrote:
> >>
> >> Please expedite getting this upstream, asap.
> > 
> > I have posted an updated patch [1] and it is acked by David. Would you
> > pick it up or should it go through the btrfs tree (or some other tree)?
> > 
> > [1] https://patchwork.kernel.org/patch/9825813/
> 
> I'm fine with either, I just want it to go in asap. I'm sending off
> a pull Monday. David, up to you.

I'm reading this just now, so I'll send the patch in my pull today.
