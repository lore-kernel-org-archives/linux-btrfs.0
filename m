Return-Path: <SRS0=fMWg=YC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A72ECE58E
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B262120640
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LRk5XIfg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbfJIOi5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:38:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45738 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfJIOi4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2019 10:38:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so3305888wrm.12
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2019 07:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:subject:from:to:mime-version
         :content-transfer-encoding;
        bh=oSgoOzXSMJUV/meWh+4YKR1b/UjVbkB5dxHC4fUF46M=;
        b=LRk5XIfgDiLRKBp/QR0JkMmoVejX7mb2V+EdYY4xNQopCUF/tTIzWdKQXPfB9qgf3W
         1EdT1xsYsxKVUT0WEitG3nOvVFarpzPM5IxLvjbtm6eM4TC3SKfi1gJpV9453+YeWt2P
         /v0F8N52NIF1GKtWAecSqHGrqcS8vRoUqre0/dkyJXs6Si/xN/Ri+FO+K5PuKhHCIlw3
         MKQb20qoL7mqfbZBzwmU+bEGbpMtBxJb/M1ZNj54UA6mKnvClRGEQWUuxlV49YEue6KY
         IFDApxCQFs65bQT5DKUM6VbuxaAoAJf+lQJLyA9kgm7ixrb4z+8aTqxeM1SEExxTCh/6
         wugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:subject:from:to:mime-version
         :content-transfer-encoding;
        bh=oSgoOzXSMJUV/meWh+4YKR1b/UjVbkB5dxHC4fUF46M=;
        b=ZrnS/aAmsh0F0sn0lLt2nJMS+VsSaIh7h+hPoZBuisFgBTcm4wxSRcGnHYE70u/P/h
         L4wM5tAzWhudn35sLKmLnjZ5GrXW0b63NSOUwPMuf/pO12mrWbfBho5QA3xcr0gBJzj1
         kOJAlkBSwyRhIjKB0bNs092y4Q+AjOslDLA1ygZsmDO1AM5h8PYwGWH+D4DgiWu1BXJN
         4aKFw5ODnlC3Mz6HsKo8+TY9f7t3U/TVnDb4cD3F/p7B8sqGgNJW/wbBWvR+rE2Q5fo5
         jMpdHCeKHGXfURm8qNmmp3/+TFyC6cWGSMQkvhtjk4Z5ZuWreL84ms10BNpkJsYIdTV7
         4avQ==
X-Gm-Message-State: APjAAAVQUML+ynLmI1J9rZKGLqKUmQjWKKitg6FppRBxbZM7ziR6YmnP
        Ney0NgnZl+ab6AJZfuz01LNn5egU
X-Google-Smtp-Source: APXvYqw+/j5SdrNWXGq3qLpBhE1sCdFHhFuSl+EuJkFFYL7DblSSAUrqVqjnLTRij+V74kPLsl2kVw==
X-Received: by 2002:a5d:56c4:: with SMTP id m4mr3095001wrw.195.1570631934414;
        Wed, 09 Oct 2019 07:38:54 -0700 (PDT)
Received: from [127.0.0.1] (212095005020.public.telering.at. [212.95.5.20])
        by smtp.gmail.com with ESMTPSA id y5sm2535193wma.14.2019.10.09.07.38.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 07:38:53 -0700 (PDT)
Message-ID: <2a2f542ad52eaa6aab3fb58ce72e3258@swift.generated>
Date:   Wed, 09 Oct 2019 16:38:05 +0200
Subject: Re: Domain eyecamera.de
From:   Matthias Jung <matzejungmj4@gmail.com>
To:     "" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sehr geehrte Damen und Herren

eyecamera.de Domain Name ist jetzt verf=
=C3=BCgbar und ist jetzt zu verkaufen.
Ich freue mich auf Ihre Antwort!=


Es gr=C3=BC=C3=9Ft herzlich

Matthias Jung

_________________=
__________________________
