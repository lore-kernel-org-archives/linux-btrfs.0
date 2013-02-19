Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54996 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3BSHNj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 02:13:39 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so2729337eaa.9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 23:13:37 -0800 (PST)
Message-ID: <5123249A.6080502@gmail.com>
Date: Tue, 19 Feb 2013 08:07:06 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com> <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com> <20130218230842.GN22221@lenny.home.zabbo.net>
In-Reply-To: <20130218230842.GN22221@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/19/2013 12:08 AM, Zach Brown wrote:
> On Mon, Feb 18, 2013 at 10:04:26PM +0100, Goffredo Baroncelli wrote:
>> This patch adds some helpers to manage the strings allocation and
>> deallocation.
>> The function string_list_add(char *) adds the passed string to a list;
>> the function string_list_free() frees all the strings together.
> 
> Please don't do this.  To verify that a given pointer isn't freed before
> it's used we'd have to make sure that there are no string_list_free()
> calls in the interim that would hit their pointer on this global list.

The idea is that the code shouldn't care about do deallocate the strings
until finishing its jobs. At the end it calls string_list_free().

Of course, if after string_list_free() some dynamically allocated
strings are used then bad things could happen.

Ideally string_list_free() should be called at the end of the main.
I don't think that btrfs-progs allocates an huge quantity of string, so
this could be an acceptable behaviour.

> 
> As far as I can tell, this is only used for the pretty units?  Instead
> of
> 	printf("%s", leaked_string(raw));
> 
> how about
> 
> 	printf("%llu%s", scaled_value(raw), static_unit_str(raw));
> 
> That'd avoid the need to pass back arbitrary allocated strings and this
> code could go away.

Sorry I don't understand the differences between {leaked, scaled,
raw}_string. Could you elaborate a bit ?

> 
>> +	if (!strings_to_free) {
>> +		fprintf(stderr, "add_string_to_free(): Not enough memory\n");
>> +		strings_to_free = 0;
> 
> if (a == 0) a = 0?
> 
>> +		count_string_to_free = 0;
>> +	}
>> +
>> +	strings_to_free[count_string_to_free-1] = s;
> 
> NULL[-1] = s?

Right, I will correct soon.

> 
> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
