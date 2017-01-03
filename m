Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933590AbdACOqT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 09:46:19 -0500
Date: Tue, 3 Jan 2017 15:46:02 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-debugfs: Display usage hint with no
 arguments
Message-ID: <20170103144602.GN12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170103115813.GA3228@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170103115813.GA3228@fedori>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is what I see when no arguments pare passed:

$ ./btrfs-debugfs
usage: btrfs-debugfs [-h] [-b] [-f] path [path ...]
btrfs-debugfs: error: too few arguments

And that's exactly the same output as with this patch applied. Am I missing
something?
