Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54615 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755557AbaGDBOq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:14:46 -0400
Message-ID: <1404436160.22279.1.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: prevent select invalid dev super after dev
 replace
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <quwenruo@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 09:09:20 +0800
In-Reply-To: <20140703181020.GL1553@twin.jikos.cz>
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1404353196-10914-3-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140703181020.GL1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-07-03 at 20:10 +0200, David Sterba wrote:
> On Thu, Jul 03, 2014 at 10:06:35AM +0800, Gui Hecheng wrote:
> > After dev replace, we should not select the superblock of the
> > replaced dev. Otherwise, all the superblokcs will be overwritten
> > by this invalid superblock.
> > 
> > To prevent this case, let btrfs-select-super check the first
> > superblock on the selected dev. If the magic doesn't match,
> > then the dev is a replaced dev and error message will show up.
> 
> Is this patch needed if Qu's superblock checksum patches are applied?
> Thanks.
Hmm...I think it is not neccessary then, please *ignore* this one.
Thanks, David.

