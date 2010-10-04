From: Chris Mason <chris.mason@oracle.com>
Subject: Re: how can I copy files bigger than ~32 GB when using
 compress-force?
Date: Mon, 4 Oct 2010 16:37:43 -0400
Message-ID: <20101004203743.GH5090@think>
References: <4CAA3872.3080106@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CAA3872.3080106@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 04, 2010 at 10:26:26PM +0200, Tomasz Chmielewski wrote:
> I'm trying to copy a ~220 GB file from a ext4 to btrfs filesystem
> with 336 GB free space on it. System is running 2.6.36-rc6.
> 
> File size on a ext4 filesystem:
> 
> # ls -l srv1-backup.qcow2
> -rw-r--r-- 1 root root 219564146688 2010-09-26 21:56 srv1-backup.qcow2
> 
> 
> Unfortunately it fails when only about 32 GB is copied (with
> compress-force mount option enabled).

I'm assuming this works without compress-force?  I can make a guess at
what is happening, the compression forces a relatively small extent
size, and this is making our worst case metadata reservations get upset.

Does it happen with any 32gb file that doesn't compress well?

-chris
