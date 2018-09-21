Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727392AbeIUUcq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 16:32:46 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 104BEAED4
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 14:43:34 +0000 (UTC)
Date: Fri, 21 Sep 2018 16:43:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Refactor delayed refs processing loop
Message-ID: <20180921144333.GJ5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534318796-23111-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2018 at 10:39:53AM +0300, Nikolay Borisov wrote:
> Here is a small series which aims to rectify the eye sore that delayed refs 
> processing loop currently is. In fact, it's actually 2 loops in the guise of a 
> single 'while' construct. All in all this should bring no functional changes 
> and I've verified this with multiple xfstest runs with no problems. 
> 
> Patch 1 factors out the code which deals with selecting a ref head which has 
> delayed refs pending and locking it. 
> 
> Patch 2 introduces a new function which comprises the internal loop aka 
> processing delayed refs of a delayed head, which is more or less most of the 
> code in __btrfs_run_delayed_refs copied. The only difference is that the 
> function can return EAGAIN if we detect a delayed ref which has sequence number
> higher than what is currently in the tree mod list. 
> 
> Patch 3 Finaly makes the loop in __btrfs_run_delayed_refs use the function 
> introduced in the previous patch, meaning deleting most of the code and 
> changing the loop to a 'do {} while' construct. I strived to retain all the 
> semantics of the old code so there should be no surprises. 
> 
> Nikolay Borisov (3):
>   btrfs: Factor out ref head locking code in __btrfs_run_delayed_refs
>   btrfs: Factor out loop processing all refs of a head
>   btrfs: refactor __btrfs_run_delayed_refs loop

Added to misc-next. It's been in next for some time and I haven't
noticed problems related to that patchset.
