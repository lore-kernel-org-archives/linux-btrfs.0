Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab3DOCV3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 22:21:29 -0400
Message-ID: <516B645E.2050204@oracle.com>
Date: Mon, 15 Apr 2013 10:22:22 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] btrfs-progs: no pending balance is not an error
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com> <1365141303-10571-3-git-send-email-anand.jain@oracle.com> <20130412155739.GY18193@twin.jikos.cz>
In-Reply-To: <20130412155739.GY18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/12/2013 11:57 PM, David Sterba wrote:
> On Fri, Apr 05, 2013 at 01:54:56PM +0800, Anand Jain wrote:
>> --- a/cmds-balance.c
>> +++ b/cmds-balance.c
>> @@ -662,8 +662,12 @@ static int cmd_balance_status(int argc, char **argv)
>>   	close(fd);
>>
>>   	if (ret < 0) {
>> +		if (e == ENOTCONN) {
>> +			printf("No balance found on '%s'\n", path);
>> +			return 0;
>> +		}
>>   		fprintf(stderr, "ERROR: balance status on '%s' failed - %s\n",
>> -			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
>
> I'm not sure if we want to change the error code if balance is not in
> progress. That's the only way to find out if it is so.
>
> Let's say that I have this shell code as a balance monitor and expect it
> to finish when the balance finishes:
>
> while btrfs fi balance status; do
> 	sleep 5;
> done
>
> not possible after your change. What we can do is to differentiate the
> status by a different error code number, let's say 1 for an error and 2
> for 'not in progress'.
>
>> +			path, strerror(e));
>>   		return 19;
>>   	}


Thanks for the review. good point. Hope the below return
code will suffice

/*
  * return codes:
  *  -1 : Error, failed to know if there is any pending balance
  *   1 : Successful to know status of a pending balance
  *   0 : when there is no pending balance or completed
  */

OR do we prefer

/*
  * return codes:
  *  -1 : Error, failed to know if there is any pending balance
  *   0 : Successful to know status of a pending balance
  *   1 : when there is no pending balance or completed
  */

I am fine with either.

Thanks, Anand
