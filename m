From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] New nodatacow checker
Date: Tue, 29 Jul 2008 23:18:22 +0000
Message-ID: <1217373502.7572.142.camel@think.oraclecorp.com>
References: <3d0408630807291040t64a8518ne840f6c618ee7332@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630807291040t64a8518ne840f6c618ee7332@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-30 at 01:40 +0800, Yan Zheng wrote:
> Hello,
> 
> This is updated version of nodatacow patch. To check whether a given
> file extent is referenced by multiple snapshots, the checker walks
> down the fs tree through dead root and checks all tree blocks in the
> path. We can easily detect whether a given tree block is directly
> referenced by other snapshot. We can also detect any indirect
> reference from other snapshot by checking reference's generation. The
> checker can always detect multiple references, but can't reliably
> detect cases of single reference. So btrfs may do file data cow even
> there is only one reference.
> 

Wonderful, thanks!  I'll put this in tonight or tomorrow morning.

-chris


