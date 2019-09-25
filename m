Return-Path: <SRS0=zJiL=XU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88C9C432C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 16:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A660821D79
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 16:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391968AbfIYQpg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:45:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:49524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391916AbfIYQpg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Sep 2019 12:45:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5938DAF83;
        Wed, 25 Sep 2019 16:45:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A0BCFDA835; Wed, 25 Sep 2019 18:45:55 +0200 (CEST)
Date:   Wed, 25 Sep 2019 18:45:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: balance: use redundancy instead of integrity
Message-ID: <20190925164555.GI2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1569392968-21340-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569392968-21340-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 25, 2019 at 02:29:28PM +0800, Anand Jain wrote:
> When balance reduces the number of copies of data it reduces the
> redundancy, use the term redundancy instead of integrity.

I agree, patch on the way to misc-next. If anybody has concerns or
further clarifications, please speak. Thanks.
