From: Lars Wirzenius <liw@liw.fi>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 11:54:45 +0000
Message-ID: <1297338885.3524.83.camel@tacticus>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se>
	 <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	 <ij0iku$hbq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ij0iku$hbq$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On to, 2011-02-10 at 11:37 +0000, Jeremy Sanders wrote:
> There's strlcpy, but it's not in glibc because of possible truncation 
> errors!

snprintf is standard, and should be about as safe as it gets with the
glibc functions.

