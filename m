Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:34504 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaHLQEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 12:04:53 -0400
Received: from [212.23.1.1] (helo=smarthost01a.mail.zen.net.uk)
	by queue01b.mail.zen.net.uk with esmtp (Exim 4.72)
	(envelope-from <david@chrestomanci.org>)
	id 1XHEZ9-00028i-RQ
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 16:04:51 +0000
Received: from [82.70.68.182] (helo=www.chrestomanci.org)
	by smarthost01a.mail.zen.net.uk with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <david@chrestomanci.org>)
	id 1XHEXC-000B0v-EU
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 16:02:50 +0000
Message-ID: <53EA3AA0.9080607@chrestomanci.org>
Date: Tue, 12 Aug 2014 17:02:40 +0100
From: David Pottage <david@chrestomanci.org>
MIME-Version: 1.0
To: Cyril Scetbon <cyril.scetbon@free.fr>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Using Btrfs with Ubuntu 14.04
References: <8951EA18-525B-43F4-8B8E-499611A69465@free.fr>
In-Reply-To: <8951EA18-525B-43F4-8B8E-499611A69465@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/08/14 08:46, Cyril Scetbon wrote:
> Hi guys,
>
> Can you tell me if there are any pitfalls to use Btrfs under Ubuntu 14.04 (Btrfs 3.12). Are there any well known bug that are only fixed later ? Please, send me links just to check if it could hurt or not ..
You should probably install the latest kernel, as otherwise if you 
report any issue to this list the first thing people will ask you to do 
is to update.

Follow the instructions here:
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

It is not hard, but it will take a while. I would allow at least an hour 
to build a kernel package unless you are on the latest fast hardware. It 
could also take a long time to git clone the kernel unless your internet 
conection is fast.

On step 2, I suggest you clone from the stable reposistory instead of 
Linus's bleeding edge repsitory. The sable clone URL is: 
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

Good luck !

-- 
David Pottage




