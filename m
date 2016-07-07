Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25189 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153AbcGGTVn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 15:21:43 -0400
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Gabriel C <nix.or.die@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
CC: <quwenruo@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
Date: Thu, 7 Jul 2016 15:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/07/2016 06:24 AM, Gabriel C wrote:
> Hi,
>
> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
> other versions )
> I trigger the following :

I definitely thought we had this fixed in v4.7-rc.  Can you easily fsck 
this filesystem?  Something strange is going on.

-chris
