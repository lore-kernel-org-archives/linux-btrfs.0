Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35285 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdGHCJc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 22:09:32 -0400
Received: by mail-pf0-f169.google.com with SMTP id c73so24770997pfk.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 19:09:32 -0700 (PDT)
Subject: Re: Commit edf064e7c (btrfs: nowait aio support) breaks shells
To: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <20170704042306.GA274@x4> <20170704074505.GA277@x4>
 <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
 <c57bf8a7-fb0d-1a53-814d-bb4fba4b246b@kernel.dk>
 <c7a5dfba-b69a-3915-9533-93b683230738@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1c8b96b6-eab0-b24e-75e1-bd3de16a0a20@kernel.dk>
Date: Fri, 7 Jul 2017 20:09:28 -0600
MIME-Version: 1.0
In-Reply-To: <c7a5dfba-b69a-3915-9533-93b683230738@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/07/2017 07:51 PM, Goldwyn Rodrigues wrote:
> 
> 
> On 07/04/2017 05:16 PM, Jens Axboe wrote:
>>
>> Please expedite getting this upstream, asap.
>>
> 
> Jens,
> 
> I have posted an updated patch [1] and it is acked by David. Would you
> pick it up or should it go through the btrfs tree (or some other tree)?
> 
> [1] https://patchwork.kernel.org/patch/9825813/

I'm fine with either, I just want it to go in asap. I'm sending off
a pull Monday. David, up to you.

-- 
Jens Axboe

