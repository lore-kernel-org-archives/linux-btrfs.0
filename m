Return-Path: <SRS0=FDMB=CK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB09C433E7
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8390B20767
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgIAPaY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:30:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:39092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbgIAPaO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C3B7B61A;
        Tue,  1 Sep 2020 15:30:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5B902DA7CF; Tue,  1 Sep 2020 17:28:58 +0200 (CEST)
Date:   Tue, 1 Sep 2020 17:28:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: init sysfs for devices outside of the
 chunk_mutex
Message-ID: <20200901152857.GG28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1598961912.git.josef@toxicpanda.com>
 <5dccee8f9d7fe7b5072090327854fcbfdbd45b28.1598961912.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dccee8f9d7fe7b5072090327854fcbfdbd45b28.1598961912.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 01, 2020 at 08:09:01AM -0400, Josef Bacik wrote:
> While running btrfs/187 I hit the following lockdep splat

So this also fixes btrfs/061, /073 and /078.
