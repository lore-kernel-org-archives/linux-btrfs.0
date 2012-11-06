Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5917 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KFUPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 15:15:38 -0500
Date: Wed, 07 Nov 2012 04:15:38 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [ablock84-btrfs:btrfs-far 19/20] fs/far/far-path.c:42:2: error:
 implicit declaration of function 'IS_ERR'
Message-ID: <50996fea.Nu9pNxL8M9vTCJZh%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   git://github.com/ablock84/linux-btrfs.git btrfs-far
head:   f9a5bb450a8cc7aa5fd4f11d0306b3f48cf2771d
commit: 29aefeaaf482ab396ff53c2bbf5c35ce237b91c0 [19/20] fs: add libfarstream support
config: make ARCH=s390 allmodconfig

All error/warnings:

In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:14:0: warning: "__constant_htonl" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:14:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:15:0: warning: "__constant_ntohl" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:15:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:16:0: warning: "__constant_htons" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:16:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:17:0: warning: "__constant_ntohs" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:17:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:18:0: warning: "__constant_cpu_to_le64" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:18:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:19:0: warning: "__constant_le64_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:19:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:20:0: warning: "__constant_cpu_to_le32" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:20:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:21:0: warning: "__constant_le32_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:21:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:22:0: warning: "__constant_cpu_to_le16" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:22:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:23:0: warning: "__constant_le16_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:23:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:24:0: warning: "__constant_cpu_to_be64" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:24:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:25:0: warning: "__constant_be64_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:25:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:26:0: warning: "__constant_cpu_to_be32" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:26:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:27:0: warning: "__constant_be32_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:27:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:28:0: warning: "__constant_cpu_to_be16" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:28:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:29:0: warning: "__constant_be16_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:29:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:30:0: warning: "__cpu_to_le64" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:30:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:31:0: warning: "__le64_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:31:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:32:0: warning: "__cpu_to_le32" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:32:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
include/uapi/linux/byteorder/big_endian.h:33:0: warning: "__le32_to_cpu" redefined [enabled by default]
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from fs/far/far-attr.h:30,
                 from fs/far/far-attr.c:19:
include/uapi/linux/byteorder/little_endian.h:33:0: note: this is the location of the previous definition
In file included from include/linux/byteorder/big_endian.h:4:0,
                 from arch/s390/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from arch/s390/include/asm/bitops.h:829,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from arch/s390/include/asm/bug.h:4,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/vmalloc.h:4,
                 from fs/far/far-mem.h:23,
                 from fs/far/far-attr.c:21:
..

vim +42 +/IS_ERR fs/far/far-path.c

