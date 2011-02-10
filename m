From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 13:27:09 +0100
Message-ID: <AANLkTi=gBD0F143APDJEYSw+LXkrS+aOeq6zR-o8MFzs@mail.gmail.com>
References: <1297081322.4615.10.camel@monotop>
	<4D53C711.3000309@nsc.liu.se>
	<AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	<ij0iku$hbq$1@dough.gmane.org>
	<1297338885.3524.83.camel@tacticus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lars Wirzenius <liw@liw.fi>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297338885.3524.83.camel@tacticus>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 10, 2011 at 12:54 PM, Lars Wirzenius <liw@liw.fi> wrote:
> On to, 2011-02-10 at 11:37 +0000, Jeremy Sanders wrote:
>> There's strlcpy, but it's not in glibc because of possible truncation
>> errors!
>
> snprintf is standard, and should be about as safe as it gets with the
> glibc functions.

But snprintf is not like strlcpy.

Olaf
