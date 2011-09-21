From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Wed, 21 Sep 2011 22:35:25 +0200
Message-ID: <20110921203525.GA7660@kashmir>
References: <20110921185350.GA6618@kashmir>
 <4E7A4695.9080106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7A4695.9080106@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2011 at 04:18:29PM -0400, Josef Bacik wrote:
> Yup, can you apply this patch and reproduce?  It will print out some
> debug info before the --- cut here --- line, which is what I need.  Thanks,

Compiling right now.  That said, I had the same exact trace under
rc6-00067-gf1fcd9f (right after rebooting to this older kernel) so it
doesn't seem to be related to the latest git...

Not sure how to trigger the bug though, I'll keep you posted!

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
