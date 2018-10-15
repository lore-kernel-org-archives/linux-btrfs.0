Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37392C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 17:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7B92089D
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 17:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="agkpbPxn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC7B92089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbeJPA7q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 20:59:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbeJPA7q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 20:59:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9FHAGfL143797;
        Mon, 15 Oct 2018 17:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=egCqRyAQtIcemirwEGsjbwe9Wok3dKewAN2I9yUsZ/s=;
 b=agkpbPxneYb3TrksI9odrcxCvtvn3m+uY2roXsig3qgE6bWHzIFu9hVgAI799yf6wpBv
 WvjJocFkh4HMT/Ok+fcSsG1Wh5m+BQaebSUc0kTsG2kcEHwUnDTzsp+WaF8O+n5503gq
 OUqnCMauT8QvecUqXiL9U2UXll0T+j6MD1uAj87UGMBlOZW5FORH0I+9NRTnZ73oJHeY
 pl5EjqRb1aHLtm5OSMNCCXCkA3DpB19Mf99LQeoIIJZITgLMW6snbIMcF+J46Th1y/no
 ECWzg/slP0R7sMGRxdSVAKQHizi/6Yd8Zf62PW28fcSQF+adGgi30Lwg2TE1Gf/53dN7 aQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n39br3nrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 17:13:20 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9FHDJDE020941
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 17:13:19 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9FHDIi3028534;
        Mon, 15 Oct 2018 17:13:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 10:13:18 -0700
Date:   Mon, 15 Oct 2018 10:13:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181015171317.GM28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
 <20181014171927.GD30673@infradead.org>
 <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com>
 <20181015124719.GA15379@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015124719.GA15379@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=541
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810150150
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 05:47:19AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 15, 2018 at 09:04:13AM +0300, Amir Goldstein wrote:
> > I supposed you figured out the reason already.
> 
> No, I hadn't.
> 
> > It makes it appearance in patch 16/25 as RFR_VFS_FLAGS.
> > All those "advisory" flags, we want to pass them in to filesystem as FYI,
> > but we don't want to explicitly add support for e.g. RFR_CAN_SHORTEN
> > to every filesystem, when vfs has already taken care of the advice.
> 
> I don't think this model makes sense.  If they really are purely
> handled in the VFS we can mask them before passing them to the file
> system, if not we need to check them, or the they are avisory and
> we can have a simple #define instead of the helper.
> 
> RFR_TO_SRC_EOF is checked in generic_remap_file_range_prep,
> so the file system should know about it  Also looking at it again now
> it seems entirely superflous - we can just pass down then len == we
> use in higher level code instead of having a flag and will side step
> the issue here.

I'm not a fan of hidden behaviors like that, particularly when we
already have a flags field where callers can explicitly ask for the
to-eof behavior.

> RFR_CAN_SHORTEN is advisory as no one has to shorten, but that can
> easily be solved by including it everywhere.

CAN_SHORTEN isn't included everywhere -- FICLONE{,RANGE} don't enable it
because they have no way to communicate the number of bytes cloned back
to userspace.  Either we can clone every byte the user asked for, or we
send back -EINVAL.  (Maybe I'm misinterpreting what you meant by 'solved
by including it everywhere'?)

> RFR_SHORT_DEDUPE is as far as I can tell entirely superflous to
> start with, as RFR_CAN_SHORTEN can be used instead.

For now it's superfluous.  At first I was thinking that we could return
a short bytes_deduped if, say, the first part of the range actually did
match, but it became pretty obvious via shared/010 that duperemove can't
handle that, so we really must stick to the existing btrfs behavior.

The existing btrfs behavior is that we can round the length down to
avoid deduping partial EOF blocks, but we return the original length
(i.e. lie) in bytes_deduped when we do that.

I sort of thought about introducing a new copy_file_range flag that
would just do deduplication and allow for opportunistic "dedup as much
as you can" but ... meh.  Maybe I'll just drop the patch instead; we can
revisit that when anyone wants a better dedupe interface.

> So something like this in fs.h:
> 
> #define REMAP_FILE_ADVISORY_FLAGS	REMAP_FILE_CAN_SHORTEN
> 
> And then in the file system:
> 
> 	if (flags & ~REMAP_FILE_ADVISORY_FLAGS)
> 		-EINVAL;
> 
> or
> 
> 	if (flags & ~(REMAP_FILE_ADVISORY_FLAGS | REMAP_FILE_DEDUP))
> 		-EINVAL;
> 
> should be all that is needed.

Sounds good to me.

--D
