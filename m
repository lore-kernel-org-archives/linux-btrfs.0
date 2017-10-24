Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:46832 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdJXExM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 00:53:12 -0400
Received: by mail-vk0-f47.google.com with SMTP id k123so12539381vkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 21:53:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 24 Oct 2017 10:22:31 +0530
Message-ID: <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Zak Kohler <y2k@y2kbugger.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Does anyone know why scrub did not catch these errors that show up in dmesg?

Can you try offline scrub from this repo
https://github.com/gujx2017/btrfs-progs/tree/offline_scrub and see
whether it
detects the issue?  "btrfs scrub start --offline <dev>"


----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
