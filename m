Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11392C48BD1
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jun 2021 19:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7E60613CA
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jun 2021 19:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFKTrF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 15:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhFKTrD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jun 2021 15:47:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3874EC061574
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jun 2021 12:44:56 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c9so7188700wrt.5
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jun 2021 12:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7iXwO069K4+sv+VN/IkT2C46ZNj1x4qss+2rw0VpJqE=;
        b=CbDcnZN8VvBrLRsvW57+Z9176jJRDEbC4F4AhssdZqBu25rb3MwES4EgDySxrsS6Y/
         3FlbK0WU8N9WQNHTWqSyeh7KuqZOFVBEdODghwckH/fZ59QoZWR/FQWaQk6yS3vPp1y0
         uKVsar29EmNTQNMlBUXsFOhgOKfeyIWkOnODRq/cuU37D1INDJNTAyxWPASvqOt5fQkM
         Vgotj1jyP83dr0XsHDTFWYjW9m3gHVWSVVJVWfF+eFRv4DnVSTLjZr+g/3uuBkLq0bCg
         PCMqv7TTFfRm7DUMwr3E5zNczPLJhM1OZZxXh0xzGpA3X/Ue9stc1Tvy/OdUS0R+7Dzc
         TJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7iXwO069K4+sv+VN/IkT2C46ZNj1x4qss+2rw0VpJqE=;
        b=qx7P/kDW+nWdzpOu6/zpRqlisAmXOlKlCXYyijbCpPL/SsDCpg4kV+xEXkQuJN2hkU
         2lj84eHh6l4vhlg8wsrHK2CSx8RQjSJWprosvPT0y5z0bzeBtaZEy+/r/cDPWbtzzmpv
         woHzq8NpF8fy44VTL/VkZ5+Qg/WqZnkE95gphyHu4xoyB3tPurm4HqUcTRQ+MuuJ7CCH
         TsBKwAKpnu7O1+p748BN3SQzvQrZAoxj1VX/fhbW+IADM/4zDL7kMf64j0hVxXyOw9rE
         xVvspHCszKqych1WGgu47sgxXjMpMqLedpmERUOOkPybD2TLN2JTickRdA+7LCzLNEjH
         yiEw==
X-Gm-Message-State: AOAM530SPKBhGTZu8OyXzfCmZUi0ogFsOZPVeKfg+lVe0WZAbnUMd21u
        KVp1GctgqmWvHQF6GcygRNHiu0JhxG5DGg==
X-Google-Smtp-Source: ABdhPJxnScOzonjLQkTaDRF1+gwl5utky/ckHRf2kyEWwfC6Dsr5VmJOQBX2qN01v/8HImqapXjYrQ==
X-Received: by 2002:a5d:6daf:: with SMTP id u15mr5795729wrs.400.1623440694319;
        Fri, 11 Jun 2021 12:44:54 -0700 (PDT)
Received: from localhost.localdomain ([176.92.77.97])
        by smtp.gmail.com with ESMTPSA id c7sm8119626wrs.23.2021.06.11.12.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:44:52 -0700 (PDT)
From:   auxsvr <auxsvr@gmail.com>
To:     linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Write time tree block corruption detected
Date:   Fri, 11 Jun 2021 22:44:50 +0300
Message-ID: <5720791.lOV4Wx5bFT@localhost.localdomain>
In-Reply-To: <9f901a7d-bbe7-fd13-8538-1fdc0f869296@gmx.com>
References: <1861574.PYKUYFuaPT@localhost.localdomain> <4656165.31r3eYUQgx@localhost.localdomain> <9f901a7d-bbe7-fd13-8538-1fdc0f869296@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wednesday, 9 June 2021 11:32:57 EEST Qu Wenruo wrote:
> Would you please try to compile the following branch of btrfs-progs?
> 
> https://github.com/adam900710/btrfs-progs/tree/device_size_fix
> 
> And run "./btrfs check --repair --force /dev/sda2" for the newly
> compiled btrfs-progs to see if it solves your problem.

Ran the repair and everything seems to be fine so far.

Thank you,
Petros


