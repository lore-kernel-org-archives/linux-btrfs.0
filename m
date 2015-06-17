Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35475 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbFQVVr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 17:21:47 -0400
Received: by wgbhy7 with SMTP id hy7so47485801wgb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 14:21:45 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Jun 2015 22:21:45 +0100
Message-ID: <CAMU1PDjKbbXPrr5uPgPUEzfN+RWxi9McvRLS02N7N9JJ39q2ug@mail.gmail.com>
Subject: btrfs-progs 4.1-rc1: btrfstune -u reporting incorrect current fsid?
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've done a quick test on changing the UUID of a btrfs.  It worked, but
btrfstune -u didn't print the same current uuid that btrfs fi sh does.
It also upper cases the UUID where as btrfs fi sh and blkid don't.

Thanks,
Mike

# btrfs filesystem show /dev/sdb1 | fgrep uuid
Label: none  uuid: b2813976-4d8b-4976-9d59-cbfbd588399c

# ~fedora/programming/c/btrfs-progs-unstable/btrfstune -f -u /dev/sdb1
Current fsid: FFFFFFFF-0000-0000-00B0-8F12937F0000
New fsid: D294F3F3-F2B7-4407-B83A-DE5A4F8CBAB1
Set superblock flag CHANGING_FSID
Change fsid in extents
Change fsid on devices
Clear superblock flag CHANGING_FSID
Fsid change finished

# btrfs filesystem show /dev/sdb1 | fgrep uuid
Label: none  uuid: d294f3f3-f2b7-4407-b83a-de5a4f8cbab1

# blkid | fgrep sdb1
/dev/sdb1: UUID="d294f3f3-f2b7-4407-b83a-de5a4f8cbab1"
UUID_SUB="70065403-5ec1-462c-93a4-26cff8b6aea2" TYPE="btrfs"
PARTUUID="b309c48c-486f-4882-896c-34d4d0aeb529"
