Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451AbcBQKKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 05:10:13 -0500
Date: Wed, 17 Feb 2016 02:10:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [PATCH 1/3] generic/304: fix high offset
Message-ID: <20160217101012.GA15314@infradead.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
 <20160215204614.7977.2848.stgit@birch.djwong.org>
 <20160217095646.GA21482@infradead.org>
 <CAL3q7H5NRUXvo=mEtGr4-S4yPT7k_yw6LsMAq_V8bPD1T=7r0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5NRUXvo=mEtGr4-S4yPT7k_yw6LsMAq_V8bPD1T=7r0g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 17, 2016 at 10:04:23AM +0000, Filipe Manana wrote:
> > What does btrfs return here?
> 
> -EINVAL, so this makes the test pass on btrfs.

Ok, looks fine to me then:

Reviewed-by: Christoph Hellwig <hch@lst.de>
