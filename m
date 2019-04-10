Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4ECC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217D320850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732766AbfDJOat (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:30:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:41118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732675AbfDJOas (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:30:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D89F6AF46
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:30:47 +0000 (UTC)
Date:   Wed, 10 Apr 2019 16:30:47 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove redundant inode argument from
 btrfs_add_ordered_sum
Message-ID: <20190410143047.GA28886@linux-x5ow.site>
References: <20190410131611.18149-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190410131611.18149-1-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
