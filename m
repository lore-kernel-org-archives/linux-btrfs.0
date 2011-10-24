From: dima <dolenin@parallels.com>
Subject: Re: system hangs after deleting bad file
Date: Mon, 24 Oct 2011 03:48:14 +0000 (UTC)
Message-ID: <loom.20111024T054315-615@post.gmane.org>
References: <BwKod0ky1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I had a similar problem.

Some files (2-3) got corrupted in my /home subvolume for no apparent reason.
Trying to access the files gives kernel oops. Sometimes it freezes the machine,
sometimes I am back to my console without any problems.

Then I switched to the latest 3.1rc and freezes were gone (though I still had
the kernel oops).

(I did not try the repair program fearing that it would do more bad than good.
After all, my / subvolume was fine and i still could mount /home)

But to tackle the problems with corrupted files I had to create a new subvolume
for /home, tranfer the files from the old one (minus the corrupted files) and
delete the old subvolume.

Though still btrfsck would give me errors trying to access some inode. But I
could mount and use all my subvolumes with no problems.

Then... I re-created btrfs with the latest btrfs-tools and installed the latest
3.1rc from the very beginning.

So far, it is working fine and the situation with disk I/O has greatly improved.
I think you may want to try to upgrade to the latest 3.1rc and at the very least
you (hopefully) should not be getting hard freezes any more.

best
~dima

