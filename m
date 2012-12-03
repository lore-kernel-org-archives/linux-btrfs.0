Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33746 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab2LCTNi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Dec 2012 14:13:38 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Mon, 3 Dec 2012 14:13:37 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 552256E8061
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2012 14:13:35 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qB3JDZC1295046
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Dec 2012 14:13:35 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qB3JDYIV016569
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Dec 2012 14:13:35 -0500
Message-ID: <50BCF9D9.3040200@linux.vnet.ibm.com>
Date: Mon, 03 Dec 2012 11:13:29 -0800
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Example of BTRFS uglyssima performance : Bitcoin
References: <50BC92F6.6050404@petaramesh.org> <20121203120952.GE7289@carfax.org.uk>
In-Reply-To: <20121203120952.GE7289@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Swâmi,

On 12/03/2012 04:09 AM, Hugo Mills wrote:

> On Mon, Dec 03, 2012 at 12:54:30PM +0100, Swâmi Petaramesh wrote:
>> Hi folks,
>>
>> My laptop is a Core i3-2310M with 4 GB RAM, running BTRFS on a 1 TB HD.
>>
>> I run Ubuntu 12.10 Quantal, kernel 3.5.0-19-generic 64-bit.
>
>     Try 3.7. That's had some significant performance improvements. 3.5
> is over 6 months old, which is a long time in btrfs development.

I'd like to emphasize this point. 3.7 has some _very_ significant performance
improvements for database workloads; you will _need_ to run at least a 3.7
kernel to have an acceptable run speed for that type of workload (at least
in my experience). Seriously.

Also, the nodatacow option Hugo mentioned will also help.

Regards,
Wade

