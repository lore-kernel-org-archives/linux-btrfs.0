From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: set the i_nlink to 2 for an initial dir inode
Date: Wed, 30 Nov 2011 10:12:14 +0800
Message-ID: <4ED590FE.1010701@oracle.com>
References: <4ED33C88.8060501@oracle.com> <4ED475F5.1090500@oracle.com> <20111129154804.GM24338@shiny>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129154804.GM24338@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/29/2011 11:48 PM, Chris Mason wrote:

> On Tue, Nov 29, 2011 at 02:04:37PM +0800, Jeff Liu wrote:
>> Please ignore this patch for now, it can cause the file system corrupted
>> and failed to mount again, sorry for the noise!
> 
> Directories always have a link count of 1 in btrfs.  This tells find not
> to use the link count as the count of subdirectories in the directory.

Thank you for your clarification!

-Jeff

> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


