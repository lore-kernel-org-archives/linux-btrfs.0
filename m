Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:54250 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbbIJNZX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 09:25:23 -0400
Subject: Re: Cancel device remove?
To: Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <B7F2379062E32745A8651FBDB20F64596913D2BD@Server.waterlogic.com.au>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <55F18310.9070907@siedziba.pl>
Date: Thu, 10 Sep 2015 15:18:08 +0200
MIME-Version: 1.0
In-Reply-To: <B7F2379062E32745A8651FBDB20F64596913D2BD@Server.waterlogic.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> Is there some way to cancel a device remove operation? I have discovered that if I reboot that will cancel it, but that's not always possible. What I'm after is something the same as cancelling scrub.
> I keep running into situations where I want to pause a remove operation for speed reasons.

Since removing a device involves shrinking it to 0 size first 
(http://lxr.free-electrons.com/source/fs/btrfs/volumes.c#L1743), I guess 
you could just run "btrfs filesystem resize" in a loop as a workaround, 
shrinking it incrementally, and then remove at the end.

