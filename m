Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37273
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279Ab2GBGTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 02:19:55 -0400
Date: Mon, 2 Jul 2012 02:19:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@fusionio.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix dio write vs buffered read race V2
Message-ID: <20120702061953.GA20804@infradead.org>
References: <1340718176-4999-1-git-send-email-jbacik@fusionio.com>
 <4FEBD0EC.6070802@cn.fujitsu.com>
 <20120628123422.GB1729@localhost.localdomain>
 <4FED107B.9020308@cn.fujitsu.com>
 <20120629130510.GY17638@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120629130510.GY17638@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 09:05:10AM -0400, Chris Mason wrote:
> > It is better that update i_size in endio, I think. because during endio, we are sure that
> > the data is flushed into the disk successfully, and can update i_size at ease. and if the
> > error happens when flushing the data into the disk, we also needn't reset i_size.
> 
> I think the i_size update should happen sooner.  The rest of the
> filesystems work that way, and it will have fewer interaction problems
> with the VM.

FYI: XFS only updates i_size in the end_io handler.

