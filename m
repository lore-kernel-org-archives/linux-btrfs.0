From: Joel Pearson <japearson@agiledigital.com.au>
Subject: Fwd: btrfs causing reboots and kernel oops on SL 6 (RHEL 6)
Date: Sat, 4 Jun 2011 14:33:02 +1000
Message-ID: <BANLkTimHUcOpSGfWKtAcTMGnZ5Gr41jrzw@mail.gmail.com>
References: <BANLkTinjKR0PwvL0pcseP7ReEeSOUpObBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinjKR0PwvL0pcseP7ReEeSOUpObBQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using SL 6 (RHEL 6) and I've been playing around with running
PostgreSQL on btrfs. Snapshotting works ok, but the computer keeps
rebooting without warning (can be 5 mins or 1.5 hours), finally I
actually managed to get a Kernel Crash instead of just a reboot.

I took a picture of the screen:
http://imageshack.us/photo/my-images/716/img0143y.jpg/

The important bits are:

IP: [<ffffffffa032c471>] btrfs_print_leaf +0x31/0x820 [btrfs]
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/dm-3/dm/name

The crashes aren't predictable either. Like it doesn't always happen
when I do a snapshot or anything like that.

Is this a known problem, that is fixed in a later kernel or something l=
ike that?

btrfs seems cool though, I hope there is something I just
misconfigured=A0or something so that I can get it to be more reliable,
although I do acknowledge that this is an experimental filesystem.

Cheers,

-Joel

--
Joel Pearson
Software Engineer
Agile Digital Engineering Pty Ltd
A.B.N. 98 106 361 273
A: 5/28 Eyre St Kingston ACT 2604
P: +61 1300-858-277
=46: +61 1300-858-477
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
