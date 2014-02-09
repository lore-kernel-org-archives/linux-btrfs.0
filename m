Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIIhP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Feb 2014 03:37:15 -0500
Message-ID: <52F73E2B.9080103@friedels.name>
Date: Sun, 09 Feb 2014 09:36:59 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name> <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>
In-Reply-To: <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

thanks for your reply.

 >> ./btrfs filesystem show /dev/sdb1
>> Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
>>         Total devices 2 FS bytes used 3.47TiB
>>         devid    1 size 2.73TiB used 1.74TiB path /dev/sdb1
>>         devid    2 size 2.73TiB used 1.74TiB path /dev/sdc1
>
> I don't understand the no spare part. You have 3.47T of data, and yet the single device size is 2.73T.
> There is no way to migrate 1.74T from sdc1 to sdb1 because there isn't enough space.

Fair point. I summed up manually (with du) and apparently missed some 
data. I can move the 0.8TiB out of the way. I just don't have 3.5TiB 
'spare'.



>> btrfs device delete /dev/sdc1 /mnt/BTRFS/rsnapshot/
>> btrfs device delete /dev/sdc1 /mnt/BTRFS/backups/
>> btrfs device delete /dev/sdc1 /mnt/BTRFS/Video/
>> btrfs filesystem balance start /mnt/BTRFS/Video/
>
> I don't understand this sequence because I don't know what you've mounted where,

I'm sorry. here you go:
/btrfs subvolume list /mnt/BTRFS/Video
ID 256 gen 226429 top level 5 path Video --> /mnt/BTRFS/Video/
ID 1495 gen 226141 top level 5 path rsnapshot  --> /mnt/BTRFS/rsnapshot
ID 4444 gen 226429 top level 256 path Snapshot --> not mounted
ID 5845 gen 226375 top level 5 path backups --> /mnt/BTRFS/backups


> but in any case maybe it's a bug that you're not getting errors for each
 > of these commands because  you can't delete sdc1 from a raid0 volume.
That makes sense. I read that procedure somewhere in the -totally 
unvalidated- Internet.
In case the missing Error-Message is a Bug: Is this place here 
sufficient to report it, or is there a Bug-Tracker?


 > You'd first have to convert the data, metadata, and system profiles to
 > single (metadata can be set to dup). And then you'd be able to delete
 > a device so long as there's room on remaining devices, which you 
don't have.

Yes, but I can create that space.
So, for me the next steps would be to:
-generate enough room on the filesystem
-btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/BTRFS/Video
-btrfs device delete /dev/sdc1 /mnt/BTRFS/Video

Right?

>> next, I'm doing the balance for the subvolume /mnt/BTRFS/backups
>
> You told us above  you deleted that subvolume. So how are you balancing it?

Yes, that was my understanding from my research:
You tell btrfs, that you want to remove one disc from the filesystem and 
then balance it to move the data on the remaining disc. I did find this 
logical. I was expecting that I possibly need a further command to tell 
btrfs that it's not a raid anymore, but I thought this could also be 
automagical.
I understand, that's not the way it is implemented, but it's not a crazy 
idea, is it?

> And also, balance applies to a mountpoint, and even if you mount a
 > subvolume to that mountpoint, the whole file system is balanced.
 > Not just the mounted subvolume.

That is confusing. (I mean: I understand what you are saying, but it's 
counterintuitive). Why is this the case?

>> In parallel, I try to delete /mnt/BTRFS/rsnapshot, but it fails:
>>   btrfs subvolume delete  /mnt/BTRFS/rsnapshot/
>>   Delete subvolume '/mnt/BTRFS/rsnapshot'
>>   ERROR: cannot delete '/mnt/BTRFS/rsnapshot' - Inappropriate ioctl
>>   for  device
>>
>> Why's that?
>> But even more: How do I free sdc1 now?!
>
>
> Well I'm pretty confused because again, I can't tell if your paths refer to
 > subvolumes or if they refer to mount points.

Now I am confused. These paths are the paths to which I mounted the 
subvolumes:
my (abbreviated) fstab:
UUID=xy      /mnt/BTRFS/Video btrfs subvol=Video
UUID=xy     /mnt/BTRFS/rsnapshot btrfs subvol=rsnapshot
UUID=xy     /mnt/BTRFS/backups btrfs subvol=backups


 > The balance and device delete commands all refer to a mount point, 
which is the path returned by the df command.
So this:
/dev/sdb1       5,5T    3,5T  2,0T   64% /mnt/BTRFS/Video
/dev/sdb1       5,5T    3,5T  2,0T   64% /mnt/BTRFS/backups
/dev/sdc1       5,5T    3,5T  2,0T   64% /mnt/BTRFS/rsnapshot

> The subvolume delete command needs a path to subvolume that starts with the mount point.
Sorry, this I do not understand, no matter how hard I think about it..
What would it be in my case?

Thanks for your help! I appreciate it.


Greetings,
Hendrik
