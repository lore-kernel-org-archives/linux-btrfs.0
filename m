Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:44946 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab3GaVeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 17:34:07 -0400
Received: by mail-qe0-f53.google.com with SMTP id f6so697523qej.40
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 14:34:06 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 31 Jul 2013 23:33:59 +0200
Message-ID: <CAKvOHKD+cYp+CO4XLXkktnFZ_5n1tZnbrqS3D+T8nJhVEReWig@mail.gmail.com>
Subject: Problems with incremental btrfs send (out of order instructions?)
From: Mathijs Kwik <mathijs@bluescreen303.nl>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

For some time, I've successfully deployed btrfs send/receive as a
viable backup solution.
It's fast and flexible and nicely scriptable =)
However, every once in a while, trouble strikes on the receiving end
with a message like:

ERROR: rename nixpkgs/pkgs/applications/version-management/subversion-1.2.x/default.nix
-> o2979-81788-0 failed. No such file or directory

Judging from looking at the dump-stream, I think sometimes a directory
gets moved (subversion-1.2.x in the example) to some temporary name
(or it gets deleted), but a little later a file within that directory
is being changed.
This seems to happen most often with filesystem-heavy applications
like a git tree or a webbrowser's cache dir.

I've tried many things to recover from such a situation, like removing
the offending directory and retrying from a new snapshot, but nothing
seems to work except for a full (non-incremental) send which is
expensive.

After some narrowing down, I managed to capture a problematic
sendstream. To reproduce:
- I created a separate subvolume (so there are no privacy-related
issues with sharing the dump)
- put a moderately large git tree on it (I used
https://github.com/NixOS/nixpkgs)
- perform an initial btrfs send of the subvolume
- jump around git history (check out very early revision, check out HEAD again)
- perform an incremental (with parent) btrfs send to a file
- try to receive this file on another machine
- about 80% chance this triggers it, if not, jump/branch some more with git

The problematic dump is here:
https://bluescreen303.nl/btrfs-send-error.dump.xz
The error provided above goes with this dump.

The dump was on kernel 3.9.x but it still happens on 3.10.4
btrfs-progs 650e656a8b9c1fbe4ec5cd8c48ae285b8abd3b69
I noticed there have been some commits since that revision but nothing
mentions send/receive.

Can someone have a look at my dumpfile and confirm this is indeed a
problem with btrfs send as opposed to something I am doing wrong?

Thanks!
Mathijs
