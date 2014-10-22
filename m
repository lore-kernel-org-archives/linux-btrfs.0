Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:38382 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbaJVUsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:48:47 -0400
Message-ID: <5448182C.8000809@pobox.com>
Date: Wed, 22 Oct 2014 13:48:44 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: NOCOW and Swap Files?
References: <54480ED0.9070703@pobox.com> <20141022202519.GC18164@carfax.org.uk> <5448161E.6020306@pobox.com> <20141022204231.GD18164@carfax.org.uk>
In-Reply-To: <20141022204231.GD18164@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2014 01:42 PM, Hugo Mills wrote:
>     swap-on-NFS is still, I think, in a set of out of tree patches, and
> it's not gone anywhere near btrfs yet. It's just that once it does
> land in mainline, it would form the appropriate infrastructure to
> develop swapfile capability for btrfs.

I just looked at my 3.16.6 kernel tree and there is a check-box for swap 
over NFS in the network file systems menu. For whatever that's worth.

But as of now only the loopdev method is workable if I understand you 
correctly.

Thanks.

--Rob.

