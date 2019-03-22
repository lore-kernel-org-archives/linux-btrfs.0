Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA369C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 17:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8760A2083D
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 17:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfCVRvV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 13:51:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:52274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbfCVRvV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 13:51:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9910ADFB;
        Fri, 22 Mar 2019 17:51:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D9019DA825; Fri, 22 Mar 2019 18:52:33 +0100 (CET)
Date:   Fri, 22 Mar 2019 18:52:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.3 00/11] btrfs: tree-checker: Write time tree checker
Message-ID: <20190322175233.GA10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190320062749.30953-1-wqu@suse.com>
 <20190321143406.GF26179@twin.jikos.cz>
 <ec2d0bb8-49bf-a7ec-3bc5-7c0f80adf018@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec2d0bb8-49bf-a7ec-3bc5-7c0f80adf018@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 22, 2019 at 07:56:37AM +0800, Qu Wenruo wrote:
> >>   btrfs: Do mandatory tree block check before submitting bio
> > 
> > All except 9 and 11 are going to misc-next after a final test. The two
> > patches are only postponed, one for review and the other one due to
> > conflict with another patch in misc-next.
> 
> Do I need to resend the last patch to solve the conflict by myself?

Please check that I've resoved the conflict correctly, the updated patch
is not top commit in misc-next. Thanks.
