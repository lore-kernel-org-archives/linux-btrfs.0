Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcGNCrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 22:47:17 -0400
Date: Wed, 13 Jul 2016 19:47:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: FIDEDUPERANGE with src_length == 0
Message-ID: <20160714024716.GA19147@infradead.org>
References: <20160712003537.GA27653@vader.dhcp.thefacebook.com>
 <20160713052643.GD13625@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160713052643.GD13625@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 10:26:43PM -0700, Darrick J. Wong wrote:
> It's a shortcut that we're introducing in the upcoming XFS implementation,
> since it shares the same back end as clone/clonerange, which both have
> this behavior.

We will have to preserve the existing btrfs semantics when reusing the
ioctl number.
