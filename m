Return-Path: <SRS0=snfn=3D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22DEC33CA9
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jan 2020 02:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777AF20CC7
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jan 2020 02:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgANCQU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 21:16:20 -0500
Received: from trent.utfs.org ([94.185.90.103]:52322 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgANCQU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Jan 2020 21:16:20 -0500
Received: from localhost (localhost [IPv6:::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by trent.utfs.org (Postfix) with ESMTPS id 4912C6003F;
        Tue, 14 Jan 2020 03:16:17 +0100 (CET)
Date:   Mon, 13 Jan 2020 18:16:17 -0800 (PST)
From:   Christian Kujau <lists@nerdbynature.de>
To:     Chris Murphy <lists@colorremedies.com>
cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: file system full on a single disk?
In-Reply-To: <CAJCQCtSmDx10PQvA8j58NcGyEV9La5FRLYj=q-EHTTXwJF+8ZQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.99999.375.2001131807440.21037@trent.utfs.org>
References: <alpine.DEB.2.21.99999.375.2001131400390.21037@trent.utfs.org> <CAJCQCtS9rx0M30zLxkND5MYTwLEPxYG=8BuRB3b1Bi8Vr3KTqg@mail.gmail.com> <alpine.DEB.2.21.99999.375.2001131514010.21037@trent.utfs.org> <CAJCQCtShpdS81pvc1m26yPmriaE7_3=MZTFkbXknp9+Wehwr5w@mail.gmail.com>
 <CAJCQCtSmDx10PQvA8j58NcGyEV9La5FRLYj=q-EHTTXwJF+8ZQ@mail.gmail.com>
User-Agent: Alpine 2.21.99999 (DEB 375 2019-10-29)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 13 Jan 2020, Chris Murphy wrote:
> This is the latest patchset as of about a week ago, and actually I'm
> not seeing it in 5.5rc6. A tested fix may not be ready yet.
> https://patchwork.kernel.org/project/linux-btrfs/list/?series=223921
> 
> Your best bet is likely to stick with 5.4.10 and just use mount option
> metadata_ratio=1. This won't cause some other weird thing to happen.

I have remounted the file system with that option set when it was still 
running, but it didn't do anything (as expected I'd assume), its usage was 
still at 100 percent.

Now I had a chance to reboot the system (with that option set), but usage 
was still at 100%, so I ran "btrfs balance" once more (although you 
recommended against it :)) and a reboot later everything seems "normal" 
again.

Thanks for the explanations and hints. I must admit it's kinda surprising 
to me that these ENOSPC errors are still happening with btrfs, I somehow 
assumed that these kinks had been ironed out by now. But as you said, this 
may have re-appeared with 5.4 and it's not a big deal for me right now, so 
I can live with the mount option set and wait for 5.5 to be released :-)

Thanks again,
Christian.
-- 
BOFH excuse #123:

user to computer ratio too high.
