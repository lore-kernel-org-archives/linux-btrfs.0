Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbcIUJ0G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 05:26:06 -0400
Date: Wed, 21 Sep 2016 11:24:06 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, holger@applied-asynchrony.com, osandov@fb.com
Subject: Status of free-space-tree feature
Message-ID: <20160921092406.GD16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

as you might have noticed, the [1] wiki Status page lists the
free-space-tree as 'Unstable', referencing a problem with the bitmap
endianity. This will affect only bigendian systems.

There's one more problem that I overlooked but was pointed to by Omar
recently.  The initial FST support in btrfs-progs is read-only,

https://marc.info/?l=linux-btrfs&m=144113538017042

"However, we're not adding the FREE_SPACE_TREE read-only compat bit to
the set of supported bits because progs doesn't know how to keep the
free space tree consistent."

Historically, the initial patchset version did not recognize FST feature
and thus refused to write, but then it was pointed by Qu and Holger that
the compat_ro bit is missing for FST. I've added it but this was a
mistake. This change is going to be reverted.

So the status of FST is unchanged (for testing only), we still have bugs
to fix.

[1] https://btrfs.wiki.kernel.org/index.php/Status
