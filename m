Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:35546 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbbFQP2t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 11:28:49 -0400
Received: by ykar6 with SMTP id r6so42687421yka.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 08:28:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mls0gb$s7m$1@ger.gmane.org>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
Date: Wed, 17 Jun 2015 09:28:48 -0600
Message-ID: <CAJCQCtTJU3z4je=CBWDP6qE7_rDt46ivYBs9T1NNj3b-5Fy_PA@mail.gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
From: Chris Murphy <lists@colorremedies.com>
To: Christian <cdysthe@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 8:33 AM, Christian <cdysthe@gmail.com> wrote:
> On 06/17/2015 10:22 AM, Chris Murphy wrote:
>>
>> On Wed, Jun 17, 2015 at 6:56 AM, Christian Dysthe <cdysthe@gmail.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> Sorry for asking more about this. I'm not a developer but trying to
>>> learn.
>>> In my case I get several errors like this one:
>>>
>>> root 2625 inode 353819 errors 400, nbytes wrong
>>>
>>> Is it inode 353819 I should focus on and what is the number after "root",
>>> in
>>> this case 2625?
>>
>>
>> I'm going to guess it's tree root 2625, which is the same thing as fs
>> tree, which is the same thing as subvolume. Each subvolume has its own
>> inodes. So on a given Btrfs volume, an inode number can exist more
>> than once, but in separate subvolumes. When you use btrfs inspect
>> inode it will list all files with that inode number, but only the one
>> in subvol ID 2625 is what you care about deleting and replacing.
>>
> Thanks! Deleting the file for that inode took care of it. No more errors.
> Restored it from a backup.
>
> However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be
> another problem. Is there a way to check if trim works?

That sounds like maybe your SSD is blacklisted for trim, is all I can
think of. So trim shouldn't be the cause of the problem if it's being
blacklisted. The recent problems appear to be around newer SSDs that
support queue trim and newer kernels that issue queued trim. There
have been some patches related to trim to the kernel, but the
existence of blacklisting and claims of bugs in firmware make it
difficult to test and isolate.

http://techreport.com/news/28473/some-samsung-ssds-may-suffer-from-a-buggy-trim-implementation

-- 
Chris Murphy
