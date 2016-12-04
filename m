Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35278 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbcLDUVW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 15:21:22 -0500
Received: by mail-yw0-f179.google.com with SMTP id i145so244752258ywg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 12:21:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQcz6W-UD5eDAiWG1QJk3tSF7boN2haG_Du=PD_U6rx1g@mail.gmail.com>
References: <CAJCQCtQcz6W-UD5eDAiWG1QJk3tSF7boN2haG_Du=PD_U6rx1g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Dec 2016 13:21:20 -0700
Message-ID: <CAJCQCtSLAjBhOCFHPLjp7gn2-GKjHP7_yJbfE1rdaozuQnHvEw@mail.gmail.com>
Subject: Re: btrfs fi du is unreliable
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another example:

[chris@f25s ~]$ sudo btrfs fi du -s /mnt/first/everything-new
     Total   Exclusive  Set shared  Filename
 367.54GiB    14.21GiB   350.95GiB  /mnt/first/everything-new

The problem here is that Exclusive + Shared ≠ Total. Rather those two
add up to 365.16GiB, which suggests 2.38GiB is neither shared nor
exclusive. What would that be? The total not equalling shared +
exclusive is the most common bug I see with fi du.



---
Chris Murphy
