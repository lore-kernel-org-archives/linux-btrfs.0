Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35227 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbcDFXIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 19:08:13 -0400
Received: by mail-io0-f179.google.com with SMTP id g185so74406998ioa.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 16:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
Date: Wed, 6 Apr 2016 17:08:12 -0600
Message-ID: <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Chris Murphy <lists@colorremedies.com>
To: Ank Ular <ankular.anime@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 6, 2016 at 9:34 AM, Ank Ular <ankular.anime@gmail.com> wrote:

>
> From the ouput of 'dmesg', the section:
> [   20.998071] BTRFS: device label FSgyroA devid 9 transid 625039 /dev/sdm
> [   20.999984] BTRFS: device label FSgyroA devid 10 transid 625039 /dev/sdn
> [   21.004127] BTRFS: device label FSgyroA devid 11 transid 625039 /dev/sds
> [   21.011808] BTRFS: device label FSgyroA devid 12 transid 625039 /dev/sdu
>
> bothers me because the transid value of these four devices doesn't
> match the other 16 devices in the pool {should be 625065}. In theory,
> I believe these should all have the same transid value. These four
> devices are all on a single USB 3.0 port and this is the link I
> believe went down and came back up.

This is effectively a 4 disk failure and raid6 only allows for 2.

Now, a valid complaint is that as soon as Btrfs is seeing write
failures for 3 devices, it needs to go read-only. Specifically, it
would go read only upon 3 or more write errors affecting a single full
raid stripe (data and parity strips combined); and that's because such
a write is fully failed.

Now, maybe there's a way to just retry that stripe? During heavy
writing, there are probably multiple stripes in flight. But in real
short order the file system I think needs to face plant (read only or
even a graceful crash) is better than continuing to write to n-4
drives which is a bunch of bogus data, in effect.

I'm gonna guess the superblock on all the surviving drives is wrong,
because it sounds like the file system didn't immediately go read only
when the four drives vanished?

However, there is probably really valuable information in the
superblocks of the failed devices. The file system should be
consistent as of the generation on those missing devices. If there's a
way to roll back the file system to those supers, including using
their trees, then it should be possible to get the file system back -
while accepting 100% data loss between generation 625039 and 625065.
That's already 100% data loss anyway, if it was still doing n-4 device
writes - those are bogus generations.

Since this is entirely COW, nothing should be lost. All the data
necessary to go back to generation 625039 is on all drives. And none
of the data after that is usable anyway. Possibly even 625038 is the
last good one on every single drive.

So what you should try to do is get supers on every drive. There are
three super blocks per drive. And there are four backups per super. So
that's potentially 12 slots per drive times 20 drives. That's a lot of
data for you to look through but that's what you have to do. The top
task would be to see if the three supers are the same on each device,
if so, then that cuts the comparison down by 1/3. And then compare the
supers across devices. You can get this with btrfs-show-super -fa.

You might look in another thread about how to setup an overlay for 16
of the 20 drives; making certain you obfuscate the volume UUID of the
original, only allowing that UUID to appear via the overlay (of the
same volume+device UUID appear to the kernel, e.g. using LVM snapshots
of either thick or thin variety and making both visible and then
trying to mount one of them). Others have done this I think remotely
to make sure the local system only sees the overlay devices. Anyway,
this allows you to make destructive changes non-destructively. What I
can't tell you off hand is if any of the tools will let you
specifically accept the superblocks from the four "good" devices that
went offline abruptly, and adapt them to to the other 16, i.e. rolling
back the 16 that went too far forward without the other 4. Make sense?

Note. You can't exactly copy the super block from one device to
another because it contains a dev UUID. So first you need to look at a
superblock for any two of the four "good" devices, and compare them.
Exactly how  do they differ? They should only differ witih
dev_item.devid, dev_item.uuid, and maybe dev_item.total_bytes and
hopefully not but maybe dev_item.bytes_used. And then somehow adapt
this for the other 16 drives. I'd love it if there's a tool that does
this, maybe 'btrfs rescue super-recover' but there are no meaningful
options with that command so I'm skeptical how it knows what's bad and
what's good.

You literally might have to splice superblocks and write them to 16
drives in exactly 3 locations per drive (well, maybe just one of them,
and then delete the magic from the other two, and then 'btrfs rescue
super-recover' should then use the one good copy to fix the two bad
copies).

Sigh.... maybe?

In theory it's possible, I just don't know the state of the tools. But
I'm fairly sure the best chance of recovery is going to be on the 4
drives that abruptly vanished.  Their supers will be mostly correct or
close to it: and that's what has all the roots in it: tree, fs, chunk,
extent and csum. And all of those states are better farther in the
past, rather than the 16 drives that have much newer writes.

Of course it is possible there's corruption problems with those four
drives having vanished while writes were incomplete. But if you're
lucky, data write happen first, then metadata writes second, and only
then is the super updated. So the super should point to valid metadata
and that should point to valid data. If that order is wrong, then it's
bad news and you have to look at backup roots. But *if* you get all
the supers correct and on the same page, you can access the backup
roots by using -o recovery if corruption is found with a normal mount.





-- 
Chris Murphy
