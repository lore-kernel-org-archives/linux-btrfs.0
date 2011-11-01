From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG at fs/btrfs/tree-log.c:3106 (Re: new integration-danger
 branch pushed out (kernel))
Date: Tue, 1 Nov 2011 06:56:50 -0400
Message-ID: <20111101105650.GB9554@shiny>
References: <20111101024957.GH4468@shiny>
 <20111101103637.GD12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: liubo2009@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101103637.GD12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:36:37AM +0100, David Sterba wrote:
> xfstests/214
> 
> [ 3142.654774] ------------[ cut here ]------------
> [ 3142.656017] kernel BUG at fs/btrfs/tree-log.c:3106!

What kind of hardware are you running this on?  I'm passing 214 here.

-chris
