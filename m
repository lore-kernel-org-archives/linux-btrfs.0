Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21667 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580Ab3D3NPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 09:15:40 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3UDFdh9019254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:15:39 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3UDFcUO016648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:15:39 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3UDFcHX016638
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:15:38 GMT
Message-ID: <517FC485.3080208@oracle.com>
Date: Tue, 30 Apr 2013 21:17:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device delete to get errors from the kernel
References: <51623C0C.4060709@oracle.com> <517A4B44.5060608@oracle.com>
In-Reply-To: <517A4B44.5060608@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



   Thanks for the comments. V2 is out. Here I followed
   the choice #1 as review suggested. which is to update
   the error code. However I have them in uapi/linux/btrfs.h
   (not in errno.h though I meant it to be there in the first
   place).

   pls do let me know your review comments.

Thanks, Anand


On 04/26/2013 05:39 PM, Anand Jain wrote:
>
>   As showed in the previous email in this thread, we need to get
>   the error string from the kernel to the cli to improve the
>   usability of the product.
>   As also said, I was looking at two way which I think we could
>   do this, here I take the 2nd approach which is to pass the error
>   string though the ioctl args. Which leads to change in the
>   ioctl-structure. But..
>
>   This comes with a caveat that both btrfs-progs and btrfs-kernel
>   patch together either must be applied or removed.
>
>    [PATCH] btrfs-progs: device delete to get errors from the kernel
>    [PATCH] btrfs: device delete to get errors from the kernel
>
>   Which is not a developer/integrator friendly rule. If there
>   is anything I could do to help on this pls do let me know.
>
>   There are quite a number of cli which needs passing of the
>   the error string from the kernel to cli. Which I plan to work
>   once we finalize the approach to address this issue.
>
>   Thanks for your time to review this.
>
> Anand
