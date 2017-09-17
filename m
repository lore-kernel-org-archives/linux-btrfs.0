Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:44613 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdIQNIl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 09:08:41 -0400
Received: by mail-oi0-f49.google.com with SMTP id l74so3499119oih.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 06:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87poaqyxdi.wl-satoru.takeuchi@gmail.com>
References: <87poaqyxdi.wl-satoru.takeuchi@gmail.com>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Sun, 17 Sep 2017 14:08:40 +0100
Message-ID: <CAMU1PDiJofgOQZ3g5Fq35huWuPp7fKFdC+KR2KjCkqGrP9aUzw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: allow "no" to disable compression for convenience
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17 September 2017 at 01:36, Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
> It's messy to use "" to disable compression. Introduce the new value "no"
> which can also be used for this purpose.

>From an English language point of view, "none" would be better.  None
says the absence of, where as no is more general negative.

Mike
