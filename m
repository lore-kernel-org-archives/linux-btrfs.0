Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50310 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3FTKW1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 06:22:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Upc0X-0001Qh-OA
	for linux-btrfs@vger.kernel.org; Thu, 20 Jun 2013 12:22:25 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:22:25 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:22:25 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Date: Thu, 20 Jun 2013 10:22:07 +0000 (UTC)
Message-ID: <kpul4f$ei7$1@ger.gmane.org>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
	<20130620091622.GL11290@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Jun 2013 10:16:22 +0100, Hugo Mills wrote:
> On Thu, Jun 20, 2013 at 10:47:53AM +0200, Clemens Eisserer wrote:
>> Hi,
>> 
>> I've observed a rather strange behaviour while trying to mount two
>> identical copies of the same image to different mount points.
>> Each modification to one image is also performed in the second one.

>> touch m2/hello
>> ls -la m1  //will now also include a file calles "hello"
>> 
>> Is this behaviour intentional and known or should I create a bug-report?
> 
>    It's known, and not desired behaviour. The problem is that you've
> ended up with two filesystems with the same UUID, and the FS code gets
> rather confused about that. The same problem exists with LVM snapshots
> (or other block-device-layer copies).
> 
>    The solution is a combination of a tool to scan an image and change
> the UUID (offline), and of some code in the kernel that detects when
> it's being told about a duplicate image (rather than an additional
> device in the same FS). Neither of these has been written yet, I'm
> afraid.

To clarify, the loop devices are properly distinct, but the first
device ends up mounted twice.

I've had a look at the vfs code, and it doesn't seem to be uuid-aware,
which makes sense because the uuid is a property of the superblock and
the fs structure doesn't expose it.  It's a Btrfs problem.

Instead of redirecting to a different block device, Btrfs could and
should refuse to mount an already-mounted superblock when the block
device doesn't match, somewhere in or below btrfs_mount.  Registering
extra, distinct superblocks for an already mounted raid is a different
matter, but that isn't done through the mount syscall anyway.

>> I've deleted quite a bunch of files on my production system because of this...
> 
>    Oops. I'm sorry to hear that. :(
> 
>    Hugo.


