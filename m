Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34851 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbdFUDbo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 23:31:44 -0400
Received: by mail-wr0-f171.google.com with SMTP id y25so76912805wrd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 20:31:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170620231202.GB5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk>
 <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk>
 <20170620154429.GC22987@merlins.org> <20170620231202.GB5303@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Jun 2017 21:31:42 -0600
Message-ID: <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space
 :-17 => btrfs check --repair runs clean
To: Marc MERLIN <marc@merlins.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 5:12 PM, Marc MERLIN <marc@merlins.org> wrote:

> I'm now going to remount this with nospace_cache to see if your guess about
> space_cache was correct.
> Other suggestions also welcome :)

What results do you get with lowmem mode? It won't repair without
additional patches, but might give a dev a clue what's going on. I
regularly see normal mode check finds no problems, and lowmem mode
finds problems. Lowmem mode is a total rewrite so it's a different
implementation and can find things normal mode won't.


-- 
Chris Murphy
