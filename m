Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31D9C67837
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 23:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8467E20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 23:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tz37kD8W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8467E20835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbeJLHEr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 03:04:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36388 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbeJLHEq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 03:04:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9BNTHuh108213;
        Thu, 11 Oct 2018 23:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=BIQIwXiZaMtsbnk0JU6KLB+xQ24ymjmbyU49lm9w6N0=;
 b=Tz37kD8WF/0yzUxI/ZxKYrr6jyP6v/5Hj+nxRqvKY67JsAFGpEUrNwhHC9RkN6RHmzvM
 L/aK7F2NLiZrW7MLmSUzQQNzh8GPLCaE3cfPtBYmgxkta+xOeGYArH/6VqZADLqHHqFR
 tEoDAEIg5OiN9ObUVJP6e/0PV3XPr1fteJ3b2JfhmXfJ5hORmQ4dbvNvRJE2JWzQRa3A
 p60k8VucHkC6QhvhU+w0/2iLxlVriyUc6AgXQKcds3kLzk8MM1O3ISP6IwYcWGegSsr6
 K0y/jSJfCrnKhuppSomzHKwvSH75NOF8qw6lcfYeFinbc/EOImuoMjmeeRKrGK65j4Dy dA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0qfg4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 23:34:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9BNYktq029926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 23:34:47 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9BNYjrc000880;
        Thu, 11 Oct 2018 23:34:45 GMT
Received: from localhost (/10.145.178.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 23:34:45 +0000
Date:   Thu, 11 Oct 2018 16:34:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 01/25] xfs: add a per-xfs trace_printk macro
Message-ID: <20181011233443.GD28243@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923114361.5546.11838344265359068530.stgit@magnolia>
 <20181011133934.GA23424@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011133934.GA23424@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9043 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=839
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110221
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 06:39:34AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 10, 2018 at 09:12:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a "xfs_tprintk" macro so that developers can use trace_printk to
> > print out arbitrary debugging information with the XFS device name
> > attached to the trace output.
> 
> I can't say I'm a fan of this.  trace_printk is a debugging aid,
> and opencoding the file system name really isn't much of a burden.

<shrug> I got tired enough of typing it to add a ewwgross macro, and then
got tired enough of maintaining the patch, let's see what Dave says. :)

--D
