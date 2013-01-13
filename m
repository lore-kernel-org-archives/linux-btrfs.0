Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23752 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3AMMUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jan 2013 07:20:46 -0500
Date: Sun, 13 Jan 2013 20:18:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130113121817.GA2784@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <20130108200734.GD12288@lenny.home.zabbo.net>
 <20130110020517.GA4456@liubo>
 <20130110170634.GF12288@lenny.home.zabbo.net>
 <20130111084504.GA2008@liubo>
 <20130111205432.GK12288@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130111205432.GK12288@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 12:54:32PM -0800, Zach Brown wrote:
> > But after flipping slab code, I find that another callback will disable
> > merging slabs when allocating a slab, so I'm not sure if it worth doing so...
> 
> Do you mean the find_mergeable() stuff in SLUB?

Yes, that's what I'm worried about.

> 
> > What do you think about it?
> 
> I don't know, pass in a callback to destruction?
> 
> void kmem_cache_destroy_inuse_cb(struct kmem_cache *s,
>                                  void (*objcb)(void *));
> 
> I'd try to spend as little time on this as possible.  Get the most basic
> thing working to demonstrate the idea and send it to lkml to get
> feedback.
> 
> - z

Okay, I'll send a RFC, and thanks for the suggestion :)

thanks,
liubo
