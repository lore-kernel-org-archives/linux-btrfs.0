Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39050 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754183AbcEQBCw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 21:02:52 -0400
Date: Mon, 16 May 2016 21:02:43 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.7
Message-ID: <20160517010243.5fwcohgejrifnqsh@floor.thefacebook.com>
References: <cover.1463406792.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <cover.1463406792.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 16, 2016 at 04:14:23PM +0200, David Sterba wrote:
> Hi,
> 
> please queue the following branch to 4.7.
> 
> New features or user-visible changes:
> * device delete by id, a v2 ioctl for device deletion (this was held back from
>   4.6 pull due to possibly related crashes that haven't appeared for a long
>   time)
> * DUP allowed on multiple-device filesystem (help in case we want to go to
>   SINGLE from RAID1/.. but do not want to lose all redundancy while converting)
> * GETFLAGS/SETFLAGS/GETVERSION ioctls work on 32bit
> 
> Developer-visible changes:
> * definitions that are shared with userspace are moved to the uapi directory
> 
> Other:
> * assorted bugfixes and cleanups
> 
> The branch is merged from several topic branches, grouped by functionality
> or purpose. The patches have been in for-next, most of them for a few weeks at
> least, tested together with Filipe's branch.

Great, thanks Dave!  I've got things merged up and I'm running more
tests.

-chris
