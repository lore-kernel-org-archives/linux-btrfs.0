Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E43C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F946214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="aVYmUpyO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F946214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731949AbeKVFlU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:20 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40269 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFlU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:20 -0500
Received: by mail-yb1-f195.google.com with SMTP id g9-v6so2638079ybh.7
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=WskV/RquoLBUHohu5F8yaloX40qzbklG3UTDTJybUus=;
        b=aVYmUpyOloZXqhQ5K4FZ9sqQmLIo2QK73qu7p1hkKdzQMH/kZrcy4BQ8vG3OqaIylJ
         saDUJieoCUyyJVtiwzOYYQGzAQ6dnWO1UaT2iisjPdiFOTosFjobl5+StOJ2gVlcxFOQ
         i38FUpM11zD6A7W/hM8OGcsANE0/pMm3Sz0FTtWS+dJamvf1CfEHwWwk70whRIsB3Hae
         sd+ZrQw6aXuvnEFlssptagpPnqzrAfOaONdyRX8GCARl3AErkmlPdAZ729zFPhJX0SNL
         Pj8aAlovJF7u3SppxdZ/z+q5qNiQLbu0f6lrAfD/avBX18Y54LTeoZ70BN7sCs7v9HoA
         4yAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=WskV/RquoLBUHohu5F8yaloX40qzbklG3UTDTJybUus=;
        b=n6doAwdK8CsDmQlTIIsZwtq1S5XhnOwf6559j2rKo3o3RFUUZKhZTpVATev8UXZH+l
         ZNlYO6/r9CHj4mdJ27ILpH5CUf9j/i2fnYEXtJaX62RIRsIOsPwgCOuFy3mcKNaiMCgu
         +QR8UX74hFYkPJAYBcls5tYgBL3neMD1Z3HwoJNgZZyhPhtr1QVy+xzzZVDEquzZP2uY
         OSQ9S4RA0cuTDEeCsTXDgZUb9aYQUqzNwPPAIjZOo0quY9ciZC9iNadmUUPGHxsVcQQH
         5A2K5CthMR4JutWDq7KaHEMApITs5PzA34EcT0cG2KphJzro9+ufBCKmkBqMal2IV4Jr
         s2gg==
X-Gm-Message-State: AA+aEWYxTZoR26vSp6UUQ6r0+PGgwCvALQe9F86Jy+k4+MqKn1CHhwk3
        7H49GcizeWusCn4K66OOKTDDft3x9Uk=
X-Google-Smtp-Source: AFSGD/UlHUbJr6uvepw5z9oVNvMpPSHecvr9W2ggh3vbHgI8ccjhgqqb6ZmXIv7Nb1H9sGQHfF7foQ==
X-Received: by 2002:a25:7009:: with SMTP id l9-v6mr7880645ybc.35.1542827147699;
        Wed, 21 Nov 2018 11:05:47 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 10-v6sm11860727ywt.47.2018.11.21.11.05.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:46 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/7] Abort cleanup fixes
Date:   Wed, 21 Nov 2018 14:05:38 -0500
Message-Id: <20181121190545.24798-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A new xfstests that really hammers on transaction aborts (generic/495 I think?)
uncovered a lot of random issues.  Some of these were introduced with the new
delayed refs rsv patches, others were just exposed by them, such as the pending
bg stuff.  With these patches in place I stopped getting all the random
leftovers and WARN_ON()'s when running whichever xfstest that was and things are
much smoother now.  Thanks,

Josef
