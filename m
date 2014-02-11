Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20534 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbaBKSd0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:33:26 -0500
Message-ID: <52FA6CEE.9010106@fb.com>
Date: Tue, 11 Feb 2014 13:33:18 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com> <52F95222.1010403@libero.it> <52FA224B.1030805@fb.com> <52FA69E7.7020206@libero.it>
In-Reply-To: <52FA69E7.7020206@libero.it>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/11/2014 01:20 PM, Goffredo Baroncelli wrote:
> On 02/11/2014 02:14 PM, Josef Bacik wrote:
>>
>>
>> On 02/10/2014 05:26 PM, Goffredo Baroncelli wrote:
>>> On 02/10/2014 05:41 PM, Josef Bacik wrote:
>>>> ===== New and improved btrfs fi df =====
> [...]
>
> Hi Josef
>
>> The problem I had with this patch was it didn't give me a way to get
>> the original output.  I as a developer really need to have the raw
>> dump of the block group info as I'm doing stuff.  So I like this
>> output, but I still need my old output, if you fix that part up I'll
>> review/ack it. Thanks,
>
> I am open to improve this patch. What about the following output (it
> was a copy and paste, no code for now, the number are invented)
>
> $ sudo btrfs filesystem df /mnt/btrfs1/
> Disk size:		 400.00GB
> Disk unallocated:	 391.97GB
> Disk allocation:
>                          Allocated	Used
>     Data, single:           2.01GB,         1.00GB
>     System, DUP:            4.00MB          2.00MB
>     System, single:         4.00MB          1.00MB
>     Metadata, DUP:          2.00GB        750.00MB
>     Metadata, single:       8.00MB          2.20MB
>                             ------         -------
>     Total:                  7.00GB          1.75GB
>
> Free (Estimated):	 250.45GB	(Max: 396.99GB, min: 201.00GB)
> Data to disk ratio:	     63 %
>
> Do you like ? Do you have further suggestions ?
>
> Anyway if you want a more understandable block group info dump,
> I suggest you to give a look to the other command (same patch set):
>
> $ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
>           Data   Data    Metadata Metadata System System
>           Single RAID6   Single   RAID5    Single RAID5   Unallocated
>
> /dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB     97.98GB
> /dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
> /dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
> /dev/vde      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
>           ====== ======= ======== ======== ====== ======= ===========
> Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB 12.00MB    391.97GB
> Used       0.00 11.25MB     0.00  36.00KB   0.00  4.00KB
>

I did not notice this before, as long as I have a way to get to this 
information still then I'm good with what you had originally.  I guess 
update and resend and I'll review it.  Thanks,

Josef
