Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34332 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753615AbcI1Sq0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 14:46:26 -0400
Received: by mail-vk0-f48.google.com with SMTP id v205so52870839vke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Sep 2016 11:46:25 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Wed, 28 Sep 2016 14:46:24 -0400
Message-ID: <CAJtFHUTUvJpMSzBXy+Ub+_iPRPocWXHfubA=5p4TyQqCj-29AQ@mail.gmail.com>
Subject: 4.8rc8 & OOM panic
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just booted my backup box with 4.8rc8 and started an rsync onto
btrfs and it panic'd with OOM a couple hours later. I thought the OOM
problems from 4.7 we're supposed to be fixed in 4.8, or did I get that
wrong? No users or anything else on the system.
