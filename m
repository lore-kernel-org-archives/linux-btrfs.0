Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AB6C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49700207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49700207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbeJXX7h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 19:59:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:45392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbeJXX7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 19:59:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA002AF79;
        Wed, 24 Oct 2018 15:31:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6482ADABAC; Wed, 24 Oct 2018 17:29:12 +0200 (CEST)
Date:   Wed, 24 Oct 2018 17:29:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: change filename limit to 255 when
 creating subvolume
Message-ID: <20181024152912.GW16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180918011754.7981-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918011754.7981-1-suyj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 18, 2018 at 09:17:54AM +0800, Su Yanjun wrote:
> Modify the file name length limit to meet the Linux naming convention.
> In addition, the file name length is always bigger than 0, no need to
> compare with 0 again.
> 
> Changelog:
> v2:
>  Fix the same problem in creating snapshot routine.
> 
> Issue: #145
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Applied, thanks.
