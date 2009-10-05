From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix possible softlockup in the allocator
Date: Mon, 5 Oct 2009 19:09:06 -0400
Message-ID: <20091005230906.GA22292@think>
References: <20091005193039.GA2308@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, johannes.hirte@fem.tu-ilmenau.de
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091005193039.GA2308@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2009 at 03:30:39PM -0400, Josef Bacik wrote:
> Like the cluster allocating stuff, we can lockup the box with the normal
> allocation path.  This happens when we

This is working for me, I'm hammering on it a bit.

-chris
