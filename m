Return-Path: <SRS0=SPQA=3Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98477C35247
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 18:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2152082E
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 18:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="MyqKnGB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBDSTA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 13:19:00 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]:41097 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgBDSTA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2020 13:19:00 -0500
Received: by mail-qv1-f47.google.com with SMTP id s7so9010759qvn.8
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2020 10:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOrLRtvaXsW001i+H7EhO2Odww19ukgXVvwXOdIKY5k=;
        b=MyqKnGB8c5yPqUKsiZK7/sir0sscQHnpzbEEDginL42alX1ANdULS+rmjzMN7kQVc0
         k9RGYSSw/q7GbAjXVf4o8QKTjxYxGoGIo7eT5YVyd4U1UbCsDuNWOqV5DrCnSZ2+o6B8
         8+7qwjGEuIztqJfaEnJVCWQFG6QjIFceND4tXEQU6XVtXoHqjs0lD7oqKpsdkaLNPBo2
         aoLbopr1hf3rrpnwLAmRl/vfKOpVe3KQ7YIrYq1yee2PNEGor+ZMG2nQqkCyiE3NI7/W
         CkGQLq+Nn+rAN92iDBgwqM1QKznc87ZDoTozLPY+7m+xnLPcL+jrpnuag61Vl+J6jqRG
         DrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOrLRtvaXsW001i+H7EhO2Odww19ukgXVvwXOdIKY5k=;
        b=TtAaxbB9+JSnWL97nrdBxPBaPPur2g9zy2euhqVyLwWGEmveRUYGkMvHz6Dba8VKXc
         Or3olne5kYkDm+DmtMVCnwAPWZ4gfCL/C0ibutvWw6dlt/aOhsiwYaurI3r0D6gG7eIx
         hQmvDIYeXZqkxLT+w5XXrDvYs41Ydsk9/gmwC6uRf5ldN2c1dbAsIWxhhrU1vqr5reFp
         LJiWhYI8LVQvEE/m1G4EIPck+jLu0bTJC7ST7OgvcUJq4yCLZXmrpMjc/83eTyfEFKWq
         pYpNDzr0/4kj0Se9FsjMQY1rVaQq+/WMtmhscf4jxKO0Ue9DRx5QqEQuKwwRfvjabjyV
         EK6Q==
X-Gm-Message-State: APjAAAUJDAQbPLK/O1mbbYF7IaazISpoXrqH7frQYcLleCgfNlp5gwMA
        kFftWv1BwXb3ZnIlorCBwKoFpxAnr6hh5g==
X-Google-Smtp-Source: APXvYqzI8pbExgS2FZwKoCIyRTbE3JEb2qvyflwk8fU4er8SsOhCNleYTJ8yKvPMzHUSmk8nl4muSw==
X-Received: by 2002:a0c:f98e:: with SMTP id t14mr28346781qvn.74.1580840338734;
        Tue, 04 Feb 2020 10:18:58 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j58sm6802625qtk.27.2020.02.04.10.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 10:18:58 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/3][v2] Add comments describing how space reservation works
Date:   Tue,  4 Feb 2020 13:18:53 -0500
Message-Id: <20200204181856.765916-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v1->v2:
- Fixed spelling mistakes, discovered you can use ':set spell' for files other
  than git commit messages.
- Reworked some of the explanations to be more visual to describe the general
  flow.

--------------- Original email ------------------
In talking with Nikolay about the data reservation patches it became clear that
there's way more about the space reservation system that exists soley in my head
than I thought.  I've written three big comments on the different sections of
the space reservation system to hopefully help people understand how the system
works generally.  Again this is from my point of view, and since I'm the one who
wrote it I'm not sure where the gaps in peoples understanding is, so if there's
something that is not clear here now is the time to bring it up.  Hopefully this
will make reviewing patches I submit to this system less scary for reviewers.
Thanks,

Josef


