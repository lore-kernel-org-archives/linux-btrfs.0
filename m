Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9740CC433ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Apr 2021 17:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79961613B0
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Apr 2021 17:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242900AbhDPRet (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:34:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:40040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236140AbhDPRes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Apr 2021 13:34:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F30D2ADFB;
        Fri, 16 Apr 2021 17:34:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DED80DA790; Fri, 16 Apr 2021 19:32:03 +0200 (CEST)
Date:   Fri, 16 Apr 2021 19:32:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Khaled ROMDHANI <khaledromdhani216@gmail.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH-next] fs/btrfs: Fix uninitialized variable
Message-ID: <20210416173203.GE7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Khaled ROMDHANI <khaledromdhani216@gmail.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20210413130604.11487-1-khaledromdhani216@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413130604.11487-1-khaledromdhani216@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 13, 2021 at 02:06:04PM +0100, Khaled ROMDHANI wrote:
> The variable zone is not initialized. It
> may causes a failed assertion.

Failed assertion means the 2nd one checking that the result still fits
to 32bit type. That would mean that none of the cases were hit, but all
callers pass valid values.

It would be better to add a default: case to catch that explicitly,
though hitting that is considered 'will not happen'.
