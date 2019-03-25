Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A01CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D468220700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WQPqTRAB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfCYSpI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49682 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730009AbfCYSpH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2PIdDYa097123;
        Mon, 25 Mar 2019 18:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=iL90uXIT8e1uX6dAVjb7DQ+dJkZt+Cn65s1yt57wdAA=;
 b=WQPqTRABl2wHIkFHroSbTlEaCsJntwPdQ6hXDMpQkvUSGlZo2amxJa1NYKdmj0Q1BHPF
 EERnjTi7bvfMnmx4/JOhzewWeIQLIqbODwZ0PuxVVHCQMvHKrxLdNF/yYR5/PumngU4Z
 wG7ibgRY060ci1ZRZucM7m9npNr+/5/oc2J0XPxNqk7HQJn3S37G6CCoJW+/hLZHe4Gc
 Yoh0RFlcH0sBQ+gYz6SZUo5DRrPE+yUCdCSbTVq1VHbMRgrucOpnV1rUuGkr9ZZjup6H
 x7OTfxkXuTWSAm7CHMc+kqXu8qA4Bigdwj38Z4mlB8JHjyNaVesEHmMVuwdeBBXWcZeJ ww== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2re6g0nwvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 18:45:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2PIivHm025387
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 18:44:58 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2PIiv3f001910;
        Mon, 25 Mar 2019 18:44:57 GMT
Received: from localhost (/10.159.240.244)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 11:44:57 -0700
Date:   Mon, 25 Mar 2019 11:44:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/12] FITRIM improvements
Message-ID: <20190325184456.GA1172@magnolia>
References: <20190325123132.27835-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325123132.27835-1-nborisov@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9206 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903250134
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 02:31:20PM +0200, Nikolay Borisov wrote:
> Here is v3 of the fitrim patches. Change since v2 [0]: 
> 
>  * Replaced BUG_ON with WARN_ON in patch 2
> 
>  * Added RB to patches 04/05/06/09
> 
>  * Squashed "btrfs: Transpose btrfs_close_devices/btrfs_mapping_tree_free in close_ctree"
>  into patch 07. It was only sent to the mailing list as a followup.
> 
>  * Rebased all patches on latest misc-next.
> 
>  This has undergone multiple xfstest runs and I think is ready to be merged.
> 
> [0] https://lore.kernel.org/linux-btrfs/20190211083510.27591-1-nborisov@suse.com/
> 
> 
> Jeff Mahoney (1):
>   btrfs: replace pending/pinned chunks lists with io tree
> 
> Nikolay Borisov (11):
>   btrfs: Honour FITRIM range constraints during free space trim

This is vaguely off-topic, but I noticed that you can FITRIM a btrfs
filesystem mounted nologreplay.  Assuming the fitrim code uses the free
space information to drive the discard calls, is it safe to do that with
unreplayed metadata?

(And no, I don't really know what nologreplay does, so please excuse my
ignorance...)

--D

>   btrfs: combine device update operations during transaction commit
>   btrfs: Handle pending/pinned chunks before blockgroup relocation
>     during device shrink
>   btrfs: Rename and export clear_btree_io_tree
>   btrfs: Populate ->orig_block_len during read_one_chunk
>   btrfs: Introduce new bits for device allocation tree
>   btrfs: Remove 'trans' argument from find_free_dev_extent(_start)
>   btrfs: Factor out in_range macro
>   btrfs: Optimize unallocated chunks discard
>   btrfs: Implement find_first_clear_extent_bit
>   btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit
> 
>  fs/btrfs/ctree.h            |   8 +-
>  fs/btrfs/dev-replace.c      |   2 +-
>  fs/btrfs/disk-io.c          |  20 ++-
>  fs/btrfs/extent-tree.c      | 102 +++++--------
>  fs/btrfs/extent_io.c        | 103 +++++++++++++-
>  fs/btrfs/extent_io.h        |  19 ++-
>  fs/btrfs/extent_map.c       |  38 +++++
>  fs/btrfs/extent_map.h       |   1 -
>  fs/btrfs/free-space-cache.c |   4 -
>  fs/btrfs/transaction.c      |  51 +------
>  fs/btrfs/transaction.h      |   2 +-
>  fs/btrfs/volumes.c          | 277 ++++++++++++++----------------------
>  fs/btrfs/volumes.h          |  23 ++-
>  13 files changed, 332 insertions(+), 318 deletions(-)
> 
> -- 
> 2.17.1
> 
