From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [PATCH] btrfs: fix race in reada
Date: Thu, 15 Mar 2012 15:59:27 +0100
Message-ID: <20120315145744.GA6474@pambianco.com>
References: <1330157370-6764-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330157370-6764-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 25, 2012 at 09:09:30AM +0100, Arne Jansen wrote:
> When inserting into the radix tree returns EEXIST, get the existing
> entry without giving up the spinlock in between.
> There was a race for both the zones trees and the extent tree.

I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
