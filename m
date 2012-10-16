Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36654 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2JPG7l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 02:59:41 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9G6xdrh029243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 06:59:40 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9G6xdMa029014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 06:59:39 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9G6xdTD003479
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 01:59:39 -0500
Message-ID: <507D06B3.6040200@oracle.com>
Date: Tue, 16 Oct 2012 15:03:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs-progs: add parent uuid for snapshots
References: <50584E6D.8000602@cn.fujitsu.com> <1349403922-4583-1-git-send-email-Anand.Jain@oracle.com> <1349403922-4583-3-git-send-email-Anand.Jain@oracle.com> <20121009154418.GV4405@twin.jikos.cz>
In-Reply-To: <20121009154418.GV4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I agree. Thanks for the comments.
New patch has been sent out.

-Anand


On 09/10/12 23:44, David Sterba wrote:
> On Fri, Oct 05, 2012 at 10:25:22AM +0800, Anand jain wrote:
>> @@ -128,6 +129,11 @@ struct {
>>   		.need_print	= 0,
>>   	},
>>   	{
>> +		.name		= "puuid",
>> +		.column_name	= "PUUID",
>
> the capitalized 'P' looks like it's part of the UUID abbreviation. The
> UUIDs are long, I think you can print 'parent UUID' in the header, the
> name for command line argument 'puuid' is understable.
>
>> +		.need_print	= 0,
>> +	},
>> +	{
>>   		.name		= "uuid",
>>   		.column_name	= "UUID",
>>   		.need_print	= 0,
>
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -267,6 +267,7 @@ static const char * const cmd_subvol_list_usage[] = {
>>   	"-p           print parent ID",
>>   	"-a           print all the subvolumes in the filesystem.",
>>   	"-u           print the uuid of subvolumes (and snapshots)",
>> +	"-P           print the parent uuid of snapshots",
>
> This clashes with my efforts to make the options consistent so that we
> can have a lowercase for column selection and uppercase for filter. In
> case of the parent UUID,  it makes sense to filter by it, eg when we
> have a hierarchy of subvolumes that keep the same structure but is
> replicated several times.
>
> I suggest to pick a different letter than 'P', say 'q'. (-q is usually
> used for 'no verbose output' in utilities, but it does not make much
> sense in context of 'subvol list' so I hope it's ok from the UI POV).
>
>>   	"-t           print the result as a table",
>>   	"-s           list snapshots only in the filesystem",
>>   	"-r           list readonly subvolumes (including snapshots)",
>
> Thanks,
> david
>
