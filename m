Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60226 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbaIBWdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 18:33:07 -0400
Received: by mail-pd0-f170.google.com with SMTP id r10so9629485pdi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 15:33:07 -0700 (PDT)
From: behanw@converseincode.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
        john.johansen@canonical.com, linux-btrfs@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH RFC 0/6] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Tue,  2 Sep 2014 15:32:27 -0700
Message-Id: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Behan Webster <behanw@converseincode.com>

These patches remove the use of Variable Length Arrays In Structs (VLAIS) in
crypto related code. Presented here for comments as a whole (since they all do
the same thing in the same way). Once everyone is happy I will submit them
individually to their appropriate maintainers.

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 


Jan-Simon Möller (4):
  crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
  crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
  crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c

Vinícius Tinti (2):
  apparmor: LLVMLinux: Remove VLAIS
  btrfs: LLVMLinux: Remove VLAIS

 crypto/hmac.c              | 27 +++++++++++++--------------
 crypto/testmgr.c           | 16 ++++++++--------
 drivers/md/dm-crypt.c      | 38 ++++++++++++++++++--------------------
 fs/btrfs/hash.c            | 18 +++++++++---------
 lib/libcrc32c.c            | 18 +++++++++---------
 security/apparmor/crypto.c | 19 +++++++++----------
 6 files changed, 66 insertions(+), 70 deletions(-)

-- 
1.9.1

