Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806Ab3BZUqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:46:35 -0500
Message-ID: <512D1F26.7020804@redhat.com>
Date: Tue, 26 Feb 2013 14:46:30 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/17 V2] btrfs-progs: replace strtok_r with strsep
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-18-git-send-email-sandeen@redhat.com> <512D0325.5050308@gmail.com> <512D190E.2050002@redhat.com> <20130226204040.GA1993@zambezi.lan>
In-Reply-To: <20130226204040.GA1993@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/26/13 2:40 PM, Ilya Dryomov wrote:
> On Tue, Feb 26, 2013 at 02:20:30PM -0600, Eric Sandeen wrote:
>> The coverity runs had a false positive complaining that save_ptr
>> is uninitialized in the call to strtok_r.
>>
>> We could initialize it, but Zach points out that just using
>> strsep is a lot simpler if there's only one delimiter,
>> so just switch to that.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: Remove accidentally-added debug printfs, thanks Geoffredo!
>>
>> diff --git a/cmds-balance.c b/cmds-balance.c
>> index b671e1d..cfbb8eb 100644
>> --- a/cmds-balance.c
>> +++ b/cmds-balance.c
>> @@ -67,11 +67,8 @@ static int parse_one_profile(const char *profile, u64 *flags)
>>  static int parse_profiles(char *profiles, u64 *flags)
>>  {
>>  	char *this_char;
>> -	char *save_ptr;
>>  
>> -	for (this_char = strtok_r(profiles, "|", &save_ptr);
>> -	     this_char != NULL;
>> -	     this_char = strtok_r(NULL, "|", &save_ptr)) {
>> +	while ((this_char = strsep(&profiles, "|"))) {
>>  		if (parse_one_profile(this_char, flags))
>>  			return 1;
>>  	}
>> @@ -136,14 +133,11 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
>>  {
>>  	char *this_char;
>>  	char *value;
>> -	char *save_ptr;
>>  
>>  	if (!filters)
>>  		return 0;
>>  
>> -	for (this_char = strtok_r(filters, ",", &save_ptr);
>> -	     this_char != NULL;
>> -	     this_char = strtok_r(NULL, ",", &save_ptr)) {
>> +	while ((this_char = strsep(&filters , ","))) {
> 
> 					  ^^^ whitespace
> 
> 
> One of the differences between strtok() and strsep() is that the former
> allows multiple delimiters between two tokens.  With strsep(), this
> 
> btrfs balance -dfoo1=bar1,,,foo2=bar2 <mnt>
> 
> fails with error, whereas with strtok() it passes.  I don't have a
> strong opinion here (this has been loosely modeled on the way mount(8)
> handles -o options), but might it be better to just initialize save_ptr?
> (And yes, I know that strsep() is better ;))

I don't really care much either way, TBH.  Initializing it seems a little
bit magic, but with a comment as to why, it'd be fine.  If you did it this
way intentionally to allow the above format, and changing it would break
expectations, then I'll happily just initialize save_ptr.

(And, I realize that lots of these changes are pedantic and seemingly
pointless, but we've gotten the static checker errors down from over 100
to under 30 and dropping; the more noise we remove the more likely we are
to pay attention to the output and catch actual errors.  At least that's
my feeling; if people think this is getting to be pointless churn, I'm
ok with that, too).

Thanks for the review,
-Eric

p.s. Zach made me do it. ;)


> Thanks,
> 
> 		Ilya
> 

