From: Kees Cook <kees.cook@canonical.com>
Subject: concerns about non-root subvol snapshots
Date: Wed, 11 Aug 2010 13:11:27 -0700
Message-ID: <20100811201127.GZ4138@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have some concerns about how brtfs access-checks the creation of
subvol snapshots. AIUI, only the destination is validated, which
basically results in a super-powerful hardlink ability. Normally,
hardlinking is possible to individual files in the same way, which
results in creation a small attack surface (i.e. if /etc and /home are
in the same fs, link /etc/shadow to ~/.bad-admin-app.rc and exploit a
vulnerability in bad-admin-app to stomp on /etc/shadow). In the case of
a btrfs subvol snapshot, a user could duplicate an entire tree of their
choice, even stuff that the user cannot see (/var/log/audit could now be
linked into ~/.bad-admin-app/var/log/audit).

I'm aware that due to DAC and MAC, when being enforced, these duplicated
trees are generally considered safe, but my concerns come from the looming
specter of misbehaving admin tools (which have in the past been tricked
by hardlinks from time to time). In this case, that tool couldn't even
check hardlink count. :)

My knee-jerk reaction is that using subvol snapshot should require
CAP_SYS_RESOURCE or CAP_SYS_ADMIN instead of just "anyone". Though perhaps
this should be a mount option, I'm not entirely sure.

Any thoughts on how to accomplish this?

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
