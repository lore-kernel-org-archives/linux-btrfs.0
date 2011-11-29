From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: set the i_nlink to 2 for an initial dir inode
Date: Tue, 29 Nov 2011 10:48:04 -0500
Message-ID: <20111129154804.GM24338@shiny>
References: <4ED33C88.8060501@oracle.com>
 <4ED475F5.1090500@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED475F5.1090500@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 02:04:37PM +0800, Jeff Liu wrote:
> Please ignore this patch for now, it can cause the file system corrupted
> and failed to mount again, sorry for the noise!

Directories always have a link count of 1 in btrfs.  This tells find not
to use the link count as the count of subdirectories in the directory.

-chris
