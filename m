Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283A5C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 12:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5822087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 12:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIp7T8Pq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD5822087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbeJRUDP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 16:03:15 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:35414 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbeJRUDO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 16:03:14 -0400
Received: by mail-lj1-f179.google.com with SMTP id o14-v6so27464955ljj.2
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 05:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZmcuOGFKwCTJyT6vmfnIghx9fQ3Ypr8GljoePsJWCnw=;
        b=VIp7T8PqrCjntNN/m5+crMZWAsMslv2v00WhaaZZXwpob0UbztnkSjPN/eNZypRNEy
         krc+KNgsVh5VdpUqGa2ocEv8D7AkVPerbz93WxkmkGLNYveGyYm5I6Jl3n+bySE14tOT
         RBPzZjnCPYKmxf0xAuWSXBG/zD13J72kDF7I+3Cs3XgdICRZgm9ttUKLx0hz3CyptXnO
         oXXjcHJTdBZqqEPZsCAMw3WKGl8zN+k7AMZgAPv4shPU5/W7D9Gbj1PdwVYcHFTY+iAy
         Hm2E1rmzh+ei9lNJHhNziPIV0wRJ8FU7zApgpr8x6gGTRp9Vw2Gozx8tzAxRxSbE2xLI
         iaHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmcuOGFKwCTJyT6vmfnIghx9fQ3Ypr8GljoePsJWCnw=;
        b=Bt9TH3vEQqwy6pJWNJCwBQaU1xj/eqoqP2gytD6c4AaPXMOLcr/UWYjPAUGPPc9lPB
         BTsxTaYmLAqgj77GD51m+Iu8kP5tz4J7RWlIlDHvybDiT+YUux1xGh4IfVLuYK0Wq8FZ
         FJh6iToF6X79RcGGMat39mH+n3xhPMuDSVeSO2n6vm0Gf+DRA32uGMOzPqM4UnJJvTaQ
         b13rxkeaLQxk9nliB8D/We17LfuFQhiAe/8f+f2GolSO3DYyc6vChmoB2YxUe2tqHu2q
         cjj2TGsLUVdPCaMFJVP9b8XJW3Z7YBnhSB78t01PlPwqo7dls6MqO911VBMNx8gJiv77
         VuBA==
X-Gm-Message-State: ABuFfogSiTTWnTWjpygshRzqX2YVrKw1rOu7RAUZljuBeNa3oGmX2Q9p
        vHlb2aDv4hOpfjoHg4qequff9kJZ
X-Google-Smtp-Source: ACcGV61UVzERk9lgnS/5ItoYZKehd5ZQ2ikZezgdZ5SkaITir1xv3kAMUAtDbkHDhFI52Pc2AhrxWw==
X-Received: by 2002:a2e:974a:: with SMTP id f10-v6mr19891024ljj.30.1539864150473;
        Thu, 18 Oct 2018 05:02:30 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id c30-v6sm4199032lfj.28.2018.10.18.05.02.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 18 Oct 2018 05:02:29 -0700 (PDT)
Date:   Thu, 18 Oct 2018 15:02:28 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: CRC mismatch
Message-Id: <20181018150228.16680172c2551c06038d5344@gmail.com>
In-Reply-To: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
References: <20181016183051.788a79297af47a9798a0c0e3@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I wrote:

>What may be the reason of a CRC mismatch on a BTRFS file in
>a virutal machine:
>
>csum failed ino 175524 off 1876295680 csum 451760558
>expected csum 1446289185
>
>Shall I seek the culprit in the host machine on in the
>guest one?  Supposing the host machine healty, what
>operations on the gueest might have caused a CRC mismatch?

Thank you, Austin and Chris, for your replies.  While
describing the problem for the client, I tried again to copy
the corrupt file and this time it was copied without error,
which is of course scary because errors that miraculously
disappear may suddenly reappear in the same manner.

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
