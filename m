Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C28C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B7D720834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="p920iIEK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7D720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbeLCPZE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:04 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33416 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:04 -0500
Received: by mail-yb1-f195.google.com with SMTP id f125so681232ybc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=UwEU/gKd2Zs6jWnHTM+dVsVsMlawlS20JnxNqnzMr58=;
        b=p920iIEKE9H0Nt3UGl+DV2nTCVPvw5eqTlgkh5GS9Z/TkT1f0d8/FFCTE23h20LaEu
         tacEYdfy/BfeDkGlAiuDn3cWTG1EuNmEMIs6iKkmMCGFR7vaqUnjTV3+cqdL37udz7RX
         W3cSSvq/V4R+jXSfcLJklKyAtpW2jIMenAZ5dMN8I6YGEphvjr89pDEBHPDxFqJ3gT+C
         xLWJEFFCM5KVxwHMxeEvz1FSvO48kuxf2L5IDKHxlg04tcjaP1TH75zak/yBnAh1pbqL
         KqHjAYDQYuUJE1U7AO58M8Z9Xx9fMYrHbgvVOpWQYNZ12gO3kfCB+IkUF6NYKDqqlbBS
         X0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=UwEU/gKd2Zs6jWnHTM+dVsVsMlawlS20JnxNqnzMr58=;
        b=Xr3e0dfMDK1JbjOWah6iTDE41pBrCw93uXz5GU+0KAr9/FL7d/+wMg495DEVmabvqP
         TIAEy5M2TueQcPHKO98rP+Fyj174IWyaHZ91SiWWzXhiedHtdbWOsLX54laTErAQwUUJ
         XYVYm5lxmng797m7TcAGJnGokc2B1CNbixDGsSltvI3HlAa/o+3Ri2rq9mFgnLa7P7FL
         xfu6NNwk3nfpL19LQ5LnOCTKV5iSNRUdoPducG6hhVI8cRrVYJrzEywecLGgDzlChSbC
         ZwWijiLuda/Q4zbj7YuYl6daYolRifschNal4Nn4nLfS66ZrKZjjFwNMCniweAoNGHQ+
         o/qA==
X-Gm-Message-State: AA+aEWbcBsRg8EKf4R67YYxeQ8sL7gvEbgXd7gbydXJwtLJWuc+aVOQ8
        tfPgvM4H791rKW2k7k9tQZhretZlFOs=
X-Google-Smtp-Source: AFSGD/VCIGS/zMbZXG7/0mbkDvdzOplvm7SE5zR6NsssWVM2RJ1S2MwhTrYK20e01cMmtgQp+nG3ww==
X-Received: by 2002:a25:8245:: with SMTP id d5-v6mr15479123ybn.498.1543850702146;
        Mon, 03 Dec 2018 07:25:02 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e194sm5092313ywa.85.2018.12.03.07.25.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:01 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/8][V2] Enospc cleanups and fixeS
Date:   Mon,  3 Dec 2018 10:24:51 -0500
Message-Id: <20181203152459.21630-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v1->v2:
- addressed comments from reviewers.
- fixed a bug in patch 6 that was introduced because of changes to upstream.

-- Original message --

The delayed refs rsv patches exposed a bunch of issues in our enospc
infrastructure that needed to be addressed.  These aren't really one coherent
group, but they are all around flushing and reservations.
may_commit_transaction() needed to be updated a little bit, and we needed to add
a new state to force chunk allocation if things got dicey.  Also because we can
end up needed to reserve a whole bunch of extra space for outstanding delayed
refs we needed to add the ability to only ENOSPC tickets that were too big to
satisfy, instead of failing all of the tickets.  There's also a fix in here for
one of the corner cases where we didn't quite have enough space reserved for the
delayed refs we were generating during evict().  Thanks,

Josef
