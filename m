From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Mon, 13 Feb 2012 21:31:09 -0500
Message-ID: <CALJXSJpjmb2F=fg_KML_W61gRPfiFH8Drz-H+uukn9d4owdwTg@mail.gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 6, 2012 at 9:30 AM, Ilya Dryomov <idryomov@gmail.com> wrote=
:
> This is a respin of restriper patch series which adds an initial
> implementation of restriper (it's a clever name for relocation framew=
ork
> that allows to do selective profile changing and selective balancing
> with some goodies like pausing/resuming and reporting progress to the
> user). =C2=A0See userspace cover patch for usage examples.

I just tried merging this on my kernel 3.2.1 and it seems to work
nicely. I compiled your btrfs-progs, made an LVM snapshot and launched
a balance on my 300 GB filesystem converted from ext4. It worked for
converting my metadata from single to dup, however, it didn't succeed
converting my system from single to dup.

Here is the command I used:
root /usr/src/kernel/btrfs-progs # ./btrfs balance start -f -v
-sconvert=3Ddup -mconvert=3Ddup /mnt/btrfs/
Dumping filters: flags 0xe, state 0x0, force is on
  METADATA (flags 0x100): converting, target=3D32, soft is off
  SYSTEM (flags 0x100): converting, target=3D32, soft is off
Done, had to relocate 28 out of 220 chunks

Then tried:
root /usr/src/kernel/btrfs-progs # ./btrfs balance start -f -v
-sconvert=3Ddup /mnt/btrfs/
Dumping filters: flags 0xa, state 0x0, force is on
  SYSTEM (flags 0x100): converting, target=3D32, soft is off
Done, had to relocate 0 out of 239 chunks

Before:
root /usr/src/kernel/btrfs-progs # ./btrfs fi df /mnt/btrfs/
Data: total=3D217.33GB, used=3D211.68GB
System: total=3D32.00MB, used=3D28.00KB
Metadata: total=3D19.39GB, used=3D14.18GB

And here is the result after balance:
root /usr/src/kernel/btrfs-progs # ./btrfs fi df /mnt/btrfs/
Data: total=3D226.33GB, used=3D225.56GB
System: total=3D32.00MB, used=3D36.00KB
Metadata, DUP: total=3D4.75GB, used=3D297.77MB

I also used the status command which was working correctly.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
