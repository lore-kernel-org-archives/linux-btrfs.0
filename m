Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576A9C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 10:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F68120874
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 10:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfADK0r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 05:26:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:46256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfADK0q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 05:26:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 914BEAD7E
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 10:26:45 +0000 (UTC)
Date:   Fri, 4 Jan 2019 11:26:45 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: btrfstune: print seeding status
Message-ID: <20190104112645.2a39eca8@suse.de>
In-Reply-To: <5e76f1f9-27aa-c89c-861a-9d6a9f197482@suse.com>
References: <20190103232239.11931-1-ddiss@suse.de>
        <20190103232239.11931-2-ddiss@suse.de>
        <5e76f1f9-27aa-c89c-861a-9d6a9f197482@suse.com>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 4 Jan 2019 09:05:00 +0200, Nikolay Borisov wrote:

> btrfs inspect-internal dump-super already supports showing seeding, why
> do we need btrfstune support for that as well?

Ah, I wasn't aware of that. IMO the logical place to look is next to
where the user enables seeding (btrfstune -S1).

> Also the way you've
> phrased is a bit misleading, since checking the superflag doesn't mean
> seeding for a particular _device_ is enabled but that the filesystem
> itself is set as seeding.

Not quite sure I follow. For a multi-dev FS (one seeding), I see:

rapido1:/# btrfstune -s /dev/zram0
Seeding flag is currently unset
rapido1:/# btrfstune -S 1 /dev/zram0
rapido1:/# btrfstune -s /dev/zram0
Seeding flag is currently set
rapido1:/# mount /dev/zram0 /mnt/test/
mount: /dev/zram0 is write-protected, mounting read-only
...
rapido1:/# btrfs device add -f /dev/zram1 /mnt/test/
[   77.805374] BTRFS info (device zram0): disk added /dev/zram1
rapido1:/# umount /mnt/test/
rapido1:/# btrfstune -s /dev/zram1
Seeding flag is currently unset
rapido1:/# btrfstune -s /dev/zram0
Seeding flag is currently set

Cheers, David
