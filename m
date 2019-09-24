Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1D0C432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 20:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCF772146E
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 20:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="z0p4ayr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437488AbfIXUc6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 16:32:58 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45487 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfIXUc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 16:32:58 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so3792869qtj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2019 13:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBFqZ0mJjpLkpbOupsagM8Jl+uHVMZdrENsKttYrEYc=;
        b=z0p4ayr/LXenta8/AVOjOn7Hmwi7u4/UVjRdaQr5SqYt/1yeXb0Yl2jlSOmgf+Whlm
         MtHPV4H5qN/4CuFe7Iz+SjVlh7+gzwEv/nUrkXnk2ZSJVonPS+HGSa4tf6vpxLoYIHY2
         MtehqjAKsv8sV3cU4mPOJRGrUPUMQzPD9gIUSK+3+vWADR2JGRkYZMHBxqCzSHWRjeJm
         9gSReAHx6D7P4q6bns04qx5pxjmG+3KYMxXHxRUZtDO6EYQARWauItLyMeuyHmgMe9H9
         OTtc8ImS0japGzBep54T5wp8R5lgpn3rmIIkrDi3CIZqGknQPcqzxoMHuG71YNLSfnkU
         Aqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBFqZ0mJjpLkpbOupsagM8Jl+uHVMZdrENsKttYrEYc=;
        b=Wq8NeZntZdKGy5w/gRvN75mTaEpS0fJU1M7SjR/bGiq+7lUWfF7411EDrpMe231GGE
         A/7SJS50+8s/gIphKHe+kgdAo4VfZgYTqxb9cJTAUDDmFP/E7wfArWRU4TvYc3t6FrUN
         3lX5H+AKUTG4Xpbsy2S7v/lrB27cj3HBBvT70u4Z1FHdl5LDb7Ip3b1lwE/zvX7vtpsN
         KKLfeMVw/LfXqe/9IPPLIxOnvzCRZ/DKdRPDTV9jHpRBdnJskm5KjAoZ6V8CIAniWoHV
         v8yHOZKP4nR62tBJIOUmzKCna6Vdgb7ZLHxiJoTAGmXusGXDFcGECh3D5YhTzX+BREVd
         ajAw==
X-Gm-Message-State: APjAAAUYunoNfL2sH6HAEfU3Iwl84g2TTQJCxLoaxXQPhnx2DDJdoCDj
        l77/lvNAnpGQuOjNr2AhWCdJtNzN8nx2JQ==
X-Google-Smtp-Source: APXvYqy6iAFlwri6z4Dwo+5yEoIMHIjGPs+tSL+/PmjblZFbkAlwunWiAhdKRHthxAILGg1s77pi9w==
X-Received: by 2002:a0c:fe0c:: with SMTP id x12mr4314510qvr.134.1569357175719;
        Tue, 24 Sep 2019 13:32:55 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y17sm1450336qtb.82.2019.09.24.13.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 13:32:54 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/4] The remaining extent_io.c split code
Date:   Tue, 24 Sep 2019 16:32:48 -0400
Message-Id: <20190924203252.30505-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hopefully all of it makes it this time, if you want you can pull from

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git \
	extent-io-rearranging

I've rebased on top of misc-next and fixed up all the conflicts.  Thanks,

Josef


