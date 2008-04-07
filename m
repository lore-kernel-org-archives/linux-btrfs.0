From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS and old kernels.
Date: Mon, 7 Apr 2008 08:54:50 -0400
Message-ID: <200804070854.51056.chris.mason@oracle.com>
References: <f058a9c30804051213j4276cc88j92a8222dd4115e39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <btrfs-devel-bounces@oss.oracle.com>
In-Reply-To: <f058a9c30804051213j4276cc88j92a8222dd4115e39@mail.gmail.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 05 April 2008, Miguel Sousa Filipe wrote:

> My question is, is there sill interestest in having btrfs compatible
> with older kernels (like, 2.6.20 or 2.6.18)?
> I'll post (or repost) patches that I need for btrfs-unstable to
> build/work on this ppc system of mine.

Definitely.  Just to confirm what Zach said over the weekend, at this stage in 
the game it is much more important to me to keep btrfs easy for testers than 
it is to avoid small amounts of compat code.

So, any fixes would definitely be appreciated.

-chris
