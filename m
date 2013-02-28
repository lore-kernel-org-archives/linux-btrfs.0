Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27193 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3B1Bxb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 20:53:31 -0500
Message-ID: <512EB870.6050600@oracle.com>
Date: Thu, 28 Feb 2013 09:52:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add correct indentation
References: <1361516364-25810-1-git-send-email-anand.jain@oracle.com> <20130227154504.GH27541@twin.jikos.cz>
In-Reply-To: <20130227154504.GH27541@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/27/2013 11:45 PM, David Sterba wrote:
> On Fri, Feb 22, 2013 at 02:59:24PM +0800, Anand Jain wrote:
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1192,12 +1192,13 @@ scan_again:
>>   		return -ENOENT;
>>   	}
>>   	/* skip the header */
>> -	for(i=0; i < 2 ; i++)
>> -		if(!fgets(buf, 1023, proc_partitions)){
>> -		fprintf(stderr, "Unable to read '/proc/partitions' for scanning\n");
>> -		fclose(proc_partitions);
>> -		return -ENOENT;
>> -	}
>> +	for (i=0; i < 2 ; i++)
>
> 	for (i = 0; i < 2; i++)
>
> If possible, It's good to fix these issues in one go, I'll fix it locally.

  Absolutely. Sorry my mistake. A new patch below if it helps. Thanks

Anand
