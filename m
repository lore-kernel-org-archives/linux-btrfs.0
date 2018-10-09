Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D49C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 11:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C961B20835
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 11:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="SfUENK1/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C961B20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbeJISgv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 14:36:51 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42132 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeJISgv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 14:36:51 -0400
Received: by mail-ed1-f67.google.com with SMTP id b7-v6so1310506edd.9
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 04:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sn/AWD4WRDQ2Msz68IUClU2wTNTckgQGW9iv1MLre4Q=;
        b=SfUENK1/2RHdd9jyU5+p/ByeQTQt8SlPigGrHXc50eAluvFrJt13K1d03Rw67JBvqj
         JpZ4JokO7kRP+9t41mUhTDl9fMbWOzBf6cSluKruXyW2GvvEFuZTK7LCs8sspmy2JDQx
         vsI5WOiOb2X73TCDBUNPYO4K3M3nwmRSJxgB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sn/AWD4WRDQ2Msz68IUClU2wTNTckgQGW9iv1MLre4Q=;
        b=oEmlw4B/q2jLpVn9a58HLGqwg1D5j7jX+SCg9w+o+QBQj2T+bsEgZaI8XW25uPLdNX
         Tuze0o+U8FoR/7d2hEYbtM0GmyNAWekA0Y4iXw5IaM9DhSnq9hCg7iwNHUg8H/wdgw/v
         TESaA4IjOH6jvLk/QJ87snCiDNdDroGpBnNnxShtH05dfr8KMPlU7ePNEyAKSgM40jvB
         SLukUEPwoq6M4gZo1A1Xe1IyK5LETvkI2v1fEYCcSWjiI5XSwv+fhyyoAcpv/UrXO8+1
         fm90OG47DRrFkZAfDfIJWV+LIABwtgGJW8MEIEC2e831Heur8gyF33Np91q56LlpP+1h
         GRGQ==
X-Gm-Message-State: ABuFfohYNzvFZy8aIKBwkZvK9Oyv1fInyd3mX5maWK5oVU4YiOy+m0qS
        8XgQ4KxehIYyEULL/G37F7CMbQ==
X-Google-Smtp-Source: ACcGV60a4vEXF463OnoPHeFSd4gn1L5j9nElIb9Szu8s77AKGG0xsHXqjk22EsE44jupCHDaAs7BcQ==
X-Received: by 2002:a17:906:95da:: with SMTP id n26-v6mr26423798ejy.205.1539084019800;
        Tue, 09 Oct 2018 04:20:19 -0700 (PDT)
Received: from prevas-ravi.vestasvisitor.net ([193.47.71.171])
        by smtp.gmail.com with ESMTPSA id n23-v6sm3595821eja.41.2018.10.09.04.20.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Oct 2018 04:20:19 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH v2 00/23] various dynamic_debug patches
Date:   Tue,  9 Oct 2018 13:19:50 +0200
Message-Id: <20181009112013.14238-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.19.1.4.g721af0fda3
In-Reply-To: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v2: Added various acks/reviews. I'll follow up with rewriting the x86
part as asm macros once that work is in mainline.

Patches 15, 16 are in next-20181009; in hindsight I should probably
have asked Rafael not to pick those. Patch 17 textually depend on
those, and patch 19 removes the .flags field, so depends on 15 so that
there are no references to that field. I'm included all patches here
hoping that the merge conflicts are trivial, given that it's just same
patches present in multiple branches.

Andrew, can you pick up these to give them some time in -next?

v1 cover letter:

This started as an experiment to see how hard it would be to change
the four pointers in struct _ddebug into relative offsets, a la
CONFIG_GENERIC_BUG_RELATIVE_POINTERS, thus saving 16 bytes per
pr_debug site (and thus exactly making up for the extra space used by
the introduction of jump labels in 9049fc74). I stumbled on a few
things that are probably worth fixing regardless of whether the latter
half of this series is deemed worthwhile.

Patch relationships: 1-2, 3-4, 5-6 and 15-16 can be applied
individually, though 2, 4 and 6 probably makes most sense in the
context of the final goal of the series.

7-12 I believe make sense on their own. Patch 13 again only makes
sense if we go all the way, and 14 and 17 depend on 13.

18-21 are more preparatory patches, and finally 22 switch over x86-64
to use CONFIG_DYNAMIC_DEBUG_RELATIVE_POINTERS. I've tested that the
end result boots under virtme and that the dynamic_debug control file
has the expected contents.

Rasmus Villemoes (23):
  linux/device.h: use DYNAMIC_DEBUG_BRANCH in dev_dbg_ratelimited
  linux/device.h: use unique identifier for each struct _ddebug
  linux/net.h: use DYNAMIC_DEBUG_BRANCH in net_dbg_ratelimited
  linux/net.h: use unique identifier for each struct _ddebug
  linux/printk.h: use DYNAMIC_DEBUG_BRANCH in pr_debug_ratelimited
  linux/printk.h: use unique identifier for each struct _ddebug
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
  dynamic_debug: introduce accessors for string members of struct
    _ddebug
  dynamic_debug: drop use of bitfields in struct _ddebug
  dynamic_debug: introduce CONFIG_DYNAMIC_DEBUG_RELATIVE_POINTERS
  x86: jump_label: introduce ASM_STATIC_KEY_INIT_{TRUE,FALSE}
  x86_64: use relative pointers with dynamic debug
  x86: dynamic_debug: protect against dynamic debug identifier reuse

 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/dynamic_debug.h |  40 ++++++++
 arch/x86/include/asm/jump_label.h    |  18 ++++
 fs/btrfs/ctree.h                     |  34 ++-----
 include/linux/acpi.h                 |  11 +--
 include/linux/device.h               |   6 +-
 include/linux/dynamic_debug.h        | 126 +++++++++++++++----------
 include/linux/jump_label.h           |   2 +
 include/linux/net.h                  |   6 +-
 include/linux/printk.h               |   6 +-
 kernel/module.c                      |   6 +-
 lib/Kconfig.debug                    |   3 +
 lib/dynamic_debug.c                  | 133 ++++++++++++++++++---------
 13 files changed, 256 insertions(+), 136 deletions(-)
 create mode 100644 arch/x86/include/asm/dynamic_debug.h

-- 
2.19.1.3.g1d92a00e68

