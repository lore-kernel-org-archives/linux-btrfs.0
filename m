Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:46122 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3C0LqE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 07:46:04 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r2RBk24e022691
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 12:46:02 +0100
Message-ID: <5152DBF6.5080702@itwm.fraunhofer.de>
Date: Wed, 27 Mar 2013 12:45:58 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Clemens Eisserer <linuxhippy@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: "No space left on device" although df reports only 55% in use
References: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com> <20130327091822.GC9290@carfax.org.uk>
In-Reply-To: <20130327091822.GC9290@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/27/2013 10:18 AM, Hugo Mills wrote:
> On Wed, Mar 27, 2013 at 12:28:23AM +0100, Clemens Eisserer wrote:
>> I am using a btrfs loopback mounted file with lzo-compression on
>> Linux-3.7.9, and I ran into "No space left on device" messages,
>> although df reports only 55% of space is used:
>>
>> # touch testfile
>> touch: cannot touch `testfile': No space left on device
>>
>> # df
>> Filesystem     1K-blocks      Used Available Use% Mounted on
>> /dev/loop0      32768000  17383924  14649172  55% /home/ce/anditest
>>
>> # btrfs filesystem df .
>> Data: total=28.22GB, used=14.25GB
>> System, DUP: total=8.00MB, used=12.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=1.50GB, used=1.16GB
>
>     Your metadata is close to full -- we need quite a lot of working

Almost 400MB are not sufficient to do simple touch? What is it doing?


Cheers,
Bernd


