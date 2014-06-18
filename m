Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaFRXFS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 19:05:18 -0400
Date: Thu, 19 Jun 2014 01:05:16 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
Message-ID: <20140618230516.GZ1903@suse.cz>
Reply-To: dsterba@suse.cz
References: <5398D475.4070309@redhat.com>
 <5398D4DF.9080508@redhat.com>
 <20140612105151.GN1903@twin.jikos.cz>
 <5399BB92.2070205@redhat.com>
 <20140618152906.GW1903@twin.jikos.cz>
 <CALOYprVo60UrZWWVk34MDur6CpDAG2a1Cg3cWd0M__gWKnQywA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprVo60UrZWWVk34MDur6CpDAG2a1Cg3cWd0M__gWKnQywA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 09:59:50PM +0100, WorMzy Tykashi wrote:
> I think you forgot to apply the patch that adds
> Documentation/btrfs-mount.5.txt before you tagged
> integration-20140618, man5 (and consequently Documentation) can't be
> made without it, causing a failed build.

You're right, sorry. The file was not added after a conflict with
git-am and I did not check afterwards. Local build test passed.
Updated integration pushed, though it's a bit reduced. The 'next'
sub-branch rebase had some suspicious glitch, I need to look closer
tomorrow.
