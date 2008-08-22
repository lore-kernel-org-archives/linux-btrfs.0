From: Paul Schyska <pschyska@googlemail.com>
Subject: Re: Mount btrfs from initramfs as /
Date: Fri, 22 Aug 2008 17:17:40 +0000 (UTC)
Message-ID: <loom.20080822T171408-225@post.gmane.org>
References: <loom.20080822T144041-753@post.gmane.org> <c24352ca0808220801x69adae88s286dca6811fed2c4@mail.gmail.com> <loom.20080822T165800-971@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Paul Schyska <pschyska <at> googlemail.com> writes:

> 
> Jeff Schroeder <jeffschroed <at> gmail.com> writes:
> 
> > You can find out the UUID with either of these commands
> > # blkid /dev/sda3
> > # vol_id -u /dev/sda3
> > 
> 
> Thank you for this info. 
> blkid shows:
> /dev/sda3: UUID="59d5f4f0-b746-4147-900c-a1ca0af47c85" TYPE="xfs"
> while df -T shows:
> /dev/sda3    btrfs    40001848  20046168  19955680  51% /mnt/sda3
> 
> how is that possible?

OK, it seems that i got some kind of cached information there. xfs was the fs
type before i remorfatted to btrfs.
After doing vol_id -u /dev/sda3 as root it shows
/dev/sda3: unknown volume type
and since then sudo blkid /dev/sda3
shows an empty line.
Also, blkid /dev/sda4 showed nothing befor but after
sudo vol_id -u /dev/sda4
sudo blkid /dev/sda4 show the correct:
/dev/sda4: UUID="0a7a1695-2e80-486c-ba38-f8d4598cb28b" TYPE="reiser4" 





