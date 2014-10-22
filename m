Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:43991 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932554AbaJVUkB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:40:01 -0400
Message-ID: <5448161E.6020306@pobox.com>
Date: Wed, 22 Oct 2014 13:39:58 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: NOCOW and Swap Files?
References: <54480ED0.9070703@pobox.com> <20141022202519.GC18164@carfax.org.uk>
In-Reply-To: <20141022202519.GC18164@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2014 01:25 PM, Hugo Mills wrote:
>     The new code is the swap-on-NFS infrastructure, which indirects
> swapfile accesses through the filesystem code. The reason you have to
> do that with NFS is because NFS doesn't expose a block device at all,
> so you can't get a list of blocks on an underlying device because
> there isn't one. Indirecting the accesses through the filesystem,
> however, allows us to side-step btrfs's problems with part (b) above,
> and in theory gives us swapfile capability.

I was not even aware there was "new code" on the matter.

Is there a guide or whatever to doing this? I didn't see any mention of 
it in the places Google led me.

--Rob

