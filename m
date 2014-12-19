Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbaLSOGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 09:06:36 -0500
Date: Fri, 19 Dec 2014 15:05:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Cleanup warnings from clang
Message-ID: <20141219140544.GJ27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5493EF88.8020200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5493EF88.8020200@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 06:27:36PM +0900, Satoru Takeuchi wrote:
> > Qu Wenruo (5):
> >    btrfs-progs: Makefile: Move linker only option to LDFLAGS
> >    btrfs-progs: Fix a clang dead-judgement warning in disk-io.c.
> >    btrfs-progs: Remove a unused function root_gtp_mask().
> >    btrfs-progs: Remove a unused function offset_to_bitmap()
> >    btrfs-progs: Remove deprecated _BSD_SOURCE macro.
> 
> All these patches looks good to me.
> 
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

All added.
