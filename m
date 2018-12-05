Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FA5C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9728020850
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rSxmqVSX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9728020850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbeLEOkX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:40:23 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:36659 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeLEOkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 09:40:23 -0500
Received: by mail-ot1-f50.google.com with SMTP id k98so18824461otk.3
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2018 06:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1hJW27RlMjzhZ+GUJrfBdsFAYDUQD0OJNo9mMnetvpM=;
        b=rSxmqVSXJQ1ox+LedgSxwg7I7UozrBF9nNSgMmrpDgkfOGJzuokRl9/BkK6hGZNi8/
         Z05/dtomF4nkLprTgHu0q5jQEA/zb+X8eS3WJCCJN0WwXHsjUYrL+kLnyF0fnM6L1XG4
         /OHvAfdblpE78I5oZb5cV7I1TFLc79nmQA3L3C4ROK/l48snHEwdEFdmzr7KdckhhieI
         1jxKPH3o2bNEbm5jIfvtgx/gD6y8lPw7LZHKhT/iLeYA5xrAXAUxUFwAkZ+u0t0KcRFs
         C92P2Ls4cNSBotX7MXLierlwPsoZA8UzvolL+4kgfHPdiO5O0mO5FxSqBUubyk3AUQsM
         QLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1hJW27RlMjzhZ+GUJrfBdsFAYDUQD0OJNo9mMnetvpM=;
        b=RMn52jBWobhMEUd1tV4ZHhY9JZJb1xH6fcEm7IIZNQ5s5VmVeEuDXNWN62YDOKzZ66
         bJxekyYfjNSZfZlZsn674Wb1oa/cSCIgVmDSCMnXNSpKm10XTpfEoWITtYlRzKdT9pvN
         tFivBUt6ZfM+v9HhHByKQk3Aqer2q0e+UlPD4jMu6shojMyxMk0hXWHmNtWSdNlivdfR
         ADuvEagov/4DRtkhNtXEZQxNK3NTRFrfzJCcL2DprYnTcdy9VbCw3bt/rkQQMv05Oknk
         HjSOmWz/BM+fci2YITFeWZueuNPRtRcRMrTu1nspVr3ufbbO8dmW7yB6YIo9uV87zVUR
         zsMw==
X-Gm-Message-State: AA+aEWb4KxOfDh6sH/3qQcWNLemaeNKTW/0wjJJBcxVFg2FLWrJJdlMH
        R2UsVfjGYSAnDKkz+qcj015gNVNN4idVVg9EQyNMMHYwZ0s=
X-Google-Smtp-Source: AFSGD/UDITLWAtM1FRYoTpOfp0P/dxZt+RlSMo9KMB8mQx3tpbo3Mc18K6VecyBPiaG64FzOw4pC9u5xMvKdR+cwyLc=
X-Received: by 2002:a9d:4201:: with SMTP id q1mr14313345ote.126.1544020822230;
 Wed, 05 Dec 2018 06:40:22 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?0KHQsNGI0LAg0JrQvtCy0YLRg9C90LXQvdC60L4=?= 
        <alexander198961@gmail.com>
Date:   Wed, 5 Dec 2018 16:40:11 +0200
Message-ID: <CANtEx+CBYP2KDU=t4AcanjjdY4g6aJn_5stV7Xj01JsDfK-OTQ@mail.gmail.com>
Subject: Fix for https://bugzilla.kernel.org/show_bug.cgi?id=200085
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello
Is it correct way to fix this issue as add max retry count
https://github.com/kdave/btrfs-progs/pull/151/files
I have added max retry count ? is it correct way to fix  this ?

Thanks
AK
