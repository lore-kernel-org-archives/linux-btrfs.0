Return-Path: <SRS0=tPet=5Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53993C2D0EA
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 13:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FF6F2072A
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 13:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgDHNPD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 09:15:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54763 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgDHNPD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2020 09:15:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id h2so5093121wmb.4
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2020 06:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=1aU6XQiLXcF4XFu4CudW7YfDS5Lpm1KoTvz1Nu1aK0o=;
        b=RNbzhLPCRYUWQYMaP3rGHPYHGd5D9qhpA5u9hxEQCU6kQcpJv3i+at/qYIFXqqEoTZ
         +3cDUJ6du4tHhTxHtrWP4H1SuUMDU6fV4UIiljv9ShGIAnWWhtNku9ZY861NJhWgAYA6
         DymUNkWBbUKcoKDFCtU4NBZA9ZUBWK6w33eljBWYTJMk+x7UQMAQx2yR6/o6peyLCzw9
         fozcqfXzi2pqyAhSxS65oefsW74Hw/do5ktlohJdoe/0yxgX9UobI3yaKsnfYjrXoZlR
         leGGbPjsvQxy7lb/t9XPxK8//v2CW9cVrskd4LUPmH4/Xy7JndcGPXvvT6H05tAnMFGh
         6nRA==
X-Gm-Message-State: AGi0PuZ3GKJxt0iMITaaFBrrL9qw+RnFfod9Ty7rLXxHsosJ+PfHsLuQ
        L5TrAMgOFp8jAnqX6gtM+j5bGc2J
X-Google-Smtp-Source: APiQypKfL9FMXdlDCMsSLCYKXkkSUd/o58dSaTOxK2zqaHPp8qvzlD8bjN9brzLv2txowDhxvLNMIw==
X-Received: by 2002:a1c:44b:: with SMTP id 72mr1897741wme.58.1586351700740;
        Wed, 08 Apr 2020 06:15:00 -0700 (PDT)
Received: from jkm (79-98-75-217.sys-data.com. [79.98.75.217])
        by smtp.gmail.com with ESMTPSA id f187sm7370988wme.9.2020.04.08.06.15.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 06:15:00 -0700 (PDT)
Date:   Wed, 8 Apr 2020 15:14:58 +0200
From:   Petr Janecek <janecek@ucw.cz>
To:     linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 0/3] btrfs-progs: balance --bg invocation
Message-ID: <20200408131457.GA19101@jkm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Whenever 'btrfs balance...' is used with '--background', there is
no error output at all, everything goes to /dev/null after fork().
This is an attempt to get some output for this type of invocation.

First patch just moves the forking after opening the directory,
so that nonexistent path type errors are shown.

Second patch adds BTRFS_IOC_BALANCE_PROGRESS ioctl to the
'--background' invocation to check that the path is a btrfs mount,
that we have the permission and that there is no balance running.
It's a racy hack, but good enough in normal situations like
forgotten sudo etc.

Third one adds the '--background' option to the
'btrfs balance --full-balance <path>' type of invocation (without
the 'start').  It's easy to do with forks moved to do_balance()
by the first patch.

Adding '--background' to the "old 'btrfs filesystem balance
<path>' syntax" would be a bit more work.  As it does not support
filters or any other option and does not display the full balance
warning, I wonder if it would be worth it at all?


Petr Janecek (3):
  btrfs-progs: move '--background' fork()s to do_balance()
  btrfs_progs: _PROGRESS ioctl for error output in do_balance()
  btrfs-progs: add '--background' option for '--full-balance'

 cmds/balance.c | 125 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 39 deletions(-)

-- 
2.26.0

