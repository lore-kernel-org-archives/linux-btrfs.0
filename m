Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23960 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbcEZQHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 12:07:41 -0400
Date: Thu, 26 May 2016 09:07:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 2/7] tests: don't put loop control files on the scratch
 mount
Message-ID: <20160526160701.GA16512@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <146424223512.6278.15231849939938178494.stgit@birch.djwong.org>
 <20160526080948.GC20307@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160526080948.GC20307@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 01:09:48AM -0700, Christoph Hellwig wrote:
> Shouldn't these tests also add a _require_test now?  But we probably
> should just move them to /tmp instead?

Yes.  I'll move 'em to /tmp.

--D
