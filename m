Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52675 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752181AbdASMJL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:09:11 -0500
Date: Thu, 19 Jan 2017 13:08:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: Fix disable backtrace assert error
Message-ID: <20170119120846.GY12081@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170118030425.28065-1-quwenruo@cn.fujitsu.com>
 <765a9beb-3d39-8b86-eff1-84eb85f2d0a2@suse.de>
 <30e9ce6b-3393-be93-d209-3d23ed74a0ce@cn.fujitsu.com>
 <4a97de85-9dcc-d5ca-3b98-671699d13511@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a97de85-9dcc-d5ca-3b98-671699d13511@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2017 at 09:42:45PM -0600, Goldwyn Rodrigues wrote:
> >>> +#define BUG_ON(c) ASSERT(!(c))
> >>
> >> The problem with this is that you are killing the value printed as a
> >> part of the trace for BUG_ON(). The main reason why commit
> >> 00e769d04c2c83029d6c71 was written. Please be careful with your notting
> >> especially when the values are being printed.
> >>
> > 
> > This is designed.
> > 
> > As ASSERT() is more meaningful than the abused BUG_ON(), I changed it to
> > print correct value for ASSERT() and ignore BUG_ON().
> 
> If ASSERT is meaningful, correct it. But please don't make BUG_ON worse
> and leave it as it is, at least until the time you can remove the
> BUG_ONs or convert it. It should print the correct value of why it did
> bug, or else it will print just 1, which is of no debug value.

Agreed, we want to see the exact value.
