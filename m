Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:39330 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaEEAyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 20:54:09 -0400
Received: by mail-yh0-f50.google.com with SMTP id 29so61969yhl.37
        for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 17:54:08 -0700 (PDT)
Message-ID: <5366DF48.40209@gmail.com>
Date: Sun, 04 May 2014 17:46:00 -0700
From: Daniel Lee <longinus00@gmail.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
References: <20140503232702.GC9061@merlins.org> <5365E4CF.3050405@swiftspirit.co.za> <20140504072420.GJ9061@merlins.org>
In-Reply-To: <20140504072420.GJ9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2014 12:24 AM, Marc MERLIN wrote:
>  
> Gotcha, thanks for confirming, so -m raid1 -d raid0 really only protects
> against metadata corruption or a single block loss, but otherwise if you
> lost a drive in a 2 drive raid0, you'll have lost more than just half
> your files.
>
>> The scenario you mentioned at the beginning, "if I lose a drive,
>> I'll still have full metadata for the entire filesystem and only
>> missing files" is more applicable to using "-m raid1 -d single".
>> Single is not geared towards performance and, though it doesn't
>> guarantee a file is only on a single disk, the allocation does mean
>> that the majority of all files smaller than a chunk will be stored
>> on only one disk or the other - not both.
> Ok, so in other words:
> -d raid0: if you one 1 drive out of 2, you may end up with small files
> and the rest will be lost
>
> -d single: you're more likely to have files be on one drive or the
> other, although there is no guarantee there either.
>
> Correct?
>
> Thanks,
> Marc
This often seems to confuse people and I think there is a common
misconception that the btrfs raid/single/dup features work at the file
level when in reality they work at a level closer to lvm/md.

If someone told you that they lost a device out of a jbod or multi disk
lvm group(somewhat analogous to -d single) with ext on top you would
expect them to lose data in any file that had a fragment in the lost
region (lets ignore metadata for a moment). This is potentially up to
100% of the files but this should not be a surprising result. Similarly,
someone who has lost a disk out of a md/lvm raid0 volume should not be
surprised to have a hard time recovering any data at all from it.

