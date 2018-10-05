Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82D2C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD79208E7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DD79208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbeJFAW5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 20:22:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:57984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeJFAW5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 20:22:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2DC6B09B;
        Fri,  5 Oct 2018 17:23:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B51BADAC22; Fri,  5 Oct 2018 19:23:14 +0200 (CEST)
Date:   Fri, 5 Oct 2018 19:23:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: volumes: Make sure there is no overlap dev
 extents at mount time
Message-ID: <20181005172314.GD29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181005082525.22441-1-wqu@suse.com>
 <20181005082525.22441-2-wqu@suse.com>
 <658c8276-4294-d31f-7c63-83fa244dc213@suse.com>
 <6b144bff-a328-98ac-b243-b82092ddbdc3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b144bff-a328-98ac-b243-b82092ddbdc3@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 05:22:40PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/10/5 下午4:56, Nikolay Borisov wrote:
> > 
> > 
> > On  5.10.2018 11:25, Qu Wenruo wrote:
> >> Enhance btrfs_verify_dev_extents() to remember previous checked dev
> >> extents, so it can check if one dev extent overlaps with previous dev extent.
> >>
> >> Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > 
> > If this is related to the initial report here:
> > 
> > https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
> > 
> > I'd rather have it as a link to the commit:
> > 
> > Link:
> > https://lore.kernel.org/linux-btrfs/b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com/
> 
> I'd prefer something shorter, like.
> Link: https://www.spinics.net/lists/linux-btrfs/msg82370.html
> 
> Is there any shorter URL version from lore.kernel.org?

https://lkml.kernel.org/r/<message-id>

or

https://lore.kernel.org/linux-btrfs/<message-id>
