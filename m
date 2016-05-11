Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32767 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbcEKUR5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 16:17:57 -0400
Subject: Re: [PATCH for 4.6] btrfs: disable a spurious WARN_ON in
 btrfs_destroy_inode.
To: Adam Borowski <kilobyte@angband.pl>, Chris Mason <clm@fb.com>,
        <linux-btrfs@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>
References: <20160510235758.3ow2wdumtisauw4n@floor.thefacebook.com>
 <20160511182514.GA6423@angband.pl> <20160511182947.GB6423@angband.pl>
CC: David Sterba <dsterba@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <f235f5f8-fe4c-d8e6-9e8d-1e4c0d829f49@fb.com>
Date: Wed, 11 May 2016 13:17:28 -0700
MIME-Version: 1.0
In-Reply-To: <20160511182947.GB6423@angband.pl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/11/2016 11:29 AM, Adam Borowski wrote:
> This happens a lot on real-world loads.  The issue is apparently benign,
> as unsaved pending checksums are moot when the ship^Winode is going down
> anyway.  Thus, no need to cause panic in users.
>
> I've retained the warning in CONFIG_BTRFS_ASSERT builds, as this shouldn't
> happen.  I've replaced the no longer helpful register+stack dump with a
> printk that mentions the device affected.
>

Chris is working on fixing the problem, and these are real issues, we 
need to not hide them behind config options.  Thanks,

Josef

