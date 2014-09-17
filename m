Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:50382 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbaIQRvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 13:51:53 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XUJOS-0002ii-4s
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 13:51:52 -0400
Message-ID: <5419CA37.1070608@intellasoft.net>
Date: Wed, 17 Sep 2014 13:51:51 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance enospc
References: <54186A4B.60902@intellasoft.net> <54186A82.7070801@intellasoft.net>,<5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com> <BAY172-W49807D9D79231B7B004F04B0C90@phx.gbl>
In-Reply-To: <BAY172-W49807D9D79231B7B004F04B0C90@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 > Does/should a balance imply removal of missing devices (as long as 
the minimum number of devices are still available)?

That's a really good question.  As a user I would expect it to balance 
over remaining devices assuming you still have a complete picture. 
Doing a device delete missing after a balance should be just some pool 
metadata updates at that point.

Anyway... I solved my problem by moving/deleting files to free up space 
to the point that balance no longer complained about enospc.

I suppose btrfs needs extra working space to do a balance... above and 
beyond the actual size of the existing data/metadata to be moved?  I had 
a total of three devices, with what appeared to be plenty of space on 
the two that were to be remaining, but balance/remove was still 
complaining to be out of disk space.

It would be a good idea for some metrics to be calculated upon start of 
a removal or balance to tell the user "hey you need to free up XXX more 
bytes in order for this operation to be successful".

