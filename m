From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix btrfs-convert's large file support.
Date: Mon, 28 Apr 2008 11:09:31 -0400
Message-ID: <200804281109.32164.chris.mason@oracle.com>
References: <13c114d20804272303mf33127bs233b68c8c2244c9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: "Zhu Yanhai" <piggestpig@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <13c114d20804272303mf33127bs233b68c8c2244c9f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 28 April 2008, Zhu Yanhai wrote:
> Hello,
>   This patch add ext2_inode.i_size_high into account when calculating
> regular file's size in btrfs-convert,  which makes it deal with large files
>  bigger than 4GB properly.

Great, I'll pull this in today.

-chris
