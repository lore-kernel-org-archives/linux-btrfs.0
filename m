From: Chris Mason <chris.mason@oracle.com>
Subject: Re: how can I copy files bigger than ~32 GB when using
 compress-force?
Date: Mon, 4 Oct 2010 18:28:37 -0400
Message-ID: <20101004222837.GD9759@think>
References: <4CAA4A34.80701@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CAA4A34.80701@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 04, 2010 at 11:42:12PM +0200, Tomasz Chmielewski wrote:
> >I'm assuming this works without compress-force?  I can make a guess at
> >what is happening, the compression forces a relatively small extent
> >size, and this is making our worst case metadata reservations get upset.
> 
> Yes, it works without compress-force.
> 
> Interesting is that cp or rsync sometimes just exit quite fast with
> "no space left".
> 
> Sometimes, they just "hang" (waited up to about an hour) - file size
> does not grow anymore, last modified time is not updated, iostat

Sorry is this hang/fast exit with or without compress-force.

> does not show any bytes read/written, there are no btrfs or any
> other processes taking too much CPU, cp/rsync is not in "D" state
> (although it gets to "D" state and uses 100% CPU as I try to kill
> it).
> 
> Could it be we're hitting two different bugs here?
> 
> 
> >Does it happen with any 32gb file that doesn't compress well?
> 
> The 220 GB qcow2 file was basically uncompressible (backuppc archive
> full of bzip2-compressed files).

Ok, I think I know what is happening here, they all lead to the same
chunk of code.  I'll be able to reproduce this locally.

-chris

