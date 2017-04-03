Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:33944 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751759AbdDCUVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 16:21:19 -0400
From: Christian Brauner <christian.brauner@ubuntu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 0/2 v2] btrfs-progs: fix btrfs send & receive with -e flag
Date: Mon,  3 Apr 2017 22:21:06 +0200
Message-Id: <20170403202108.14859-1-christian.brauner@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

This is the second version of the patch. It contains no functional changes but
merely adds a second small patch to adapt the test to use -e with btrfs receive
in order to terminate on an end marker in the stream. Thanks to David for
pointing this out. Here's the description of the patch again:

The old check here tried to ensure that empty streams are not considered valid.
The old check however, will always fail when only one run through the while(1)
loop is needed and honor_end_cmd is set. So this:

btrfs send /some/subvol | btrfs receive -e /some/

will consistently fail because -e causes honor_cmd_to be set and
btrfs_read_and_process_send_stream() to correctly return 1. So the command will
be successful but btrfs receive will error out because the send - receive
concluded in one run through the while(1) loop.

If we want to exclude empty streams we need a way to tell the difference between
btrfs_read_and_process_send_stream() returning 1 because read_buf() did not
detect any data and read_and_process_cmd() returning 1 because honor_end_cmd was
set. Without introducing too many changes the best way to me seems to have
btrfs_read_and_process_send_stream() return -ENODATA in the first case. The rest
stays the same. We can then check for -ENODATA in do_receive() and report a
proper error in this case. This should also be backwards compatible to previous
versions of btrfs receive. They will fail on empty streams because a negative
value is returned. The only thing that they will lack is a nice error message.

Christian Brauner (2):
  btrfs-progs: fix btrfs send & receive with -e flag
  tests: use receive -e to terminate on end marker

 cmds-receive.c                                  | 13 +++++--------
 send-stream.c                                   |  2 +-
 tests/misc-tests/018-recv-end-of-stream/test.sh | 12 ++++++------
 3 files changed, 12 insertions(+), 15 deletions(-)

-- 
2.11.0

