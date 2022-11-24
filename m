Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A7FC46467
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Nov 2022 19:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiKXTOS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 14:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKXTOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2022 14:14:16 -0500
Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBC281581
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2022 11:14:15 -0800 (PST)
Date:   Thu, 24 Nov 2022 20:14:12 +0100
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Endless "reclaiming chunk"/"relocating block group"
Message-ID: <1669317166@msgid.manchmal.in-ulm.de>
References: <1666204197@msgid.manchmal.in-ulm.de>
 <Y1Crh/Cz2rcbIayw@hungrycats.org>
 <1666262200@msgid.manchmal.in-ulm.de>
 <Y1FSxogPeNIUfyVn@hungrycats.org>
 <1669313605@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669313605@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Stupid typo ...


Christoph Biedl wrote...

> *However*, some additional debug-print statements revealed the generated
> code enters the block that calls btrfs_mark_bg_to_reclaim /even/ /if/
> alloc is
           true,
>                 and reclaim undefined (usually true).
