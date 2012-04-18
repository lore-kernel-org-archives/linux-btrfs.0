From: David Sterba <dave@jikos.cz>
Subject: Re: segmentation fault while running btrfsck
Date: Wed, 18 Apr 2012 11:50:16 +0200
Message-ID: <20120418095016.GF20982@twin.jikos.cz>
References: <CAH55dvMzcduXnvrGP03cG=mJP7CwJm6mMCv2A3FVR8Rb_GaSNA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nicholas Tung <gatoatigrado@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAH55dvMzcduXnvrGP03cG=mJP7CwJm6mMCv2A3FVR8Rb_GaSNA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2012 at 01:34:48AM -0700, Nicholas Tung wrote:
>     One of my btrfs volumes got corrupted, and seems to be
> unrecoverable. When I tried to run a recent version of btrfsck (built
> from git), it crashed with a segmentation fault. I have a file
> containing the first 8 GB (copied with "dd if=/dev/sda5 ..."), which
> seems to reproduce the segmentation fault when using the btrfsck tool.
> [...]
> http://pastebin.com/3txgBn71 .

I've seen the same error, caused probably same problems according to
what you write below. I had a raid1 (data/metadata) filesystem on top of
a few disks and added a new one. After a while of balance running I saw
tons of errors in syslog like

[ 3402.240402] sd 9:0:1:0: [sde] Unhandled error code
[ 3402.240404] sd 9:0:1:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 3402.240406] sd 9:0:1:0: [sde] CDB: Read(10): 28 00 06 6e 59 40 00 00 08 00
[ 3402.240409] end_request: I/O error, dev sde, sector 107895104

I had to reboot the machine, and after running fsck I saw messages like
in your log:

Check tree block failed, want=2327687168, have=0

where the 'want' sector numbers matched the ones from syslog. And after
a while segfault. I was more interested to see how scrub and automatic
repair would work, so I did not dig deeper. (Yeah, scrub repaired the
blocks and I was able to remove the device from the set again.)

Looking to your logs again,

parent transid verify failed on 2327711744 wanted 2488 found 464

I did not see any of these in my fsck output, guessing from the
wanted/found numbers, it's a lost write on the device.

* What kernel did you run at that time? (3.2 or older)
* How many disks and what raid profile did you use?

[...]
> A final note: the corruption of my partition was likely
> due to some hardware instability problems -- it could either be
> related to the SATA controller (some of the earlier Intel H67 Sandy
> Bridge motherboards like mine had issues), bad SATA cables, or new SSD
> (though, I ran badblocks, and it seemed okay ... and very fast, yay!).
> The disk would unmount, and wouldn't be recognized by the motherboard
> until I left the system off for a while.

I'm blaming the SATA port/cable combo on my side, two different disks
exhibited the same problems there, while ok in another.


thanks,
david
