From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Algorithm for nodatacow is broken
Date: Thu, 17 Jul 2008 12:45:35 +0000
Message-ID: <1216298735.24425.338.camel@think.oraclecorp.com>
References: <3d0408630807160041h20d2157agfc221b34a836df87@mail.gmail.com>
	 <1216214154.24425.326.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216214154.24425.326.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-16 at 13:15 +0000, Chris Mason wrote:
> On Wed, 2008-07-16 at 15:41 +0800, Yan Zheng wrote:
> > Hello,
> > 
> > Yesterday, I realized the algorithm for nodatacow is broken, it can't
> > reliably detect whether a given extent is referenced by only one
> > snapshot.
> 
> I had to change around nodatacow back in May because it was definitely
> broken in the way you describe.  I agree the special case I added to
> allow nodatacow when one of the references comes from the running
> transaction is broken.
> 
> But, we should be able to fix it by extending the reference count checks
> up the tree.  Any reference > 1 not held by the running transaction on
> any block should force a cow.

Actually the existing code assumes any reference held by a different
generation of the current root is safe.  As Yan's picture shows that
isn't quite true.  So, we can make it safe by walking down that root and
checking for snapshots as well.

-chris


