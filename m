Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9266C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 12:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B15720672
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 12:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B15720672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394775AbeKWXbK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 18:31:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:38614 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394756AbeKWXbJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 18:31:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AFDB7AEFA;
        Fri, 23 Nov 2018 12:47:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BCF29DA858; Fri, 23 Nov 2018 13:46:49 +0100 (CET)
Date:   Fri, 23 Nov 2018 13:46:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: relocation: set trans to be NULL after free
Message-ID: <20181123124648.GB2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Pan Bian <bianpan2016@163.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1542967815-14547-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542967815-14547-1-git-send-email-bianpan2016@163.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 23, 2018 at 06:10:15PM +0800, Pan Bian wrote:
> The function relocate_block_group calls btrfs_end_transaction to release
> trans when update_backref_cache returns 1, and then continues the loop
> body. If btrfs_block_rsv_refill fails this time, it will jump out the
> loop and the freed trans will be accessed. This may result in a
> use-after-free bug. The patch assigns NULL to trans after trans is
> released so that it will not be accessed.
> 
> Fixes: 0647bf564f1("Btrfs: improve forever loop when doing balance
> relocation")
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Good catch, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
