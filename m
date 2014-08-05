Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:38285 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaHEJvs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 05:51:48 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so723378wes.15
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 02:51:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140805094656.GI31950@carfax.org.uk>
References: <CAFChkqv7WOUmYPajdJMqZ_LAeMfssUH8X8a6J_y1Xghm_Rqgiw@mail.gmail.com>
 <20140805094656.GI31950@carfax.org.uk>
From: Peter Waller <peter@scraperwiki.com>
Date: Tue, 5 Aug 2014 10:51:06 +0100
Message-ID: <CAFChkquNFjOzMWqHnKG_SzHpUY1VAuWVT21RqzsDf3a_OK79Yg@mail.gmail.com>
Subject: Re: Stack dumps in use_block_rsv while rebalancing ("block rsv
 returned -28")
To: Hugo Mills <hugo@carfax.org.uk>, Peter Waller <peter@scraperwiki.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 August 2014 10:46, Hugo Mills <hugo@carfax.org.uk> wrote:
>    It's a warning, not an oops, so it's less immediately dangerous.
> The other key thing is "block rsv returned -28", which says it's an
> ENOSPC. My guess would be that you've got ENOSPC debugging enabled in
> the kernel, and that the backtraces, while scary, are essentially
> harmless (if irritating).

Ah, yes, thanks! I had turned on enospc_debug for the previous thread.
