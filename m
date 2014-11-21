Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:37201 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaKUKNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 05:13:55 -0500
Received: from [85.19.192.9] (port=18612 helo=[172.20.1.92])
	by smtp.domeneshop.no with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <lists@skagestad.org>)
	id 1XrlDt-0007kY-AV
	for linux-btrfs@vger.kernel.org; Fri, 21 Nov 2014 11:13:53 +0100
Message-ID: <546F107D.1040509@skagestad.org>
Date: Fri, 21 Nov 2014 11:14:21 +0100
From: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0-rc4 - WARNING: CPU: 3 PID: 3889 at fs/btrfs/extent-tree.c:3785
 btrfs_free_reserved_data_space+0xc8/0xe0 [btrfs]()
References: <54631A84.2000500@skagestad.org>
In-Reply-To: <54631A84.2000500@skagestad.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12. nov. 2014 09:29, Torbjørn wrote:
> Hi,
>
> After upgrade to 3.18.0-rc4 get a lot of these warnings.
> The system seems to otherwise behave normally. I have not observed any 
> actual issues.
>
--snip--

Just to close off this email thread.
After upgrading to 3.18.0-rc5 these messages have disappeared.
For rc-4 it was about 80 000 messages a day.

--
Torbjørn
