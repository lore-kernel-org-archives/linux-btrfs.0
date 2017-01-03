Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li296-246.members.linode.com ([66.228.54.246]:44952 "EHLO
        li296-246.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760372AbdACSQZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 13:16:25 -0500
Date: Tue, 3 Jan 2017 17:18:41 +0000
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re:[PATCH] btrfs-progs: btrfs-debugfs: Display usage hint with no
 arguments
Message-ID: <20170103171841.GA8261@li296-246.members.linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes. /mnt/file.txt is a mandatory argument. And -h/-b/-f are optional arugments. But the issue is, one of these optional argument is must. If we run:

btrfs-debugfs /mnt/file.txt

doesn't produce any output at all. From time to time, I run 'btrfs-debugfs /path/to/file'  and wonder why no output received then realize I must pass either -f or -b.  (May be '-f' needs be to set as 'default' when  no optional argument is provided.)

Overall, the current patch provides verbose message and does nothing more, it can be ignored. End user needs to remember -f or -b must be passed for valid outputs.
