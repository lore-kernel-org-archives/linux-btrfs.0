Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751289AbdILLPX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:15:23 -0400
Date: Tue, 12 Sep 2017 13:13:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: send: fix error code if an unknown inode type is
 found
Message-ID: <20170912111353.GG14538@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170911165854.19460-1-dsterba@suse.com>
 <fa3a2302-b3cd-fafe-b9ec-9fd127706656@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fa3a2302-b3cd-fafe-b9ec-9fd127706656@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 12:02:44PM +0900, Tsutomu Itoh wrote:
> Hi David,
> 
> On 2017/09/12 1:58, David Sterba wrote:
> > There are two types for "not supported", but the correct one is
> > EOPNOTSUPP, let's use that one. The error message in the error case is
> > not very helpful, enhance it at least with the inode number.
> 
> When I first posted a similar patch, you said "I'd rather make it EINVAL".
> https://marc.info/?l=linux-btrfs&m=145342170820262&w=2

So this patch got lost, thanks for pointing it out. I'll replace it and
leave mine just updating the error message.
