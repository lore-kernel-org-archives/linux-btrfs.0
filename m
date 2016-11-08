Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48752 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750938AbcKHA55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 19:57:57 -0500
Subject: Re: [PATCH v4 1/4] btrfs-progs: utils: Introduce function to escape
 characters
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
 <20161103040734.8098-2-quwenruo@cn.fujitsu.com>
 <20161107102027.GK12522@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e7291503-310e-3c93-3574-dd1f838d6ad8@cn.fujitsu.com>
Date: Tue, 8 Nov 2016 08:57:52 +0800
MIME-Version: 1.0
In-Reply-To: <20161107102027.GK12522@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/07/2016 06:20 PM, David Sterba wrote:
> On Thu, Nov 03, 2016 at 12:07:31PM +0800, Qu Wenruo wrote:
>> Introduce new function, escape_string_inplace(), to escape specified
>> characters in place.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  utils.c | 24 ++++++++++++++++++++++++
>>  utils.h | 14 ++++++++++++++
>>  2 files changed, 38 insertions(+)
>>
>> diff --git a/utils.c b/utils.c
>> index 3f54245..3c50d84 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -4251,3 +4251,27 @@ unsigned int rand_range(unsigned int upper)
>>  	 */
>>  	return (unsigned int)(jrand48(rand_seed) % upper);
>>  }
>> +
>> +static void escape_one_char(char *restrict string, char escape)
>> +{
>> +	int i = 0;
>> +	int j = 0;
>> +
>> +	while (string[j] != '\0') {
>> +		if (string[j] != escape) {
>> +			string[i] = string[j];
>> +			i++;
>> +		}
>
> So how does this actually escape the characters? I don't see anything
> inserted. I think we don't have a common understanding of what's
> supposed to be done here. I mean C-string-like escaping. And this cannot
> be done inplace, as it increases string length. I've implemented it in a
> different way, so this patch is left out. The final stream dump output
> is preserved.
>
>
And further more.

The new string escaping is screwing up original output.

Operation lile mkfile lacks the final '\n'.
String over the width will lack the ending ' ' to seperate later 
key=value pairs.

It would be better to output the escaped string into a buffer and still 
use printf() format to output them out as it used to be.

Thanks,
Qu


