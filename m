Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:1073 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751113Ab3JTHi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 03:38:57 -0400
Message-ID: <52638623.7040706@shiftmail.org>
Date: Sun, 20 Oct 2013 09:28:35 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Shilong Wang <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing
 supers
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>	<526247E3.9000804@giantdisaster.de> <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com> <5262914D.7030306@giantdisaster.de>
In-Reply-To: <5262914D.7030306@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/10/2013 16:03, Stefan Behrens wrote:
> On 10/19/2013 12:32, Shilong Wang wrote:
>
> > Yeah, it did not hurt. but it may  output checksum mismatch. For 
> example:
> > Writing 4k superblock is not totally finished, but we are trying to 
> scrub it.
>
> Have you ever seen this issue?
>

...

> If this is really an issue and these 4K disk writes and reads 
> interfere, let's find a better solution please.
>


Why don't you scrub optimistically as is now, and then just in case of 
checksum mismatch you re-scrub in transaction context?

