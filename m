From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Shrinking oops
Date: Wed, 18 Nov 2009 16:23:06 -0500
Message-ID: <20091118212306.GC3110@think>
References: <alpine.LSU.2.00.0911182213360.29660@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0911182213360.29660@obet.zrqbmnf.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 18, 2009 at 10:20:29PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> the following testcase, if I remember the afternoon correctly, caused an 
> oops on 2.6.31.6:

Oh, this was 2.6.31 ;) You'll want to pull from the btrfs unstable repo
or try 2.6.32-rc.  In the oops below, you ran out of space.  So sorry.

-chris
