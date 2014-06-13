Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-t3e-f6d.wadns.net ([41.185.62.109]:30069 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751864AbaFMGCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 02:02:05 -0400
Message-ID: <539A9224.5060300@swiftspirit.co.za>
Date: Fri, 13 Jun 2014 07:54:44 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        1i5t5.duncan@cox.net
Subject: Re: [PATCH v3] lib: add size unit t/p/e to memparse
References: <1396428877-24089-1-git-send-email-guihc.fnst@cn.fujitsu.com> <20140612141516.219f8c6b95f0d4f97332b8c7@linux-foundation.org>
In-Reply-To: <20140612141516.219f8c6b95f0d4f97332b8c7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/06/14 23:15, Andrew Morton wrote:
> On Wed, 2 Apr 2014 16:54:37 +0800 Gui Hecheng <guihc.fnst@cn.fujitsu.com> wrote:
>
>> For modern filesystems such as btrfs, t/p/e size level operations
>> are common.
>> add size unit t/p/e parsing to memparse
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> ---
>> changelog
>> 	v1->v2: replace kilobyte with kibibyte, and others
>> 	v2->v3: add missing unit "bytes" in comment
>> ---
>>   lib/cmdline.c | 25 ++++++++++++++++++++-----
>>   1 file changed, 20 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/cmdline.c b/lib/cmdline.c
>> index eb67911..511b9be 100644
>> --- a/lib/cmdline.c
>> +++ b/lib/cmdline.c
>> @@ -119,11 +119,17 @@ char *get_options(const char *str, int nints, int *ints)
>>    *	@retptr: (output) Optional pointer to next char after parse completes
>>    *
>>    *	Parses a string into a number.  The number stored at @ptr is
>> - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
>> - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
>> - *	1073741824).  If the number is suffixed with K, M, or G, then
>> - *	the return value is the number multiplied by one kilobyte, one
>> - *	megabyte, or one gigabyte, respectively.
>> + *	potentially suffixed with
>> + *	%K (for kibibytes, or 1024 bytes),
>> + *	%M (for mebibytes, or 1048576 bytes),
>> + *	%G (for gibibytes, or 1073741824 bytes),
>> + *	%T (for tebibytes, or 1099511627776 bytes),
>> + *	%P (for pebibytes, or 1125899906842624 bytes),
>> + *	%E (for exbibytes, or 1152921504606846976 bytes).
> I'm afraid I find these names quite idiotic - we all know what the
> traditional terms mean so why go and muck with it.
>
> Also, kibibytes sounds like cat food.
Hi, Andrew

While I agree it sounds like cat food, it seemed like a good opportunity 
to fix a minor issue that is otherwise unlikely to be fixed for a very 
long time. Should we feel uncomfortable with the patch, as is, because 
of language/correctness friction? Pedantry included, the patch is 
correct. ;)

Thanks

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

