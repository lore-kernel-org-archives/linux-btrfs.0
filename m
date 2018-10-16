Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E709DC04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 15:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8708D208B3
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 15:30:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sI74YKl/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8708D208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbeJPXVy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:21:54 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:41615 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbeJPXVy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 19:21:54 -0400
Received: by mail-lj1-f176.google.com with SMTP id u21-v6so21291729lja.8
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2018 08:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=NPU1Oegqbm1qqGsQ+wPonMbeusgy73czY5uMNCtWZYg=;
        b=sI74YKl/D16i0rIxbu+eTcPBNIfSa+PeXd5XsCYOLGioJ5Q5fO/C5QXvQBzGDwl4wt
         NdtAly17OkYUmgST7vLxjutDTivvBCyneK5YmtBYeaySWhtCO4MEKIytiUia4qHxdxkB
         x9k3RZA5mWUHBFv2axqpr2EN9szTHrOGWblhoxMeSVJGFlxY1Ddb6OpIKd1XFzrCYn+6
         OJcrgpVVjfNjmwS5QAw7PbaZUhLTAUC8TInqss6lGaX1QdI+LrbnCGcrqBKxdPKPZnrY
         90jKaf1sz1LInmiJuNipPzaLcFMprjUEe+4YyZEkN8l/V8MnR6NTLivVVS1G4PYKDodq
         58SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=NPU1Oegqbm1qqGsQ+wPonMbeusgy73czY5uMNCtWZYg=;
        b=CpBv+9o4KGIrUghr8WzUOSUF/pUlonyyzLpSIUyXnk+jh3PO14gBfenBM8rgUDyKJ+
         rIygyVARrOxj3efOYVhKJRbg2sGOBHaXtP7m+CSJuU07ziykgxyl17xp5bBWZeEdgusa
         WYOPKskdqySs7gW2s8+ve1pySinRSwbTJ0p6ymLcl58YISmAs2Ik0CWO9RSN9fxzWQvA
         ZoSRcY5cYTD1G3TloIoCCJv/1CyA2lq8kYvdcufBzoOKHVXMYWeuGA8AY+I5NwBATRFV
         HhMTvdQAYjM00fatHHID8WG5/3WQuKYtJlOd6etY67VFixcPCtJbw+r350LoEfGx3xEM
         PsvA==
X-Gm-Message-State: ABuFfojH2vqmv1qSrmcrmSf+wZbl1XyJ2+vZR/9p0MSSfnAfgZCA9YiM
        jCJVzlE+ScHqCNAV+KHJQ1y6kn59
X-Google-Smtp-Source: ACcGV63usaOpTaI0HNMGRa38a7vH4tgH6C6LA/peGCayRxnq9nQ9tMqy8cKo/RgURLap1nmbKlDiLA==
X-Received: by 2002:a2e:8090:: with SMTP id i16-v6mr13806853ljg.168.1539703853243;
        Tue, 16 Oct 2018 08:30:53 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id p11-v6sm3374570lji.87.2018.10.16.08.30.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 16 Oct 2018 08:30:52 -0700 (PDT)
Date:   Tue, 16 Oct 2018 18:30:51 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: CRC mismatch
Message-Id: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, all

What may be the reason of a CRC mismatch on a BTRFS file in
a virutal machine:

   csum failed ino 175524 off 1876295680 csum 451760558
   expected csum 1446289185

Shall I seek the culprit in the host machine on in the guest
one?  Supposing the host machine healty, what operations on
the gueest might have caused a CRC mismatch?

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
