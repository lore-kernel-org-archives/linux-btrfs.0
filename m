Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46775 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757116AbaCTNra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 09:47:30 -0400
Message-ID: <532AF211.5000100@fb.com>
Date: Thu, 20 Mar 2014 09:50:09 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
References: <20140320002007.GY18959@merlins.org> <CF4FB5F3.2116%clm@fb.com> <pan$abf66$faea9a06$c5ce02f4$1e7a0c96@cox.net>
In-Reply-To: <pan$abf66$faea9a06$c5ce02f4$1e7a0c96@cox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/20/2014 02:19 AM, Duncan wrote:
> Chris Mason posted on Thu, 20 Mar 2014 01:01:35 +0000 as excerpted:
>
>> Message-ID: <CF4FB5F3.2116%clm@fb.com>
>> Accept-Language: en-US
>> Content-Type: text/plain; charset=euc-kr
>> Content-Transfer-Encoding: base64
>> Content-Language: en-US
>
>>>> Sorry, I misspoke, you should bump /proc/sys/vm/min_free_kbytes.
>>>> Honestly though, it©ös just a bug in the mvs driver.  Atomic 8K
>>>> allocations are doomed to fail eventually.
>
>> The process is a btrfs worker, and the IO was started by btrfs, but the
>> allocation failure is all inside the mvs driver.  There¡¯s even the
>> printk in there from mvs about the allocation failing.
>
>> -chris
>>
>> N§²æìržyúèØb²X¬¶Ç§vØ^)Þº{.nÇ+·¥{±nÚß²)íæèw*jg¬±š¶Ý¢
> j/êäz¹Þà2Þšè­Ú&¢)ß¡«a¶Úþø®G«éh®æj:+všwèÙ¥
>
>
> Chris, you might wish to take a look at this and/or have one of the FB
> techs familiar with your mail transport layers (and/or your mail client,
> and/or perhaps it's vger's list-serv bot) look at it.  That list-sig came
> thru as garbage at least here, and your "it's" and "there's" appear to
> have strange apostrophes as well.  As you can see I also included the
> headers I think might be relevant, plus the Message-ID.
>

So the list-sig is a vger feature.  It just tacks on the list sig 
regardless of the encoding of the message, which generates garbage some 
times.

The rest sounds like a facebook feature.  I've got thunderbird 
configured to force saner encodings, hopefully it'll be more consistent now.

Thanks

-chris
