Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51208 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbaEJINU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 04:13:20 -0400
Date: Sat, 10 May 2014 01:13:25 -0700
From: David Brown <davidb@davidb.org>
To: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0rc3: did not find backref in send_root
Message-ID: <20140510081325.GA25002@davidb.org>
References: <20140225063652.GD3521@merlins.org>
 <20140506061053.GA17689@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20140506061053.GA17689@davidb.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 11:10:54PM -0700, David Brown wrote:
>On Mon, Feb 24, 2014 at 10:36:52PM -0800, Marc MERLIN wrote:
>>I got this during a btrfs send:
>>BTRFS error (device dm-2): did not find backref in send_root. inode=22672, offset=524288, disk_byte=1490517954560 found extent=1490517954560
>>
>>I'll try a scrub when I've finished my backup, but is there anything I
>>can run on the file I've found from the inode?
>>
>>gargamel:/mnt/dshelf1/Sound# btrfs inspect-internal inode-resolve  -v 22672 file.mp3
>>ioctl ret=0, bytes_left=3998, bytes_missing=0, cnt=1, missed=0
>>file.mp3
>
>I've just seen this error:
>
>  BTRFS error (device sda4): did not find backref in send_root. inode=411890, offset=307200, disk_byte=48100618240 found extent=48100618240
>
>during a send between two snapshots I have.
>
>after moving to 3.14.2.  I've seen it on two filesystems now since
>moving to 3.14.  I have the two readonly snapshots if there is
>anything helpful I can figure out from them.

After bisecting it seems to be caused by

    commit 7ef81ac86c8a44ab9f4e6e04e1f4c9ea53615b8a
    Author: Josef Bacik <jbacik@fb.com>
    Date:   Fri Jan 24 14:05:42 2014 -0500

        Btrfs: only process as many file extents as there are refs

        The backref walking code will search down to the key it is looking for and then
        proceed to walk _all_ of the extents on the file until it hits the end.  This is
        suboptimal with large files, we only need to look for as many extents as we have
        references for that inode.  I have a testcase that creates a randomly written 4
        gig file and before this patch it took 6min 30sec to do the initial send, with
        this patch it takes 2min 30sec to do the intial send.  Thanks,

        Signed-off-by: Josef Bacik <jbacik@fb.com>
        Signed-off-by: Chris Mason <clm@fb.com>

This appears to be fixed in 3.15-rc5, but I wonder if either the extra
fixes, or a revert of the above should be applied to 3.14 stable?

David
