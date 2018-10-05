Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA42C64EBC
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 01:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A160220684
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 01:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CsEisAXD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A160220684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbeJEIVQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 04:21:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbeJEIVQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 04:21:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w951NpgG056850;
        Fri, 5 Oct 2018 01:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cwkihl5m74CM4TR2spJoOfizUKw+vQIGnx6MJuwEgKQ=;
 b=CsEisAXDjCHxh0YxHLeTZmhZhiwqIhSNVDTG9CdG/TbATWVsQU3IkMYWmJq9IfDyM+Vb
 mbb9YdyadZrqGZM/6xaW/dp8rJLJl2JUQQOw8SmDGzsDX9+/qGvziXe590KeWq/kAMdX
 HI1Dt7SKlP/7RpMPYSCQTEwepM+kPaZhPBtHLCDvbUJ/xUlATDeCOdU7hvZwHdqJjMGp
 YgO1uLHoPSzn4O+dOIGtpNJcgSVse7sJWSfj+bDapEZDCCuzMZ5/ApB/fkah0/YJpPlR
 5gKK9mX815Hyt3GYatuYyGJD0lX6phKj6prj/8Xt+0Z/9ZYqxpQNgL6B89KwHxM5EAWu EA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mt0tu7rg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 01:24:53 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w951OqR5031051
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 01:24:52 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w951OqwW004199;
        Fri, 5 Oct 2018 01:24:52 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 01:24:52 +0000
Date:   Thu, 4 Oct 2018 18:24:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH 00/15] fs: fixes for serious clone/dedupe problems
Message-ID: <20181005012450.GN19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <20181005011718.GX31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005011718.GX31060@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050013
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 11:17:18AM +1000, Dave Chinner wrote:
> On Thu, Oct 04, 2018 at 05:44:34PM -0700, Darrick J. Wong wrote:
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
> > The patch "generic: test reflink side effects" recently sent to fstests
> > exercises the fixes in this series.  Tests are in [2].
> 
> Hmmm. I've got a couple of patches to fix dedupe/reflink partial EOF
> block data corruptions, too. I'll have to see how they fit into this
> new series - combined they add this code just after the call to
> vfs_clone_file_prep_inodes():
> 
> ....
> +       u64                     blkmask = i_blocksize(inode_in) - 1;
> ....
> +       /*
> +        * If the dedupe data matches, chop off the partial EOF block
> +        * from the source file so we don't try to dedupe the partial
> +        * EOF block.
> +        */
> +       if (is_dedupe) {
> +               len &= ~blkmask;
> +       } else if (len & blkmask) {
> +               /*
> +                * The user is attempting to share a partial EOF block,
> +                * if it's inside the destination EOF then reject it
> +                */
> +               if (pos_out + len < i_size_read(inode_out)) {
> +                       ret = -EINVAL;
> +                       goto out_unlock;
> +               }
> +       }
> 
> It might be better to put these in with the eof-zeroing patch then
> add all the other changes on top? Let me post them separately,
> as they may be candidates for 4.19-rc7 along with the eof zeroing.

Yeah, maybe we want to push the first two for 4.19 and leave the rest
for 4.20/5.0.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
