Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59AFC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B3BB2054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ujnm2qLU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B3BB2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbeJKXXE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 19:23:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbeJKXXE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 19:23:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9BFs6PO056359;
        Thu, 11 Oct 2018 15:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=hKI69bABDFysqLyaxLaiy7JTh/Ca5LKETEo4AoJ+HwU=;
 b=ujnm2qLU2UZm9XHfkhGSPmGOOSVGq8HjXhinQCriuOzTFQBCz7dDZC/kekZzJRBAu23R
 JnRiOJmbpPVpjhcfuplJZUwjv9gDH9EE3adUK5wwmHDewyMogVOeEM43wAlaGmNxqFLJ
 IBTNZLQ8VLGDjwwDH2mT1eTW8wtyV9vAKR0YbCX42sGi4PuU8K7Vu2AqmCE4D6lFkNWN
 6N77o/gPMwzjWhebp8vgk4Vb4gU3Ek9+gPfdmjp8Dw1N4jv7OcEn684SaPE/9oOa12Td
 +KvfxElGF3sHm/uiKfpTIWsuSDO9+i4CIJhmOBlqTm+FBDUW9oyAB2Kn0C8cJJ7NEWBI 3Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mxnprd6ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 15:55:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9BFt7is025360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 15:55:08 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9BFt6qV012701;
        Thu, 11 Oct 2018 15:55:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 15:55:06 +0000
Date:   Thu, 11 Oct 2018 08:55:04 -0700
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
Subject: Re: [PATCH v3 00/25] fs: fixes for serious clone/dedupe problems
Message-ID: <20181011155504.GZ28243@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <CAOQ4uxgOvOOnKL5TsC9jpjBsepAgtQ56Hhjh7WDeXM7m0=dz7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgOvOOnKL5TsC9jpjBsepAgtQ56Hhjh7WDeXM7m0=dz7g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110153
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 11:33:57AM +0300, Amir Goldstein wrote:
> On Thu, Oct 11, 2018 at 7:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > Hi all,
> >
> > Dave, Eric, and I have been chasing a stale data exposure bug in the XFS
> > reflink implementation, and tracked it down to reflink forgetting to do
> > some of the file-extending activities that must happen for regular
> > writes.
> >
> > We then started auditing the clone, dedupe, and copyfile code and
> > realized that from a file contents perspective, clonerange isn't any
> > different from a regular file write.  Unfortunately, we also noticed
> > that *unlike* a regular write, clonerange skips a ton of overflow
> > checks, such as validating the ranges against s_maxbytes, MAX_NON_LFS,
> > and RLIMIT_FSIZE.  We also observed that cloning into a file did not
> > strip security privileges (suid, capabilities) like a regular write
> > would.  I also noticed that xfs and ocfs2 need to dump the page cache
> > before remapping blocks, not after.
> >
> > In fixing the range checking problems I also realized that both dedupe
> > and copyfile tell userspace how much of the requested operation was
> > acted upon.  Since the range validation can shorten a clone request (or
> > we can ENOSPC midway through), we might as well plumb the short
> > operation reporting back through the VFS indirection code to userspace.
> >
> > So, here's the whole giant pile of patches[1] that fix all the problems.
> > This branch is against 4.19-rc7 with Dave Chinner's XFS for-next branch.
> > The patch "generic: test reflink side effects" recently sent to fstests
> > exercises the fixes in this series.  Tests are in [2].
> >
> > --D
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
> 
> I tested your branch with overlayfs over xfs.
> I did not observe any failures with -g clone except for test generic/937
> which also failed on xfs in my test.

Ok, matches what I saw overnight.  Good, that means I (at least
theoretically) know how to test overlayfs now. :)

> I though that you forgot to mention I needed to grab xfsprogs from djwong-devel
> for commit e84a9e93 ("xfs_io: dedupe command should only complain
> if we don't dedupe anything"), but even with this change the test still fails:
> 
> generic/937     - output mismatch (see
> /old/home/amir/src/fstests/xfstests-dev/results//generic/937.out.bad)
>     --- tests/generic/937.out   2018-10-11 08:23:00.630938364 +0300
>     +++ /old/home/amir/src/fstests/xfstests-dev/results//generic/937.out.bad
>    2018-10-11 10:54:40.448134832 +0300
>     @@ -4,8 +4,7 @@
>      39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-937/file2
>      Files 1-2 do not match (intentional)
>      (partial) dedupe the middle blocks together
>     -deduped XXXX/XXXX bytes at offset XXXX
>     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     +XFS_IOC_FILE_EXTENT_SAME: Extents did not match.

Ohhh, right, g/937 is the test to see if the dedupe implementation will
return a short bytes_deduped if a single byte at the end of the range
doesn't match.  I'll have to update that because...

I reverted the FIDEDUPERANGE behavior to set ->info[x].bytes_deduped =
->src_length even if we rounded the length down to the nearest block
boundary to avoid incorrect sharing of blocks on files with
non-block-aligned EOF.  It turned out that the existing FIDEDUPERANGE
users will hang in infinite loops if the kernel returns ->info[x].status
== FILE_DEDUPE_RANGE_SAME but ->info[x].bytes_deduped < ->src_length.

It seems really stupid to me that the kernel now lies to userspace to
avoid breaking it, but that's what btrfs does so we're stuck with that.
For now.

>      Compare sections
> 
> One thing that *is* different with overlayfs test is that filefrag crashes
> on this same test:
> 
>     QA output created by 937
>     Create the original files
>     35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-937/file1
>     39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-937/file2
>     Files 1-2 do not match (intentional)
>     (partial) dedupe the middle blocks together
>     XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
>     ./tests/generic/937: line 59: 19242 Floating point exception(core
> dumped) ${FILEFRAG_PROG} -v $testdir/file1 >> $seqres.full
>     ./tests/generic/937: line 60: 19244 Floating point exception(core
> dumped) ${FILEFRAG_PROG} -v $testdir/file2 >> $seqres.full
> 
> It looks like an overlayfs v4.19-rc1 regression - FIGETBSZ returns zero.
> I never noticed this regression before, because none of the generic tests
> are using filefrag.

Funny, I was wondering just the other day if there were any filesystems
that set s_blocksize == 0... :)

--D

> Thanks,
> Amir.
