Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47319 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933472AbdIYPnv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 11:43:51 -0400
Received: from mail-qk0-f198.google.com ([209.85.220.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <christian.brauner@canonical.com>)
        id 1dwVXy-0004t2-95
        for linux-btrfs@vger.kernel.org; Mon, 25 Sep 2017 15:43:50 +0000
Received: by mail-qk0-f198.google.com with SMTP id b82so11310090qkc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 08:43:50 -0700 (PDT)
From: Christian Brauner <christian.brauner@canonical.com>
Date: Mon, 25 Sep 2017 17:43:47 +0200
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: btrfs send <ro-snap-0> -p <ro-snap-1>
Message-ID: <20170925154346.br5lznxy3hpfup57@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,


It seems that btrfs v4.12.1 allows:

	(1) btrfs send -p <ro-snap-1> <ro-snap-0>

but disallows

	(2) btrfs send <ro-snap-0> -p <ro-snap-1>

Code-wise it assumes that <ro-snap-1> is always found at optind == 1. I was
about to patch this but I'm not sure which way we'd like to go with this:
Actually only allow (1) and block (2) properly or allow both. In any case, this
seems to me like a pretty serious regression and we'd like to get this settled
soon. :)

Thanks!
Christian
