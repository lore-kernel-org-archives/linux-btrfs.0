Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758449AbcCVOt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 10:49:57 -0400
Date: Tue, 22 Mar 2016 15:49:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfsck memory usage reduce idea
Message-ID: <20160322144927.GB29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56DD14B6.4070908@cn.fujitsu.com>
 <56DE8D1D.5050504@jp.fujitsu.com>
 <56DE9171.8040309@cn.fujitsu.com>
 <20160318181854.GF21722@twin.jikos.cz>
 <56EF595B.7080509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56EF595B.7080509@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 10:15:55AM +0800, Qu Wenruo wrote:
> > IOW, there will be two options for the use to choose from, right? That's
> > what I'd expect. Be able to check the filesystem on a machine with less
> > memory at the cost of IO, but also do the faster check on a different
> > machine.
> 
> I was planning to use the new extent tree check to replace current one, 
> as a rework.
> Am I always reworking things? :)

The problem with big reworks is that there are few people willing to
review them. So I'm not against doing such changes, especially in this
case it would be welcome, but I'm afraid that it could end up stalled
similar to the convert rewrite.

> The point that I didn't want to keep the current behavior is, the old 
> one is just OK or OOM, no one would know if it will OOM until it happens.
> 
> But the new one would be much flex than current behavior.
> As it fully uses the IO cache provided by kernel.

That's a good point, for the single implementation.
