Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab3CSMTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 08:19:20 -0400
Date: Tue, 19 Mar 2013 20:16:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: build up error handling for merge_reloc_roots
Message-ID: <20130319121639.GG27360@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
 <1362414341-17306-3-git-send-email-bo.li.liu@oracle.com>
 <20130318141612.GM7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130318141612.GM7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 18, 2013 at 03:16:12PM +0100, David Sterba wrote:
> On Tue, Mar 05, 2013 at 12:25:37AM +0800, Liu Bo wrote:
> > We first use btrfs_std_error hook to replace with BUG_ON, and we
> > also need to cleanup what is left, including reloc roots rbtree
> > and reloc roots list.
> > Here we use a helper function to cleanup both rbtree and list, and
> > since this function can also be used in the balance recover path,
> > we also make the change as well to keep code simple.
> 
> I've noticed that return value from merge_reloc_roots is never checked
> in the callers. Did you verify that this is ok?

Yeah, it's fine.

Actually we set fs to RO once we get error here, as we have recorded a balance
item and , balance can start over again the next time.

> 
> For example when called from btrfs_recover_relocation, is it possible
> that the reloc-to-be-recovered is still left unprocessed but the
> filesystem is going to be silently mounted read-write?

hmm, I'm not able to picture such a case...

> 
> The mount and remount callpaths check for recover_relocation errors and
> do not proceed otherwise. In RO mount, it's not called.
> 
> So, either merge_reloc_roots callers should catch the errors or there
> are none by design (ie. the whole reloc operation is restartable).
> 

it's desigend to be always ready for a crash or a power off.

thanks,
liubo
