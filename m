Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63497 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaIOOVr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 10:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <1410766234-1634-12-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
	<1410766234-1634-12-git-send-email-behanw@converseincode.com>
Date: Mon, 15 Sep 2014 07:21:46 -0700
Message-ID: <CA+55aFx8FN2Rq+d3v9rsDbTyX3hwm6TvudvZrL5wgf7fX3aQjA@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Behan Webster <behanw@converseincode.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Chris Mason <clm@fb.com>,
        David Miller <davem@davemloft.net>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Herbert Xu <herbert@gondor.apana.org.au>, Josef Bacik <jbacik@fb.com>,
        Mike Snitzer <snitzer@redhat.com>, tadeusz.struk@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        James Morris <james.l.morris@oracle.com>, john.griffin@intel.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, qat-linux@intel.com,
        "Serge E. Hallyn" <serge@hallyn.com>, thomas.lendacky@amd.com,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 15, 2014 at 12:30 AM,  <behanw@converseincode.com> wrote:
> From: Behan Webster <behanw@converseincode.com>
>
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This patch allocates the appropriate amount of memory
> using a char array using the SHASH_DESC_ON_STACK macro.

You only made the first case use SHASH_DESC_ON_STACK, the two other
cases you left in the ugly format. Was that just an oversight, or was
there some reason for it?

             Linus
