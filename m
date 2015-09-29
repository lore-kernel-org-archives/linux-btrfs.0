Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbbI2Idh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 04:33:37 -0400
MIME-Version: 1.0
In-Reply-To: <20150929035411.GE30949@dhcp-13-216.nay.redhat.com>
References: <1443267613-9453-1-git-send-email-fdmanana@kernel.org>
	<20150929035411.GE30949@dhcp-13-216.nay.redhat.com>
Date: Tue, 29 Sep 2015 09:33:34 +0100
Message-ID: <CAL3q7H4w_f3N+s4xzN-v13h=nD2Wgm7+YYgswwRZJub-VEGfDQ@mail.gmail.com>
Subject: Re: [PATCH] fstests: test for btrfs incremental send after replacing
 a file
From: Filipe Manana <fdmanana@kernel.org>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>, Martin Raiber <martin@urbackup.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 4:54 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Sat, Sep 26, 2015 at 12:40:13PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Test that an incremental send works after a file from the parent snapshot
>> gets replaced in the send snapshot by another one at the same exact
>> location, with the same name and with the same inode number.
>>
>> This test used to fail after the linux kernel commit 8b191a684968
>> ("Btrfs: incremental send, check if orphanized dir inode needs delayed
>> rename") and it's fixed by patch titled:
>>
>>   "Btrfs: send, fix corner case for reference overwrite detection"
>
> I got "btrfs receive" error when testing this, with 4.3-rc1 kernel and
> btrfs-progs v4.2, not sure if this is expected

Yes, it's expected.
The fix isn't yet in any kernel release (nor rc).

thanks

>
> At subvol /mnt/testarea/scratch/mysnap2_ro
> # /usr/bin/btrfs receive /mnt/testarea/scratch -f /mnt/testarea/test/btrfs-test-104/1.snap
> At subvol mysnap1
> # /usr/bin/btrfs receive /mnt/testarea/scratch -f /mnt/testarea/test/btrfs-test-104/2.snap
> ERROR: unlink o258-7-0 failed. No such file or directory
> At snapshot mysnap2_ro
> failed: '/usr/bin/btrfs receive /mnt/testarea/scratch -f /mnt/testarea/test/btrfs-test-104/2.snap'
>
> Thanks,
> Eryu
