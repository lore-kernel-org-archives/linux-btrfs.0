Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36770 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752537AbbFCIqK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 04:46:10 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t538iaM4019028
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 16:44:36 +0800
Message-ID: <556EBDB0.7010704@cn.fujitsu.com>
Date: Wed, 3 Jun 2015 16:41:20 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: qgroup: allow user to clear some limitation
 on qgroup.
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1433314653-548-3-git-send-email-yangds.fnst@cn.fujitsu.com> <556EBD7C.8000603@jp.fujitsu.com>
In-Reply-To: <556EBD7C.8000603@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/03/2015 04:40 PM, Tsutomu Itoh wrote:
> On 2015/06/03 15:57, Dongsheng Yang wrote:
>> Currently, we can not clear a limitation on a qgroup. Although
>> there is a 'none' choice provided to user to do it, it does not
>> work well.
>>
>> It does not set the flag which user want to clear, then kernel
>> will never know what the user want to do at all.
>>
>> *Without this commit*
>>    # ./btrfs qgroup show -re /mnt
>> qgroupid         rfer         excl     max_rfer     max_excl
>> --------         ----         ----     --------     --------
>> 0/5           2.19GiB      2.19GiB      5.00GiB         none
>> 0/257       100.02MiB    100.02MiB         none         none
>>    # ./btrfs qgroup limit none /mnt
>>    # ./btrfs qgroup show -re /mnt
>> qgroupid         rfer         excl     max_rfer     max_excl
>> --------         ----         ----     --------     --------
>> 0/5           2.19GiB      2.19GiB      5.00GiB         none
>> 0/257       100.02MiB    100.02MiB         none         none
>>
>> This patch will set the flag user want to clear and pass a
>> size=-1 to kernel. Then kernel will clear it correctly.
>>
>> *With this commit*
>>    # ./btrfs qgroup show -re /mnt
>> qgroupid         rfer         excl     max_rfer     max_excl
>> --------         ----         ----     --------     --------
>> 0/5           2.19GiB      2.19GiB      5.00GiB         none
>> 0/257       100.02MiB    100.02MiB         none         none
>>    # ./btrfs qgroup limit none /mnt
>>    # ./btrfs qgroup show -re /mnt
>> qgroupid         rfer         excl     max_rfer     max_excl
>> --------         ----         ----     --------     --------
>> 0/5           2.19GiB      2.19GiB         none         none
>> 0/257       100.02MiB    100.02MiB         none         none
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>    cmds-qgroup.c | 23 +++++++++++------------
>>    1 file changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>> index b073250..00cc089 100644
>> --- a/cmds-qgroup.c
>> +++ b/cmds-qgroup.c
>> @@ -110,9 +110,10 @@ static int parse_limit(const char *p, unsigned long long *s)
>>    {
>>    	char *endptr;
>>    	unsigned long long size;
>> +	unsigned long long CLEAR_VALUE = -1;
> 
> Even if a negative value is specified, it doesn't become an error...
> So, it doesn't make an error of the following command.
> 
> # btrfs qg lim -- -1 sub1
> # btrfs qg show -prce /test1
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/259         8.86GiB      7.88GiB         none         none ---     ---
> # btrfs qg lim -- -2 sub1
> # btrfs qg show -prce /test1
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/259         8.86GiB      7.88GiB     16.00EiB         none ---     ---

Agreed, I understand your point here.

If we pass a negative value to limit command, we should Error out. But
currently, btrfs-progs are treating it as a unsigned value in parsing
it. Yes, that's a bit of confusing.

We need to cover it in parsing steps with another patch I think.
> 
> Otherwise OK,
> 
> Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Thanx


Yang
> 
> 
>>    
>>    	if (strcasecmp(p, "none") == 0) {
>> -		*s = 0;
>> +		*s = CLEAR_VALUE;
>>    		return 1;
>>    	}
>>    	size = strtoull(p, &endptr, 10);
>> @@ -406,17 +407,15 @@ static int cmd_qgroup_limit(int argc, char **argv)
>>    	}
>>    
>>    	memset(&args, 0, sizeof(args));
>> -	if (size) {
>> -		if (compressed)
>> -			args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
>> -					  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
>> -		if (exclusive) {
>> -			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
>> -			args.lim.max_exclusive = size;
>> -		} else {
>> -			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
>> -			args.lim.max_referenced = size;
>> -		}
>> +	if (compressed)
>> +		args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
>> +				  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
>> +	if (exclusive) {
>> +		args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
>> +		args.lim.max_exclusive = size;
>> +	} else {
>> +		args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
>> +		args.lim.max_referenced = size;
>>    	}
>>    
>>    	if (argc - optind == 2) {
>>
> 
> 
> .
> 

