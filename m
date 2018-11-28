Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC977C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96DF42081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96DF42081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbeK2DXV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:23:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:51242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727979AbeK2DXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:23:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97715B04A;
        Wed, 28 Nov 2018 16:21:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6DD99DAC7F; Wed, 28 Nov 2018 17:20:51 +0100 (CET)
Date:   Wed, 28 Nov 2018 17:20:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: remove redundant nowait check for
 buffered_write
Message-ID: <20181128162050.GT2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
 <20181128032330.11753-1-lufq.fnst@cn.fujitsu.com>
 <2aa63759-0c0a-a8f8-c02e-e215e1be6c73@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2aa63759-0c0a-a8f8-c02e-e215e1be6c73@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 09:04:31AM +0200, Nikolay Borisov wrote:
> On 28.11.18 г. 5:23 ч., Lu Fengqi wrote:
> > The generic_write_checks will check the combination of IOCB_NOWAIT and
> > !IOCB_DIRECT.
> 
> True, however btrfs will return ENOSUPP whereas the generic code returns
> EINVAL. I guess this is not a big deal and it's likely generic code is
> correct, so:

I tried to check the git history if there are some clues for that. The
duplicate checks could be a intermediate step before the aio/nowait
feature was complete but somehow not removed at the end.

The btrfs part was Added in commit
91f9943e1c7b6638f27312d03fe71fcc67b23571 "fs: support RWF_NOWAIT for
buffered reads" (4.13)

The generic checks were added in
6be96d3ad34a124450028dabba43f07fe1d0c86d (4.12), so from that it seems
that it was added tot btrfs as redundant already.
