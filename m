Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:36171 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab3AKUyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 15:54:32 -0500
Date: Fri, 11 Jan 2013 12:54:32 -0800
From: Zach Brown <zab@zabbo.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130111205432.GK12288@lenny.home.zabbo.net>
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <20130108200734.GD12288@lenny.home.zabbo.net>
 <20130110020517.GA4456@liubo>
 <20130110170634.GF12288@lenny.home.zabbo.net>
 <20130111084504.GA2008@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130111084504.GA2008@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> But after flipping slab code, I find that another callback will disable
> merging slabs when allocating a slab, so I'm not sure if it worth doing so...

Do you mean the find_mergeable() stuff in SLUB?

> What do you think about it?

I don't know, pass in a callback to destruction?

void kmem_cache_destroy_inuse_cb(struct kmem_cache *s,
                                 void (*objcb)(void *));

I'd try to spend as little time on this as possible.  Get the most basic
thing working to demonstrate the idea and send it to lkml to get
feedback.

- z
