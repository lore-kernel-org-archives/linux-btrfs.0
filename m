Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:34628 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbcFBWMW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 18:12:22 -0400
Received: by mail-vk0-f45.google.com with SMTP id c189so90792029vkb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 15:12:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC-H7HkWiTD5HYXoTuqW4rEhYSXr9xnp1xk6aZ51F_yhQ--CYw@mail.gmail.com>
References: <CAC-H7HkWiTD5HYXoTuqW4rEhYSXr9xnp1xk6aZ51F_yhQ--CYw@mail.gmail.com>
Date: Fri, 3 Jun 2016 00:12:20 +0200
Message-ID: <CAPmG0jbJbUzi+1UbXgp1i_J_ZhHHQH-J9hoOjqxepa9BsXeTwQ@mail.gmail.com>
Subject: Re: [BUG] receive not seeing file that exists
From: Henk Slager <eye1tm@gmail.com>
To: Benedikt Morbach <benedikt.morbach@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2016 at 9:26 AM, Benedikt Morbach
<benedikt.morbach@googlemail.com> wrote:
> Hi all,
>
> I've encountered a bug in btrfs-receive. When receiving a certain
> incremental send, it will error with:
>
>     ERROR: cannot open
> backup/detritus/root/root.20160524T1800/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b/user-1000.journal:
> No such file or directory
>
> even though that path exists and the parent subvolume is identical on
> both ends (I checked manually).
>
> I've noticed this happen before on the same directory (and google
> confirms it has also happened to others) and /var/log/journal/ and its
> children are the only directories with 'chattr +C' on this system, so
> it might be related to that?

Now that I see this report, I realize that I also hit this issue. I
was compiling a kernel with 'make -j4 all'. Under some circumstances,
this leads to 'package temp too high' and throtlling speed of CPU;
with -j1 or -j2 I haven't seen it (root cause is the power supply I
think).

Anyhow, while this compile was running, my nightly snapshotting and
incremental send|receive was started. I saw a mce HW error in kernel
log also at that point, so I did restart. Also the inc send had failed
so I thought, it was due to mce issue. But also with no mce-HW issues
logged, tools-4.5.3 + kernel-4.5.4 and also tools-4.5.3 + kernel-4.6.0
had the same issue.

I run send and receive on same PC in this case, but splitting the
stream to a file in addition. The file was already corrupt (too short)
I noticed, so I concluded the issue was in send. I set up a hourly
extra backup crontask for this problem subvol and it failed almost
every hour. For another subvolume on the new 3-day young fs, it was
not a problem. The fs is a few TB, has default mkfs settings +noholes.
Nodesize increased from 4k to 16k, that was a reason to re-create it.

For the problem subvol and also others that I do not inc backup, I set
the subvol to ro on old fs, send the stream-file to temp storage,
received it back on new fs and set it to rw and created initial backup
snapshot of it and send it over to backup fs. That all worked fine.
Several programs write and delete roughly 10 files/hour so not very
active part of the fs. It was quite random at which file the
incremental stream got corrupted.

My best guess was that the use of  btrfs property set  might be the
issue, so I rsynced the data in the subvol into a new subvol and did
initial backup snapshot transfer. This was with tools-4.5.3 +
kernel-4.5.4 and it runs now fine for 10 days.

I had limited time to research this issue for the subvol and also
cannot provide send-stream data for the subvol. But I have still a 12G
btrfs-stream of a .git kernelbuild tree that also got this btrfs
property set ro=true treatment. So I might try to reproduce the bug
with that one.
