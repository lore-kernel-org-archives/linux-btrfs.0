From: Andrew Benton <b3nton@gmail.com>
Subject: Re: chmod errors compiling on btrfs
Date: Mon, 09 Nov 2009 18:58:07 +0000
Message-ID: <4AF8663F.8000605@gmail.com>
References: <4AF5DA58.1060600@gmail.com> <20091109151503.GA2812@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091109151503.GA2812@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/09 15:15, Chris Mason wrote:
> We fixed some umask problems recently, these should be fixed in the
> master branch of the btrfs-unstable repo (which is against 2.6.31).
>

Thanks, that did the trick. Will these umask fixes be in the 2.6.32 kernel?

Andy
