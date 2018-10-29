Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4630C2BC61
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 06:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 722E12080A
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 06:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNO6Dfpz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 722E12080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbeJ2PFw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 11:05:52 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:43192 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbeJ2PFw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 11:05:52 -0400
Received: by mail-ot1-f47.google.com with SMTP id k9so6456962otl.10
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2018 23:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YA5AafD7Ryor7OmkSXHf8BEG0/I7w4jnSg3U1Lb40jk=;
        b=oNO6Dfpz9m6NMfZrJVe5KxhqKa36fJVEr+EcnkYfPrGOAoorhFn4Eq1HLXDZ+vTKdC
         Js4nYUIvpGKmcaERT8BMS+V6fQ7o9frSr69FRzvUsIUkfnXAHthsg0b9Iu1Bc6OFrJCh
         xLQlpMJf47Xw5FkNHxJ7Hf/ABqWQAyrFAekuHFQ04a+1/7KiRHZyvCrcGXssx4liQ4iQ
         DncHhurYj2KQ9a8ZzoYhrt59I+UQDcrac8KtsvDKVwbZDiResyZMfbrgxo20z/jXTYmv
         NIMHyO5YW9kDmgNmeS9rziPIt5s16+Zw5lYTmgOppBQXhZEPOaikOJ+gbvcVu+F6lRrk
         wx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YA5AafD7Ryor7OmkSXHf8BEG0/I7w4jnSg3U1Lb40jk=;
        b=bSo6AaHzawyBL0Pyj87uU59kp5a9TRbZxk5j7N7phJJAZCEZ+PD9WoMVIw1BTH2gux
         NxTaxzcpi/GO/m6BTTe+8vcPJbAYM5XzwzWqPcEdR4qSoHiS5W/yb6P8mG/y8Hgis9La
         ziKSipa1R9yiopBj2I7fKzNjAwe7Wm6vYgyife48HH7mxhW5QLSP1nf7EhPUj/szf1Xu
         1sxdTbCLdnHSvNJHt4btCybAkrS3gJcBKMl4lPy0PgGV1jVRXAeHg6wE80SK9X8EMvZx
         NUyLFTIjyI+iFPr5MHV0X1yHDcxpzw8+YOQWK53K98VT2d9/zPFb0ASrpzghRT0dfYol
         3qhA==
X-Gm-Message-State: AGRZ1gIutrkvlBCu3hLV6BgE1O0xd3nTop/949Xzyoh/uphuTtar+GnA
        dThg+sLOquNYP2Nxjh4N9BFE77b2o/WwExUTuh0h6XpM
X-Google-Smtp-Source: AJdET5dkK0X7NpdKI3cSOOOdh9doUxo87S4ucbyDX0u+5BtKPziWaQbwOr5YslIE9UjkyS6yVGQ6Oa4YQPhJ6+JcCA8=
X-Received: by 2002:a9d:4491:: with SMTP id v17mr2591363ote.219.1540793917509;
 Sun, 28 Oct 2018 23:18:37 -0700 (PDT)
MIME-Version: 1.0
From:   Dave <davestechshop@gmail.com>
Date:   Mon, 29 Oct 2018 02:18:25 -0400
Message-ID: <CAH=dxU4QoRn71+JF3BYC3OZ+=PHfwy59thiVRrZ9OhjxNVzULA@mail.gmail.com>
Subject: a new kind of "No space left on device" error
To:     Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is one I have not seen before.

When running a simple, well-tested and well-used script that makes
backups using btrfs send | receive, I got these two errors:

At subvol snapshot
ERROR: rename o131621-1091-0 ->
usr/lib/node_modules/node-gyp/gyp/pylib/gyp/MSVSVersion.py failed: No
space left on device

At subvol snapshot
ERROR: rename o259-1095-0 -> myser/.bash_profile failed: No space left on device

I have run this script many, many times and never seen errors like
this. There is plenty of room on the device:

# btrfs fi df /mnt/
Data, single: total=18.01GiB, used=16.53GiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.00GiB, used=145.12MiB
GlobalReserve, single: total=24.53MiB, used=0.00B

# df -h /mnt/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdc2        54G   17G   36G  33% /mnt

The send | receive appears to have mostly succeeded because the final
expected size is about 17G, as shown above. That will use only about
1/3 of the available disk space, when completed. I don't see any
reason for "No space left on device" errors, but maybe somebody here
can spot a problem I am missing.
