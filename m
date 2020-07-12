Return-Path: <SRS0=7zqG=AX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,BODY_SINGLE_WORD,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05194C433DF
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Jul 2020 19:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F2B20674
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Jul 2020 19:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b1JqgyKm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgGLTdC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 Jul 2020 15:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgGLTdC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Jul 2020 15:33:02 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41867C061794
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2020 12:33:02 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f2so4512595plr.8
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2020 12:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:user-agent;
        bh=iPHrAwh/I6LdHdDngN6o15P8EjNanSMIIyTPQRdDFXE=;
        b=b1JqgyKmsOb/LXmspcLfKuB3hWgmGQHBc/6tgR03LZnLsz9hXsz6/jUAwfMxRi5t2x
         2xHnnSBjL+duwSeekz5siwelKV4HT9vCDG1Prm41L2nM/+3np0Wmx9jIcMMR+uZoP6bP
         Cqq9buDBFUhjqUVQLCkIchaTRZ0Rf9oUb0L8TFmRKwrOJAE48ugulemt1PY96kKCq3WI
         ZfN1Kf+oOxFZxOwhV7xL/lcsxSYLYXm7zWl2xVOzxc/1kVEkAi/KjBTMK+jB+KNwBe5t
         +fm8v039TgtHcOW/38FVzs81nHmrjlm+y8YqX15pwStqAUxkYXvb1e+Vy9m4xrjzbC4b
         keoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:user-agent;
        bh=iPHrAwh/I6LdHdDngN6o15P8EjNanSMIIyTPQRdDFXE=;
        b=bY5YTFhW29hKyuwq3+g+iHCuW4kbuUy5pVqw5LBgYs4fNvax3MPgDrUHRo8bOFtmqs
         2m5PQ2duV6AjKELlwB4ECp8xTUi6YcvpwXeeEc5crFOfamQPLbs6qqUEIAS3iEQE+mfQ
         Gu5B9h0FdnT17OeCSpDLQIjBsIpGShXKLo2G8RHbMFwTW4vj5K5t3y0k3gRos8eXfcD1
         ZWT7bXbOBq2/uJh5Ghoc+9lg/tGf5kEwfQXTGOSc0ubU2oGnzcNDC3AZ8lpfQt9bVFvN
         rT1CRwJsdXeTW5EQFiLGDtuERDIWYQk35Sayu50LRTLsw8a/H7F6VZWsZuqhg9n+ww1o
         judQ==
X-Gm-Message-State: AOAM531z7P65GT+VR4KPGoBTG++MD959wrD6lgypssvRGQ0M0MpOE3Oy
        uxrjojP43qd5ii7jGyHM23kEAmWTCqc=
X-Google-Smtp-Source: ABdhPJwEmu2koQRiPWWT3/IwPlK4KYh1kkUh0qf6KEPoN4Wf1uOt5HPbd7gFufxkc3P2BiS88tv4Pg==
X-Received: by 2002:a17:90a:8009:: with SMTP id b9mr17613956pjn.190.1594582380732;
        Sun, 12 Jul 2020 12:33:00 -0700 (PDT)
Received: from ersa.localdomain (node-1w7jr9qqyrgwg590lie18grb0.ipv6.telus.net. [2001:569:7a01:a900:f4ab:71f5:21ab:fa3c])
        by smtp.gmail.com with ESMTPSA id m1sm11944752pjy.0.2020.07.12.12.32.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 12:33:00 -0700 (PDT)
Date:   Sun, 12 Jul 2020 13:32:59 -0600
From:   Ersa <paul.kulyk@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Balance bug
Message-ID: <20200712193259.iRwJJ%paul.kulyk@gmail.com>
User-Agent: mail v14.9.19
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

post.txt
