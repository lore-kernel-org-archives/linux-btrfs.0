Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52208 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaA2VAp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 16:00:45 -0500
Message-ID: <52E96BF8.3000601@fb.com>
Date: Wed, 29 Jan 2014 16:00:40 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dan Merillat <dan.merillat@gmail.com>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Rapid memory exhaustion during normal operation
References: <52E430F7.7030801@gmail.com>
In-Reply-To: <52E430F7.7030801@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/25/2014 04:47 PM, Dan Merillat wrote:
> I'm trying to track this down - this started happening without changing the kernel in use, so probably
> a corrupted filesystem. The symptoms are that all memory is suddenly used by no apparent source.  OOM
> killer is invoked on every task, still can't free up enough memory to continue.
>
> When it goes wrong, it's extremely rapid - system goes from stable to dead in less than 30 seconds.
>
> Tested 3.9.0, 3.12.0, 3.12.8.   Limited testing on 3.13 shows I think the same problem but I need
> to double-check that it's not a different issue.  Blows up the exact same way on a real kernel or in
> UML.
>
> All sorts of things can trigger it - defrag, random writes to files.  Balance and scrub don't,
> readonly mount doesn't.
>
> I can reproduce this trivially, mount the filesystem read-write and perform some activity.  It only
> takes a few minutes.   The other btrfs filesystems on the same machine don't show similar problems.
> Unfortunately, the output of btrfs-image -c9 is 75gb, much more than I can reasonably share.  I've got
> a reliable reproducer in UML using UML-COW to always start with the same base image, defrag a file with
> 33,000 extents and the system explodes within a minute.
>
> Here's the OOM report, the formatting is a bit off due to being delivered via netconsole.
> Swap was disabled on this run, but it makes no difference.  I get insta-OOM issues out of the blue
> with very little memory swapped out.
Don't defrag right now, the snapshot aware defrag is horribly broken and 
will OOM the box.  Thanks,

Josef
