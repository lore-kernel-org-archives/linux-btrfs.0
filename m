Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37350 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751006AbcJBUNB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Oct 2016 16:13:01 -0400
Received: by mail-wm0-f46.google.com with SMTP id b201so44893110wmb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 13:13:01 -0700 (PDT)
Received: from localhost (host86-130-216-236.range86-130.btcentralplus.com. [86.130.216.236])
        by smtp.gmail.com with ESMTPSA id y4sm15382359wmy.22.2016.10.02.13.12.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Oct 2016 13:12:59 -0700 (PDT)
Date: Sun, 2 Oct 2016 21:12:58 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unable to open ctree
Message-ID: <20161002201258.zummlz3ftiphfmn6@tiamat>
References: <20161002181754.wxved3j66dzrvfoc@tiamat>
 <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for your suggestions

On 02/10/16, Chris Murphy wrote:
> Well short of a bug, the problem aren't the checksums. The problem is
> the metadata is wrong, so if you recalculate checksums you're likely
> end up with an even more corrupted file system because it'll start out
> trusting bad metadata.
> 
> If you're prepared to lose this filesystem, use --repair and see if it
> can fix the metadata problems despite csum failures. If it were me,
> I'd take a btrfs-image before --repair. In theory, if it makes things
> worse you can restore the image, or donate the image to making the
> btrfsck better.
> 
> If --repair doesn't work, try -b --repair.
> 
> If that doesn't work then I'd probably use --init-extent-tree which,
> while it's a heavy hammer, at least still isn't going to pretend bad
> metadata is good which is what --init-csum-tree will end up doing.
> 
> But before all of that I'm curious what you get for:
> 
> btrfs-debug-tree -b 11185160192 /dev/sda3
> btrfs-find-root /dev/sda3

The output from btrfs-debug-tree command is: https://ptpb.pw/0weU
The btrfs-find-root: https://ptpb.pw/PIZe
The btrfs-show-super -f : https://ptpb.pw/O4C9

I tried the btrfs-image but failed
# btrfs-image /dev/sda3 /root/sda3-btrfs-image.bin
with output https://ptpb.pw/jtDJ

Unless there's some other idea I will continue with the following:
# btrfs check --repair
# btrfs check -b --repair
# btrfs check --init-extent-tree --repair

and see if I can get something

Thanks,

-- 
Leonidas Spyropoulos

A: Because it messes up the order in which people normally read text.
Q: Why is it such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

