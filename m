Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B32C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 21:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF30222C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 21:43:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="WLVhYF4w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbfBLVl6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 16:41:58 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41871 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfBLVl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 16:41:58 -0500
Received: by mail-ed1-f66.google.com with SMTP id x7so157496eds.8
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 13:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q299i7b4D1aHhBrLyv9qe98k821Ph08ofif5+bJaMdI=;
        b=WLVhYF4wqbHkVOecv7rjfd2U/bnhBKufPQiy6IdNaSgJagEEB4HxurBaDJX7p92ZK3
         c+EPJwjFNEhPTj/7ZpejS0/Zy4fdDMmbK/xtDxGlPpKVL6PpC1PeUk5SaRKrduWmcz6b
         NIfeyRsk4a6OI3ZqmIEN6kZL8hax9ARe0vE84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q299i7b4D1aHhBrLyv9qe98k821Ph08ofif5+bJaMdI=;
        b=f+WMXFmA4WgCjwG6PUiyppXX2y7AiHfD1DCIl9sEi4tNjUOyb5KDYEFF8VX62IjdHj
         FCPTRCGcJTv4rRQ/dgCth/6E+aauv0ol0lSP+VyYDjA8Gnq79V04hopxuxrD6u9otCYD
         SXKJ14/k5MijZxlkE0jxneBH9zRYsL1pOMv5KsDwZNABSTRgPN/TvmpgSKqXJGbBkRSX
         +xxWflHluiPAxuob/VDlaLp0oKLiTl773GHUxtKNO+0gMDWx/MGi4uMwvOGs/M1CUaly
         LyZtfKhHNQXZmRldyUN7kkc+hrnvdMUhjXoRooL/pXH1oG3lI3aNE2cLbUmbTwaLD1Mu
         haPQ==
X-Gm-Message-State: AHQUAuaVzcnPFbgo4kovGCAgR5W5g9DKME8RbCVpqEyrWOUVKoc3dpHc
        iVjUJ8Rx1EPNao7AV2h0E8nAvw==
X-Google-Smtp-Source: AHgI3Ibt+JIXF78qPZ9ZykAxJvkvHNu/7i42OJH+Sl5UKu0YalX2Ym8G58qAkEo/P360xhRPL0ryqQ==
X-Received: by 2002:a17:906:2296:: with SMTP id p22mr4251731eja.92.1550007716024;
        Tue, 12 Feb 2019 13:41:56 -0800 (PST)
Received: from prevas-ravi.waoo.dk (ip-5-186-119-174.cgn.fibianet.dk. [5.186.119.174])
        by smtp.gmail.com with ESMTPSA id v1sm3697607eds.47.2019.02.12.13.41.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 13:41:54 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Sterba <dsterba@suse.com>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-btrfs@vger.kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v4 00/14] various dynamic_debug patches
Date:   Tue, 12 Feb 2019 22:41:36 +0100
Message-Id: <20190212214150.4807-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181109231021.11658-1-linux@rasmusvillemoes.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This started as an experiment to see how hard it would be to change
the four pointers in struct _ddebug into relative offsets, a la
CONFIG_GENERIC_BUG_RELATIVE_POINTERS, thus saving 16 bytes per
pr_debug site (and thus exactly making up for the extra space used by
the introduction of jump labels in 9049fc74). I stumbled on a few
things that are probably worth fixing regardless of whether that goal
is deemed worthwhile.

Back at v3 (in November), I redid the implementation on top of the
fancy new asm-macros stuff. Luckily enough, v3 didn't get picked up,
since the asm-macros were backed out again. I still want to do the
relative-pointers thing eventually, but we're close to the merge
window opening, so here's just most of the "incidental" patches, some
of which also serve as preparation for the relative pointers.

I'm not sure how long an Ack/Reviewed-by is good for, but OTOH it also
feels rude to just drop them on the floor. I've kept those tags since
the rebasing to current master went completely smooth.

Andrew, please pick these up for soaking in -next.

v3 series: lkml.kernel.org/r/20181109231021.11658-1-linux@rasmusvillemoes.dk
v2 series: lkml.kernel.org/r/20181009112013.14238-1-linux@rasmusvillemoes.dk

Rasmus Villemoes (14):
  linux/device.h: use DYNAMIC_DEBUG_BRANCH in dev_dbg_ratelimited
  linux/net.h: use DYNAMIC_DEBUG_BRANCH in net_dbg_ratelimited
  linux/printk.h: use DYNAMIC_DEBUG_BRANCH in pr_debug_ratelimited
  dynamic_debug: consolidate DEFINE_DYNAMIC_DEBUG_METADATA definitions
  dynamic_debug: don't duplicate modname in ddebug_add_module
  dynamic_debug: use pointer comparison in ddebug_remove_module
  dynamic_debug: remove unused EXPORT_SYMBOLs
  dynamic_debug: move pr_err from module.c to ddebug_add_module
  dynamic_debug: add static inline stub for ddebug_add_module
  dynamic_debug: refactor dynamic_pr_debug and friends
  btrfs: implement btrfs_debug* in terms of helper macro
  ACPI: use proper DYNAMIC_DEBUG_BRANCH macro
  ACPI: remove unused __acpi_handle_debug macro
  ACPI: implement acpi_handle_debug in terms of _dynamic_func_call

 fs/btrfs/ctree.h              |  34 ++++--------
 include/linux/acpi.h          |  11 +---
 include/linux/device.h        |   2 +-
 include/linux/dynamic_debug.h | 102 +++++++++++++++++++---------------
 include/linux/net.h           |   2 +-
 include/linux/printk.h        |   2 +-
 kernel/module.c               |   6 +-
 lib/dynamic_debug.c           |  22 ++++----
 8 files changed, 84 insertions(+), 97 deletions(-)

-- 
2.20.1

