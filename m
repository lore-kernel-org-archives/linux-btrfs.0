Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58672 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbC3WkI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 18:40:08 -0400
Date: Mon, 30 Mar 2015 15:45:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs on top of LUKS (dm-crypt)
Message-ID: <20150330224526.GA32166@merlins.org>
References: <CAA7pwKM9WoGy0JbOfnLc9ifACcZMxbAan4XJqAMcqnfV-cWKtA@mail.gmail.com> <20150114224406.GO13806@merlins.org> <CAJCQCtS2n=dbncq5g+ZOEajqz1ykstefBvfECXiLQxxOTZbyCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtS2n=dbncq5g+ZOEajqz1ykstefBvfECXiLQxxOTZbyCw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 05:09:28PM -0700, Chris Murphy wrote:
> Following the trail backward leads to this one
> http://wiki.drewhess.com/wiki/Creating_an_encrypted_filesystem_on_a_partition
> 
> Which has a subheading "md RAID array" that starts out:
> 
> "If the device to be encrypted is an md RAID array..."
> 
> This is referring to encrypting the array, not the individual member
> physical devices. We can't encrypt a Btrfs array with dmcrypt we'd
> need to use ecryptfs or an encrypted raw file mounted as a loop
> device. We can only encrypt member devices, and then use them to
> create a Btrfs volume. So this option isn't applicable as it's
> described.
> 
> Further, man 8 cryptsetup tells us that "If not specified, cryptsetup
> tries to use topology info provided by kernel for underlying device to
> get optimal alignment..." so we don't need to use the option unless
> there's something we know for sure that the kernel doesn't know. For
> quite a while dm understands what info to supply upstream so for
> instance if you use md raid then LVM to create an LV, and then encrypt
> the LV, and then mkfs.xfs you'll see that mkfs.xfs automatically sets
> sunit swidth correctly, it doesn't use the single drive defaults.

Yeah, sorry for replying soo late.

So now I remember what went on.
See
http://wiki.drewhess.com/wiki/Creating_an_encrypted_filesystem_on_a_partition#md_RAID_array
and
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/34837
" What I was trying to do there is avoid write amplification.
I went with
mdadm --create /dev/md8 --level=5 --raid-devices=5 /dev/sd[abdef]1
--chunk=256 --bitmap=/boot/bitmap-md8
which I believe required me to use
cryptsetup luksFormat --align-payload=1024 -s 256 -c aes-xts-plain64
/dev/md8
(that was with 5 drives, or 4 drives with data).

If so, for 4K sector sizes, if we have to use align-payload=1024, in
turn I'd have to use --chunk=512."

The point was to diminish write amplification as much as possible
because I was having severe latency problems on hard drives.

The defaults will give you proper alignment but end up with a raid chunk
size as small as possible, which in turn means reducing the align payload
value to match.

It's not necessary to do this, but you should get better latency as a
result.

Hope that makes sense.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
