Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaENOlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 10:41:23 -0400
Message-ID: <5373808F.4020403@redhat.com>
Date: Wed, 14 May 2014 09:41:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: jshubin@redhat.com
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <5373803E.9000406@libero.it>
In-Reply-To: <5373803E.9000406@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/14/14, 9:39 AM, Goffredo Baroncelli wrote:
> Hi Eric,
> 
> On 05/14/2014 03:18 AM, Eric Sandeen wrote:
>> Allow the specification of the filesystem UUID at mkfs time.
> 
> I suggest to add some warning when this options is used, because the
> behavior could be very different than the one expected.
> 
> I suspect that BTRFS tracks the filesystem by UUID and not by
> devices. When two filesystems have the same UUID at the same time, it
> may mount the wrong one.

Well, of course if you explicitly create two "universally unique identifiers"
which are not actually unique, you can shoot yourself in the foot.

"Here's enough rope to hang yourself with" is a proud tradition in
the Unix world.  ;)

> $ #
> $ # Make two *different* filesystems with the *same* UUID
> $ #
> $ UUID=e285c9bd-ea97-40b3-ad7d-8713dcfd5eea
> $ sudo ./mkfs.btrfs -f -U $UUID /dev/vdg
> $ sudo ./mkfs.btrfs -f -U $UUID /dev/vdh
> 
> $ #
> $ # from the beginning "btrfs fi show" reports wrong information
> $ #
> $ sudo btrfs fi show
> Label: none  uuid: e285c9bd-ea97-40b3-ad7d-8713dcfd5eea
> 	Total devices 1 FS bytes used 96.00KB
> 	devid    1 size 50.00GB used 4.00MB path /dev/vdh
> 	devid    1 size 50.00GB used 2.04GB path /dev/vdg
> 
> $ #
> $ # mount the first one, create a new file then un-mount it
> $ #
> $ sudo mount /dev/vdg /mnt/btrfs1
> $ sudo touch /mnt/btrfs1/dev-vdg
> $ sudo umount /dev/vdg
> 
> $ #
> $ # mount the second one, it should be empty
> $ # instead btrfs mount the first one
> $ #
> $ sudo mount /dev/vdh /mnt/btrfs2
> $ ls -l /mnt/btrfs2
> total 0
> -rw-r--r-- 1 root root 0 May 14 16:12 dev-vdg

o_O ok, that's a little unexpected.

> 
> I am not against this option; I am suggesting to add a explicit
> warning to the user about the risk of doing that, both on the man
> pages and into the program. The warning should say that this option
> is only for testing. Better ask for a confirmation (even with an
> undocumented switch like
> '--I-know-that-I-am-doing-something-really-dangerous').

meh.  ext4 and xfs have had the ability to either set or change the
UUID for years, and I've not heard of any horror stories.

> 
> For the record, BTRFS seems unable to mount at the same time two different filesystems with the same UUID:
> 
> $ #
> $ # try to mount two fs with the same UUID, but BTRFS doesn't allow it
> $ #
> $ sudo mount /dev/vdh /mnt/btrfs2
> $ sudo mount /dev/vdg /mnt/btrfs1
> ERROR: mount failed : 16 - Device or resource busy

(presumably the kernel said something, too?)

and this seems to make it even more safe.

-Eric

> 
> BR
> G.Baroncelli
> 

