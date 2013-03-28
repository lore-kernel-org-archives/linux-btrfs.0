Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab3C1OPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 10:15:48 -0400
Date: Thu, 28 Mar 2013 15:15:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: build up error handling for merge_reloc_roots
Message-ID: <20130328141546.GC29125@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
 <1362414341-17306-3-git-send-email-bo.li.liu@oracle.com>
 <20130318141612.GM7229@twin.jikos.cz>
 <20130319121639.GG27360@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130319121639.GG27360@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 19, 2013 at 08:16:41PM +0800, Liu Bo wrote:
> On Mon, Mar 18, 2013 at 03:16:12PM +0100, David Sterba wrote:
> > I've noticed that return value from merge_reloc_roots is never checked
> > in the callers. Did you verify that this is ok?
> 
> Yeah, it's fine.

Then it's ok to change return value to 'void' so it does not look like
an unhandled errorcode.

> Actually we set fs to RO once we get error here, as we have recorded a balance
> item and , balance can start over again the next time.

Yeah, if we get there via transaction abort. My background motivation is
to implement a (much) more responsive balance cancel. This is different
from the poweroff "cancel", because it does not keep any in-memory
state.

david
