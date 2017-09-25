Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59753 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932107AbdIYPTI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 11:19:08 -0400
Date: Mon, 25 Sep 2017 17:17:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 0/3] Introduce comprehensive sanity check framework and
Message-ID: <20170925151734.GK31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 23, 2017 at 04:57:55PM +0900, Qu Wenruo wrote:
> The patchset introduce a new framework to do more comprehensive (if not
> the most) sanity check when reading out a leaf.
> 
> The new sanity checker will include:
> 
> 1) Key order
>    Existing code
> 
> 2) Item boundary
>    Existing code with enhanced checker to ensure item pointer doesn't
>    overlap with item itself.
> 
> 3) Key type based sanity checker
>    Only EXTENT_DATA and EXTENT_CSUM checker is implemented yet.
>    As each checker should go through review and tests, or it can easily
>    make a valid btrfs failed to be mounted.
>    So only two checkers are implemented as an example.
> 
>    Existing checker like INODE_REF checker can be moved to this
>    framework easily, and we can centralize all existing checkers, make
>    the rest of codes more clean.
> 
> Performance wise, it's just iterating a leaf.
> And it will only get triggered when reading a leaf, cached leaf will
> not go through such checker.
> So it won't be a performance breaker.

The series looks great, I really like it. Some of the error messages
could be more verbose about what exactly went wrong, eg. what is the
value that's not expected. I'll reply to the patches with examples what
I'd expect.
