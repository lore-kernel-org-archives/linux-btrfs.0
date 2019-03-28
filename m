Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6ACC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 17:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C52720811
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 17:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bV9GvK0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfC1R55 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 13:57:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfC1R55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 13:57:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SHs64B058152;
        Thu, 28 Mar 2019 17:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=3Am7D+JT4HdVeylSccYOusV17b+Gn6lVGdA+DJO7BWk=;
 b=bV9GvK0+ImE6m8jL04dnNpHKuufyPGi0bLte91zxCXSr2ViFUDz8ZeFeKsQqicj+Wfu1
 xU13+ProYSZkB/IlCM/AtX6eiv/hnIZQy2GhplOI/Egz/lA+cNSUO/kEH5C4uGqk7Mtc
 tviOLmKmEtMJszMjA73HXHADP7XiYifWwLspqJ4D6yxGxKpuqguqwg/27YGMZYiY9TNV
 dd6KiFpX5SlYayLIwLzoyX6f118xq3s+gKuxOx1UTjZeDVM9hC135KFT+p6snoE3wm3h
 MKVsFkUBgjJrrD/vR9UXu2gzmF2xY5lBslsVfdQRtNEcGgLQqo5lhr7fMtD7Wa70yxjO qg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2re6djra39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 17:57:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2SHvj8x010812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 17:57:45 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2SHvi9d012946;
        Thu, 28 Mar 2019 17:57:44 GMT
Received: from localhost (/10.159.234.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 10:57:43 -0700
Date:   Thu, 28 Mar 2019 10:57:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190328175736.GA1177@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
 <20190328172825.GQ29086@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328172825.GQ29086@twin.jikos.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9209 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280118
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 06:28:25PM +0100, David Sterba wrote:
> On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > This sets S_DAX in inode->i_flags, which can be used with
> > IS_DAX().
> > 
> > The dax option is restricted to non multi-device mounts.
> > dax interacts with the device directly instead of using bio, so
> > all bio-hooks which we use for multi-device cannot be performed
> > here. While regular read/writes could be manipulated with
> > RAID0/1, mmap() is still an issue.
> 
> I'm looking for other features that would not work with dax. Disabling
> multiple devices strikes out device add, device delete and device
> replace.
> 
> To be verified:
> 
> - balance - at least profile changes must be forbidden
> 
> - defrag
> 
> - compression - as it needs COW, it won't work on the nodatacow files,
>   thus seems to be ok
> 
> - resize/grow - this could work without changes, no block relocation is
>   needed, only new structures created
> 
> - resize/shrink - depends on balance, the block groups from the removed
>   area need to be relocated
> 
> - swapfiles - I'm sure somebody will try that; I haven't seen any
>   IS_DAX checks in the swapfile activation code

I've never tried dax swapfiles, but so long as you can issue bios to the
underlying bdev they ought to work, right?  Even if the swap code could
be streamlined by memcpy in the dax case.

(Granted I have no idea what sort of bio-hooks magic btrfs does, maybe
it really doesn't work there...)

--D
