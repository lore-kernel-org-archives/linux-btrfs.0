From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Btrfs: initial online fsck support
Date: Fri, 01 Jul 2011 10:48:36 -0700
Message-ID: <m239ipnb7v.fsf@firstfloor.org>
References: <4E0C4303.1080406@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0C4303.1080406@cn.fujitsu.com> (Li Zefan's message of "Thu, 30
	Jun 2011 17:33:55 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan <lizf@cn.fujitsu.com> writes:

> This is an initial version of online fsck. What it does is:
>
> - check the dir item and dir index pointing to a file.
> - check the structure of extents of a file.
>
> As furthur work, we should consider:
>
> - fix but not only check the structure of a file.
> - verify the extent allocation tree on the fly.

It's scary to have a fsck in kernel space. Is there no way to do
this from user space?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
