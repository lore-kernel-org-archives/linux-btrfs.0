Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from md5i.com ([75.151.244.229]:56351 "EHLO maru2.md5i.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751710AbaDSDn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 23:43:58 -0400
From: Michael Welsh Duggan <mwd@md5i.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Michael Welsh Duggan <mwd@md5i.com>, linux-btrfs@vger.kernel.org
Subject: Re: Fixing a degraded RAID
References: <87y4z2avvz.fsf@maru2.md5i.com>
	<742B9F92-56D1-4B9E-AB69-ABB7B0C4A928@colorremedies.com>
Date: Fri, 18 Apr 2014 22:58:22 -0400
In-Reply-To: <742B9F92-56D1-4B9E-AB69-ABB7B0C4A928@colorremedies.com> (Chris
	Murphy's message of "Fri, 18 Apr 2014 20:49:33 -0600")
Message-ID: <87tx9qauup.fsf@maru2.md5i.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> writes:

> On Apr 18, 2014, at 8:36 PM, Michael Welsh Duggan <mwd@md5i.com> wrote:
>
>> I had a disk in my RAID0 die:
>> 
>>  root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi show 8c530f6f-7592-4d57-854d-1fae33ae7cb6
>>  Label: none  uuid: 8c530f6f-7592-4d57-854d-1fae33ae7cb6
>>          Total devices 3 FS bytes used 329.66GiB
>>          devid    1 size 1.79TiB used 357.03GiB path /dev/sdd1
>>          devid    3 size 931.51GiB used 178.00GiB path /dev/sdf
>>          *** Some devices missing
>> 
>>  Btrfs v3.12-43-gc2081e2-dirty
>> 
>> So, I try to mount it with -o degraded.  That fails, implying that a
>> degraded mount needs to be read-only.  So I successfully mount it read
>> only.  Then I want to add a new disk to replace the missing one:
>> 
>>  root@maru2:~# /usr/local/src/btrfs-progs/btrfs dev add /dev/sdg /mnt/
>>  ERROR: error adding the device '/dev/sdg' - Read-only file system
>> 
>> So I can't add a disk if it's mounted read-only, and can't mount it
>> read-write?  What am I missing?  What's my way around this?
>
> Not really because it's raid0. The minimum number of disks for a 3
> disk raid0 is 3 disks. Upon losing one, the data portion of the file
> system is toast. I'm guessing it lets you mount it ro,degraded because
> the metadata and hence the file system itself, is raid1 (the default
> for raid0 data volumes).
>
> The file system could determine what files aren't damaged, i.e they
> exist entirely on one of the remaining two drives, with no dependency
> on the dead one. But I don't think this code exists yet. You could
> possibly rsync the drive to another file system, and bad files damaged
> by the missing disk will be reported in dmesg while the good ones
> would still copy over. I haven't tried this.

My mistake.  I meant RAID1.

-- 
Michael Welsh Duggan
(md5i@md5i.com)
