From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: [patch 1/5] btrfs-progs: convert to autotools
Date: Sat, 14 Jun 2008 03:09:06 +0100
Message-ID: <f058a9c30806131909m177bf1d4id296afd7340af363@mail.gmail.com>
References: <20080613200906.180149089@suse.com>
	 <20080613201007.641785953@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Chris Mason" <chris.mason@oracle.com>,
	"Btrfs Development List" <linux-btrfs@vger.kernel.org>
To: "Jeff Mahoney" <jeffm@jeffreymahoney.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080613201007.641785953@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

On Fri, Jun 13, 2008 at 9:09 PM, Jeff Mahoney <jeffm@jeffreymahoney.com> wrote:
>  This patch converts the btrfs-progs build system from a single Makefile
>  to the autotools suite.
>
>  The advantages are:
>  Easier construction of Makefiles
>  Easier to breakout the source into separate directories for easier management
>  Easier to build shared libraries automatically
>  Automatic checking for optional libraries, like libext2fs for btrfs-convert
>  Automatic infrastructure for installing and testing
>
>  The caveats are:
>  Opinions on autotools are... mixed.
>  make C=1 no longer works, but is replaced by make check.

Please make this optional..
I would really prefer the simple makefile that it has now..
If the proposed advantages are a wanted feature, I would gladly try to
supply patches for the makefile to support them..
Just to keep it away from autotool hell.

Kind regards

--
Miguel Sousa Filipe
