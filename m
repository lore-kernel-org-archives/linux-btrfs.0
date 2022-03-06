Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7775C433F5
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Mar 2022 01:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiCFBlX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiCFBlX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2022 20:41:23 -0500
Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 995F3F06
        for <linux-btrfs@vger.kernel.org>; Sat,  5 Mar 2022 17:40:32 -0800 (PST)
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
        id 37636235FA6; Sat,  5 Mar 2022 20:40:32 -0500 (EST)
Date:   Sat, 5 Mar 2022 20:40:32 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Christoph Anton Mitterer <calestyo@scientia.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: status page status - dedupe
Message-ID: <YiQRED8tzbWZPnbH@hungrycats.org>
References: <c16169c5b971fe5dee1e50e07e2c7bb8d2bface4.camel@scientia.org>
 <YiP5l4Rq9AOuiIKt@hungrycats.org>
 <3d8e6c6a2bd08164835b6aa3bf6d4d1d9ed9e5df.camel@scientia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8e6c6a2bd08164835b6aa3bf6d4d1d9ed9e5df.camel@scientia.org>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 06, 2022 at 02:38:48AM +0100, Christoph Anton Mitterer wrote:
> Thanks for that elaborate description (and thanks to Qu, too).
> 
> I think that might be be a good addition to
> https://btrfs.wiki.kernel.org/index.php/Deduplication
> 
> 
> Also:
> 
> On Sat, 2022-03-05 at 19:00 -0500, Zygo Blaxell wrote:
> > jdupes can use the safe dedupe ioctl (-B) or very unsafe hardlinks (-
> > H).
> 
> I guess you mean -L ?!

Uhhh, yes.  I don't use either option myself.  ;)

> Thanks,
> Chris.
