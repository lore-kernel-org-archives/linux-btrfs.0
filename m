Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A6DC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 16:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F041C21873
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 16:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljSVVjaA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbeLRQiq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 11:38:46 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:39422 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeLRQiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 11:38:46 -0500
Received: by mail-wr1-f54.google.com with SMTP id t27so16592033wra.6
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 08:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=n2qM2c7KXwBNnLPy8HYNW0FCJkwZQvVKsqi7qHvET7o=;
        b=ljSVVjaA5LhG1PXeGcxp9iu7BtLberchdnwt8Dlp5pL2NkcGzeLsnnOgbDE8ULC66e
         M70eYq1R6Zx9yV+o9ceo0x2X6yDKBWaR5CjRkaiSbBjabey6Vm/HsEyhsxZtHnqRKxvJ
         XKd1m4Jw1Gc+3lgRk4bJuBK+dUxQdBynRwxcR63rrl1+PyjuB6Nqc+bLNILDLCQRMaji
         4W77sWohc4NY0tlYY/LirMfscGmG0FD5TSKRTUBbGX2FV4j/r9kiwt99RQLFKp2KmrnX
         22SBaj0U/j9SrvI4ikgz3y3B1seJp4eLuXKoyu7dULjuDrcNys77sibxrlrIRGaPGxIq
         jmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=n2qM2c7KXwBNnLPy8HYNW0FCJkwZQvVKsqi7qHvET7o=;
        b=fhIi89CkfeY80THM3AArmPtJq0pwFHyf/0CWPL8T4Ec4/wuR/PLz96QaSozkt0r9Ua
         SIAF7Qr0YWpc4GWFOsSA9CHFyfRv1q74iE9L/ut/4ATCO90BkvG6/0kg7YQ4VBrKG4qi
         s3jQ0VTsCnQpwVi2vVcocTM41WYAYgHyf0S2NFHuU0MkXbvUdAxvf4HuP20OKT20XW4N
         /n8JtgHH7bn6SRUc9Kb9pjdY0D/SwBOvwK+LJoD7H9LjYRirJSEpD4WRvGpPwEbQRv/0
         BzdAcbLXGl+K4PXFzQ9VsEcq5hnasLy57ArhkFlJI8HpCWZdAu2MsFfWE+dv7nUyx/9f
         Cx8A==
X-Gm-Message-State: AA+aEWY00uGEiBZrNrr2Z+xX7nq4IwLZhyT6fkFBEW3kIVECOhzfgtVX
        dcL9vucdtSMglqf2sqQua6yHsOSB
X-Google-Smtp-Source: AFSGD/Xk6n01vZX38xkDh4DA42//IKbcBxsSBa/iFDdYy3z1HBy9d8lEPQ6+Qu4BmxqhqW98LIRdwA==
X-Received: by 2002:adf:9168:: with SMTP id j95mr14903938wrj.217.1545151123213;
        Tue, 18 Dec 2018 08:38:43 -0800 (PST)
Received: from [192.168.1.51] (ip-78-45-105-225.net.upcbroadband.cz. [78.45.105.225])
        by smtp.googlemail.com with ESMTPSA id j33sm5316711wre.91.2018.12.18.08.38.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 08:38:42 -0800 (PST)
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Better data balancing over multiple devices for raid1/10 (read)
Message-ID: <acf42b0d-4c38-8010-f50b-92aed2444884@gmail.com>
Date:   Tue, 18 Dec 2018 17:38:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, regarding Wiki/Idea pool:
Better data balancing over multiple devices for raid1/10 (read)

By looking at [1] (which I currently use) and [2, 3, 4]
is there agreement to solve this?

[1] https://patchwork.kernel.org/patch/10681671/
[2] https://patchwork.kernel.org/patch/10403299/
[3] https://patchwork.kernel.org/patch/10403303/
[4] https://patchwork.kernel.org/patch/10403301/

TIA, Z.
