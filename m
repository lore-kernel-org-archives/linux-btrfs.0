From: Paul Schyska <pschyska@googlemail.com>
Subject: Re: Mount btrfs from initramfs as /
Date: Fri, 22 Aug 2008 17:04:03 +0000 (UTC)
Message-ID: <loom.20080822T165800-971@post.gmane.org>
References: <loom.20080822T144041-753@post.gmane.org> <c24352ca0808220801x69adae88s286dca6811fed2c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jeff Schroeder <jeffschroed <at> gmail.com> writes:

> You can find out the UUID with either of these commands
> # blkid /dev/sda3
> # vol_id -u /dev/sda3
> 

Thank you for this info. 
blkid shows:
/dev/sda3: UUID="59d5f4f0-b746-4147-900c-a1ca0af47c85" TYPE="xfs"
while df -T shows:
/dev/sda3    btrfs    40001848  20046168  19955680  51% /mnt/sda3

how is that possible?
Also, I just had a very odd situation where i accidentally changed fstab on
/dev/sda4 to mount /dev/sda3 as /.
The initramfs with root=/dev/sda4 then booted me to /dev/sda3 as /. However,

initramfs with root=/dev/sda4 did not boot and showed the error described above.
I think I can nail down that problem to the initramfs now ...




