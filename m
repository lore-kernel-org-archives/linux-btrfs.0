From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.14 Released
Date: Thu, 1 May 2008 12:04:20 -0400
Message-ID: <200805011204.20847.chris.mason@oracle.com>
References: <200804291601.32945.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200804291601.32945.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 29 April 2008, Chris Mason wrote:
> Hello everyone,
>
> Btrfs v0.14 is now available for download.  Please note the disk format has
> changed, and it is not compatible with older versions of Btrfs.
>
> For downloads and documention, please see the Btrfs project page:
>
> http://btrfs.wiki.kernel.org
>

Hello everyone,

I've rolled up some fixes for older kernels and fixed an uninitialized 
variables in btrfs-progs that could cause an oops on mount.  I'll wait a few 
days to see if other bug reports come in and cut a 0.15 with any other 
critical fixes.

Until then, you can find download information on the important fixes so far:

http://btrfs.wiki.kernel.org/index.php/Hot_Fixes

-chris
