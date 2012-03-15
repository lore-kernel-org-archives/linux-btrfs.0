From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [PATCH] btrfs: don't add both copies of DUP to reada extent tree
Date: Thu, 15 Mar 2012 16:00:37 +0100
Message-ID: <20120315150037.GB6474@pambianco.com>
References: <1330157387-6803-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330157387-6803-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 25, 2012 at 09:09:47AM +0100, Arne Jansen wrote:
> Normally when there are 2 copies of a block, we add both to the
> reada extent tree and prefetch only the one that is easier to reach.
> This way we can better utilize multiple devices.
> In case of DUP this makes no sense as both copies reside on the
> same device.

I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
