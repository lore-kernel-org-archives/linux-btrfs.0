Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:34765 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753332AbdBDCzq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 21:55:46 -0500
Received: by mail-ua0-f194.google.com with SMTP id i68so3025985uad.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Feb 2017 18:55:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
References: <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf> <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de> <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sat, 4 Feb 2017 08:25:04 +0530
Message-ID: <CAKuJGC-3pmzOWmaUZx-xav9W1zp+m=1PLhunKDm2Cw80c+6-Fg@mail.gmail.com>
Subject: Re: Very slow balance / btrfs-transaction
To: Jorg Bornschein <jb@capsec.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Should quota support generally be disabled during balances?

If this true and quota impacts balance throughput, at-least there
should an alert message like "Running Balance with quota will affect
performance" or similar before starting.

----
Cheers,
Lakshmipathi.G
