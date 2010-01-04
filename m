From: Steve Freitas <sflist@ihonk.com>
Subject: Re: btrfs volume mounts and dies (was Re: Segfault in btrfsck)
Date: Sun, 03 Jan 2010 16:37:54 -0800
Message-ID: <1262565474.17096.68.camel@phat>
References: <1262476565.17096.20.camel@phat>
	 <1262559421.17096.50.camel@phat>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1262559421.17096.50.camel@phat>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-01-03 at 14:57 -0800, Steve Freitas wrote:
> Got some more information. I installed Debian on another disk ("rescue")
> running 2.6.32, pulled the latest btrfs module code from git, applied an
> earlier mentioned patch[1], then compiled and loaded the new module.
> It's able to mount the volume initially...

I've just tried it again with the pure git pull, no patch, and the
result (of an "ls -R /mnt/btrfs_vol") was the same. 'Cept this time it
never gave me a kernel traceback, just unending lines like:

Jan  3 16:36:36 rescue kernel: [ 1046.494252] parent transid verify
failed on 69140480 wanted 28342 found 29646

Steve

