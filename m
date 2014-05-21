Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57326 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaEUAE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 20:04:57 -0400
Message-ID: <537BEDA1.2010900@zytor.com>
Date: Tue, 20 May 2014 17:04:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Formalizing the use of Boot Area B
References: <537403E3.6090902@zytor.com> <537BE54B.3060603@zytor.com> <537BE73F.7040307@fb.com>
In-Reply-To: <537BE73F.7040307@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2014 04:37 PM, Chris Mason wrote:
> 
> Hi Peter,
> 
> We do leave the first 1MB of each device alone.  Can we do 256K-1024K
> for the boot loader?  We don't have an immediate need for the extra
> space, but I'd like to reserve a little more than the extra 64KB.
> 

Incidentally, the current version of mkfs.btrfs actually leaves not
1 MB (1024K) but rather 1104K (64K+16K+1024K).  Not sure if that is
intentional.

	-hpa

