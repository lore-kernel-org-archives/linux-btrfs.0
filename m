From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs not iSCSI-target safe?
Date: Wed, 22 Jul 2009 10:40:31 -0400
Message-ID: <20090722144031.GC29886@think>
References: <20090722112706.GA7374@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090722112706.GA7374@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2009 at 01:27:06PM +0200, Tomasz Torcz wrote:
> 
>   Hi,
> 
> I tried to export file from btrfs volume using iSCSI target.
> As soon as some initiator have read it over network, server
> oopsed: http://www.kerneloops.org/submitresult.php?number=557979
>  Kernel is Fedora's 2.6.29.6-213.fc11.x86_64. I'm aware that
> target iSCSI functionality is out-of-tree (I'm using iscsitarget-0.4.17-3),
> so it may not be safe. But is there any known incompatibility
> between iscsi-target and btrfs?

Sorry, I don't know of any problems between btrfs and iscsi.  Is the
iscsi target configured to use linux aio?  That could be the problem.

-chris
