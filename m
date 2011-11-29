From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 2/2] Btrfs: set the i_nlink to 2 for an initial dir inode
Date: Tue, 29 Nov 2011 17:10:34 +0100
Message-ID: <4ED503FA.9070301@jan-o-sch.net>
References: <4ED33C88.8060501@oracle.com> <4ED475F5.1090500@oracle.com> <20111129154804.GM24338@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jeff Liu <jeff.liu@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129154804.GM24338@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 29.11.2011 16:48, Chris Mason wrote:
> On Tue, Nov 29, 2011 at 02:04:37PM +0800, Jeff Liu wrote:
>> Please ignore this patch for now, it can cause the file system corrupted
>> and failed to mount again, sorry for the noise!
> 
> Directories always have a link count of 1 in btrfs.  This tells find not
> to use the link count as the count of subdirectories in the directory.

I'm surprised.

Now I see why my thread "Creation of pseudo items leads to (seemingly)
duplicate inodes (BUG inside)" suffered from little attention :-)

-Jan
