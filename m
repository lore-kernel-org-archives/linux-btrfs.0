Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:59685 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650Ab3H0RDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 13:03:39 -0400
Message-ID: <521CDC22.1020507@sgi.com>
Date: Tue, 27 Aug 2013 12:04:34 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, Ben Myers <bpm@sgi.com>, <xfs@oss.sgi.com>
Subject: Re: [PATCH v2] xfstests/btrfs/308: add snapshot-aware defrag for
 partial extents testcases
References: <1374740102-9687-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1374740102-9687-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Liu Bo, it has been committed as test number 10.

commit d943515bbcb8893c5d4ae21340a6022235d9e643
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Thu Jul 25 08:15:02 2013 +0000

     xfstests/btrfs/010: add snapshot-aware defrag for partial extents 
testcases

     This is to test whether snapshot-aware defrag can work well on 
partial extents.

     Reviewed-by: Ben Myers <bpm@sgi.com>
     Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

