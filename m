Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57320 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3AUBj6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 20:39:58 -0500
Received: by mail-ee0-f49.google.com with SMTP id d4so2572495eek.8
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 17:39:57 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Jan 2013 17:39:57 -0800
Message-ID: <CAEm3SNAW-oGtPQ5Fjf4P0qEeMU29MA8frnNekGfSQ3rWCLSvsw@mail.gmail.com>
Subject: A couple bugs with btrfs and 3.5.0 kernel
From: Elladan <elladan@eskimo.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I upgraded to Ubuntu 12.10 and thought, "Hey, that 3.5 kernel is
relatively recent.  And they seem to finally have implemented
restriping.  Maybe it's time to try btrfs again!"

So, first off, I backed up all my data.

Next, I decided I would attempt to use btrfs's features for my benefit.

Specifically (this part is less interesting except as setup):

1. I put a btrfs filesystem on top of dm-crypt on an external USB drive.
2. I copied data to it.
3. I unmounted the original partition, and then immediately mounted
the btrfs partition in its place.

Ok, now to the interesting bits:

My goal here is to delete the usb device and just leave myself with my
data, migrated back to the internal disk (with minimal downtime)

So, I figured I could use restriping/device delete to live-migrate
back onto the internal hard disk.

4. I did a btrfs device add on a partition (over lvm/dm-crypt) on the
internal disk.  Now I have 2 partitons in the fs.

I attempted to btrfs device delete the usb disk, and it errored out
(with somewhat inscrutable information) telling me that I can't reduce
raid1 to dup this way.

Note: Arguably, this is a bug.  You really ought to do it, but with a
-f option, and automatically reduce the chunks appropriately.

Note: Also arguably, this is also a bug because it should not have
changed the metadata profile from dup to raid1 without asking me.
Maybe I don't want raid1.

Anyway, I figure I can fix this up with a balance filter (this is
primarily what made me think btrfs might be more usable now).

6. I attempt to balance with a filter -mconvert=dup.  This immediately
errors out with no real indication as to why.

In the dmesg log I found:

[52656.153908] btrfs: unable to start balance with target metadata profile 32

Clearly a bug.

7. After some random trial and error, I find that it accepts
-mconvert=single, and the result appears to be metadata in dup state.
Maybe.

Ok now that's done, it's time to delete.

8. btrfs device delete /dev/dm-11 /btrfs

Some hours later, it fails.  I find stuff like this all over my dmesg log:

[113936.300109] bio too big device dm-11 (1024 > 240)
[113936.297242] btrfs: bdev /dev/dm-11 errs: wr 101, rd 10247, flush
0, corrupt 109, gen 0
[113935.425960] btrfs_dev_stat_print_on_error: 38 callbacks suppressed

It also found 2 files with csum errors, which were left on the USB device.

[92750.052638] btrfs csum failed ino 257 off 49278976 csum 948519347
private 2127080388
[95692.348662] btrfs: checksum error at logical 94682349568 on dev
/dev/mapper/tempusb, sector 224788736, root 256, inode 114815, offset
14360576, length 4096, links 1 (path:...path to file)

The csum errors appeared to have caused it to stop.

Googling around seemed to indicate that someone had once experienced a
similar problem with an external drive around the 3.0 kernel era.
They suggested something about the filesystem not working when dealing
with devices mixed between SATA and USB, which sounded a bit wacky to
me.  I initially assumed that maybe the USB drive was a bit flaky, but
this sounds to me like the csum errors were probably btrfs causing
silent corruption.

I tried deleting the files with the csum errors and running the device
delete again, but it immediately failed with invalid argument errors
and nothing in the dmesg log.  Clearly a bug.

Then, I tried unmounting, remounting, and then re-running the delete.
This time it started, but it's been running for a long time and
spamming my kernel logs with the bio too big for device errors.  I'm
guessing I'll probably need to sysrq reboot or something.

This is with Ubuntu's standard 3.5.0-22 generic kernel.

Any ideas?  I guess I could try to mount in degraded mode or try a 3.6
kernel or something, but this all seems like I should probably just
restore from backups and move on.

Thanks!
