Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3BZUX7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:23:59 -0500
Message-ID: <512D169C.3020100@redhat.com>
Date: Tue, 26 Feb 2013 14:10:04 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/17] btrfs-progs: fix fd leak in cmd_subvol_set_default
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-17-git-send-email-sandeen@redhat.com> <512D031D.20408@gmail.com>
In-Reply-To: <512D031D.20408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/26/13 12:46 PM, Goffredo Baroncelli wrote:
> Hi Eric,
> 
> On 02/25/2013 11:54 PM, Eric Sandeen wrote:
>> Rearrange cmd_subvol_set_default() slightly so we
>> don't have to close the fd on an error return.
>>
>> While we're at it, fix whitespace & remove magic
>> return values.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  cmds-subvolume.c |   17 +++++++++--------
>>  1 files changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index 0dfaefe..461eed9 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -712,24 +712,25 @@ static int cmd_subvol_set_default(int argc, char **argv)
>>  	subvolid = argv[1];
>>  	path = argv[2];
>>  
>> +	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
> 
> Could you replace strtoll() with strtoull() ? Note that:
> 
> strtoull("0xffffffffffffffff",0,0)  == 0xffffffffffffffff
> strtoull("-1",0,0)  == 0xffffffffffffffff
> strtoll("-1",0,0)  == 0xffffffffffffffff
> strtoll("0xffffffffffffffff",0,0)  -> ERANGE

Probably a good idea, I think I had noticed that earlier and
then spaced it.  :(

But I figure one functional change per patch is the way to go;
making this other change would probably be best under its own commit;
one to fix the fd leak, and one to fix this issue?

>> +	if (errno == ERANGE) {
> 
> Pay attention that if strtoull() doesn't encounter a problem errno *is
> not* touched: this check could catch a previous error. I don't know if
> it is an hole in the standard or a bug in the gnu-libc; however I think
> that before strtoXll() we should put 'errno = 0;'.

yeah, ugh.  But this problem existed before, correct?  So I think a
separate fix makes sense, do you agree?  Or have I made something
worse here with this change?

Thanks,
-Eric



>> +		fprintf(stderr, "ERROR: invalid tree id (%s)\n", subvolid);
>> +		return 1;
>> +	}
>> +
>>  	fd = open_file_or_dir(path);
>>  	if (fd < 0) {
>>  		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
>> -		return 12;
>> +		return 1;
>>  	}
>>  
>> -	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
>> -	if (errno == ERANGE) {
>> -		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
>> -		return 30;
>> -	}
>>  	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
>>  	e = errno;
>>  	close(fd);
>> -	if( ret < 0 ){
>> +	if (ret < 0) {
>>  		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
>>  			strerror(e));
>> -		return 30;
>> +		return 1;
>>  	}
>>  	return 0;
>>  }
> 
> 

