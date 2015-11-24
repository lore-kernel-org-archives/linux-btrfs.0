Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36955 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbKXNFQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 08:05:16 -0500
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56546076.4090709@oracle.com>
Date: Tue, 24 Nov 2015 21:04:54 +0800
MIME-Version: 1.0
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




Thanks for comments.


Distro would also want to use the latest btrfs-progs on older kernel
since it will have latest fsck/send/receive fixes, better UI
and updated man pages.

btrfs-progs which claim backward kernel compatible and it shouldn't
fail on the below cmd when the btrfs-progs is upgraded.
    mkfs.btrfs /dev/sda && mount /dev/sda /btrfs
but it does in some test cases.


A warning is unnecessary IMO. Imagine user who upgrade progs for
better doc/UI and have no intention to upgrade the kernel, gets a 
Warning!. If user does not upgrade kernel its a fair assumption
that they don't need/not-looking for latest kernel features. (What
did I miss ?).


Next.
For users looking to have a disk-layout which is compatible with
older kernels (and may not be a running kernel), then with the
current patch set its quite possible to do something like below,

mkfs.btrfs -O as-per-kernel=3.2
mkfs.btrfs -O as-per-kernel=4.0
mkfs.btrfs -O as-per-kernel=x.x (anything)

And only those features that are supported until version x.x
(mainline) will be enabled by default unless user want to over
default totally by using -O <feature>.

Thanks, Anand



Anand Jain wrote:
> Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-progs
> be compatible w any set of older/newer kernels.
>
> So far mkfs.btrfs and btrfs-convert sets the default features, for eg,
> skinny-metadata even if the running kernel does not supports it, and
> so the mount fails on the running.
>
> Here in this set of patches will make sure the progs understands the
> kernel supported features.
>
> So in this patch, checks if sysfs tells whether the feature is
> supported if not, then it will relay on static kernel version which
> provided that feature (skinny-metadata here in this example), next
> if for some reason the running kernel does not provide the kernel
> version, then it will fall back to the original method to enable
> the feature with a hope that kernel will support it.
>
> Also the last patch adds a warning when we fail to read either
> sysfs features or the running kernel version.
>
> With this I hope all the concerns from the review comments are
> addressed.
>
>
> Anand Jain (5):
>    btrfs-progs: introduce framework to check kernel supported features
>    btrfs-progs: add framework to check features supported by sysfs
>    btrfs-progs: kernel based default features for mkfs
>    btrfs-progs: kernel based default features for btrfs-convert
>    btrfs-progs: add warning when we fail to read sysfs or kernel version
>
>   btrfs-convert.c |  18 ++++++-
>   mkfs.c          |  22 ++++++++-
>   utils.c         | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>   utils.h         |   2 +
>   4 files changed, 173 insertions(+), 15 deletions(-)
>
