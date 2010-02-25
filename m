From: Leszek Ciesielski <skolima@gmail.com>
Subject: btrfs no csum found for inode X start 0
Date: Thu, 25 Feb 2010 10:34:22 +0100
Message-ID: <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
References: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

(My previous post seems to have been discarded because of the
attachment size, I'm resending it without the dmesg output - which can
be found @ http://pastebin.com/T0J3z59j )

Hi,

yesterday I updated my kernel (clean clone from
mason/btrfs-unstable.gi), pulling in the single latest change I have
been missing ( http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=3f6fae9559225741c91f1320090b285da1413290
) and adding my patch from http://patchwork.kernel.org/patch/81547/ .
Previous kernel version (without my patch - could this be my fault?)
has been running fine for 14 days, but after recompiling and
rebooting, my dmesg output is full of "btrfs no csum found for inode
386 start 0" and "btrfs csum failed ino 386 extent 65191274496 csum
1851253866 wanted 0 mirror 1" and "btrfs csum failed ino 82619 off
8749056 csum 2686054019 private 0", repeating with different values.
Also, accessing pretty much any file ends with "read error" - only
small text files remained readable. Newly written files seem to behave
correctly. I have tried reverting back to the version from 10.02.2010
(last change on 04.02, without my patch) that worked well before, but
now it also spits out the same errors and files remain unreadable.
Dmesg output is attached. Anything more I can do to help diagnose the
problem?

Regards,

Leszek 'skolima' Ciesielski
