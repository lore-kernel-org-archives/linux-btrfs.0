Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48702 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab2JZI1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 04:27:03 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2621320pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 01:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan>
	<64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com>
Date: Fri, 26 Oct 2012 09:27:03 +0100
Message-ID: <CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com>
Subject: Re: Naming of subvolumes
From: Richard Hughes <hughsient@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26 October 2012 06:24, Chris Murphy <lists@colorremedies.com> wrote:
> What's the read-only snapshot of and used for?

/root and /boot

> And if you're going to apply the upgrade to the snapshot, or to the top level file system?

That's a very good question. I was going to apply the upgrade to the
top level file system, and then roll-back to the old snapshot if the
new upgrade state does not boot to a GUI. It would work equally well
applying the update to the snapshot and then switching to that,
although I don't know how well userspace is going to cope switching to
a new subvolume at early-runtime given the fact we're running the
upgrade itself from the filesystem and not in a special initrd or
something. Also, we need to ready out lots of upgrade data (200Mb+?)
from somewhere, so doing this on the snapshot would mean creating the
snapshot and copying the data there *before* we reboot to install
upgrades, and we really want to create the snapshot when we're sure
the system will boot.

> So I'm going to guess that you will actually create a subvolume named something like @system-upgrade-20121025, and then snapshot root, boot, and home into that subvol?

Not /home. Packages shouldn't be installing stuff there anyway, and
/home is going to typically much bigger than /root or /boot.

> If the upgrade is not successful, you change the default subvolume ID to that of @system-upgrade-20121025.

I was actually thinking of using btrfs send | btrfs receive to roll
back the root manually. It would be better if btrfs could swap the
subvolume ID's of @system-upgrade-20121025 and 0, as then we don't get
a snapshot that's useless.

> Well, if there are 52 snapshots of Fedora 18, there are effectively 53 copies of /etc/fedora-release to be found. So how is this going to show up?

I figured we could have some kind of metadata in the snapshot to tell
the installer "this is an upgrade snapshot" and to ignore it being
offered to upgrade. Metadata is the key here to make things just work.

> ...if there are 52 or 5000 subvolumes, what's this UI going to look like?

Also a good question. An unanswered question :)

> Maybe in the short term you do something just like with kernels and keep the most recent three and start deleting the older ones?

Yes, this is a very good idea and probably what we need to do for our use case.

Richard
