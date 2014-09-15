Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:59911 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaIORhs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 13:37:48 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTaDi-0004eY-QO
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 13:37:46 -0400
Message-ID: <541723EA.6010608@intellasoft.net>
Date: Mon, 15 Sep 2014 13:37:46 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance enospc
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune>
In-Reply-To: <20140915170722.GA9160@sune>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs balance start -dusage=86 /
Done, had to relocate 1 out of 13 chunks

cartman {~} root# btrfs fi df /
Data, RAID1: total=7.03GiB, used=7.01GiB
System, RAID1: total=32.00MiB, used=4.00KiB
Metadata, RAID1: total=1.00GiB, used=438.88MiB
unknown, single: total=148.00MiB, used=0.00

What's this 'unknown' section? Maybe this is the problem?  How do I get 
rid of it?

I still get enospc after a balance with a filter, and then a regular 
balance:

cartman {~} root# btrfs balance start /
ERROR: error during balancing '/' - No space left on device




On 09/15/14 13:07, Leonidas Spyropoulos wrote:
> On 15/09/14, Mark Murawski wrote:
>> I should have plenty of space for this operation, but it fails....
>>
>> [...]
>
> This might be useful:
> https://btrfs.wiki.kernel.org/index.php/Balance_Filters
>
> Regards,
> Leonidas
>

