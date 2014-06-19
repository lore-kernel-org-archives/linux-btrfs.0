Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:37061 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbaFSVuj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 17:50:39 -0400
Received: from [192.168.150.196] (catv-80-98-74-144.catv.broadband.hu [80.98.74.144])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: tamas.papp@rtfm.co.hu)
	by gitanes.rtfm.co.hu (Postfix) with ESMTPSA id AD9E1B4722
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 23:50:37 +0200 (CEST)
Message-ID: <53A35B2D.4000606@martos.bme.hu>
Date: Thu, 19 Jun 2014 23:50:37 +0200
From: Tamas Papp <tompos@martos.bme.hu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed
References: <539EF06A.4080803@martos.bme.hu> <539EF907.6010102@martos.bme.hu>
In-Reply-To: <539EF907.6010102@martos.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/16/2014 04:02 PM, Tamas Papp wrote:
>
> On 06/16/2014 03:26 PM, Tamas Papp wrote:
>> hi All,
>>
>> There is a Dell XPS 13 laptop with and SSD.
>>
>> System:
>>
>> Ubuntu 14.04 amd64
>> Kernel is from the daily ppa, like 3.15rcX.
>>
>> Now, it's running live system:
>>
>> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 
>> 2014 x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 
>> 2014 x86_64 x86_64 x86_64 GNU/Linux
>> Label: none  uuid: 7cf95491-8ec6-48a2-b4c4-4b80650d169a
>>     Total devices 1 FS bytes used 121.91GiB
>>     devid    1 size 236.53GiB used 146.02GiB path /dev/sda4
>>
>> Btrfs v3.14.1
>>
>>
>>
>> I've attached all debug output, that I was able to get.
>> btrfs check exited with segfault.
>>
>>
>> Can you help me with this?
>>
>
> I just fixed the subject.

Someone? Any idea?


10x
tamas
