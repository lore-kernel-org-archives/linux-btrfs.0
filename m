Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:37631 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaG1LLP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 07:11:15 -0400
Message-ID: <53D62FD7.6010205@skagestad.org>
Date: Mon, 28 Jul 2014 13:11:19 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
References: <1502954.OtX3SzjMKZ@merkaba> <53C52AE4.6010803@fb.com> <1984661.CMGGdWA6Ux@merkaba> <1809953.ithLVmijbn@merkaba> <53D11F2B.1070008@fb.com> <53D1E260.6080708@skagestad.org> <20140725092800.GC25859@localhost.localdomain> <53D22FD4.2070806@skagestad.org> <53D23AF1.9010704@skagestad.org> <53D24166.7030208@skagestad.org> <20140728100059.GB29285@localhost.localdomain>
In-Reply-To: <20140728100059.GB29285@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28. juli 2014 12:00, Liu Bo wrote:
<snip>
> This seems to be incomplete(Looks like dmesg has reached its buffer size limit),
> does /var/log/message have the whole stack info?
>
> thanks,
> -liubo
Hi,

Complete log was over 40MB. I uploaded everything from boot until 
"blocked for 120 seconds" started to appear.
If you want all the trailing log as well, let me know.

https://gist.github.com/anonymous/7958d8917967f727f324

--
Torbjørn
