From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs-progs: bug fixes
Date: Fri, 2 Oct 2009 15:09:57 -0400
Message-ID: <20091002190957.GL2881@think>
References: <4AC59118.6030707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AC59118.6030707@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 02, 2009 at 02:35:20PM +0900, TARUISI Hiroaki wrote:
> Hi,
> 
> I have tested btrfsck in some error case, such as item missing
> case or CRC error case or so. In this test session I found some
> bugs in btrfsck.c and disk-io.c in btrfs-progs.
>   1. The last pair of ptrs and items are not checked at 2 place
>      of check_node/leaf.
>   2. Csum printed CRC error message is not correct.
>   3. In CRC error, btrfsck fails in segmentation fault.
> 
> I'll post three tiny patches to fix these bugs.

Thank you for spending time in the btrfsck code.  I'll test these out
and get them pushed into the btrfs-progs repository.

-chris

