Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43430C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 01:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07C4121773
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 01:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jXbH6UEx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfBRBdr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Feb 2019 20:33:47 -0500
Received: from mail-it1-f175.google.com ([209.85.166.175]:53693 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfBRBdq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Feb 2019 20:33:46 -0500
Received: by mail-it1-f175.google.com with SMTP id x131so36356288itc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Feb 2019 17:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sJ/JDEpo1pVHYMexjCZ2qMJcNhY6xrK2N/RU0PvdjdY=;
        b=jXbH6UExB0vmPeZt02rgt0KkDG+ctqplIH1g0jwr5QjWBVcPRo+PjZ5pkUS4FuFLfE
         ECsfA9kULkPftruz15RNCaAKkZgIRSwBZNxUSnpLLKHof/raRuYIJdy6atmg9VwXT3l4
         y3n4GEi7NR0lRxas9Lwzn6AZunucLsF68oJvG35dEGpRCvM1Tl+Hc2LLsNszPEzEBjnE
         tL//krKvYFhndWN9rN+PHF6d6CVpFfHxbDim34acJ63b9KKVYuymrm3QW+DHcZ/H2vVY
         I1GcyU9pvq9AHkNkQtKG7exbAU40FeCBn7QL8M2WVsi9PqkHambpmSwd9n4VgtKtg+5n
         cOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sJ/JDEpo1pVHYMexjCZ2qMJcNhY6xrK2N/RU0PvdjdY=;
        b=I8Xf8wL45lCxGmm/mD+pyCelEDY1+RkXkyk5VP96+7fMVEK1h3WQDCfxQ7F7LpGnCC
         Y1jgQL3N72RahHVMerifJRbBB2AXnaqxV8h+U/BYZrObLsXL/diPLsUvmu7/c/KKC9d2
         6KBP8wJbncK2+FsB95gizZ/atvs+ubsNt2y7NGYRE1iuHwyjW8cFZSJrKu24ggvxyW3X
         kAQKmJX0nUB7KD411tVEOtHgIjUAvncOMoNvug2UtcHTGy5EhDKO6OtEzIaxVBaAm2XA
         dEkfPbaoFK2StdhaMY/BKRLSKe+pFXfnOKUaFl7N0aPCmtsql7vx2PH1genUc+Umn9ev
         h+8g==
X-Gm-Message-State: AHQUAuZGPIW4l70cW8GXJR9gff+t3QQkhACdYPTcpIKlV0veVCG0j9H6
        xhCYrMjCwGiIZ8KDTIV4RACL0NjtEgwk1jUjraWUoN7A
X-Google-Smtp-Source: AHgI3Ia8ZLIYR8KPbcDyapD9HLb/u+IxXTzs/bgL2Ra6u+kILQ5lEkSLossvP8Adj1woOsRMsh3X2NOrAaxGqNkT6uw=
X-Received: by 2002:a24:1d4a:: with SMTP id 71mr9751313itj.62.1550453625552;
 Sun, 17 Feb 2019 17:33:45 -0800 (PST)
MIME-Version: 1.0
From:   nstgc379@gmail.com
Date:   Sun, 17 Feb 2019 20:33:34 -0500
Message-ID: <CAMOGTQm-xnYjetpQ6jzDL6Do4PZQwpHL0W_fGTzcWmW+4Npadg@mail.gmail.com>
Subject: Errors after kernel panic not addressed during scrub or fsck.
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I have an issue that I first experienced a few years back which was
never resolved. The timing was really bad so I just scrapped the
effected volume and made another, but I'd like to actually fix it now.

My system went down as the result of what I assume to be a kernel
panic. After rebooting I ran `dmesg |grep BTRFS` and found two lines
which concerned me.

    [    9.493064] BTRFS info (device sde3): bdev /dev/sde3 errs: wr
432, rd 0, flush 4, corrupt 8, gen 3
    [    3.086233] BTRFS info (device sde1): bdev /dev/sde1 errs: wr
5711892, rd 14399372, flush 104, corrupt 467, gen 2

I then scrubbed the effected volumes (both RAID1s), but no errors were
found. I've gotten messages like that before, and scrub normally
identifies that there are errors and fixes them. I then also tried
running `btrfs check --readonly` on the devices, but again the test
showed everything was okay.

Admittedly everything seems to be working.

$ uname -r
4.20.7-arch1-1-ARCH
$ btrfs --version
btrfs-progs v4.20.1
I don't have any journal logs as a result of the crash. `dmesg -l err`
doesn't show anything out of the ordinary (complaints about not using
ECC memory).
