Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34088 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755781AbcH1RfT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 13:35:19 -0400
Received: by mail-oi0-f41.google.com with SMTP id l203so170346213oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 10:35:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472355960.16760.9.camel@scientia.net>
References: <1472355960.16760.9.camel@scientia.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 Aug 2016 11:35:18 -0600
Message-ID: <CAJCQCtQ9fv9ewj_E7W69d9UR1YzdE87ZSPrSWmjJJhN3cwtb1g@mail.gmail.com>
Subject: Re: does btrfs-receive use/compare the checksums from the btrfs-send side?
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 27, 2016 at 9:46 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> I've often wondered:
> When I do a send/receive, does the receiving side use the checksums
> from the sending side (either by directly storing them or by comparing
> them with calculated checksums and failing if they don't match after
> the transfer)?
>
> Cause that would effectively secure any transport in between against
> transmission errors ... and also against badblocks/etc. on the
> receiving fs.
>
> If btrfs is already that smart, then I think this feature should be
> mentioned in the send/receive manpages.

I don't see evidence of them in the btrfs send file, so I don't think
csums are in the stream.


-- 
Chris Murphy
