Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hmm.wantstofly.org ([148.251.232.15]:53113 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbEZSC1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 14:02:27 -0400
Date: Tue, 26 May 2015 21:02:25 +0300
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
Message-ID: <20150526180225.GW11340@wantstofly.org>
References: <20150526173634.GU11340@wantstofly.org>
 <CAJCQCtRW5ZJ9J-dq_64p+vQnWsAM+Pt8eGP+NxH_SzwSAU9mpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtRW5ZJ9J-dq_64p+vQnWsAM+Pt8eGP+NxH_SzwSAU9mpg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 26, 2015 at 11:50:00AM -0600, Chris Murphy wrote:

> Before wiping I suggest making an image with btrfs-image. And then
> also see if any additional messages appear with the enospc_debug mount
> option. And also see if there's any correlation between the journald
> reported failures (the specific .journal file) and whether it's +C by
> using lsattr. Fedora 21 systemd journal files do not have +C by
> default, whereas Fedora 22 systemd journal files do use +C by default.
> So I'd expect the journal files to be a mix. Also let us know if there
> are snapshots that affect /var/log/journal (either reflink copies of
> the journal files or a snapshot of the root subvolume which contains
> /var/log/journal.

I have:

[root@foobox 5997c521ad1f4293842511a8ae54ff19]# pwd
/var/log/journal/5997c521ad1f4293842511a8ae54ff19
[root@foobox 5997c521ad1f4293842511a8ae54ff19]# lsattr
---------------C ./system@7ea3ae63cd0247cbbe8f33bfec625725-0000000000000001-0005140f825e6aa3.journal
---------------C ./user-1000@f2b557cdffd5430caff9632200741e18-00000000000007dd-0005140f840dd4e4.journal
---------------C ./user-1000@f2b557cdffd5430caff9632200741e18-0000000000019aba-0005167499cd62e4.journal
---------------C ./user-1000.journal
---------------C ./system@00000000000000000000000000000000-0000000000000000-0000000000000000.journal
---------------C ./system.journal


And I tried remounting with enospc_debug, which seems to have
succeeded:

[root@foobox ~]# cat /proc/mounts  | grep enos
/dev/dm-0 / btrfs rw,seclabel,relatime,ssd,space_cache,enospc_debug 0 0


But I still get the -ENOSPC errors:

[root@foobox ~]# cd /var/lib
[root@foobox lib]# mv abrt abrt2
mv: cannot move ‘abrt’ to ‘abrt2’: No space left on device
[root@foobox lib]#

Yet nothing is appearing in dmesg about this.


I didn't create any snapshots, and I don't think I have any.

[root@foobox ~]# btrfs subvolume list /
ID 257 gen 125768 top level 5 path root
ID 260 gen 31676 top level 257 path var/lib/machines


I think the journal thing is somewhat of a red herring, though, as lots
of I/O is returning -ENOSPC right now, not just the journal related
operations, yet only journald is syslogging the I/O errors it sees.
