Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34903 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbcCWLRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 07:17:45 -0400
Received: by mail-qk0-f171.google.com with SMTP id o6so4163300qkc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 04:17:45 -0700 (PDT)
Subject: Re: overlay file to test btrfs repairs
To: Henk Slager <eye1tm@gmail.com>, Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
 <CAPmG0jY16du77GzzMScdMMB6dNQeMvOOqBqsYQLMn0CsE5HgmQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F27B48.2000006@gmail.com>
Date: Wed, 23 Mar 2016 07:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPmG0jY16du77GzzMScdMMB6dNQeMvOOqBqsYQLMn0CsE5HgmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-22 16:42, Henk Slager wrote:
> On Mon, Mar 21, 2016 at 4:43 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> Hi folks,
>>
>> So I just ran into this:
>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>>
>> This is a device mapper overlay file - not overlayfs.
>>
>> For the repairs that are sometimes uncertain what's next, maybe this
>> is a viable option to avoid changing the file system? I'm thinking
>> chunk-recover might take up too much space, I'm not sure how that one
>> works, if chunks are just being read or if they have to be rewritten
>> or if it's just the chunk tree? But for 'btrfs check' and 'btrfs
>> rescue super-recover/zero-log' there should be very little being
>> written so the overlay idea might be a good step?
>
> I used the info via this message:
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/54178
>
> to try to fix a 4x4TB disks RAID10 (some bad metadata, some nbytes 400 errors).
> I used AoE (instead of NBD) to avoid that btrfs+kernel might get
> confused by double UUID's.
>
> I created 4x 10G sparse files for each bcached HDD. After the --repair
> action had ended (apparently successful), du reported only 50M size on
> disk for each of the sparse files. The fix operation lasted about 1.5
> hours. After a mount and umount again of the 'just repaired fs', a
> subsequent btrfs check still reported the same errors, although
> reported in another sequence.
> So the nbytes 400 errors actually did not get fixed ( while there were
> also other errors; This in accordance to what Qu once noted, but at
> that time older tools/kernel).

I actually do similar when I need to fix something other than my root 
filesystem on my home server system.  I run Xen though, so instead of 
using AoE, I just unmount the filesystem, set up the snapshots, and then 
attach them to the VM I use to build updates for the other VM's directly 
via Xen's virtual block device protocol, and work with them from there. 
  Obviously not practical for most people, but it works well for my setup.
