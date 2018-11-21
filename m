Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24082C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7EA214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="k57dCXZO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC7EA214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbeKVFit (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:49 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39700 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFit (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:49 -0500
Received: by mail-yb1-f194.google.com with SMTP id w17-v6so2634160ybl.6
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=q7qsAkrVu5pvfHJ10hlqqNJDEWPgA9+pb70aQK+bVjg=;
        b=k57dCXZOxkIgLbku2ASqPnA88RIW8stTflBDRefIpvRg0KoJK1fz8+0tOIZunUrJh2
         O5ZTNYR4429ne/fGtqhw0smvjEUer8HO+yeOOQjDhaTqTtS8zB2VKH3yH4hLUAmaJvLm
         VbxqbqI4ezmkmMtQr3bRVDuc5yY/iLNfIw4QISp1Q8HUmmJCM7bf8wfhUluTAqlls6n8
         Rwx9DNBIB7UI1G4e5kGPavpex8VW4L2EnGDEUZYI96R2GXnjiEAMdxEn7b7yfkhj1Bqn
         ztM5KBcW8ZkPN5b44RGEtj96djc2v30KCNTbhVl3Vb7e6WkKzKaKGG2r54O86vRsClsA
         bi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=q7qsAkrVu5pvfHJ10hlqqNJDEWPgA9+pb70aQK+bVjg=;
        b=LsXeWI98dXKb36sjNx6X35G/ruY3IqFVezyrkrtylg0Bgoqutc3nb0YOSgEoMMfEG5
         f6D7YQZn90V19B17ujsoSREVn8u3rmBiWxansGKP8qWXFLO7gOFZAFl2tVA/rCUc1zqn
         C7UGQCNRFPRKKDs8zP8yoPDp2Js9H1DzO1wt1tuc3Vurz8GFzIvWzTMQfn9kEOHG/2S7
         FOTt5F7B5rLttWWKqNNFUZKD0XlrCpjnXXWXzaEHXDtCBPmVPOTeGSLoezHjQ98QdEKM
         EmKeLwSE+SMrhQqlDAgVP5WvystPZOvkebSyXspzTZJJscSVlWxS3kxNgP70X/9EHz+i
         e+2Q==
X-Gm-Message-State: AA+aEWY7UhweSUfJsLmlis6J/GjwRuRqYQumqm5VIyAQWAk36Hlf7r34
        G0DlVKKH0DFT2mER8j0wRAcE6qH16CA=
X-Google-Smtp-Source: AFSGD/WsSpw7Bz0e8exXK/aB93YMi3KAc6FPJPGOSc0xWmjBK9f8d09JW1VBMRsKiRwIyW/hn7j8yg==
X-Received: by 2002:a25:13ca:: with SMTP id 193-v6mr7723009ybt.468.1542826996182;
        Wed, 21 Nov 2018 11:03:16 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l35sm13342166ywh.48.2018.11.21.11.03.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:15 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/8] Enospc cleanups and fixes
Date:   Wed, 21 Nov 2018 14:03:05 -0500
Message-Id: <20181121190313.24575-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

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
