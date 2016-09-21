Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754372AbcIUPsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:48:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B174CAB9F
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 15:48:07 +0000 (UTC)
Date: Wed, 21 Sep 2016 17:46:09 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 0/5] btrfs: printing cleanup patchset
Message-ID: <20160921154609.GL16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474380303-25995-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:04:58AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This is a patchset I've been working on to clean up message printing,
> make it adhere to kernel style, and be more consistent.
> 
> The end result is that we:
> * use dynamic debugging for debugging messages
> * merge strings that exceed 80 characters into a single greppable string
> * convert printk calls to btrfs_{warn,info,err,debug,etc} calls where it
>   makes sense.
> * dump the ad-hoc verbose_printk garbage in send
> 
> The exception to this is check-integrity since it has a ton of messages
> and it also has its own mask mechanism.  I wanted to discuss if we wanted
> to find another solution to that and, if so, how we want to move forward
> there.

IIRC integrity checker does a lot of custom string formatting,
indentation etc, but as it's a debugging feature you can leave it as is.

> Dave, this will probably conflict with the fsinfo patchset, so please
> advise on which you want to land first.

I've test-applied the whole patchset on current "for 4.9" queue and
there were no conflicts, so I that as a good starting point. Please use
the branch misc-4.9 for base of the fs_info cleanup patches. Thanks.
