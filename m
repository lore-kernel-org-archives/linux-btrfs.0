From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Metadata Duplication on a Single Disk Btrfs Setup
Date: Tue, 12 Jan 2010 12:08:19 -0600
Message-ID: <26a1f7961001121008u2d55eacobf2efd7a8ad39c7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On a single disk btrfs setup, such as for a desktop computer, what are
the implecations of creating your btrfs partition with '-m single'?

At first, I assumed I would want a single disk desktop setup to be
configured as 'single'.  But that may not be the case for metadata.

I see that the default is for metadata duplication in a single disk scenario.

Is duplication of the metadata important for recovery from common
desktop user problems such as power interruption?
