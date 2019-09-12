Return-Path: <SRS0=o9HI=XH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE76C4CEC7
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Sep 2019 17:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD50206A5
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Sep 2019 17:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfILRok (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 13:44:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:37170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726032AbfILRok (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Sep 2019 13:44:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3E23AAD69;
        Thu, 12 Sep 2019 17:44:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B083BDA835; Thu, 12 Sep 2019 19:44:38 +0200 (CEST)
Date:   Thu, 12 Sep 2019 19:44:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: corrupt-block: Fix description of 'r' option
Message-ID: <20190912174438.GK2850@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190911135552.22087-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911135552.22087-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 11, 2019 at 04:55:52PM +0300, Nikolay Borisov wrote:
> Since commit 04be0e4b1962 ("btrfs-progs: corrupt-block: Correctlyi
> handle -r when passing -I") the 'r' switch is used with both -I and -d
> options. So remove the wrong clarificatoin that -r is used only with -d
> option.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