29aefeaa Alexander Block 2012-11-06   36  	INIT_LIST_HEAD(&fp->elements);
29aefeaa Alexander Block 2012-11-06   37  	return fp;
29aefeaa Alexander Block 2012-11-06   38  }
29aefeaa Alexander Block 2012-11-06   39  
29aefeaa Alexander Block 2012-11-06   40  void far_path_free(struct far_path *fp)
29aefeaa Alexander Block 2012-11-06   41  {
29aefeaa Alexander Block 2012-11-06  @42  	if (!fp || IS_ERR(fp))
29aefeaa Alexander Block 2012-11-06   43  		return;
29aefeaa Alexander Block 2012-11-06   44  	far_path_reset(fp);
29aefeaa Alexander Block 2012-11-06   45  	far_free(fp);
29aefeaa Alexander Block 2012-11-06   46  }
29aefeaa Alexander Block 2012-11-06   47  
29aefeaa Alexander Block 2012-11-06   48  void far_path_reset(struct far_path *fp)
29aefeaa Alexander Block 2012-11-06   49  {
29aefeaa Alexander Block 2012-11-06   50  	struct far_path_element *e, *tmp;
29aefeaa Alexander Block 2012-11-06   51  	list_for_each_entry_safe(e, tmp, &fp->elements, list) {
29aefeaa Alexander Block 2012-11-06   52  		far_free(e);
29aefeaa Alexander Block 2012-11-06   53  	}
29aefeaa Alexander Block 2012-11-06   54  	INIT_LIST_HEAD(&fp->elements);
29aefeaa Alexander Block 2012-11-06   55  }
29aefeaa Alexander Block 2012-11-06   56  
29aefeaa Alexander Block 2012-11-06   57  
29aefeaa Alexander Block 2012-11-06   58  char *far_path_add_prepare(struct far_path *fp, enum far_path_element_type type, int name_len, int prepend)
29aefeaa Alexander Block 2012-11-06   59  {
29aefeaa Alexander Block 2012-11-06   60  	struct far_path_element *e;
29aefeaa Alexander Block 2012-11-06   61  
29aefeaa Alexander Block 2012-11-06   62  	e = far_malloc(sizeof(*e) + name_len + 1);
29aefeaa Alexander Block 2012-11-06   63  	if (!e)
29aefeaa Alexander Block 2012-11-06   64  		return NULL;
29aefeaa Alexander Block 2012-11-06   65  
29aefeaa Alexander Block 2012-11-06   66  	e->len = name_len;
29aefeaa Alexander Block 2012-11-06   67  	e->type = type;
29aefeaa Alexander Block 2012-11-06   68  	e->name[0] = 0;
29aefeaa Alexander Block 2012-11-06   69  	if (prepend)
29aefeaa Alexander Block 2012-11-06   70  		list_add(&e->list, &fp->elements);
29aefeaa Alexander Block 2012-11-06   71  	else
29aefeaa Alexander Block 2012-11-06   72  		list_add_tail(&e->list, &fp->elements);
29aefeaa Alexander Block 2012-11-06   73  	return e->name;
29aefeaa Alexander Block 2012-11-06   74  }
29aefeaa Alexander Block 2012-11-06   75  
29aefeaa Alexander Block 2012-11-06   76  int far_path_add(struct far_path *fp, enum far_path_element_type type, const char *name, int name_len, int prepend)
29aefeaa Alexander Block 2012-11-06   77  {
29aefeaa Alexander Block 2012-11-06   78  	char *buf;
29aefeaa Alexander Block 2012-11-06   79  	if (name_len == -1)
29aefeaa Alexander Block 2012-11-06   80  		name_len = strlen(name);
29aefeaa Alexander Block 2012-11-06   81  	buf = far_path_add_prepare(fp, type, name_len, prepend);
29aefeaa Alexander Block 2012-11-06   82  	if (!buf)
29aefeaa Alexander Block 2012-11-06   83  		return -ENOMEM;
29aefeaa Alexander Block 2012-11-06   84  	memcpy(buf, name, name_len);
29aefeaa Alexander Block 2012-11-06   85  	buf[name_len] = 0;
29aefeaa Alexander Block 2012-11-06   86  	return 0;
29aefeaa Alexander Block 2012-11-06   87  }
29aefeaa Alexander Block 2012-11-06   88  
29aefeaa Alexander Block 2012-11-06   89  void far_path_remove_one(struct far_path *fp)
29aefeaa Alexander Block 2012-11-06   90  {
29aefeaa Alexander Block 2012-11-06   91  	struct far_path_element *e;
29aefeaa Alexander Block 2012-11-06   92  	if (list_empty(&fp->elements))
29aefeaa Alexander Block 2012-11-06   93  		return;
29aefeaa Alexander Block 2012-11-06   94  	e = list_entry(fp->elements.prev, struct far_path_element, list);
29aefeaa Alexander Block 2012-11-06   95  	list_del(&e->list);
29aefeaa Alexander Block 2012-11-06   96  }
29aefeaa Alexander Block 2012-11-06   97  
29aefeaa Alexander Block 2012-11-06   98  int far_path_copy(struct far_path *fp, struct far_path *from)
29aefeaa Alexander Block 2012-11-06   99  {
29aefeaa Alexander Block 2012-11-06  100  	int ret;
29aefeaa Alexander Block 2012-11-06  101  	struct far_path_element *e;
29aefeaa Alexander Block 2012-11-06  102  	far_path_reset(fp);
29aefeaa Alexander Block 2012-11-06  103  	list_for_each_entry(e, &from->elements, list) {
29aefeaa Alexander Block 2012-11-06  104  		ret = far_path_add(fp, e->type, e->name, e->len, 0);
29aefeaa Alexander Block 2012-11-06  105  		if (ret < 0)
29aefeaa Alexander Block 2012-11-06  106  			return ret;
29aefeaa Alexander Block 2012-11-06  107  	}
29aefeaa Alexander Block 2012-11-06  108  	return 0;
29aefeaa Alexander Block 2012-11-06  109  }
29aefeaa Alexander Block 2012-11-06  110  
29aefeaa Alexander Block 2012-11-06  111  struct far_path *far_path_clone(struct far_path *fp)
29aefeaa Alexander Block 2012-11-06  112  {
29aefeaa Alexander Block 2012-11-06  113  	int ret;
29aefeaa Alexander Block 2012-11-06  114  	struct far_path *c;
29aefeaa Alexander Block 2012-11-06  115  	c = far_path_alloc();
29aefeaa Alexander Block 2012-11-06  116  	if (!c)
29aefeaa Alexander Block 2012-11-06  117  		return NULL;
29aefeaa Alexander Block 2012-11-06  118  	ret = far_path_copy(c, fp);
29aefeaa Alexander Block 2012-11-06  119  	if (ret < 0) {
29aefeaa Alexander Block 2012-11-06  120  		far_path_free(c);
29aefeaa Alexander Block 2012-11-06 @121  		return ERR_PTR(ret);
29aefeaa Alexander Block 2012-11-06  122  	}
29aefeaa Alexander Block 2012-11-06  123  
29aefeaa Alexander Block 2012-11-06  124  	return c;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
