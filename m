Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68DDC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Jan 2021 13:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77A18207B2
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Jan 2021 13:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAHN7v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 08:59:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:44072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbhAHN7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jan 2021 08:59:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 96809AD4D;
        Fri,  8 Jan 2021 13:59:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 36A1EDA6E9; Fri,  8 Jan 2021 14:57:19 +0100 (CET)
Date:   Fri, 8 Jan 2021 14:57:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: fixup read_policy latency
Message-ID: <20210108135719.GW6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, josef@toxicpanda.com
References: <df71f31c04177b7f5977944b0f1adcecca13391b.1603950490.git.anand.jain@oracle.com>
 <e9cd491fb05be97dbba756b7d0b9df3418b02a1d.1609916374.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9cd491fb05be97dbba756b7d0b9df3418b02a1d.1609916374.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 06, 2021 at 03:08:15PM +0800, Anand Jain wrote:
> In the meantime, since I have sent the base patch as below [1], the
> block layer commit 0d02129e76ed (block: merge struct block_device and
> struct hd_struct) has changed the first argument in the function
> part_stat_read_all() to struct block_device in 5.11-rc1. So the
> compilation will fail. This patch fixes it.
> 
> This fixup patch must be rolled into its base patch [1].
> [1] [PATCH v2 1/4] btrfs: add read_policy latency
> 
> I will include these changes in the base patch after the review comments.

It would be better to resend the patchset in this case as the fixup is
not just cosmetic. So far there's no discussion ongoing so resend would
not break the flow.
