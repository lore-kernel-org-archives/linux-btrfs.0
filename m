From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Inode to bdi  issue?
Date: Wed, 20 Oct 2010 09:59:38 -0400
Message-ID: <20101020135938.GH3400@think>
References: <14C7F4F06DB5814AB0DE29716C4F6D670EB36236@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Smets, Jan (Jan)" <jan.smets@alcatel-lucent.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <14C7F4F06DB5814AB0DE29716C4F6D670EB36236@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 20, 2010 at 03:03:00PM +0200, Smets, Jan (Jan) wrote:
> Hi list
> 
> Just a quick cut 'n paste report from my dmesg. Let me know if I can help any furter.
> 
> 2.6.36~rc6
> 
> PS: I think this is identical to the problem reported on 23/09 "Dirtiable inode bdi default != sb bdi btrfs", and might already be fixed in rc6+ , but there are some other traces in here, so I just want to make sure it's all covered :-)

Correct, this one is already fixed.  Just do a git pull from Linus' tree
and you'll get the fix.

-chris
