Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41093 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbcEaQmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 12:42:44 -0400
Date: Tue, 31 May 2016 09:41:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531164138.GB5053@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <20160527180231.GB5050@birch.djwong.org>
 <20160531125109.GA17018@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160531125109.GA17018@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2016 at 05:51:09AM -0700, Christoph Hellwig wrote:
> Looks fine, but can't we also remove the workaround at the end of the
> the test as well?

Oh, heh, yes, those can go.  The whitespace is wrong on them anyway.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
