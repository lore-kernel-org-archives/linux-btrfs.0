Return-Path: <SRS0=17CA=2D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE9AC341CC
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F552472C
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLMMc5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 07:32:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:37568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbfLMMc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Dec 2019 07:32:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D8A75AF13;
        Fri, 13 Dec 2019 12:32:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2924DA82A; Fri, 13 Dec 2019 13:32:55 +0100 (CET)
Date:   Fri, 13 Dec 2019 13:32:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix format string warning
Message-ID: <20191213123255.GW3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Arnd Bergmann <arnd@arndb.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191210204429.3383471-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210204429.3383471-1-arnd@arndb.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 10, 2019 at 09:44:16PM +0100, Arnd Bergmann wrote:
> To print a size_t, the format string modifier %z should be used instead
> of %l:
> 
> fs/btrfs/tree-checker.c: In function 'check_extent_data_item':
> fs/btrfs/tree-checker.c:230:43: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Werror=format=]
>      "invalid item size, have %u expect [%lu, %u)",
>                                          ~~^
>                                          %u
> 
> Fixes: 153a6d299956 ("btrfs: tree-checker: Check item size before reading file extent type")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, there's already fix for that in our devel queue, I'm going to
send it to the next rc.
