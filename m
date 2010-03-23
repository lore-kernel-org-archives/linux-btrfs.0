From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: [PATCH 4/4] btrfs-convert: split into convert/.
Date: Tue, 23 Mar 2010 16:09:07 -0400
Message-ID: <20100323200907.GA2525@lelouch.nomadic.ncsu.edu>
References: <20100320042746.GA17114@flcl.lan>
 <20100323190628.GI30249@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100323190628.GI30249@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 23, 2010 at 03:06:28PM -0400, Chris Mason wrote:
> Thanks for doing all this work.  Which filesystems have you currently
> wired up to the converter?

ReiserFS is almost working; I just need to finish xattr support and
clean up the patch. I have somewhat less free time now, so I'm not sure
I can work on anything beyond ReiserFS.

I have looked briefly at other filesystems, and I've found that FAT,
HFS, and HFS+ have alignment issues (file data isn't aligned to block
size), while JFS, XFS, and NTFS do not.
