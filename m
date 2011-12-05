From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Blocked for more than 120 seconds
Date: Mon, 5 Dec 2011 08:12:52 -0500
Message-ID: <20111205131252.GB26622@shiny>
References: <4ED5FAEF.8070400@robotech.de>
 <20111130141006.GY24338@shiny>
 <4ED738E5.3080200@robotech.de>
 <20111201184158.GB10535@shiny>
 <4ED8D6C8.4020609@robotech.de>
 <4ED8ED36.3080105@gmail.com>
 <4ED8F34F.8090609@robotech.de>
 <4ED92CA6.3030302@gmail.com>
 <4ED96EE6.2010308@gmail.com>
 <4EDA33FC.5020206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tobias <tracer@robotech.de>, linux-btrfs@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EDA33FC.5020206@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2011 at 04:36:44PM +0200, Konstantinos Skarlatos wrote:
> unfortunately i was wrong. rc4 does not fix this issue for me when
> rsyncing large amounts of data...
> 
> my mount options:
> mount -o loop,compress=zlib,compress-force btrfs_test /storage/btrfs
> the filesystem is a file on a raid5 xfs volume.

Oh, the loop + raid5 + xfs is going to cause problems.  The loop driver
is fine for testing but I wouldn't be using it in a production
environment.

-chris
