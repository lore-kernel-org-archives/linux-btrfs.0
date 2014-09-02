Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53690 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIBXBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 19:01:34 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH RFC 0/6] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Date: Tue, 2 Sep 2014 16:01:42 -0700
Cc: Alasdair Kergon <agk@redhat.com>, clm@fb.com,
        "David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
        Fabian Frederick <fabf@skynet.be>,
        Herbert Xu <herbert@gondor.apana.org.au>, jbacik@fb.com,
        snitzer@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        james.l.morris@oracle.com, john.johansen@canonical.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
        linux-security-module@vger.kernel.org, neilb@suse.de, serge@hallyn.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-Id: <05DCB0B8-AA7C-495F-B8E6-0803052DD273@holtmann.org>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
To: behanw@converseincode.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Behan,

> These patches remove the use of Variable Length Arrays In Structs (VLAIS) in
> crypto related code. Presented here for comments as a whole (since they all do
> the same thing in the same way). Once everyone is happy I will submit them
> individually to their appropriate maintainers.
> 
> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
> clang (the C front end for the LLVM compiler infrastructure project). 
> 
> 
> Jan-Simon Möller (4):
>  crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
>  crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
>  crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
>  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
> 
> Vinícius Tinti (2):
>  apparmor: LLVMLinux: Remove VLAIS
>  btrfs: LLVMLinux: Remove VLAIS
> 
> crypto/hmac.c              | 27 +++++++++++++--------------
> crypto/testmgr.c           | 16 ++++++++--------
> drivers/md/dm-crypt.c      | 38 ++++++++++++++++++--------------------
> fs/btrfs/hash.c            | 18 +++++++++---------
> lib/libcrc32c.c            | 18 +++++++++---------
> security/apparmor/crypto.c | 19 +++++++++----------
> 6 files changed, 66 insertions(+), 70 deletions(-)

are you sure these are all of them? I know for a fact that we are using the same construct in net/bluetooth/amp.c as well.

Regards

Marcel

