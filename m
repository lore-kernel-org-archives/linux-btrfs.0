From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Adding a disk fails
Date: Fri, 21 Jan 2011 19:42:39 +0100
Message-ID: <4D39D39F.5040806@libero.it>
References: <201101201318.40686.CACook@quantum-sci.com> <4D38B382.1050709@libero.it> <201101201510.54418.CACook@quantum-sci.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101201510.54418.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2011 12:10 AM, Carl Cook wrote:
> On Thu 20 January 2011 14:13:22 Goffredo Baroncelli wrote:
>> To add another disk you don't have to run mkfs.btrfs. For example:
>>
>> # add the first disk
>> mkfs.btrfs /dev/sdb
>> # mount the disk
>> mount /dev/sdb /media/backups
>>
>> # add another disk to the first one
>> btrfs device add /dev/sdc /media/backup
> 
> Thanks Goffredo but as I say, I did this and it responds with 
>  "ERROR: error adding the device '/dev/sdc'"
> .. it doesn't give a clue.

In your email you wrote that before adding the device you format it.
Anyway I don't think that this is the problem.

Have you check which is reported in dmesg.

> 
>> Note1: the filesystem has to be mounted
>> Note2: the medatada will be in raid1, the data in raid0
>> If you shutdown the system, at the reboot you should "scan" all the
>> device in order to find the btrfs ones
>>
>> # find the btrfs device
>> btrfs device scan
> 
> This must be done at every boot?  If so, where is recommended, in rc.local? 

Look at this thread, where I wrote anout a possible solution

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04709.html

> 
> 
>> # if you try to mount snapshot-3 directly, you fail because this
>> # snapshot is not under the root of the btrfs filesystem
>> mount -o subvol=dir-1/snapshot-3 /dev/sdb /media/backup	 # -> error
> 
> This is how I'd understood it, but when creating a subvolume in the root and putting a snalshot into it, it seems to make a further subvolume (or directory) with a redundant name.  This would not be under the root, and may not be mountable?
> 
> 
>> Which kenel version debian testing uses ?
> 
> 2.6.32-5-amd64 with Debian patches.

>From a btrfs point of view, it is a very old kernel. IIRC in this kernel
is not supported the snapshot removal. I suggest you to update the
kernel with a recent one.

> 
> 
>> btrfs filesystem snapshot / /snapshot-$(date +"%Y-%m-%d")
> 
> Oh thank you.
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

