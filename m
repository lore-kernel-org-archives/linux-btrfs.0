Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbcCRSTW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 14:19:22 -0400
Date: Fri, 18 Mar 2016 19:18:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfsck memory usage reduce idea
Message-ID: <20160318181854.GF21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56DD14B6.4070908@cn.fujitsu.com>
 <56DE8D1D.5050504@jp.fujitsu.com>
 <56DE9171.8040309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DE9171.8040309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 08, 2016 at 04:46:41PM +0800, Qu Wenruo wrote:
> > 1. Could you tell me what you'd like to do?
> >
> >     a) Provide completely the same function with current
> >        implementation by other, more efficient way.
> 
> Same function, but less efficient.
> It may takes longer time, more IO, but less memory.

IOW, there will be two options for the use to choose from, right? That's
what I'd expect. Be able to check the filesystem on a machine with less
memory at the cost of IO, but also do the faster check on a different
machine.

> And some error message will be output at different time.
> E.g, error message for missing backref may be output at fs tree checking 
> time, instead of extent tree checking time.

This is acceptable.
