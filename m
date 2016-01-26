Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbcAZNBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 08:01:11 -0500
Date: Tue, 26 Jan 2016 14:01:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix error number in send.c
Message-ID: <20160126130100.GF8567@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201601220013.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160122140043.GS4227@twin.jikos.cz>
 <56A58737.906@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56A58737.906@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 11:23:51AM +0900, Tsutomu Itoh wrote:
> Hi, David,
> 
> On 2016/01/22 23:00, David Sterba wrote:
> > On Fri, Jan 22, 2016 at 09:13:25AM +0900, Tsutomu Itoh wrote:
> >> ENOTSUPP should not be returned to the user program.
> >>   (cf. include/linux/errno.h)
> >> Therefore, EOPNOTSUPP is used instead of ENOTSUPP.
> >
> > I'm not sure that EOPNOTSUPP is the right error code here. I'd rather
> > make it EINVAL, the bug we're talking about is a new type of inode
> > outside of the S_IFMT bits. "not supported" would mean we don't support
> > it but we could in theory.
> 
> Thanks for review.
> 
> In the meaning that btrfs-send is not supporting a new type of inode now,
> EOPNOTSUPP is acceptable, I think.

It is, there's a warning message printed anyway, the actual error code
does not matter much.

Reviewed-by: David Sterba <dsterba@suse.com>
