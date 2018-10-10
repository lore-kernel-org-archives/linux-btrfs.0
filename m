Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E042C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 18:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 499F12075B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 18:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iDBi+Xjz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 499F12075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbeJKB4M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 21:56:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbeJKB4M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 21:56:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AIPlk9080088;
        Wed, 10 Oct 2018 18:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=CY/PWC3cO4gHG6rftWesalkP5N/7TZPiWt0V7MJ/4W4=;
 b=iDBi+Xjz2FjCtd/nMSQzuLeoEnUAz59F4+VKxofzGIV5h+8Yifldrt7gzNHITN2v4QP9
 vv5dKqy/wSJwITDEjzHU/VCh1slR17LKq8jxN1NcwB1NfVcXwBUCJbDs1SnuWAiLqnjh
 3q3nfU+nFzI8xlykrYWiCkuc3blk4aCCXCBQBUuZqJBZGOZBcxkBF9nD54fb8FeKufbF
 rtZEXnEmlPnOArYSqYwj2/d767cfv64gVomqreuqJv4rLWgTxTBNkez2wMkD/GLbDmH7
 VhpT7iHY0NPufeHeCR/O4F6OOIvIitrxGvozQ2TxKnsHudQea0pcoZnL/E1iesRMx1ir DA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0q5yy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 18:32:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9AIWdLb019231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 18:32:39 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9AIWcgn004316;
        Wed, 10 Oct 2018 18:32:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 18:32:38 +0000
Date:   Wed, 10 Oct 2018 11:32:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 14/25] vfs: make remap_file_range functions take and
 return bytes completed
Message-ID: <20181010183236.GU28243@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913040858.32295.9474188640729118153.stgit@magnolia>
 <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
 <20181010155055.GS28243@magnolia>
 <CAOQ4uxjsKZHxoYqbnJTxQ1SPGn7o_2QhYseuETHnvZxvgCV5vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjsKZHxoYqbnJTxQ1SPGn7o_2QhYseuETHnvZxvgCV5vg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100172
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:28:34PM +0300, Amir Goldstein wrote:
> On Wed, Oct 10, 2018 at 6:51 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Wed, Oct 10, 2018 at 09:47:00AM +0300, Amir Goldstein wrote:
> > > On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > >
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > > > Change the remap_file_range functions to take a number of bytes to
> > > > operate upon and return the number of bytes they operated on.  This is a
> > > > requirement for allowing fs implementations to return short clone/dedupe
> > > > results to the user, which will enable us to obey resource limits in a
> > > > graceful manner.
> > > >
> > > > A subsequent patch will enable copy_file_range to signal to the
> > > > ->clone_file_range implementation that it can handle a short length,
> > > > which will be returned in the function's return value.  Neither clone
> > > > ioctl can take advantage of this, alas.
> > > >
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> [...]
> > > Commit message wasn't clear enough on the behavior of copy_file_range()
> > > before and after the patch IMO. Maybe it would be better to pospone this
> > > semantic change to the RFR_SHORTEN patch and keep if (cloned == len)
> > > in this patch?
> >
> > There shouldn't be any behavior change here -- all implementations
> > return a negative error code or the length that was passed in.  I'll
> > clarify that in the commit message.
> >
> 
> OK. BTW, you forgot to update Documentation/filesystems/vfs.txt.

Yeah, I noticed that and updated it too.

> Also since this series has a potential to break clone/dedup on
> overlayfs, it would be great if you could run some of the clone/dedupe
> xfstests with overlay over xfs.
> 
> For the simple case of running ./check with a local.config file that is
> not multi section, this just means running ./check -overlay after the
> first ./check run (-overlay doesn't mkfs the base fs).

I'll give it a try, though we should probably both run '-g clone' just
to make sure everything is working...

> If this is a problem, let me know once new devel branch is ready

Yeah, Dave asked me to merge the xfs for-next branch so I'm working on
that too.

> and I'll pull it for testing. If I need to pull in extra xfstests, please
> mention that as well.

You'll probably want "generic: test creation time recovery after power
failure" that I sent to the fstests lists a few days ago.

--D

> 
> Thanks,
> Amir.
