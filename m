Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:57658 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3J0Sim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 14:38:42 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by shiva.plaintext.sk (Postfix) with ESMTP id 250E226C48
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 19:38:40 +0100 (CET)
Received: from shiva.plaintext.sk ([127.0.0.1])
	by localhost (shiva.plaintext.sk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i0mMAs3nAlBk for <linux-btrfs@vger.kernel.org>;
	Sun, 27 Oct 2013 19:38:38 +0100 (CET)
Received: from shiva.plaintext.sk (shiva.plaintext.sk [85.248.156.6])
	by shiva.plaintext.sk (Postfix) with ESMTP id D18AC26BD9
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 19:38:38 +0100 (CET)
Date: Sun, 27 Oct 2013 19:38:37 +0100 (GMT+01:00)
From: luvar@plaintext.sk
To: linux-btrfs@vger.kernel.org
Message-ID: <1296381926.4841382899117881.JavaMail.root@shiva>
In-Reply-To: <25936185.4821382898828712.JavaMail.root@shiva>
Subject: Re: btrfs unable to mount
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ehm, after one, or two days (computer was shut down normally to night), now I am not able to mount that btrfs partition. Nor btrfs-zero-log helps. I am going to reformat it, but uploading btrfs-image for further analyse if anybody wants.

PS: I have used for this btrfs partition a bcache partition. Bcache block device consists of iscsi drive (140GB) as a backing device and one ssd partition (20GB) used as a cache device. This is possibly a couse of these problems. I will try ext3 now for that partition.

----- luvar@plaintext.sk wrote:

> Hi I have similar (not same) problem like described here:
> 
> http://www.spinics.net/lists/linux-btrfs/msg27102.html
> 
> So I want just make Josef to have some fun seeing btrfs-image of
> unmountable filesystem, before btrfs-zero-log command...
> 
> Two images and explanatory text is available on here:
> http://dawn.ynet.sk/~luvar/asdf/btrfs/
> 
> File btrfs.unabletomount contains explanatory text. image files are
> beeing uploaded right now and will be there in a few minutes.
> 
> If any additional question, just ask. LuVar
