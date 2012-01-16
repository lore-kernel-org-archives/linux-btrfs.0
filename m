From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Possible btrfs deadlock coused by commit 660d3f6c
Date: Mon, 16 Jan 2012 09:53:23 +0100
Message-ID: <20120116085322.GB2105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick <ragamuffin@datacomm.ch>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

commit 660d3f6cde552323578b85fc5a09a6742f1fe804
Author: Josef Bacik <josef@redhat.com>
Date:   Fri Dec 9 11:18:51 2011 -0500

    Btrfs: fix how we do delalloc reservations and how we free reservations on error

introduced possible deadlock. According to comment before
btrfs_page_mkwrite(), that function is not allowed to take
node->i_mutex .

The problem was detected by Patrick (full lockdep info is provided):
http://bugzilla.kernel.org/attachment.cgi?id=72072
during investigating of some other issue (kernel.org bug 42576)

Stanislaw
