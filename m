Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1B4C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 046C72083D
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfCVNdN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:33:13 -0400
Received: from retiisi.org.uk ([95.216.213.190]:36874 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728162AbfCVNdN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 09:33:13 -0400
Received: from lanttu.localdomain (unknown [IPv6:2a01:4f9:c010:4572::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3E452634C7B;
        Fri, 22 Mar 2019 15:19:02 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Date:   Fri, 22 Mar 2019 15:21:06 +0200
Message-Id: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

The printk family of functions supports %ps and %pS conversion specifiers
to print function names. Yet the deprecated %pf and %pF conversion
specifiers with equivalent functionality remain supported. A number of
users of %pf and %pF remain.

This patchsets converts the existing users of %pf and %pF to %ps and %pS,
respectively, and removes support for the deprecated %pf and %pF.

The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
%pf or %pF users have been added in the meantime so the patch is
sufficient as itself on linux-next, too.

Sakari Ailus (2):
  treewide: Switch printk users from %pf and %pF to %ps and %pS,
    respectively
  vsprintf: Remove support for %pF and %pf in favour of %pS and %ps

 Documentation/core-api/printk-formats.rst | 10 ----------
 arch/alpha/kernel/pci_iommu.c             | 20 ++++++++++----------
 arch/arm/mach-imx/pm-imx6.c               |  2 +-
 arch/arm/mm/alignment.c                   |  2 +-
 arch/arm/nwfpe/fpmodule.c                 |  2 +-
 arch/microblaze/mm/pgtable.c              |  2 +-
 arch/sparc/kernel/ds.c                    |  2 +-
 arch/um/kernel/sysrq.c                    |  2 +-
 arch/x86/include/asm/trace/exceptions.h   |  2 +-
 arch/x86/kernel/irq_64.c                  |  2 +-
 arch/x86/mm/extable.c                     |  4 ++--
 arch/x86/xen/multicalls.c                 |  2 +-
 drivers/acpi/device_pm.c                  |  2 +-
 drivers/base/power/main.c                 |  6 +++---
 drivers/base/syscore.c                    | 12 ++++++------
 drivers/block/drbd/drbd_receiver.c        |  2 +-
 drivers/block/floppy.c                    | 10 +++++-----
 drivers/cpufreq/cpufreq.c                 |  2 +-
 drivers/mmc/core/quirks.h                 |  2 +-
 drivers/nvdimm/bus.c                      |  2 +-
 drivers/nvdimm/dimm_devs.c                |  2 +-
 drivers/pci/pci-driver.c                  | 14 +++++++-------
 drivers/pci/quirks.c                      |  4 ++--
 drivers/pnp/quirks.c                      |  2 +-
 drivers/scsi/esp_scsi.c                   |  2 +-
 fs/btrfs/tests/free-space-tree-tests.c    |  4 ++--
 fs/f2fs/f2fs.h                            |  2 +-
 fs/pstore/inode.c                         |  2 +-
 include/trace/events/btrfs.h              |  2 +-
 include/trace/events/cpuhp.h              |  4 ++--
 include/trace/events/preemptirq.h         |  2 +-
 include/trace/events/rcu.h                |  4 ++--
 include/trace/events/sunrpc.h             |  2 +-
 include/trace/events/timer.h              |  8 ++++----
 include/trace/events/vmscan.h             |  4 ++--
 include/trace/events/workqueue.h          |  4 ++--
 include/trace/events/xen.h                |  2 +-
 init/main.c                               |  6 +++---
 kernel/async.c                            |  4 ++--
 kernel/events/uprobes.c                   |  2 +-
 kernel/fail_function.c                    |  2 +-
 kernel/irq/debugfs.c                      |  2 +-
 kernel/irq/handle.c                       |  2 +-
 kernel/irq/manage.c                       |  2 +-
 kernel/irq/spurious.c                     |  4 ++--
 kernel/rcu/tree.c                         |  2 +-
 kernel/stop_machine.c                     |  2 +-
 kernel/time/sched_clock.c                 |  2 +-
 kernel/time/timer.c                       |  2 +-
 kernel/workqueue.c                        | 12 ++++++------
 lib/error-inject.c                        |  2 +-
 lib/percpu-refcount.c                     |  4 ++--
 lib/vsprintf.c                            |  8 ++------
 mm/memblock.c                             | 12 ++++++------
 mm/memory.c                               |  2 +-
 mm/vmscan.c                               |  2 +-
 net/ceph/osd_client.c                     |  2 +-
 net/core/net-procfs.c                     |  2 +-
 net/core/netpoll.c                        |  4 ++--
 scripts/checkpatch.pl                     |  5 -----
 60 files changed, 111 insertions(+), 130 deletions(-)

-- 
2.11.0

