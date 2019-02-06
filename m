Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12188C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF05C2073F
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfBFP2m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:28:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:50748 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728658AbfBFP2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Feb 2019 10:28:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 281E6AB48;
        Wed,  6 Feb 2019 15:28:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 94C67DA823; Wed,  6 Feb 2019 16:28:04 +0100 (CET)
Date:   Wed, 6 Feb 2019 16:28:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14] Add cli and ioctl to forget scanned device(s)
Message-ID: <20190206152804.GC2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
 <20190107172816.GX23615@twin.jikos.cz>
 <f7446cbe-0003-0539-fff6-70cd8ea28ba5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7446cbe-0003-0539-fff6-70cd8ea28ba5@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 01:16:14PM +0800, Anand Jain wrote:
> 
> 
> On 01/08/2019 01:28 AM, David Sterba wrote:
> > On Fri, Jan 04, 2019 at 01:31:51PM +0800, Anand Jain wrote:
> >> Adds cli and ioctl to forget a scanned device or forget all stale
> >> devices in the kernel.
> > 
> > I've read my comments to previous postings and I suggested to add more
> > ways how to specify the device, eg. by uuid or fsid:devid. Have you
> > considered that?
> 
>   Right I responded [1],
> 
>    [1]
>    https://www.spinics.net/lists/linux-btrfs/msg81059.html
> 
>   basically.. I like uuid|fsid:devid idea but,
>   - we also need to add the ability to list out uuid|fsid:devid which
>   are already scanned, such as [2] (in ml since 2015).
> 
>    [2]
>    https://patchwork.kernel.org/patch/7362881/

That would be nice to have but is a bigger task than this ioctl.

>   Further, its better to be consistent with other cli too..
>   As of now, 'btrfs device delete' supports only <path|devid> we need
>   to add uuid.

Yeah, the changes to support the enhanced syntax would need to be done
for all commands.

The /dev/path should be sufficient for now.
