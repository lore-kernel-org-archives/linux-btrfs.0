Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613E5C67837
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 00:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E33820835
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 00:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E33820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeJLHqC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 03:46:02 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46444 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbeJLHqC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 03:46:02 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 12 Oct 2018 10:46:21 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gAl7o-0004uG-1Y; Fri, 12 Oct 2018 11:16:16 +1100
Date:   Fri, 12 Oct 2018 11:16:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
Message-ID: <20181012001615.GR6311@dastard>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923117420.5546.13317703807467393934.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923117420.5546.13317703807467393934.stgit@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:12:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A deduplication data corruption is exposed by fstests generic/505 on
> XFS. It is caused by extending the block match range to include the
> partial EOF block, but then allowing unknown data beyond EOF to be
> considered a "match" to data in the destination file because the
> comparison is only made to the end of the source file. This corrupts the
> destination file when the source extent is shared with it.
> 
> The VFS remapping prep functions only support whole block dedupe, but
> we still need to appear to support whole file dedupe correctly.  Hence
> if the dedupe request includes the last block of the souce file, don't
> include it in the actual dedupe operation. If the rest of the range
> dedupes successfully, then reject the entire request.  A subsequent
> patch will enable us to shorten dedupe requests correctly.

Ok, so this patch rejects whole file dedupe requests, and then a
later patch adds support back in for it?

Doesn't that leave a bisect landmine behind? Why separate the
functionality like this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
