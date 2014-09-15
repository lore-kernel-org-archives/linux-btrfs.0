Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47132 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaIOIhx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 04:37:53 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so6008873pab.40
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 01:37:49 -0700 (PDT)
Message-ID: <5416A558.3070109@converseincode.com>
Date: Mon, 15 Sep 2014 01:37:44 -0700
From: Behan Webster <behanw@converseincode.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
CC: agk@redhat.com, clm@fb.com, David Miller <davem@davemloft.net>,
        fabf@skynet.be, Herbert Xu <herbert@gondor.apana.org.au>,
        jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com,
        thomas.lendacky@amd.com, linux-ima-user@lists.sourceforge.net,
        qat-linux@intel.com, d.kasatkin@samsung.com,
        Bruce Allan <bruce.w.allan@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, john.griffin@intel.com,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ima-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>, zohar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [dm-devel] [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove
 use of VLAIS in crypto code
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-2-git-send-email-behanw@converseincode.com> <CAHXqBFK=o2Q3CUPWaL_8TDBJbGjfEOx_HnQzooy33wuKWyu5Gw@mail.gmail.com>
In-Reply-To: <CAHXqBFK=o2Q3CUPWaL_8TDBJbGjfEOx_HnQzooy33wuKWyu5Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/14 01:06, Michał Mirosław wrote:
> 2014-09-15 9:30 GMT+02:00  <behanw@converseincode.com>:
> [...]
>> +#define SHASH_DESC_ON_STACK(shash, tfm)                                  \
>> +       char __desc[sizeof(struct shash_desc) +                   \
>> +               crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
>> +       struct shash_desc *shash = (struct shash_desc *)__desc
>> +
> char shash##__desc[] or similar? Otherwise it won't work if you use
> this macro twice in the same block.
>
> Best Regards,
> Michał Mirosław
Good thinking. Will fix.

Behan

-- 
Behan Webster
behanw@converseincode.com

