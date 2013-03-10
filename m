Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:55952 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3CJOtl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 10:49:41 -0400
Message-ID: <513C9DDB.4030804@tiscalinet.it>
Date: Sun, 10 Mar 2013 15:51:07 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com> <1362917859-18824-2-git-send-email-goffredo.baroncelli@yahoo.com> <9199E774-B2A4-4C7F-B85A-464BF00FA517@gmail.com>
In-Reply-To: <9199E774-B2A4-4C7F-B85A-464BF00FA517@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2013 03:34 PM, Wang Shilong wrote:
> Hello,
[...]
>> +
>> +/* 
>> + * Add a string to the dynamic allocated string list
>> + */
>> +char *string_list_add(char *s)
>> +{
>> +	int  size;
>> +
> 	
> 	I'd prefer to have a check here firstly, like:
> 	if (!s)
> 		return s;
> 
> 	Since this function is called directly without any check about 'char *s'
>         in your next patch..
> 	
> 	Thanks,
> 	Wang

Thanks for the review.
However this check is not mandatory. Even if s == null, we store a null
pointer which is meaningless but not dangerous because it is legal to
free() a null pointer.

Form man 3 free:

	void free(void *ptr);
	[...]
	If ptr is NULL, no operation is performed.

In a next submit I will add your suggestions.
> 
>> +	size = sizeof(void *) * ++count_string_to_free;
>> +	strings_to_free = realloc(strings_to_free, size);
>> +
>> +	/* if we don't have enough memory, we have more serius
>> +	   problem than that a wrong handling of not enough memory */
>> +	if (!strings_to_free) {
>> +		fprintf(stderr, "add_string_to_free(): Not enough memory\n");
>> +		count_string_to_free = 0;
>> +		return NULL;
>> +	}
>> +
>> +	strings_to_free[count_string_to_free-1] = s;
>> +	return s;
>> +}
>> +
>> +/*
>> + * Free the dynamic allocated strings list
>> + */
>> +void string_list_free()
>> +{
>> +	int	i;
>> +	for (i = 0 ; i < count_string_to_free ; i++)
>> +		free(strings_to_free[i]);
>> +
>> +	free(strings_to_free);
>> +
>> +	strings_to_free = 0;
>> +	count_string_to_free = 0;
>> +}
>> +
>> +
>> diff --git a/string_list.h b/string_list.h
>> new file mode 100644
>> index 0000000..fdc027d
>> --- /dev/null
>> +++ b/string_list.h
>> @@ -0,0 +1,23 @@
>> +/*
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
>> +
>> +#ifndef STRING_LIST_H
>> +#define STRING_LIST_H
>> +
>> +char *string_list_add(char *s);
>> +void string_list_free();
>> +
>> +#endif
>> -- 
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
