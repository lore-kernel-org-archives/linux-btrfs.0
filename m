Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35836 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbcIMVG5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 17:06:57 -0400
Received: by mail-oi0-f54.google.com with SMTP id w11so31211325oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 14:06:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3756c0ee-4f64-7974-932c-0a1615c658c8@gmail.com>
References: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
 <53969836-4a5a-f842-6156-3f88a78bfc4e@gmail.com> <3756c0ee-4f64-7974-932c-0a1615c658c8@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 13 Sep 2016 15:06:55 -0600
Message-ID: <CAJCQCtSckyab3JzmW+82GWCCdmMNnNVauT9bs8da1BTGdm0v_g@mail.gmail.com>
Subject: Re: Filesystem forced to readonly after use
To: Cesar Strauss <cestrauss@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the fsck...

bad block 160420741120

I can't tell though if that's a bad Btrfs leaf/node where both dup
copies are bad; or if it's a bad sector.

I'd mount it ro, and take a backup of anything you care about before
proceeding further.

smartctl -x might reveal if there are problems the drive itself is aware of.
