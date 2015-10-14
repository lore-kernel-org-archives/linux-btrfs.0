Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37834 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbbJNU1g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 16:27:36 -0400
Received: by wijq8 with SMTP id q8so99132284wij.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 13:27:35 -0700 (PDT)
Message-ID: <561EBAB1.6030600@gmail.com>
Date: Wed, 14 Oct 2015 22:27:29 +0200
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Recover btrfs volume which can only be mounded in read-only mode
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com> <561E6969.40500@oracle.com>
In-Reply-To: <561E6969.40500@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/10/2015 16:40, Anand Jain wrote:
>> # mount -o degraded /var
>> Oct 11 18:20:15 kernel: BTRFS: too many missing devices, writeable
>> mount is not allowed
>>
>> # mount -o degraded,ro /var
>> # btrfs device add /dev/sdd1 /var
>> ERROR: error adding the device '/dev/sdd1' - Read-only file system
>>
>> Now I am stuck: I cannot add device to the volume to satisfy raid
>> pre-requisite.
> 
>  This is a known issue. Would you be able to test below set of patches
>  and update us..
> 
>    [PATCH 0/5] Btrfs: Per-chunk degradable check

Many thanks for the reply. Unfortunately I have no environment to
recompile the kernel, and setting it up will perhaps take a day. Can the
latest kernel be pushed to Debian sid?

1. Is there any way to recover btrfs at the moment? Or the easiest I can
do is to mount ro, copy all data to another drive, re-create btrfs
volume and copy back?

2. How to avoid such a trap in the future?

3. How can I know what version of kernel the patch "Per-chunk degradable
check" is targeting?

4. What is the best way to express/vote for new features or suggestions
(wikipage "Project_ideas" / bugzilla)?

Thanks!

-- 
With best regards,
Dmitry
