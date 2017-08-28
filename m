Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33740 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdH1MDu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 08:03:50 -0400
Received: by mail-wr0-f174.google.com with SMTP id k94so1074976wrc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2017 05:03:49 -0700 (PDT)
Subject: Re: deleted subvols don't go away?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1503854146.5155.2.camel@scientia.net>
 <CANznX5Hs9i5PzeJib=XGuDwPzUCEbbvh8LrY1+7xwpadB8BiNQ@mail.gmail.com>
 <cab790fa-22f7-b05d-b18e-000c7d1a81cd@gmail.com>
 <1503907621.1671.5.camel@scientia.net>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <83c6b0bb-a120-e0e3-dfc3-069ede63906f@gmail.com>
Date: Mon, 28 Aug 2017 15:03:47 +0300
MIME-Version: 1.0
In-Reply-To: <1503907621.1671.5.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.08.2017 11:07, Christoph Anton Mitterer wrote:
> Thanks...
> 
> Still a bit strange that it displays that entry... especially with a
> generation that seems newer than what I thought was the actually last
> generation on the fs.

Snapshot destroy is a 2-phase process. The first phase deletes just the
root references. After it you see what you've described. Then, later,
when the cleaner thread runs again the snapshot's root item is going to
be deleted for good and you no longer will see it.

> 
> Cheers,
> Chris.
> 
