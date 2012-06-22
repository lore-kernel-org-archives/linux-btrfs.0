Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:41924 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762159Ab2FVNdu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 09:33:50 -0400
Message-ID: <4FE4743B.8060306@fusionio.com>
Date: Fri, 22 Jun 2012 09:33:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] btrfs: join DEV_STATS ioctls to one
References: <1340368239-8152-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1340368239-8152-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2012 08:30 AM, David Sterba wrote:
> Hi Chris,
>
> please consider this patch for 3.5-rc before it goes final. Thanks.
>
> From: David Sterba <dsterba@suse.cz>
>
> Commit c11d2c236cc260b36 (Btrfs: add ioctl to get and reset the device
> stats) introduced two ioctls doing almost the same thing distinguished
> by just the ioctl number which encodes "do reset after read". I have
> suggested
>
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16604.html
>
> to implement it via the ioctl args. This hasn't happen, and I think we
> should use a more clean way to pass flags and should not waste ioctl
> numbers.
>

I agree, pulling into btrfs-next.  Thanks,

Josef
