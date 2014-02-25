Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42440 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbaBYHwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 02:52:14 -0500
Message-ID: <530C4B37.9000402@cn.fujitsu.com>
Date: Tue, 25 Feb 2014 15:50:15 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0rc3: did not find backref in send_root
References: <20140225063652.GD3521@merlins.org>
In-Reply-To: <20140225063652.GD3521@merlins.org>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

This seems a regression which has been fixed by the following
commit(only pushed into btrfs-next):

https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=1334bebe71bebbca47b3b92f25511ea980fdeab8

Thanks,
Wang

On 02/25/2014 02:36 PM, Marc MERLIN wrote:
> I got this during a btrfs send:
> BTRFS error (device dm-2): did not find backref in send_root. inode=22672, offset=524288, disk_byte=1490517954560 found extent=1490517954560
>
> I'll try a scrub when I've finished my backup, but is there anything I
> can run on the file I've found from the inode?
>
> gargamel:/mnt/dshelf1/Sound# btrfs inspect-internal inode-resolve  -v 22672 file.mp3
> ioctl ret=0, bytes_left=3998, bytes_missing=0, cnt=1, missed=0
> file.mp3
>
> Anything else?
>
> Thanks,
> Marc

