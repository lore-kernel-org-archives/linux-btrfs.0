From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] missed btrfs fix
Date: Tue, 20 Sep 2011 17:00:21 -0400
Message-ID: <1316551659-sup-7171@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sage mentioned I was missing a patch.  So I've retested and updated the
git tree.  Since Linus did pull my tree yesterday, here's a new pull
request with the single commit.

Linus I have this in two flavors.  One is merged on top of my for-linus
branch, which was 3.1-rc6 + my last pull request:

head: 0a7a0519d1789f3a222849421dbe91b6bddb88f5
git://github.com/chrismason/linux.git for-linus

Second is just against the btrfs-3.0 tree.  I have the two branches just
so the N-1 world can update to the latest fixes without running the rest
of the rc kernel.  I know in the git universe these are all the same,
but I'm assuming you'll want to skip my merge commit:

head: b6f3409b2197e8fcedb43e6600e37b7cfbe0715b
git://github.com/chrismason/linux.git btrfs-3.0

Sage Weil (1) commits (+6/-1):
    Btrfs: reserve sufficient space for ioctl clone

 fs/btrfs/ioctl.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)
