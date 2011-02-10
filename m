From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 13:41:06 +0100
Message-ID: <4D53DCE2.50306@nsc.liu.se>
References: <1297081322.4615.10.camel@monotop>	<4D53C711.3000309@nsc.liu.se>	<AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>	<ij0iku$hbq$1@dough.gmane.org>	<1297338885.3524.83.camel@tacticus> <AANLkTi=gBD0F143APDJEYSw+LXkrS+aOeq6zR-o8MFzs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Lars Wirzenius <liw@liw.fi>, linux-btrfs@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=gBD0F143APDJEYSw+LXkrS+aOeq6zR-o8MFzs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-02-10 13:27, Olaf van der Spek wrote:

> On Thu, Feb 10, 2011 at 12:54 PM, Lars Wirzenius <liw@liw.fi> wrote:

>> snprintf is standard, and should be about as safe as it gets with the
>> glibc functions.
> 
> But snprintf is not like strlcpy.

It is indeed uglier to write 'snprintf(dst, size, "%s", src)' instead of
'strlcpy(dst, src, size)', but both the effect and the return value should
be identical.

	/Bellman
