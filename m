Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E98C432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 02:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87FE52068F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 02:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WsD7wMrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfKRCJm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Nov 2019 21:09:42 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:51488 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfKRCJm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Nov 2019 21:09:42 -0500
Received: by mail-wm1-f41.google.com with SMTP id q70so15655469wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2019 18:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=rqF3FzjOPuFlnMei6yp+hU41oMeUhgrF+AdRFUcH8fc=;
        b=WsD7wMrbjnq1vP6Qd2T6c60Erg4Z3NraFa2MBCVyeMQuljjXaJX6V1IybR65Bq4AVh
         2y0fjGsfv4RbxPl3+tFrYhfvJYHRpAln1ZimsycZEShQ45ppriVzIAE/QgnT/opI15eX
         U7ziAhmDoJaEjrG49rrfjmX/yD9X8TqOBRAEfsCR+mu4+Q8l9Ql1S7f31ph4fY/aKgKF
         ar3Ben1OfCEJ0jlW1IBhg7TypjyEUrqdyF9jlGKNNngk/PyF2Q0nKgnUeGFx0NPNOTfY
         ghUr6mUa/PVdN6Ix9qgEZZ2enWXhhXol+YVB3jDz4UEmzbwt7tMNuQBBBqj7J4osqsEB
         QQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rqF3FzjOPuFlnMei6yp+hU41oMeUhgrF+AdRFUcH8fc=;
        b=tDdvQS/e/FXZAcuaqnAuKd6FMSBZ+ZSRC2mYh1uasVoK4zfeaFrELWJWxwd2pyuD6j
         nY7BCmEUHifJomQSYiPz1PIdq6gS49pVMGOupHNk0fDtT6+R9WUuczs8Ld3vzIZA+H9g
         zD0qhXmFmTISySBOQXTNTVBMdHK27kWOmp9jYubsQIUmPg3YufMz5kxyZDrbvWvj2nIl
         LIrPdI0eBU3rOZO8By7g6y3G7d2z3gcGaTY1Zo+5565YPYcRz5p4UGVqiGkoNdSXNnwV
         4agv18EnAYhRcnJ67pbTFS0HI5LpIedKQ74XhVs1UTcrsuL7/JRk5fmTxf3JYUL7xXbz
         E8FA==
X-Gm-Message-State: APjAAAVNWlmt2f59dNvlQRki7LiDX/J6uiK80qpHz/KVDxuwaOM1tkkJ
        lAcKc7ByYRdVnYcyvA1LQm2xtKMiJeAI93fIOohZ9yRuvjk=
X-Google-Smtp-Source: APXvYqyobqeKfk/0X7+ZJbVRtaGwNq96UgM/udzeePJs59FzCu3qdelwvKoyAmN23lZMpab2p1Z+4AQpOVwHOrkrLUY=
X-Received: by 2002:a7b:cd0f:: with SMTP id f15mr15518185wmj.127.1574042980500;
 Sun, 17 Nov 2019 18:09:40 -0800 (PST)
MIME-Version: 1.0
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Sun, 17 Nov 2019 20:09:28 -0600
Message-ID: <CAEEhgEt_hNzY7Y3oct767TGGOHpqvOn4V_xWoOOB0NfYi1cswg@mail.gmail.com>
Subject: How to replace a missing device with a smaller one
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a 10-disk raid10 with a missing device I'm trying to replace. I
get this error when doing it though:

btrfs replace start 1 /dev/bcache0 /mnt
ERROR: target device smaller than source device (required 1000203091968 bytes)

I see that people recommend resizing a disk before replacing it, which
isn't an option for me because it's gone. I'm replacing the drive by
copying from its mirror, so can I resize the mirror and then replace?
How do I do that? Do I need to run "btrfs fi res" on each of the
remaining drives in the array?
