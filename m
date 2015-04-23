Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33973 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233AbbDWPCk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 11:02:40 -0400
Received: by iget9 with SMTP id t9so11759405ige.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 08:02:40 -0700 (PDT)
MIME-Version: 1.0
From: Paul Harvey <csirac2@gmail.com>
Date: Fri, 24 Apr 2015 01:02:19 +1000
Message-ID: <CAB3_QuKfKTXr=pARvvcAJrdF0k29rYu6SvJxUD2h88azpG7Wjw@mail.gmail.com>
Subject: Seeking feedback: snazzer, a btrfs snapshotting/pruning/measurement/transport
 tool
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been hacking on https://github.com/csirac2/snazzer over the last
few months. It started out as a 20-line cron job, then a 50-line gist,
and now this thing that's obviously grown a little too much perhaps.

snazzer was initially written to help me maintain snapshots on a fleet
of VMs all using multiple subvolumes (especially with separate
/var/cache subvols which are excluded from snapshots in the default
configuration along with docker subvolumes, among others). I found it
frustrating having to enumerate the subvols I wanted to maintain
snapshots for in each VM build; snazzer tries to be "zero-config"
where possible. The snazzer-receive script helps me keep snapshots
flowing out of the VMs and onto tiered storage elsewhere.

There's a more verbose manifesto at the github readme above, but
briefly the features are:
- Minimal dependencies (portable-ish sh script - a painful learning
exercise I must admit)
- Maintains snapshots for each subvol under
subvol/.snapshotz/YYYY-MM-DDTHHMMSS+hhmm i.e. a valid isodate
- Can operate on specific subvols, all subvols on a filesystem, or all
subvols on all mounted filesystems, Eg: snazzer --all
- Operations include snapshotting (default), --measure (sha512sum &
PGP signatures of snapshots), --prune (deleting snapshots except for
those required to meet configured number of
hourlies/daylies/monthlies/yearlies to keep)
- snazzer-receive operates on remote hosts for specific subvols, all
subvols on a filesystem, or all subvols on all mounted filesystems,
Eg: snazzer-receive somehost --all (or snazzer-receive -- --all to
receive local paths without ssh in the middle)

It's not quite polished yet but I feel that I should start thinking
about automating testing on multiple distros and setting up distro
packaging. I've started playing with debconf scripts with a view to
guiding new snazzer users through semi-sanely/securely configuring
their systems to work with snazzer-receive, which is the most tedious
part of using this thing. The goal is some semi-automatic, hopefully
sane configuration of dedicated restricted user accounts for
appropriate things, with ssh forced-command wrappers, restricted
sudoers etc. which is presently only provided in the documentation for
now.

Before I embark on all that effort though I'd appreciate any initial
feedback, let me know what you think - or talk me out of it, help me
avoid wasting my time :-)

--
Paul Harvey
