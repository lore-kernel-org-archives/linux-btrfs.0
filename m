Return-Path: <SRS0=bWPQ=XM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CC1C4CEC9
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Sep 2019 12:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6053214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Sep 2019 12:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfIQMFi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 08:05:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:38724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbfIQMFi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Sep 2019 08:05:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7F40FB621;
        Tue, 17 Sep 2019 12:05:37 +0000 (UTC)
Date:   Tue, 17 Sep 2019 14:05:36 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/7] btrfs: don't prematurely free work in
 end_workqueue_fn()
Message-ID: <20190917120536.GC12128@x250>
References: <cover.1568658527.git.osandov@fb.com>
 <50984ff1f8148fcb8516d34fa20c828dd465c97d.1568658527.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50984ff1f8148fcb8516d34fa20c828dd465c97d.1568658527.git.osandov@fb.com>
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
