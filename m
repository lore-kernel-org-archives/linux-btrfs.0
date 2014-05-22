Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54258 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaEVEY6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 00:24:58 -0400
From: Russell Coker <russell@coker.com.au>
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: historical backups with hardlinks vs cp --reflink vs snapshots
Date: Thu, 22 May 2014 14:24:53 +1000
Message-ID: <1668691.Jr8NPxkTPc@xev>
In-Reply-To: <20140521035928.GW10656@merlins.org>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <20140521035928.GW10656@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 May 2014 20:59:28 Marc MERLIN wrote:
>  just wrote a blog post about the 3 way of doing historical snapshots:
> http://marc.merlins.org/perso/btrfs/post_2014-05-20_Historical-Snapshots-Wit
> h-Btrfs.html 
> I love reflink, but that forces me to use btrfs send as the only way to
> copy a filesystem without losing the reflink relationship, and I have no
> good way from user space to see the blocks shared to see how many are
> shared or whether some just got duped in a copy.
> As a result, for now I still use hardlinks.

It would be nice if someone patched rsync to look for files with identical 
contents and use reflink or hardlinks (optionally at user request) instead of 
making multiple copies of the same data.  Also it would be nice if rsync would 
look for matching blocks in different files to save transfer.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

