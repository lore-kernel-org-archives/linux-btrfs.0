Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B7CC433DB
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Feb 2021 01:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45AC364E9A
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Feb 2021 01:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBIBvo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 20:51:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:60490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhBIBvn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Feb 2021 20:51:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2D5CEAD29;
        Tue,  9 Feb 2021 01:51:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1AE2EDA7C8; Tue,  9 Feb 2021 02:49:09 +0100 (CET)
Date:   Tue, 9 Feb 2021 02:49:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v15 40/42] btrfs: zoned: serialize log transaction on
 zoned filesystems
Message-ID: <20210209014908.GP1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <b36444df121d46c6d9638a8ae8eacecaa845fbe4.1612434091.git.naohiro.aota@wdc.com>
 <5eabc4600691c618f34f8f39c156d9c094f2687b.1612434091.git.naohiro.aota@wdc.com>
 <20210205091516.l3nkvig7swburnxx@naota-xeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205091516.l3nkvig7swburnxx@naota-xeon>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 05, 2021 at 06:15:16PM +0900, Naohiro Aota wrote:
> David, could you fold the below incremental diff to this patch? Or, I
> can send a full replacement patch.

Folded to the patch, thanks.
