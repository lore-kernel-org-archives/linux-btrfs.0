Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BFAC04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 15:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BA062083C
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 15:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PdZSG0qc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BA062083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbeJPXQx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:16:53 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:38923 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbeJPXQw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 19:16:52 -0400
Received: by mail-lj1-f179.google.com with SMTP id p1-v6so21293278ljg.6
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2018 08:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WzuQ0K/UAgbHjSXE9MKhQTkioQVqO1uVezHUbZ/yMCU=;
        b=PdZSG0qc6n5shiRc3866YfL/t2V28JQk70L4autOP7FdzDqnG0H0d26BNZrBgKM34J
         fZuKVxXo9xM/5rf+nYgsPpo+rUK/v2d3SD29mHxDQe4hA4blZ/W6ga55VdcIbWVue+T/
         Ke0flNPF8o+387UEhE97sgSc3gM+37iLX0h1OAUJIUsXnUmi0IrsEiD04KIt0/yOP60y
         TrQKJMU7gFwymxg6PG+NmuV2hyBRhyzN3GGiGFk0n1yJEdWf84VGasfOs9qlMc91Q8RZ
         7HurSh7ulnVB6KU30Dz337yzP65rv3BCl7TlkypgW0f0dH/VQll0IqpZ97Mpm6OahSvY
         jp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzuQ0K/UAgbHjSXE9MKhQTkioQVqO1uVezHUbZ/yMCU=;
        b=fekHfE1gnRT1KDiQZGKBlB081q/PT5l++02klSbSbAYKZOy/P+et1KHY4ULygIHtYv
         DTuifZTDf4JKZS1jtdURcUOnwCCdeX8FrlEdK82AC5C2rGzH0fyNfTYUr1pB9UemlIqZ
         ONZbAVxISSWODNa2eHUdu5r+7DOKPTi7KF+psQ1CWjtnrjj0PUxhb5l9Gxuqx5GaHQ4o
         2CuloA7qFsmudfVHkIUhjj5x5uOIBE6Kfm05EqsJn2Q9fFwci8cA5/VWiYTgwaAqkPYh
         zOypui++3mZeVbyTIcTmxYFcEimlyylJBkqJnkRg9l1UTxzccq4k6U5sYg3UMRgcza8Q
         QuUA==
X-Gm-Message-State: ABuFfohqvgT+3/zxBO8DMiQ9clcspo1omP7QK4k0tx1d4lS4WJzYD9GW
        narbCw9VuhYT7deHdkxyRk38xO1Z
X-Google-Smtp-Source: ACcGV63TGYs+dOjn9Tu4v/TA+fJCCk+zxbiEoAx6pRsuuw06iec9o3ea54MyD1wr1jiLfPSMtl9TlQ==
X-Received: by 2002:a2e:9d7:: with SMTP id 206-v6mr15260524ljj.127.1539703552954;
        Tue, 16 Oct 2018 08:25:52 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id t15-v6sm3239830lji.75.2018.10.16.08.25.51
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 16 Oct 2018 08:25:52 -0700 (PDT)
Date:   Tue, 16 Oct 2018 18:25:50 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: btrfs check: Superblock bytenr is larger than device size
Message-Id: <20181016182550.60bafce18bfb07fb4bcf24d0@gmail.com>
In-Reply-To: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
References: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo to Anton Shepelev:

>>On all our servers with BTRFS, which are otherwise working
>>normally, `btrfs check /' complains that
>>
>>Superblock bytenr is larger than device size
>>Couldn't open file system
>>
>Please try latest btrfs-progs and see if btrfs check
>reports any error.

It is SUSE Linux Enterprise with its native repository, so I
cannot update btrfs easily.  I will, though.

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
