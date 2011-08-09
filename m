From: Sage Weil <sage@newdream.net>
Subject: Re: clone ioctl bug with inline extents
Date: Tue, 9 Aug 2011 12:10:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1108091209200.9871@cobra.newdream.net>
References: <Pine.LNX.4.64.1108091102240.9871@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1108091102240.9871@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 9 Aug 2011, Sage Weil wrote:
> Hi all,
> 
> I'm hitting a problem cloning inline extents that I haven't had much 
> success tracking down.  It's simple enough to reproduce:
> 
>  echo 1111111111111111111111111111 > src
>  echo 2 > dst
>  clone_range src 0 29 dst 0
>  cmp src dst       # fails! dst is size 29 but contains "2\n\0\0\0\0..."

<facepalm>, ok, this was just a matter of the ioctl code not dropping the 
old page cache pages.  I'm not sure how we didn't notice that for so long!

sage
