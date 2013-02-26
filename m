Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:47140 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759705Ab3BZVCx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 16:02:53 -0500
Message-ID: <512D2344.40607@tiscalinet.it>
Date: Tue, 26 Feb 2013 22:04:04 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/17] btrfs-progs: fix fd leak in cmd_subvol_set_default
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-17-git-send-email-sandeen@redhat.com> <512D031D.20408@gmail.com> <512D169C.3020100@redhat.com>
In-Reply-To: <512D169C.3020100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2013 09:10 PM, Eric Sandeen wrote:
> On 2/26/13 12:46 PM, Goffredo Baroncelli wrote:
>> Hi Eric,
>>
>> On 02/25/2013 11:54 PM, Eric Sandeen wrote:
>>> Rearrange cmd_subvol_set_default() slightly so we
>>> don't have to close the fd on an error return.
>>>
>>> While we're at it, fix whitespace & remove magic
>>> return values.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>  cmds-subvolume.c |   17 +++++++++--------
>>>  1 files changed, 9 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>>> index 0dfaefe..461eed9 100644
>>> --- a/cmds-subvolume.c
>>> +++ b/cmds-subvolume.c
>>> @@ -712,24 +712,25 @@ static int cmd_subvol_set_default(int argc, char **argv)
>>>  	subvolid = argv[1];
>>>  	path = argv[2];
>>>  
>>> +	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
>>
>> Could you replace strtoll() with strtoull() ? Note that:
>>
>> strtoull("0xffffffffffffffff",0,0)  == 0xffffffffffffffff
>> strtoull("-1",0,0)  == 0xffffffffffffffff
>> strtoll("-1",0,0)  == 0xffffffffffffffff
>> strtoll("0xffffffffffffffff",0,0)  -> ERANGE
> 
> Probably a good idea, I think I had noticed that earlier and
> then spaced it.  :(
> 
> But I figure one functional change per patch is the way to go;
> making this other change would probably be best under its own commit;
> one to fix the fd leak, and one to fix this issue?

IMHO this would be simple enough to be done in one shot. However this
problem exists also in other points.
May be that for now your patch is ok. But then we should start another
set of patches which correct/sanitise all these use of
"parse_size/strto[u]ll/parse_limit...".

Unfortunately this means that these next series of patches will start
only when these one will be accepted in order to avoid patches conflict.

> 
>>> +	if (errno == ERANGE) {
>>
>> Pay attention that if strtoull() doesn't encounter a problem errno *is
>> not* touched: this check could catch a previous error. I don't know if
>> it is an hole in the standard or a bug in the gnu-libc; however I think
>> that before strtoXll() we should put 'errno = 0;'.
> 
> yeah, ugh.  But this problem existed before, correct?  So I think a
> separate fix makes sense, do you agree?  Or have I made something
> worse here with this change?

No the things aren't worse. You are doing a great work

> 
> Thanks,
> -Eric
> 
> 
> 
>>> +		fprintf(stderr, "ERROR: invalid tree id (%s)\n", subvolid);
>>> +		return 1;
>>> +	}
>>> +
>>>  	fd = open_file_or_dir(path);
>>>  	if (fd < 0) {
>>>  		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
>>> -		return 12;
>>> +		return 1;
>>>  	}
>>>  
>>> -	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
>>> -	if (errno == ERANGE) {
>>> -		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
>>> -		return 30;
>>> -	}
>>>  	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
>>>  	e = errno;
>>>  	close(fd);
>>> -	if( ret < 0 ){
>>> +	if (ret < 0) {
>>>  		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
>>>  			strerror(e));
>>> -		return 30;
>>> +		return 1;
>>>  	}
>>>  	return 0;
>>>  }
>>
>>
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
