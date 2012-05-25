Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48526 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2EYPfi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 11:35:38 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 17:35:37 +0200
Message-ID: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
Subject: atime and filesystems with snapshots (especially Btrfs)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

(this is a resend with proper CC for linux-fsdevel and linux-kernel)

I would like to start a discussion on atime in Btrfs (and other
filesystems with snapshot support).

As atime is updated on every access of a file or directory, we get
many changes to the trees in btrfs that as always trigger cow
operations. This is no problem as long as the changed tree blocks are
not shared by other subvolumes. Performance is also not a problem, no
matter if shared or not (thanks to relatime which is the default).
The problems start when someone starts to use snapshots. If you for
example snapshot your root and continue working on your root, after
some time big parts of the tree will be cowed and unshared. In the
worst case, the whole tree gets unshared and thus takes up the double
space. Normally, a user would expect to only use extra space for a
tree if he changes something.
A worst case scenario would be if someone took regular snapshots for
backup purposes and later greps the contents of all snapshots to find
a specific file. This would touch all inodes in all trees and thus
make big parts of the trees unshared.

relatime (which is the default) reduces this problem a little bit, as
it by default only updates atime once a day. This means, if anyone
wants to test this problem, mount with relatime disabled or change the
system date before you try to update atime (that's the way i tested
it).

As a solution, I would suggest to make noatime the default for btrfs.
I'm however not sure if it is allowed in linux to have different
default mount options for different filesystem types. I know this
discussion pops up every few years (last time it resulted in making
relatime the default). But this is a special case for btrfs. atime is
already bad on other filesystems, but it's much much worse in btrfs.

Alex.
