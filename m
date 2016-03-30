Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:57330 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbcC3AtP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 20:49:15 -0400
Date: Wed, 30 Mar 2016 03:49:07 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 12/12] btrfs: check device for critical errors and mark
 failed
Message-ID: <20160330004907.GA8929@jeknote.loshitsa1.net>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
 <1459261349-32206-13-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459261349-32206-13-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 10:22:29PM +0800, Anand Jain wrote:
> Write and Flush errors are considered as critical errors,
> upon which the device will be brought offline and marked as
> failed. Write and Flush errors are identified using device
> error statistics.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> btrfs: check for failed device and hot replace
> 
> This patch creates casualty_kthread to check for the failed
> devices, and triggers device replace.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ctree.h   |   2 +
>  fs/btrfs/disk-io.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/disk-io.h |   2 +
>  fs/btrfs/volumes.c |   1 +
>  fs/btrfs/volumes.h |   4 ++
>  5 files changed, 169 insertions(+), 1 deletion(-)

btrfs_check_and_handle_casualty() tries to perfom auto-replacement
only once after each failure. If no hotspare was added in system before failure, only one
remaining way to replace drive is to perform replace manually. This sounds
reasonable, so just clarification: are you sure that we shouldn't start
autoreplacement if hotspare will be added after drive failure?

V1 of the patchset tried to perform autoreplace endlessly until replace
drive is added.



-- 
Yauhen Kharuzhy
