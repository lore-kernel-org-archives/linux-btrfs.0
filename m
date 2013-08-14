Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416Ab3HNXRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:23 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHNe5014658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSv017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/15] btrfs-progs: fix unaligned compat endian warnings
Date: Wed, 14 Aug 2013 16:16:42 -0700
Message-Id: <1376522205-16992-13-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The _una_ struct's entire job is to pass an argument to le*_to_cpu.  So
it's a little embarassing that it uses a native cpu types and generates
endian warnings.

ctree.h:1616:1: warning: incorrect type in assignment (different base types)
ctree.h:1616:1:    expected unsigned long long [unsigned] [usertype] x
ctree.h:1616:1:    got restricted __le64 [usertype] <noident>

Signed-off-by: Zach Brown <zab@redhat.com>
---
 kerncompat.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index 4d78288..1fc2b34 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -277,9 +277,9 @@ typedef u64 __bitwise __be64;
 #define le16_to_cpu(x) ((__force u16)(__le16)(x))
 #endif
 
-struct __una_u16 { u16 x; } __attribute__((__packed__));
-struct __una_u32 { u32 x; } __attribute__((__packed__));
-struct __una_u64 { u64 x; } __attribute__((__packed__));
+struct __una_u16 { __le16 x; } __attribute__((__packed__));
+struct __una_u32 { __le32 x; } __attribute__((__packed__));
+struct __una_u64 { __le64 x; } __attribute__((__packed__));
 
 #define get_unaligned_le8(p) (*((u8 *)(p)))
 #define put_unaligned_le8(val,p) ((*((u8 *)(p))) = (val))
-- 
1.7.11.7

