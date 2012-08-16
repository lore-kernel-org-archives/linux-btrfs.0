Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:40973 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2HPPHC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 11:07:02 -0400
Date: Thu, 16 Aug 2012 17:06:47 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120816150647.GA22010@sig21.net>
References: <50299142.2030504@oberhumer.com>
 <20120814123937.GA14756@sig21.net>
 <502B8FE3.7080501@oberhumer.com>
 <20120815144539.GA8300@sig21.net>
 <502C92C3.7090701@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502C92C3.7090701@oberhumer.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2012 at 08:27:15AM +0200, Markus F.X.J. Oberhumer wrote:
> On 2012-08-15 16:45, Johannes Stezenbach wrote:
> > 
> > I made the attached quick hack userspace code
> > using ARM kernel headers and barebox unlzop code.
> > (new == your new code, old == linux-3.5 git, test == new + your suggested change)
> > (sorry I had no time to clean it up)
> 
> My suggested COPY4 replacement probably has a lot of load stalls - maybe some
> ARM expert could have a look and suggest a more efficient implementation.
> 
> In any case, I still would like to see the new code in linux-next because
> of the huge improvements on other modern CPUs.

Well, ~2x speedup on x86 is certainly a good achievement, but there
are more ARM based devices than there are PCs, and I guess many
embedded devices use lzo compressed kernels and file systems
while I'm not convinced many PCs rely on lzo in the kernel.

I know everyone's either busy or on vacation, but it would
be so cool if someone could test on a more modern ARM core,
with the userspace test code I posted it should be easy to do.


Johannes
