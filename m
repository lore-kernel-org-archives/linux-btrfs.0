Return-Path: <SRS0=C3Cz=O7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DATE_IN_PAST_06_12,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A5BC43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 17:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AEA721A7E
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 17:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SulZfuu7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389620AbeLVRmZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:42:25 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:37404 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbeLVRmZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 12:42:25 -0500
Received: by mail-oi1-f180.google.com with SMTP id y23so7335679oia.4
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Dec 2018 09:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kXrqbLsPbjeFaK105OmHMgYncdhhT4lKD3Pxm1jIoRY=;
        b=SulZfuu7rA5/4Hcs3wberbY5+XDnrdvCA+ldc2MZUREbvyp3m6z2pxfQuPK0afXfq8
         1hp/rr8fQJP0B7HOaa5NwBRNOqHgMzVt7u2hwFUEdxJ7TnWxe4R/mXBPf83FepQm0q46
         VRiU/briElD78qvU7Dj0c5gVJXqB/UTYB5nLtZvr87jYVSv4OwiEQMec2r6wwVWvcN1H
         UjJO5fSmAIYyMEPkEng7ogAqW1G4yXqK9lmLF9bUgXLI+IGMVrzQY74thFoA5PgVU4Db
         IJpWr4oQiA4nxRvNzVu6VHvGwN+pjL7jFGUlCzcutN2DuvH4NKHuunWga1c4EFexKuOr
         40lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kXrqbLsPbjeFaK105OmHMgYncdhhT4lKD3Pxm1jIoRY=;
        b=fbZvY1Izy6WuucIH7aYHjSayevjfN0s2Z1fL0iC1rkb9UeuuukMafuGUt/0hZ8KxOX
         n4AZbxXxdFHn1knmnJl/VR5FmMUNWSQuoN/1J1SUArsX8cGQTa6LgbA6hKR9rYNvSv67
         Cx/ba072g2jgpf+fOZNWc4ilbswzh/IyqspeOouVgp1bu/0s/XHAAEV7iymlekCFDCQB
         aNuZqSzM6zrrGDsZtR+E4rQIGjEycFbiI6jTXoeNFhhqcWizCH+rAEQPwxOr9LB7tpbO
         WLKx3ES+4lqTRpRKa6cX00TqExO1HXyaup+zlX6IFrPKlDDn5HydHb/Wxk6xhuP851ce
         dkQg==
X-Gm-Message-State: AA+aEWa4zV7JpG5CWhhZPlRlNEpgX5Oww004t0Il+FrVUC3niU/YGJWL
        S4A8MYPC1sH1XKgABnRlsBlJ3eimbEiNackve9truA==
X-Google-Smtp-Source: AFSGD/X41Dvw7jZqC4ki08GEcY5S6t3iTY3o/7bbueiH1JwtYn5OEO1qysT0ujye1ljb5mRrMOqrGveiD/IsIJtJZ9U=
X-Received: by 2002:aca:1c04:: with SMTP id c4mr3113632oic.191.1545459556748;
 Fri, 21 Dec 2018 22:19:16 -0800 (PST)
MIME-Version: 1.0
From:   Raymond Jennings <shentino@gmail.com>
Date:   Fri, 21 Dec 2018 22:18:40 -0800
Message-ID: <CAGDaZ_o0NYy4HXmE67u8HvH7Y7RwT6=GvPDrPtRbRdPzEEDHGA@mail.gmail.com>
Subject: Specifying block group size
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

How do I specify the size of a block group at mkfs?

Like, for example, saying that data groups will be 1GiB, but metadata
groups will be 1MiB?

I noticed that they had different default sizes based on the profile
(dup vs single vs raid)
