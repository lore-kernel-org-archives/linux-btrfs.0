Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63117 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaKRL0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 06:26:22 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so1458557wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 03:26:21 -0800 (PST)
Message-ID: <546B2CDB.3070109@gmail.com>
Date: Tue, 18 Nov 2014 12:26:19 +0100
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem show _exact_ freaking size?
References: <546B21F4.8060203@pobox.com>
In-Reply-To: <546B21F4.8060203@pobox.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 18/11/2014 11:39, Robert White a écrit :
> Howdy,
> 
> How does one get the exact size (in blocks preferably, but bytes okay)
> of the filesystem inside a partition? I know how to get the partition
> size, but that's not useful when shrinking a partition...

dev_item.total_bytes in brtfs-show-super's output is what you're after.

