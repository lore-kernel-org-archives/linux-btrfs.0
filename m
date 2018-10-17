Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E734ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 09:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193F721523
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 09:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vghqIsqY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 193F721523
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbeJQRKf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 13:10:35 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:42238 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJQRKf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 13:10:35 -0400
Received: by mail-lf1-f52.google.com with SMTP id s10-v6so19195705lfc.9
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 02:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pEr5On5t0wAUqHI2KrCUIVyM2jWo9pI4qIpErMTi94E=;
        b=vghqIsqYD3nfOIUSadgDAn3VGQBImTCWMe0Cylc0a3S2Be/ftUXIcTd+XuJV5mg6j3
         u1ko+7m9F2VzwY/e8cIEGyKg3P2wnDJ0jNjWyoBRfvsdkK72lAn1BGHIOFHi44Qd5fpl
         yKo8BZiA5ZUtDJddcBnAWDQc7IFw+wzzx1+3u3Qy4dLYC7AIsSrHTnGF1HHVejLBnCxS
         GDAF524JGPZzbcL/tBhcRcw+LET0nknDpDMk+JYVjZrOgCaGvuGu04Htb3yk54/aJ4Hd
         lH9JIxTEI4IdaLfqj3ngxcZX0Xg2FannqweE+C5LjV0/ByB8Rz4B8+QncsvooT82e3Tz
         HdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pEr5On5t0wAUqHI2KrCUIVyM2jWo9pI4qIpErMTi94E=;
        b=Y6oddOLYESDU6Wgj4ld7KSoToZCM5SVfgLbZZJS7HdIyw+oWRHy2UpPYClvjnlLhJX
         XfKU9/RQbVq5ktJ3gxNCHJmJEwreQ6P1gr38ys4ngSkSyt+Hex6owtDN3tMU3Sxg7c7o
         IvcpvW+Q/xmkAiPjN/FFlimbNq8IkGJ7aV8WTt/yn5PezZtbKxZapAImnySQIgsT+spa
         AfwkLOE2SH+ATU/Fa/FN1i20S7jprS83Rsm6YYA+xv+ZSwYrzP6cH53nRj9xWi2bw58J
         JgIwY36dXU+nxYWBOJ02JrJ5a0hfbuBqXdHTqy68T7QEL894UuyJ4axfpeB22s3Lh9TK
         wYuA==
X-Gm-Message-State: ABuFfogeatqzJUGM34y3yKnF/wyR+hP81C7ixeyYnOLfDHPqebU84KBa
        xmkZPNo5j4y3M1BlE/bkOTGV1dw6
X-Google-Smtp-Source: ACcGV62s8Sl4wgHC4sZvGpsjfYcymadyGx5FdJ0n/a46NJ1IjZSuggKI0ILXgmKOInWVDcaOhCUFIQ==
X-Received: by 2002:a19:d0c2:: with SMTP id h185-v6mr14837507lfg.81.1539767745743;
        Wed, 17 Oct 2018 02:15:45 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id m26-v6sm3670500lfc.30.2018.10.17.02.15.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 17 Oct 2018 02:15:45 -0700 (PDT)
Date:   Wed, 17 Oct 2018 12:15:44 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: CRC mismatch
Message-Id: <20181017121544.3d5e310a9266747d2367c871@gmail.com>
In-Reply-To: <CAJCQCtRrqOf+AzkH+-z++GTx9+Mh0-wA5PqQB9g0kDhBBCJ2qQ@mail.gmail.com>
References: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
        <f2df5862-ae3e-5808-4f00-e153f604df60@gmail.com>
        <CAJCQCtRrqOf+AzkH+-z++GTx9+Mh0-wA5PqQB9g0kDhBBCJ2qQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[I accdientally replied to Chris instead of the mailing list]
Chris Murphy:

>Is there still that O_DIRECT related "bug" (or more of a
>limitation) if the guest is using cache=none on the block
>device?

I know nothing about it.

>Anton what virtual machine tech are you using?  qemu/kvm
>managed with virt-manager?  The configuration affects host
>behavior; but the negative effect manifests inside the
>guest as corruption.  If I remember correctly.

This is a commericial system run inside VMWare.

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
