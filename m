From: Tydus Ken <kentydus@gmail.com>
Subject: An issue when mounting the dd-copied partition and the original one together
Date: Fri, 20 Apr 2012 14:49:48 +0800
Message-ID: <CAOLNCyrvxNi-wKYdPaUX9Qvpzi7RhVjDgmig-Mr1_M5HmXza2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all.

I'm using btrfs for a long time. It's the time for me to report an issu=
e.

I use btrfs for my home and I dded the block device to a new computer.
It works well. But when I tried to mount both up and do syncing
between them, I found the two mountpoints are the same! i.e. when I
touch a file on my original partition, the same file appears in the
new one now. Vice versa.

I wrote a script to replay it (using loop, but result is the same):

=A0 =A0 dd if=3D/dev/zero of=3Dori.img bs=3D16M count=3D16
=A0 =A0 mkfs.btrfs ori.img
=A0 =A0 cp ori.img new.img
=A0 =A0 mkdir ori new
=A0 =A0 mount -o loop ori.img ori
=A0 =A0 mount -o loop new.img new
=A0 =A0 touch ori/foo
=A0 =A0 ls new

You'll see the file `foo' also appears in the `new' directory.

I guess there's something wrong with btrfs in how to deal with two
partition with same UUID or something else, but I'm not sure.

It's proved on Gentoo with Kernel 3.2.11, as well as Ubuntu with Kernel=
 3.1.9

Tydus
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
