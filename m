Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:33042 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754593AbdEIRXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 13:23:21 -0400
Date: Tue, 9 May 2017 22:23:18 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: "corrupt leaf, invalid item offset size pair"
Message-ID: <20170509222318.1ccbba3a@natsu>
In-Reply-To: <CANznX5FbxnO66uqA=UK7h-f5MbnCR0zDMs6iYfyYidPZ7MyU9Q@mail.gmail.com>
References: <20170508095820.633970a3@natsu>
        <CANznX5FbxnO66uqA=UK7h-f5MbnCR0zDMs6iYfyYidPZ7MyU9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 8 May 2017 20:05:44 +0200
"Janos Toth F." <toth.f.janos@gmail.com> wrote:

> May be someone more talented will be able to assist you but in my
> experience this kind of damage is fatal in practice (even if you could
> theoretically fix it, it's probably easier to recreate the fs and
> restore the content from backup, or use the rescue tool to save some
> of the old content which you never had copies from and restore that).
> I think the problem is that the disturbed disk gets out of sync
> (obviously, it misses some queued/buffered writes) from the rest of
> the fs/disk(s) but later gets accepted back like it's in a perfectly
> fine state (and/or Btrfs is ready to deal with problems like this,
> though it looks like it is not), and then some fatal corruption starts
> developing (due to the problematic disk being treated like it has
> correct data, even though it has some errors). If you have it mounted
> RW long enough, it will probably get worse and gets unmountable at
> some point (and thus harder, if not impossible to rescure any data).
> This is how I usually lost my RAID-5 mode Btrfs filesystems before I
> stopped experimenting with that. I never had this problem since I
> disabled SATA HotPlug (in the firmware setup of the motherboard) and
> switched to RAID-10 mode (and eventually replaced both faulty SATA
> cables in the system, one at a time after an incident...).

Yeah I scrapped the FS and now restoring from backups.  For some of the stuff
that wasn't backed up, "btrfs restore" worked remarkably well.

This was my primary 9x2TB mdadm RAID6 with Btrfs on top. But after all, it
appears to be too risky to run all storage as a huge SPOF like that. And
since I had almost everything backed up elsewhere, there's seems to be little
justification for the protections of RAID6 (the machine does not need 100.00%
uptime and does not even have hot-swap drive bays).

So I will now switch to using individual drives with single-device Btrfs on
each, joined for convenience with mhddfs/unionfs/aufs on the directory tree
level.

-- 
With respect,
Roman
