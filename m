Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:51539 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3BZVOH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 16:14:07 -0500
Message-ID: <512D25E9.7080907@tiscalinet.it>
Date: Tue, 26 Feb 2013 22:15:21 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/17] btrfs-progs: Unify size-parsing
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-2-git-send-email-sandeen@redhat.com> <512D03DB.1000704@gmail.com> <512D1877.4090506@redhat.com>
In-Reply-To: <512D1877.4090506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2013 09:17 PM, Eric Sandeen wrote:
> On 2/26/13 12:50 PM, Goffredo Baroncelli wrote:
>> On 02/25/2013 11:54 PM, Eric Sandeen wrote:
>>> cmds-qgroup.c contained a parse_limit() function which
>>> duplicates much of the functionality of parse_size.
>>> The only unique behavior is to handle "none"; then we
>>> can just pass it off to parse_size().
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>  cmds-qgroup.c |   44 ++++++--------------------------------------
>>>  utils.c       |    8 +++++++-
>>>  utils.h       |    2 +-
>>>  3 files changed, 14 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>>> index 26f0ab0..ce013c8 100644
>>> --- a/cmds-qgroup.c
>>> +++ b/cmds-qgroup.c
>>> @@ -198,43 +198,13 @@ done:
>>>  	return ret;
>>>  }
>>>  
>>> -static int parse_limit(const char *p, unsigned long long *s)
>>> +static u64 parse_limit(const char *p)
> 
> ...
> 
>>> +	/* parse_size() will exit() on any error */
>>> +	return parse_size(p);
>>
>> I don't think that this is a good thing to do: the parse_limit behaviour
>> is the good one: return an error to the caller instead of exit()-ing.
>>
>> We should convert the parse_size() to return an error, no to convert
>> parse_limit to exit(). Of course this is out of the goals of this set of
>> patches.
> 
> Hm, fair point.  I could either fix it before this patch, and add
> a 0.5/17, or add it to my next set of patches.  What do you think?

I think that there is a general problem about
parse_size/parse_limit/str[x]ll functions... We should address all these
issues with another set of patches. Your set of patches is big enough,
and now we should stabilise them in order to be accepted.

If we agree that it is not good thing to allow parse_limit to call
exit(), I will leave parse_limit() as is.
If you are brave enough ( :) )  add the /* Fallthrough */ comment and
add the peta and exa cases.

In the future we could move parse_limit in utils.c then implement
parse_size in terms of parse_limits and finally replace all the
occurrences of strto[x]ll...

> 
> Thanks,
> -Eric
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
