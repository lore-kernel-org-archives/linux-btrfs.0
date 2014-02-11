Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:34533 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBKSUZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:20:25 -0500
Message-ID: <52FA69E7.7020206@libero.it>
Date: Tue, 11 Feb 2014 19:20:23 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com> <52F95222.1010403@libero.it> <52FA224B.1030805@fb.com>
In-Reply-To: <52FA224B.1030805@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2014 02:14 PM, Josef Bacik wrote:
> 
> 
> On 02/10/2014 05:26 PM, Goffredo Baroncelli wrote:
>> On 02/10/2014 05:41 PM, Josef Bacik wrote:
>>> ===== New and improved btrfs fi df =====
[...]

Hi Josef

> The problem I had with this patch was it didn't give me a way to get
> the original output.  I as a developer really need to have the raw
> dump of the block group info as I'm doing stuff.  So I like this
> output, but I still need my old output, if you fix that part up I'll
> review/ack it. Thanks,

I am open to improve this patch. What about the following output (it 
was a copy and paste, no code for now, the number are invented)

$ sudo btrfs filesystem df /mnt/btrfs1/
Disk size:		 400.00GB
Disk unallocated:	 391.97GB
Disk allocation:
                        Allocated	Used
   Data, single:           2.01GB,         1.00GB
   System, DUP:            4.00MB          2.00MB
   System, single:         4.00MB          1.00MB
   Metadata, DUP:          2.00GB        750.00MB
   Metadata, single:       8.00MB          2.20MB
                           ------         -------
   Total:                  7.00GB          1.75GB

Free (Estimated):	 250.45GB	(Max: 396.99GB, min: 201.00GB)
Data to disk ratio:	     63 %

Do you like ? Do you have further suggestions ?

Anyway if you want a more understandable block group info dump, 
I suggest you to give a look to the other command (same patch set):

$ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
         Data   Data    Metadata Metadata System System             
         Single RAID6   Single   RAID5    Single RAID5   Unallocated
                                                                    
/dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB     97.98GB
/dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
/dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
/dev/vde      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
         ====== ======= ======== ======== ====== ======= ===========
Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB 12.00MB    391.97GB
Used       0.00 11.25MB     0.00  36.00KB   0.00  4.00KB            




> 
> Josef -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
