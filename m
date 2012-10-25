Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51451 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2JYM1b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 08:27:31 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so810127wey.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 05:27:30 -0700 (PDT)
Message-ID: <1351168220.1923.6.camel@hughsie-work.lan>
Subject: Naming of subvolumes
From: Richard Hughes <hughsient@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Thu, 25 Oct 2012 13:30:20 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm planning to use "btrfs subvolume snapshot -r <name>" in the system
upgrade functionality[1] if the user is using btrfs for their root file
system. We've got most of the bits in place already for Fedora 18.

One think that confuses me is the convention for the naming of
snapshots. Is there any conventions or prior art there? Can I add
metadata to the snapshot so that I don't have encode everything in the
snapshot name itself?

Also, being able to do a snapshot using a libbtrfs (or whatever) would
be much preferable to exec'ing the btrfs command and then trying to
parse the exit code and any stderr. I don't know if this kind of thing
is the norm for filesystem utilities, but a versioned shared library to
use would be awesome.

Any advice welcome, thanks.

Richard
(PackageKit author)

[1] https://fedoraproject.org/wiki/Features/OfflineSystemUpdates

