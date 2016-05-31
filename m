Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbcEaMvM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 08:51:12 -0400
Date: Tue, 31 May 2016 05:51:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, Xiao Yang <yangx.jy@cn.fujitsu.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531125109.GA17018@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <20160527180231.GB5050@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160527180231.GB5050@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks fine, but can't we also remove the workaround at the end of the
the test as well?
