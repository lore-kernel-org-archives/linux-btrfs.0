Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaANP16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 10:27:58 -0500
Date: Tue, 14 Jan 2014 16:27:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: "hugo@carfax.org.uk" <hugo@carfax.org.uk>,
        "wangsl.fnst@cn.fujitsu.com" <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs-progs: make send/receive compatible with older
 kernels
Message-ID: <20140114152756.GX6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389264758-9495-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <52CE8CDC.6030408@giantdisaster.de>
 <20140109121606.GI15634@carfax.org.uk>
 <1389279172.23310.50.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389279172.23310.50.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 09, 2014 at 02:52:27PM +0000, Chris Mason wrote:
> >    You may need to upgrade the kernel to get new features offered by a
> > new userspace, but I think we should absolutely not be changing
> > userspace in a way that makes it incompatible with older kernels.
> 
> I'd really prefer that we maintain compatibility with the older kernels.
> Heavy btrfs usage is going to want a newer kernel anyway, but this is an
> important policy to keep in place for the future.

I agree.

> Especially since Wang went to the trouble of making the patch, I'd
> rather take it.

What do you think about adding #ifdef's around the code? That way we'll
know that's for backwards compatibility only and up to what kernel
version. It will be easier to remove it in the far future.


david
