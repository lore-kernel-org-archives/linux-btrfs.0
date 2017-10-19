Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:49709 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbdJSSQF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:16:05 -0400
Received: by mail-qk0-f175.google.com with SMTP id q83so11459281qke.6
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 11:16:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/8] Remaining queue
Date: Thu, 19 Oct 2017 14:15:54 -0400
Message-Id: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's the updated batch of the remaining queue of patches from me.  I've
addressed all of the outstanding review feedback for everything and they've been
pretty thoroughly tested.  Most of the changes are around changelogs and adding
comments, as well as switching to lockdep_assert_held from whatever crap I was
using before.  Thanks,

Josef
