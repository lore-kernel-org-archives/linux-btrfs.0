Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36603 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbcJBWFv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Oct 2016 18:05:51 -0400
Received: by mail-wm0-f43.google.com with SMTP id k125so117091426wma.1
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 15:05:50 -0700 (PDT)
Received: from localhost (host86-130-216-236.range86-130.btcentralplus.com. [86.130.216.236])
        by smtp.gmail.com with ESMTPSA id l3sm31221414wjp.17.2016.10.02.15.05.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Oct 2016 15:05:49 -0700 (PDT)
Date: Sun, 2 Oct 2016 23:05:48 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unable to open ctree
Message-ID: <20161002220548.skncaa6iipyvwscs@tiamat>
References: <20161002181754.wxved3j66dzrvfoc@tiamat>
 <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
 <20161003012225.089c4d38@natsu>
 <CAJCQCtRw+TMEDx9aPROdKSgbNDDw1PwkS2r8u-Lg_jyetv6wtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRw+TMEDx9aPROdKSgbNDDw1PwkS2r8u-Lg_jyetv6wtQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

After the command to rebuild the extent tree
# btrfs check --init-extent-tree --repair /dev/sda3

I was able to mount and run successfully a scrub (not sure if it would
detect something though).

Next was reboot and try to boot which was successful as well.

I'll keep an eye on the dmesh log next days but seems it's ok.

Thanks for suggestions all,

Regards,

-- 
Leonidas Spyropoulos

A: Because it messes up the order in which people normally read text.
Q: Why is it such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

