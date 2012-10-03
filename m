Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2JCQeh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 12:34:37 -0400
Received: by bkcjk13 with SMTP id jk13so6254608bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 09:34:36 -0700 (PDT)
Message-ID: <506C691E.6020506@gmail.com>
Date: Wed, 03 Oct 2012 18:34:38 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <1349264596-9383-2-git-send-email-kreijack@inwind.it> <20121003150219.GB1978@zambezi.lan>
In-Reply-To: <20121003150219.GB1978@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 05:02 PM, Ilya Dryomov wrote:
> On Wed, Oct 03, 2012 at 01:43:15PM +0200, Goffredo Baroncelli wrote:
>> The  command  btrfs  filesystem  df is used to query the
>> status of the chunks, how many space on the disk(s) are used  by
>> the  chunks,  how many space are available in the chunks, and an
>> estimation of the free space of the filesystem.
>> ---
>>   cmds-filesystem.c |  264 +++++++++++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 215 insertions(+), 49 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index b1457de..6c3ebdc 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>
> (snipped)
>
>> +static int cmd_disk_free(int argc, char **argv)
>> +{
>> +
>> +	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
>> +	int	i, more_than_one=0;
>> +
>> +	if (check_argc_min(argc, 2))
>> +		usage(cmd_disk_free_usage);
>> +
>> +	for(i=1; i<  argc ; i++){
>> +		if(!strcmp(argv[i],"-d"))
>> +			flags&= ~DF_SHOW_DETAIL;
>> +		else if(!strcmp(argv[i],"-s"))
>> +			flags&= ~DF_SHOW_SUMMARY;
>> +		else if(!strcmp(argv[i],"-k"))
>> +			flags&= ~DF_HUMAN_UNIT;
>> +		else{
>> +			int r;
>> +			if(more_than_one)
>> +				printf("\n");
>> +			r = _cmd_disk_free(argv[i], flags);
>> +			if( r ) return r;
>> +			more_than_one=1;
>> +		}
>
> Is there any reason getopt(), or better yet, getopt_long() won't work?

In the beginning there were also the switches +d, +s, +k, then I dropped 
them. So I leaved this style. The code is simple enough to not justify a 
change.

>
>> +
>> +	}
>> +
>> +	return 0;
>> +}	
>> +	
>> +
>> +	
>>   static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
>>   {
>>   	char uuidbuf[37];
>> @@ -529,7 +695,7 @@ static int cmd_label(int argc, char **argv)
>>
>>   const struct cmd_group filesystem_cmd_group = {
>>   	filesystem_cmd_group_usage, NULL, {
>> -		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
>> +		{ "df", cmd_disk_free, cmd_disk_free_usage, NULL, 0 },
>
> If this command is going to replace df, you should change the function
> name back to cmd_df.

I was never convinced to use 'df'. At the beginning when I wrote the 
first parser of btrfs, was suggested (not by me) to use "long" command 
and allow the parser to match a contracted command until there was any 
ambiguity. I suggested to use disk-free, but everybody were confortable 
with df.. so I leaved it as "official name". But I prefer for the 
internal code a more verbose name.


>
> Thanks,

Thanks you for your review.

>
> 		Ilya
>

