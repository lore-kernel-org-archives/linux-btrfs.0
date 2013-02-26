Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3BZUSE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:18:04 -0500
Message-ID: <512D1877.4090506@redhat.com>
Date: Tue, 26 Feb 2013 14:17:59 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/17] btrfs-progs: Unify size-parsing
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-2-git-send-email-sandeen@redhat.com> <512D03DB.1000704@gmail.com>
In-Reply-To: <512D03DB.1000704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/26/13 12:50 PM, Goffredo Baroncelli wrote:
> On 02/25/2013 11:54 PM, Eric Sandeen wrote:
>> cmds-qgroup.c contained a parse_limit() function which
>> duplicates much of the functionality of parse_size.
>> The only unique behavior is to handle "none"; then we
>> can just pass it off to parse_size().
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  cmds-qgroup.c |   44 ++++++--------------------------------------
>>  utils.c       |    8 +++++++-
>>  utils.h       |    2 +-
>>  3 files changed, 14 insertions(+), 40 deletions(-)
>>
>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>> index 26f0ab0..ce013c8 100644
>> --- a/cmds-qgroup.c
>> +++ b/cmds-qgroup.c
>> @@ -198,43 +198,13 @@ done:
>>  	return ret;
>>  }
>>  
>> -static int parse_limit(const char *p, unsigned long long *s)
>> +static u64 parse_limit(const char *p)

...

>> +	/* parse_size() will exit() on any error */
>> +	return parse_size(p);
> 
> I don't think that this is a good thing to do: the parse_limit behaviour
> is the good one: return an error to the caller instead of exit()-ing.
> 
> We should convert the parse_size() to return an error, no to convert
> parse_limit to exit(). Of course this is out of the goals of this set of
> patches.

Hm, fair point.  I could either fix it before this patch, and add
a 0.5/17, or add it to my next set of patches.  What do you think?

Thanks,
-Eric

