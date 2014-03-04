Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989AbaCDMb3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 07:31:29 -0500
Date: Tue, 4 Mar 2014 13:31:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add readahead for send_write
Message-ID: <20140304123127.GG7004@suse.cz>
Reply-To: dsterba@suse.cz
References: <1393838683-25216-1-git-send-email-bo.li.liu@oracle.com>
 <20140303142528.GC7004@twin.jikos.cz>
 <20140304024951.GB27809@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140304024951.GB27809@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 04, 2014 at 10:49:52AM +0800, Liu Bo wrote:
> On Mon, Mar 03, 2014 at 03:25:28PM +0100, David Sterba wrote:
> > This should not be a hard failure, it can continue without RA for this
> > buffer. Besides, the RA buffer can be allocated at the beginning of send
> > operation and pointer stored in the send context.
> 
> Good point, I think we can fold this into 'struct send_ctx', do you agree?

Sure, size of send_ctx + readahead state will remain below 512.
