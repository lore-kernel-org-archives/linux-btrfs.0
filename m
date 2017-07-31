Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35734 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdGaHgk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 03:36:40 -0400
Received: by mail-vk0-f44.google.com with SMTP id d124so12955487vkf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 00:36:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170727154723.2208-5-jeffm@suse.com>
References: <20170727154723.2208-1-jeffm@suse.com> <20170727154723.2208-5-jeffm@suse.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 31 Jul 2017 13:05:59 +0530
Message-ID: <CAKuJGC8EgYMZMPgbg8qEW5Y=UQuT9RJRQ+N_GsjbxWHgwkPtrw@mail.gmail.com>
Subject: Re: [PATCH 4/5] btrfs-progs: tests: fix typo in convert-tests/008-readonly-image
To: jeffm@suse.com
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  if [ $? -ne 1 ]; then
>         echo "after convert ext2_save/image is not read-only"
Though this mayn't affect test-script result, please change the typo
in this location also. thanks.

Cheers.
Lakshmipathi.G
