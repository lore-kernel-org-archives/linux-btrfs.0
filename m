From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: add discard flag to btrfs_device and make
 btrfs_discard_extent aware of that
Date: Mon, 13 Jun 2011 17:43:08 +0200
Message-ID: <20110613154308.GU12709@twin.jikos.cz>
References: <1307604489-7884-1-git-send-email-lidongyang@novell.com>
 <20110610000017.GP12709@twin.jikos.cz>
 <201106101340.31230.lidongyang@novell.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Li Dongyang <lidongyang@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106101340.31230.lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2011 at 01:40:31PM +0800, Li Dongyang wrote:
> > otherwise the patch looks good (and matches my view how to do it). I
> > will test it eventually.
> Thanks a lot, I'll resend this this a proper name.

JFYI, tested in the previous scenario, ie. all devices without trim
support, does not crash.

david
