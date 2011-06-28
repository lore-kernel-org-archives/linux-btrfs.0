From: Daniel Witzel <dannyboy48888@gmail.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Tue, 28 Jun 2011 17:04:20 +0000 (UTC)
Message-ID: <loom.20110628T190235-371@post.gmane.org>
References: <4E026FD4.7020606@podzimek.org> <1308793398-sup-9234@shiny> <20110623195409.GA21007@dhcp231-156.rdu.redhat.com> <4E03E8B8.9080500@podzimek.org> <loom.20110628T174243-342@post.gmane.org> <BANLkTi=w4ZcVktZzwdKw7oszNvYyUoXjRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply. copied the patch from the line "diff...." onward 
did a fresh kernel tree and got the following (same on 2.6.39-r1 and r2)

localhost linux# patch -p1 --dry-run --verbose < disk-io.patch
Hmm...  Looks like a unified diff to me...
The text leading up to this was:
--------------------------
|diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
|index c650a1d..53e330e 100644
|--- a/fs/btrfs/disk-io.c
|+++ b/fs/btrfs/disk-io.c
--------------------------
Patching file fs/btrfs/disk-io.c using Plan A...
Hunk #1 succeeded at 281.
Hunk #2 succeeded at 296.
Hunk #3 succeeded at 328.
Hunk #4 succeeded at 338.
Hunk #5 succeeded at 360.
Hunk #6 succeeded at 2012.
Hunk #7 succeeded at 2631.
done


A perfect patch job if I say so :)

any other ideas are welcome 

Dan Witzel



