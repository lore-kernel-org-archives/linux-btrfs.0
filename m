Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:50373 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab3AOBjY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 20:39:24 -0500
Received: from [199.115.105.252] (helo=mail.parallels.com)
	by mx2.parallels.com with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <dolenin@parallels.com>)
	id 1TuvUp-0006Rs-IN
	for linux-btrfs@vger.kernel.org; Mon, 14 Jan 2013 20:39:23 -0500
Message-ID: <50F4B348.3090401@parallels.com>
Date: Tue, 15 Jan 2013 10:39:20 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: partition question
References: <50F06639.6030409@home.nl> <818D716E-CEFF-4170-B470-574D6E98375E@colorremedies.com> <20130111223845.GV19051@carfax.org.uk>
In-Reply-To: <20130111223845.GV19051@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>     I don't know this area of the code at all well, but as I understand
> it, there's been some work in the kernel (swap over NFS) which lays
> down some of the underlying infrastructure we'd need to support
> swapfiles on btrfs, but we don't have anything beyond that. I don't
> know of anyone working on it, either.
>
>     Hugo.
>

You can use swapfile on btrfs with mounting it via a loop device. It 
won't be incredibly fast, but it will work.
