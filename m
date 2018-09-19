Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37272 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbeITDos (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 23:44:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id a20-v6so6176546edd.4
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 15:04:51 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH 00/22] various dynamic_debug patches
Date: Thu, 20 Sep 2018 00:04:22 +0200
Message-Id: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

Rasmus Villemoes (22):
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

 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/dynamic_debug.h |  35 +++++++++
 arch/x86/include/asm/jump_label.h    |  18 +++++
 fs/btrfs/ctree.h                     |  34 +++------
 include/linux/acpi.h                 |  11 +--
 include/linux/device.h               |   6 +-
 include/linux/dynamic_debug.h        | 126 +++++++++++++++++++--------------
 include/linux/jump_label.h           |   2 +
 include/linux/net.h                  |   6 +-
 include/linux/printk.h               |   6 +-
 kernel/module.c                      |   6 +-
 lib/Kconfig.debug                    |   3 +
 lib/dynamic_debug.c                  | 133 ++++++++++++++++++++++++-----------
 13 files changed, 251 insertions(+), 136 deletions(-)
 create mode 100644 arch/x86/include/asm/dynamic_debug.h

-- 
2.16.4
