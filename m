Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33964 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaIWEmn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 00:42:43 -0400
Received: by mail-pa0-f45.google.com with SMTP id lj1so5377394pab.32
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 21:42:43 -0700 (PDT)
From: behanw@converseincode.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com, tadeusz.struk@intel.com
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, john.griffin@intel.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
        thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
        torvalds@linux-foundation.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v4 00/12] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Mon, 22 Sep 2014 21:42:05 -0700
Message-Id: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Behan Webster <behanw@converseincode.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. These patches allocate the appropriate amount of memory
using a char array using the SHASH_DESC_ON_STACK macro.

There are places in the kernel whose maintainers have previously taken our
patches to remove VLAIS from their crypto code. Once this patch set is accepted
into mainline, I'll go back and resubmit patches to these maintainers to use
this new macro so the same approach is used consistently in all places in the
kernel.

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 


Behan Webster (6):
  crypto: LLVMLinux: Add macro to remove use of VLAIS in crypto code
  crypto: LLVMLinux: Remove VLAIS from crypto/mv_cesa.c
  crypto: LLVMLinux: Remove VLAIS from crypto/n2_core.c
  crypto: LLVMLinux: Remove VLAIS from crypto/omap_sham.c
  crypto: LLVMLinux: Remove VLAIS from crypto/.../qat_algs.c
  security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c

Jan-Simon Möller (5):
  crypto: LLVMLinux: Remove VLAIS from crypto/ccp/ccp-crypto-sha.c
  crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
  crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
  crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c

Vinícius Tinti (1):
  btrfs: LLVMLinux: Remove VLAIS

 crypto/hmac.c                            | 25 ++++++++---------
 crypto/testmgr.c                         | 14 ++++------
 drivers/crypto/ccp/ccp-crypto-sha.c      | 13 ++++-----
 drivers/crypto/mv_cesa.c                 | 41 ++++++++++++----------------
 drivers/crypto/n2_core.c                 | 11 +++-----
 drivers/crypto/omap-sham.c               | 28 ++++++++-----------
 drivers/crypto/qat/qat_common/qat_algs.c | 31 ++++++++++-----------
 drivers/md/dm-crypt.c                    | 34 ++++++++++-------------
 fs/btrfs/hash.c                          | 16 +++++------
 include/crypto/hash.h                    |  5 ++++
 lib/libcrc32c.c                          | 16 +++++------
 security/integrity/ima/ima_crypto.c      | 47 +++++++++++++-------------------
 12 files changed, 122 insertions(+), 159 deletions(-)

-- 
1.9.1

