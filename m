Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50388 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2KZKbp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 05:31:45 -0500
Date: Mon, 26 Nov 2012 18:30:13 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
Message-ID: <20121126103012.GA18538@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
 <CANW9uyu0NyFj57AVp2X-Hc=AjXdwyP=wieOcteEbj2_Mx_F95w@mail.gmail.com>
 <50911FC0.4080104@oracle.com>
 <CANW9uyse7bw1+=GkV-aRQbDPh1E-t3G4VwkAGc5-76KMfYMjog@mail.gmail.com>
 <20121101112114.GA4328@liubo.cn.oracle.com>
 <CANW9uysHg6qk4zSh_yFgP5e545kJZVoma36Hpd1Zzg-hoSVAhQ@mail.gmail.com>
 <50929CF4.9060206@oracle.com>
 <CANW9uyt9qE9384WnQq5ggZ2hb-DbahZe8KY5-WXRFSKTiedekg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANW9uyt9qE9384WnQq5ggZ2hb-DbahZe8KY5-WXRFSKTiedekg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 25, 2012 at 12:48:33PM +0900, Itaru Kitayama wrote:
> Hi Liubo:
> 
> At the relinking stage, in some situations, looking up the extent tree with
> the extent logical start objectid key from one of the old extents fails,
> but the found previous item's objectid + offset is exactly the original
> search objectid. As you say, usually old extents are retrieved from the
> extent tree without a problem, but if the Delayed or some other mechanisms
> change extents layout in the finish ordered IO function, we need to take
> care of those rejected extents, not simply returning ENOENT. What do you
> think?

Hi Itaru san,

Thanks for the suggestion.

It's all right to ignore ENOENT.

An extent stands for a range of space, which owns an item in extent tree.

If old extents' item is not found in the extent tree, i.e. rejected extents,
it means that this range of space is not shared by any snapshots(the extent refs is now 0),
and so it's safe.

So the worst case is that due to COW, a file and its snapshots share nothing
after some time, the defrag on the file won't change its snapshots, but this
can be solved when we always with autodefrag and snapshot-aware defrag.

thanks,
liubo
