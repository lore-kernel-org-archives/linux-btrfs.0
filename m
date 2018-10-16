Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CCBC04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 14:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835652089E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 14:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smUcN0n2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 835652089E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbeJPV4U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 17:56:20 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:42169 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbeJPV4T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 17:56:19 -0400
Received: by mail-lf1-f44.google.com with SMTP id s10-v6so17018475lfc.9
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2018 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=/mFD/s/seoFodSh82DP6xZoM0v+3pAJp/zhMJXpDVg0=;
        b=smUcN0n2zA+TazhK2/x4rseVylvKYDdmDkkwLPU6CsSUuTU9z1gMT17s4/8GP1tQz9
         taTVo41/GwH378lRJ4PLj2LwGDitSAvpq2smUmpNZXcCoeqQHC5xaC7c8PRLB/Ycar5s
         viusdgXbr0TdYkb3oj0jigXs8mlL8qO5RpK3qkR2jAoUn5jUdk9g6GF9AbUQPruXyqUF
         2fSJMsopa63Hw9SanqBHKW7QkatGTgVY+PYSLAiYTbW5Z6SQ4XXGSbseSce2bpHG3dv6
         H4IojVESvSx53KK+GKuNW9r7NBCDbSo6hzSUPSgpSM+ebpmLwtbntyE1jdXfUk+2pgYc
         JP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=/mFD/s/seoFodSh82DP6xZoM0v+3pAJp/zhMJXpDVg0=;
        b=q0aJy6ge/iy8NnzgT8TyvDwSGwScUZxiB0VXbV8nTy6az4+CCgHhmZDNl0QcRfAx96
         wJlkMEGM6ByoWePRWNZaXWQ+06xTlzf3ZXCbWtsxLWtVKUETMH1CXh0rXCU1Iu6dquHU
         jxOu0aKU9qKKeFBsJa4cqOT51Z7z4qrvHIcSpH7DfXY5+rC3hlFT316bCyIJWor5fYBf
         Oj8ulvGM13nBfugLninO3RafX1MszYnpgBsOj3Qpbi/k62sdqSn90RATOifuP82/O7h1
         a9JMLUQxTkKMjgyjZnxtcLSB/CPcnGtQW6j3sMI7L5tuudNBMhlkuMcwm8GNVTzsHAZY
         OV5g==
X-Gm-Message-State: ABuFfohiZoiIitHB6TdIdmoR3Li5XGL7U8i5mpknp7fYejdu11souGiY
        Ht9JoYUy2MuuxD67yABDkbHlIuir0Y0=
X-Google-Smtp-Source: ACcGV63D/T9eN6ZbIXWWQ4xKlxxcT7n5YXltcxVZ5eln7pq/6sMiRDgl5btrxWbRP7Facnxe1bMDAQ==
X-Received: by 2002:a19:41c9:: with SMTP id o192-v6mr1494839lfa.93.1539698740428;
        Tue, 16 Oct 2018 07:05:40 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id p24-v6sm3215313ljg.57.2018.10.16.07.05.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 16 Oct 2018 07:05:39 -0700 (PDT)
Date:   Tue, 16 Oct 2018 17:05:38 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: btrfs check: Superblock bytenr is larger than device size
Message-Id: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, all

On all our servers with BTRFS, which are otherwise working
normally, `btrfs check /' complains that

   Superblock bytenr is larger than device size
   Couldn't open file system

Since am not using any "dangerous" options and want merely
to analyse the system for errors without any modifications,
I don't think I must unount my FS, which in my case would
mean booting from a live CD.  What may be causeing this
error?

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
