From: David Sterba <dave@jikos.cz>
Subject: Re: scrub: Inappropriate ioctl for device
Date: Wed, 2 Nov 2011 13:55:59 +0100
Message-ID: <20111102125559.GJ12759@twin.jikos.cz>
References: <Bx1FpyLi1uB@helmut.hullen.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bx1FpyLi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 08:36:00PM +0100, Helmut Hullen wrote:
> The bundle uses the devices /dev/sdb1, /dev/sdc1 and /dev/sdg1, "btrfs  
> filesystem show" shows these informations.
> 
> Mounting doesn't work immediately; most times I have to run the "mount"  
> command three times - strange.

I observed failed mounts between 2 consecutive xfstests (random two, no
pattern) while the umount/mount went just fine when I tried it manually.
IIRC it was in 3.1-rc9 and one of Josef's branches, but I haven't seen
it since and was not able to reproduce it reliably.

> Changing the rights of "/dev/sdb1" to 660 doesn't help - same nasty  
> behaviour.

I think it's not a problem from the userspace side (like access rights)
but some unfinished device cleanup from the previous umount which blocks
new mount.


david
