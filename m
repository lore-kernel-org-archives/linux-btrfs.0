Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:50312 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964823Ab2JCRKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 13:10:01 -0400
Message-ID: <506C7153.4020004@inwind.it>
Date: Wed, 03 Oct 2012 19:09:39 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <1349264596-9383-2-git-send-email-kreijack@inwind.it> <20121003150219.GB1978@zambezi.lan>
In-Reply-To: <20121003150219.GB1978@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 05:02 PM, Ilya Dryomov wrote:
>> +static int cmd_disk_free(int argc, char **argv)
>> >  +{
>> >  +
>> >  +	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
>> >  +	int	i, more_than_one=0;
>> >  +
>> >  +	if (check_argc_min(argc, 2))
>> >  +		usage(cmd_disk_free_usage);
>> >  +
>> >  +	for(i=1; i<  argc ; i++){
>> >  +		if(!strcmp(argv[i],"-d"))
>> >  +			flags&= ~DF_SHOW_DETAIL;
>> >  +		else if(!strcmp(argv[i],"-s"))
>> >  +			flags&= ~DF_SHOW_SUMMARY;
>> >  +		else if(!strcmp(argv[i],"-k"))
>> >  +			flags&= ~DF_HUMAN_UNIT;
>> >  +		else{
>> >  +			int r;
>> >  +			if(more_than_one)
>> >  +				printf("\n");
>> >  +			r = _cmd_disk_free(argv[i], flags);
>> >  +			if( r ) return r;
>> >  +			more_than_one=1;
>> >  +		}
> Is there any reason getopt(), or better yet, getopt_long() won't work?

I re-changed idea: I will use getopt()


>

