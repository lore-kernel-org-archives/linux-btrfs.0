Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46969 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbbFQOeJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 10:34:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5EPa-0002OI-7d
	for linux-btrfs@vger.kernel.org; Wed, 17 Jun 2015 16:33:54 +0200
Received: from c-73-47-108-123.hsd1.ma.comcast.net ([73.47.108.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 16:33:54 +0200
Received: from cdysthe by c-73-47-108-123.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 16:33:54 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
Date: Wed, 17 Jun 2015 10:33:46 -0400
Message-ID: <mls0gb$s7m$1@ger.gmane.org>
References: <mlpb8i$dus$1@ger.gmane.org>	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>	<55816E7B.5040905@gmail.com> <CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/17/2015 10:22 AM, Chris Murphy wrote:
> On Wed, Jun 17, 2015 at 6:56 AM, Christian Dysthe <cdysthe@gmail.com> wrote:
>> Hi,
>>
>> Sorry for asking more about this. I'm not a developer but trying to learn.
>> In my case I get several errors like this one:
>>
>> root 2625 inode 353819 errors 400, nbytes wrong
>>
>> Is it inode 353819 I should focus on and what is the number after "root", in
>> this case 2625?
>
> I'm going to guess it's tree root 2625, which is the same thing as fs
> tree, which is the same thing as subvolume. Each subvolume has its own
> inodes. So on a given Btrfs volume, an inode number can exist more
> than once, but in separate subvolumes. When you use btrfs inspect
> inode it will list all files with that inode number, but only the one
> in subvol ID 2625 is what you care about deleting and replacing.
>
Thanks! Deleting the file for that inode took care of it. No more 
errors. Restored it from a backup.

However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be 
another problem. Is there a way to check if trim works?

-- 
//Christian


