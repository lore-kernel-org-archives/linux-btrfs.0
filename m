Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19858 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3AHDao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 22:30:44 -0500
Date: Tue, 8 Jan 2013 11:28:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jun Lion <junlion@tormail.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: chattr +C  vs.  btrfs subvolume snapshot
Message-ID: <20130108032808.GB1916@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1TsN9p-000FDf-SX@internal.tormail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1TsN9p-000FDf-SX@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 12:37:11AM +0000, Jun Lion wrote:
> What happens if you set an individual file inside a subvolume as nocow
> (chattr +C) and then take a snapshot of that subvolume and modify the
> file in both?
> 
> Will btrfs now ignore the nocow attribute completely or will it do "as
> few copies as possible"? (I'd love to know if it's possible to visualize
> the fragmentation of a single file.)

Well, btrfs nearly puts everything with a kind of "timestamp",
generation, which stands for transaction id.

For your case, the NOCOW file is created just before taking the
snapshot, so btrfs thinks of it being shared, and for shared parts, we
must COW it to keep everything right when trying to modify them.

And for the fragmentation, do you mean 'filefrag'?

thanks,
liubo
