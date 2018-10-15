Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2B7C070C3
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 00:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBAEE2087D
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 00:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBAEE2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbeJOIOe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 04:14:34 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16730 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726343AbeJOIOe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 04:14:34 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 15 Oct 2018 11:01:40 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gBqnL-0000c3-SL; Mon, 15 Oct 2018 11:31:39 +1100
Date:   Mon, 15 Oct 2018 11:31:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
Message-ID: <20181015003139.GZ6311@dastard>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923117420.5546.13317703807467393934.stgit@magnolia>
 <CAL3q7H7mLvCGpyitJhQ=To-aDvG9k9rxSVi2jSpcALQVj3myzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7mLvCGpyitJhQ=To-aDvG9k9rxSVi2jSpcALQVj3myzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 09:22:18PM +0100, Filipe Manana wrote:
> On Thu, Oct 11, 2018 at 5:13 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > A deduplication data corruption is exposed by fstests generic/505 on
> > XFS.
> 
> (and btrfs)
> 
> Btw, the generic test I wrote was indeed numbered 505, however it was
> never committed and there's now a generic/505 which has nothing to do
> with deduplication.
> So you should update the changelog to avoid confusion.

What test is it now? And if it hasn't been committed, are you going
to update it and repost as it clearly had value....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
