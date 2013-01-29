Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39176 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab3A2PdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 10:33:08 -0500
Date: Tue, 29 Jan 2013 10:33:06 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About Chunk Tree recover
Message-ID: <20130129153306.GE23893@shiny.globalsuite.net>
References: <5107AEEB.2030106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5107AEEB.2030106@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 29, 2013 at 04:13:47AM -0700, Miao Xie wrote:
> Hi, everyone.
> 
> About 1 years ago, we implemented the chunk tree recover function,
> but it has not been applied till now because that implementation
> need change the disk format.
> (http://marc.info/?l=linux-btrfs&m=129914269932543&w=2
>  http://marc.info/?l=linux-btrfs&m=130976668006281&w=2
>  http://marc.info/?l=linux-btrfs&m=129914269932543&w=2)
> 
> Recently, I reconsidered the implementation of this function, and
> found a new approach that needn't change the disk format. That is
> the external chunk tree backup, just like external journal device
> of ext4. The basic idea is:

I do like the idea of a dedicated chunk backup area, outside the
filesystem.  But, I think we need to be able to fall back to the
scanning operation.

The chunk tree backup actually fits well into the log area I'm setting
up for raid5/6.  The log area is really just a dedicated chunk where I'm
stuffing blocks to avoid read/modify/write and to make sub stripe writes
power cut safe.

-chris
