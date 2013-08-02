Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22998 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3HBCTZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 22:19:25 -0400
Date: Fri, 2 Aug 2013 10:19:17 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Sandy McArthur <sandymac@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: filefrag and btrfs filesystem defragment and maybe snapshots
Message-ID: <20130802021916.GC24158@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAPs0BihZNQ1fY4syh-=Pqm_ekVwd7Fw+YhGuVgz0fcO=VUZrFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPs0BihZNQ1fY4syh-=Pqm_ekVwd7Fw+YhGuVgz0fcO=VUZrFw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 01, 2013 at 05:18:50PM -0400, Sandy McArthur wrote:
> While exploring some btrfs maintenance with respect to defragmenting I
> ran the following commands:
> 
> # filefrag /path/to/34G.file /path/to/5.7G.file
> /path/to/34G.file: 2406 extents found
> /path/to/5.7G.file: 572 extents found
> 
> Thinking those mostly static files could be less fragmented I ran:
> # btrfs filesystem defragment -c /path/to/34G.file
> # btrfs filesystem defragment -c /path/to/5.7G.file
> 
> and to my surprise the number of fragments/extends doubled:
> 
> # filefrag /path/to/34G.file /path/to/5.7G.file
> /path/to/34G.file: 6324 extents found
> /path/to/5.7G.file: 1079 extents found
> 
> Did I actually improve these files?
> 
> I do have a number rolling readonly snapshots on the subvolume these
> files are on. I can imagine how that might be related but I'm not
> sure. When the pre-defrag snapshots are purged will the filefrag
> extents count drop.

I guess the reason is that you're doing the defragment with compression,
ZLIB in default case, and btrfs compression has a maximum length limit, 128k.
So if the original file's extents have a length larger than 128k, it's possible
to get the results of 'filefrag' doubled.

But I have no possible answer for
'why filefrag extents count drop after purging snapshots'.

-liubo
