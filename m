Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9889 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbaBCSRP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:17:15 -0500
Message-ID: <52EFDD80.4050800@fb.com>
Date: Mon, 3 Feb 2014 13:18:40 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
References: <52EAC9B6.7090603@fb.com> <20140203175405.GL1364@twin.jikos.cz>
In-Reply-To: <20140203175405.GL1364@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon 03 Feb 2014 12:54:05 PM EST, David Sterba wrote:
> On Thu, Jan 30, 2014 at 04:52:54PM -0500, Chris Mason wrote:
>> Chris Mason (3) commits (+64/-32):
>>      Btrfs: setup inode location during btrfs_init_inode_locked (+9/-9)
>>      Btrfs: don't use ram_bytes for uncompressed inline items (+52/-22)
>
> The patches are CC: stable, but haven't gone through the mailinglist.
> Are they still going to be picked by stable?

We do need both in -stable, I'll help with backports.

-chris

