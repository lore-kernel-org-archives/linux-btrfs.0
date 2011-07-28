From: Josef Bacik <josef@redhat.com>
Subject: Re: 3.0 BUG at fs/btrfs/disk-io.c:2362 caused by I/O errors
Date: Thu, 28 Jul 2011 15:09:37 -0400
Message-ID: <20110728190937.GB3524@dhcp231-156.rdu.redhat.com>
References: <4E31ABC4.8030409@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E31ABC4.8030409@simon.arlott.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2011 at 07:34:44PM +0100, Simon Arlott wrote:
> I was running rsync when this happened. The filesystem appeared to be ok
> afterwards, with the current temporary file .MVI_0478.MOV.6YQlBJ still
> present.
> 

I have a patch for that

Btrfs: don't print the leaf if we had an error

Thanks,

Josef
