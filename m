From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: 800 GByte free, but "no space left"
Date: Thu, 2 Dec 2010 19:28:42 -0800
Message-ID: <AANLkTikWfn-=T==MjcbiZiURy_nY1+RpBfpXyOHLLfUO@mail.gmail.com>
References: <Bb7IYwqi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bb7IYwqi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 2, 2010 at 10:23 AM, Helmut Hullen <Hullen@t-online.de> wrote:
> Btrfs Btrfs v0.19
>

"btrfs" in the kernel has been version 0.19 for a *long* time.  The
version number there may never change.  How do you encode a feature
mask in a version number?  Some features may be in one tree but not
upstreamed all together and other such minutiae.

What you need to do is use a more recent kernel than 2.6.32 if you
want to use btrfs (modulo backports, but let's not talk about that
right now).

So if you're using a kernel older than 2.6.36, then you should probably upgrade.
