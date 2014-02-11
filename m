Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33424 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbaBKNPK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 08:15:10 -0500
Message-ID: <52FA224B.1030805@fb.com>
Date: Tue, 11 Feb 2014 08:14:51 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>,
        "lin >> \"linux-btrfs@vger.kernel.org\""
	<linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com> <52F95222.1010403@libero.it>
In-Reply-To: <52F95222.1010403@libero.it>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/10/2014 05:26 PM, Goffredo Baroncelli wrote:
> On 02/10/2014 05:41 PM, Josef Bacik wrote:
>> ===== New and improved btrfs fi df =====
>>
>> Since people using this tool are already going to be better informed
>> and since we are already given the block group flags we can go ahead
>> and do the raid multiplier in btrfs-progs and spit out the adjusted
>> numbers rather than the raw numbers we get from the ioctl.  This will
>> just be a progs thing and that way we can possibly add an option to
>> not apply the multipliers and just get the raw output.
>
> In the past [1] I proposed the following approach.
>
> $ sudo btrfs filesystem df /mnt/btrfs1/
> Disk size:		 400.00GB
> Disk allocated:		   8.04GB
> Disk unallocated:	 391.97GB
> Used:			  11.29MB
> Free (Estimated):	 250.45GB	(Max: 396.99GB, min: 201.00GB)
> Data to disk ratio:	     63 %
>
> The space was given in terms of "disk space" and in terms of
> "filesystem space". Other that there is an indication of an estimation of
> the free space, with the pessimistic and optimistic values.
>
> [1] See "[PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support"
> dated 03/10/2013 01:17 PM
>

The problem I had with this patch was it didn't give me a way to get the 
original output.  I as a developer really need to have the raw dump of 
the block group info as I'm doing stuff.  So I like this output, but I 
still need my old output, if you fix that part up I'll review/ack it. 
Thanks,

Josef
