Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36048 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab2HaPDW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 11:03:22 -0400
Date: Fri, 31 Aug 2012 11:03:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Ben Wreder <benwreder@hotmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Tail packing
Message-ID: <20120831150319.GB4299@localhost.localdomain>
References: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2012 at 08:40:36AM -0600, Ben Wreder wrote:
> 
> The disk format description implies that btrfs should be able to support tail packing. I just did some experimentation, and while small files are packed, it seems that files occupying more than one block are not. For example, a lot of 32769-byte files will end up taking over 36KB on average (a small excess due to the metadata itself).
> 
> So just to confirm - btrfs does not currently support tail-packing, is that correct?
> 
> If so, is it a planned feature?
>

It does, just only in that it can fit into a leaf block.  Thanks,

Josef
