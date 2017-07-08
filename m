Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36919 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751785AbdGHBvU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Jul 2017 21:51:20 -0400
Subject: Re: Commit edf064e7c (btrfs: nowait aio support) breaks shells
To: Jens Axboe <axboe@kernel.dk>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <20170704042306.GA274@x4> <20170704074505.GA277@x4>
 <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
 <c57bf8a7-fb0d-1a53-814d-bb4fba4b246b@kernel.dk>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <c7a5dfba-b69a-3915-9533-93b683230738@suse.de>
Date: Fri, 7 Jul 2017 20:51:30 -0500
MIME-Version: 1.0
In-Reply-To: <c57bf8a7-fb0d-1a53-814d-bb4fba4b246b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/04/2017 05:16 PM, Jens Axboe wrote:
> 
> Please expedite getting this upstream, asap.
> 

Jens,

I have posted an updated patch [1] and it is acked by David. Would you
pick it up or should it go through the btrfs tree (or some other tree)?

[1] https://patchwork.kernel.org/patch/9825813/

-- 
Goldwyn
