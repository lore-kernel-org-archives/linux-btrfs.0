From: Francis GALIEGUE <fge@one2team.com>
Subject: dmesg filled with "parent transid verify failed" messages using
	Linus' HEAD as of 20100704
Date: Sun, 4 Jul 2010 13:09:23 +0200
Message-ID: <AANLkTikcruG8Bva2xZ_pm02_TPARJ55xUCdSbpnJ3iN6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[Note: I am not on the list, can you please Cc: me on replies? Thank
you in advance]

Hello,

Kernels: 2.6.34 to HEAD. Using ~amd64 Gentoo. All my filesystems
except /boot are btrfs.

btrfsck says I have a corrupted btrfs filesystem on my machine, and I
see this message in dmesg when mounting the filesystem (in
fs/btrfs/disk-io.c:284):

parent transid verify failed on 48136192 wanted 16424 found 16420

But there is something strange:

* this message only appears twice when running 2.6.34;
* it fills my dmesg (several tens of thousands of times a second -
printk_ratelimit() triggers to suppress the vast majority of them)
when running HEAD.

After a quick git log v2.6.34.. -- fs/btrfs, I found commit
5bdd3536cbbe2ecd94ecc14410c6b1b31da16381, which I reverted: HEAD now
"behaves" like 2.6.34, dmesg-wise. Unintended side effect?

--=20

=46rancis Galiegue
ONE2TEAM
Ing=C3=A9nieur syst=C3=A8me
Mob : +33 (0) 683 877 875
Tel : +33 (0) 178 945 552
fge@one2team.com
40 avenue Raymond Poincar=C3=A9
75116 Paris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
