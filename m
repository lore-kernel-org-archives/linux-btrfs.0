Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbeHUR4I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:56:08 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180821142432.GD24025@twin.jikos.cz>
References: <20180821142432.GD24025@twin.jikos.cz> <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com> <20180816130515.GR24025@twin.jikos.cz> <31114.1534417285@warthog.procyon.org.uk> <32208.1534767847@warthog.procyon.org.uk> <341.1534859015@warthog.procyon.org.uk>
To: dsterba@suse.cz
Cc: dhowells@redhat.com, Qu Wenruo <quwenruo.btrfs@gmx.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, wqu@suse.de
Subject: Re: Are the btrfs mount options inconsistent?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 21 Aug 2018 15:35:42 +0100
Message-ID: <4246.1534862142@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> wrote:

> - nothing: auto-detect non-rotating devices, enable SSD mount option in turn

And it's right that this should only turn on SSD if *all* the devices are
non-rotating?

David
