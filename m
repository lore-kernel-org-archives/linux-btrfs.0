Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh2.e.nsc.no ([193.213.121.73]:45987 "EHLO nmsh2.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbL1CEi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 21:04:38 -0500
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <567FEEB6.3080701@online.no>
 <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
 <56806F06.50309@online.no> <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
From: Waxhead <waxhead@online.no>
Message-ID: <568098B1.2040908@online.no>
Date: Mon, 28 Dec 2015 03:04:33 +0100
MIME-Version: 1.0
In-Reply-To: <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan wrote:
> Waxhead posted on Mon, 28 Dec 2015 00:06:46 +0100 as excerpted:
>
>> btrfs scrub status /mnt scrub status for
>> 2832346e-0720-499f-8239-355534e5721b
>>           scrub started at Sun Mar 29 23:21:04 2015 and finished after
>> 00:01:04
>>           total bytes scrubbed: 1.97GiB with 14549 errors error details:
>>           super=2 csum=14547 corrected errors: 0, uncorrectable errors:
>>           14547, unverified
>> errors: 0
>>
>> Now here is the first worrying part... it says that scrub started at Sun
>> Mar 29. That is NOT true, the first scrub I did on this filesystem was a
>> few days ago and it claims it is a lot of uncorrectable errors. Why?
>> This is after all a raid6 filesystem correct?!
> Hmm...  The status is stored in readable plain-text files in /var/lib/
> btrfs/scrub.status.*, where the * is the UUID.  If you check there, the
> start time (t_start) seems to be in POSIX time.
>
> Is it possible you were or are running the scrub from, for instance, a
> rescue image that might not set the system time correctly and that falls
> back to, say, the date the rescue image was created, if it can't get
> network connectivity or some such?
>
No I don't think so....

# ls -la /var/lib/btrfs/scrub.status.2832346e-0720-499f-8239-355534e5721b
-rw------- 1 root root 2315 Mar 29  2015 
/var/lib/btrfs/scrub.status.2832346e-0720-499f-8239-355534e5721b

# cat /var/lib/btrfs/scrub.status.2832346e-0720-499f-8239-355534e5721b
scrub status:1
2832346e-0720-499f-8239-355534e5721b:1|data_extents_scrubbed:5391|tree_extents_scrubbed:21|data_bytes_scrubbed:352542720|tree_bytes_scrubbed:344064|read_errors:0|csum_errors:0|verify_errors:0|no_csum:32|csum_discards:0|super_errors:0|malloc_errors:0|uncorrectable_errors:0|corrected_errors:0|last_physical:3306160128|t_start:1427664064|t_resumed:0|duration:51|canceled:0|finished:1
2832346e-0720-499f-8239-355534e5721b:2|data_extents_scrubbed:5404|tree_extents_scrubbed:26|data_bytes_scrubbed:353517568|tree_bytes_scrubbed:425984|read_errors:0|csum_errors:0|verify_errors:0|no_csum:64|csum_discards:2|super_errors:0|malloc_errors:0|uncorrectable_errors:0|corrected_errors:0|last_physical:3306160128|t_start:1427664064|t_resumed:0|duration:51|canceled:0|finished:1
2832346e-0720-499f-8239-355534e5721b:3|data_extents_scrubbed:5396|tree_extents_scrubbed:19|data_bytes_scrubbed:352718848|tree_bytes_scrubbed:311296|read_errors:0|csum_errors:0|verify_errors:0|no_csum:48|csum_discards:2|super_errors:0|malloc_errors:0|uncorrectable_errors:0|corrected_errors:0|last_physical:3306160128|t_start:1427664064|t_resumed:0|duration:51|canceled:0|finished:1
2832346e-0720-499f-8239-355534e5721b:4|data_extents_scrubbed:5391|tree_extents_scrubbed:31|data_bytes_scrubbed:352739328|tree_bytes_scrubbed:507904|read_errors:0|csum_errors:14547|verify_errors:0|no_csum:32|csum_discards:0|super_errors:2|malloc_errors:0|uncorrectable_errors:14547|corrected_errors:0|last_physical:2282749952|t_start:1427664064|t_resumed:0|duration:64|canceled:0|finished:1
2832346e-0720-499f-8239-355534e5721b:5|data_extents_scrubbed:5393|tree_extents_scrubbed:23|data_bytes_scrubbed:352665600|tree_bytes_scrubbed:376832|read_errors:0|csum_errors:0|verify_errors:0|no_csum:48|csum_discards:0|super_errors:0|malloc_errors:0|uncorrectable_errors:0|corrected_errors:0|last_physical:2534408192|t_start:1427664064|t_resumed:0|duration:51|canceled:0|finished:1
2832346e-0720-499f-8239-355534e5721b:6|data_extents_scrubbed:5407|tree_extents_scrubbed:33|data_bytes_scrubbed:353361920|tree_bytes_scrubbed:540672|read_errors:0|csum_errors:0|verify_errors:0|no_csum:48|csum_discards:2|super_errors:0|malloc_errors:0|uncorrectable_errors:0|corrected_errors:0|last_physical:3306160128|t_start:1427664064|t_resumed:0|duration:51|canceled:0|finished:1

# date
Mon Dec 28 02:54:11 CET 2015

Just to clear up any possible misunderstandings. I run this from a 
simple netbook, and I have no idea why the date is off by so much.

Since all drives register and since I can even mount the filesystem. 
Since I can reproduce this every time I try to start a scrub I have not 
tried to run balance , defrag or just md5sum all the files on the 
filesystem to see if that fixes up things a bit. In a raid6 config you 
should be able to loose up to two drives and honestly so far only one 
drive is hampered and even if another one for any bizarre reason should 
contain damaged data things should "just work" right?

Note:  I have used the same USB drives (memory sticks really) to create 
various configs of btrfs filesystems earlier. Could it be old metadata 
in the filesystem that mess up things? Is not metadata stamped with the 
UUID of the filesystem to prevent such things?

