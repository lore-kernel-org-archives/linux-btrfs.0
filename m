Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B274C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 13:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02FCD208E3
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 13:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfADNeR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 08:34:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:40026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbfADNeQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 08:34:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC8BAAD38
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 13:34:15 +0000 (UTC)
Date:   Fri, 4 Jan 2019 14:34:15 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: btrfstune: print seeding status
Message-ID: <20190104143415.1a4d4296@suse.de>
In-Reply-To: <85b4bef0-20ae-9cac-5ddb-955fe2331a0d@suse.com>
References: <20190103232239.11931-1-ddiss@suse.de>
        <20190103232239.11931-2-ddiss@suse.de>
        <5e76f1f9-27aa-c89c-861a-9d6a9f197482@suse.com>
        <20190104112645.2a39eca8@suse.de>
        <85b4bef0-20ae-9cac-5ddb-955fe2331a0d@suse.com>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 4 Jan 2019 15:18:13 +0200, Nikolay Borisov wrote:

> IMO seed has really been
> hacked on "just because" and is lacking coherent design, I'd prefer it
> didn't proliferate and rely on what we have currently.

That's unfortunate to hear. Seed devices are IMO a very cool feature for
transactional OS updates and live installers.

Cheers, David
