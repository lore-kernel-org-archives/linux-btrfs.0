Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41450 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaL2PRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 10:17:14 -0500
Date: Mon, 29 Dec 2014 10:17:00 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: 3.16.3: fs/btrfs/delayed-inode.c:1410
 btrfs_assert_delayed_root_empty
To: Marc MERLIN <marc@merlins.org>
CC: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <1419866220.13012.18@mail.thefacebook.com>
In-Reply-To: <20141228213606.GP17254@merlins.org>
References: <20141228192614.GO17254@merlins.org>
	<20141229010047.7f9b6d43@natsu> <20141228213606.GP17254@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 28, 2014 at 4:36 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Dec 29, 2014 at 01:00:47AM +0500, Roman Mamedov wrote:
>>  > Will btrfs scrub, even if it takes about 24H to run for me, tell 
>> me
>>  > which FS is affected and if so do I run btrfs repair?
>> 
>>  I had this: 
>> https://urldefense.proofpoint.com/v1/url?u=http://www.spinics.net/lists/linux-btrfs/msg40586.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=yBJylKLQ0wXzMPYXMMCJaXZfTMrX%2FbRGSoF3t%2FRZsUU%3D%0A&s=9d08d8fb169b6429b819fb9a0c2fda816b4b6c031ee4c5e6ca5a53bb04e3c067
>> 
>>  1) I determined which btrfs of the multiple ones that I have is the 
>> culprit, by
>>  unmounting them one by one and seeing if the dmesg spam disappears;
> 
> And of course it's the root filesystem on a remote server which I 
> can't
> service remotely :-/
> 
>>  3) After that, I ran btrfsck (it did found some errors that looked 
>> like this,
>>  repeated dozens of times, with different "root nnnnn" numbers):
> 
> For the archives, one should use btrfs check --repair directly, 
> btrfsck is
> dead.
> 
>>  6) Surprisingly(#2), despite apparently not all of the errors 
>> having been
>>  fixed, the btrfs_assert_delayed_root_empty messages no longer 
>> appear in dmesg.
>> 
>>  The current versions of files mentioned (xfce4-panel.xml and parts 
>> of the Chromium profile)
>>  were of course corrupted, but I already noticed that and restored 
>> them from an earlier snapshot
>>  even before starting the fsck (yes I also had backups, but didn't 
>> need them as snapshotted versions
>>  were fine).
> 
> Thanks for the info. I think for now I'll be forced to leave the 
> broken
> FS run as is and will deal with it when I get home.
> 
> Dear btrfs-devs: this is one more example of btrfs having a problem 
> with
> a non consistent state that ended up on disk.
> 
> I got there this way:
> - btrfs on top of dmcrypt on top of md raid1 (sorry too many raid bugs
>   in btrfs, so I went back to mdadm at the time)
> - kernel bug in a serial driver was causing a loop, so I was forced to
>   cycle power remotely
> - btrfs got broken as per this mail.
> - please please please, all warnings and bugs should still be fixed to
>   output what device they happened on. Making the admin guess by 
> trying
>   filesystem one by one isn't really a good way.
> 
> Anyway, assuming there isn't a core bug in the btrfs "always 
> consistent
> state on disk" code, dmcrypt or mdadm prevented a consistent state 
> from
> reaching the disks.
> 
> Separately, I wish I could just fix this while the filesystem is 
> online.
> btrfs scrub ran totally clean with no errors :(
> scrub device /dev/mapper/cryptroot (id 1) done
>         scrub started at Sun Dec 28 12:07:55 2014 and finished after 
> 512 seconds
>         total bytes scrubbed: 25.95GiB with 0 errors
> 
> Thankfully the filesystem is still running for now, so it could be 
> worse.


I've hit this recently on my laptop, and haven't yet been able to 
recreate it on a machine where I can debug things.  The messages are an 
error in the log tree replay code, and I don't think they are actually 
related to any corruptions.  Trying to nail it down today.

-chris



