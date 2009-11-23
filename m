From: Chris Mason <chris.mason@oracle.com>
Subject: Re: A file cloned with "--reflink" different from the original one?
Date: Mon, 23 Nov 2009 09:40:20 -0500
Message-ID: <20091123144019.GA15294@think>
References: <119341710911230126t542b7921p9dd15d804ba97244@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jian Lin <lj@linjian.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <119341710911230126t542b7921p9dd15d804ba97244@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 23, 2009 at 05:26:32PM +0800, Jian Lin wrote:
> I installed BtrFS 0.19 and GNU coreutils 8.1 on my Ubuntu 9.10.
> I tried to clone some files with "--reflink" to make them "copy-on-write".
> However, I found some of the files cloned have different MD5's to the
> original ones.
> 
> Is BtrFS (or cp with reflink) buggy?
> Or it is indeed a feature that I used incorrectly?

There have been some fixes to the reflink code sine 2.6.31, I think
you're hitting a known bug.  Please try the btrfs-unstable repo, or a
2.6.32-rc kernel.

-chris
