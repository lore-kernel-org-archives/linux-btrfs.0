Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbaFSM0e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 08:26:34 -0400
Date: Thu, 19 Jun 2014 14:26:32 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
Message-ID: <20140619122632.GA1903@suse.cz>
Reply-To: dsterba@suse.cz
References: <5398D475.4070309@redhat.com>
 <5398D4DF.9080508@redhat.com>
 <20140612105151.GN1903@twin.jikos.cz>
 <5399BB92.2070205@redhat.com>
 <20140618152906.GW1903@twin.jikos.cz>
 <CALOYprVo60UrZWWVk34MDur6CpDAG2a1Cg3cWd0M__gWKnQywA@mail.gmail.com>
 <20140618230516.GZ1903@suse.cz>
 <CALOYprWx6OPVK=A14yRHye1x1QuTqAu1QnH74Css=vWqjDMQoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprWx6OPVK=A14yRHye1x1QuTqAu1QnH74Css=vWqjDMQoQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 08:43:36AM +0100, WorMzy Tykashi wrote:
> > You're right, sorry. The file was not added after a conflict with
> > git-am and I did not check afterwards. Local build test passed.
> > Updated integration pushed, though it's a bit reduced. The 'next'
> > sub-branch rebase had some suspicious glitch, I need to look closer
> > tomorrow.
> 
> Thanks for the fast update. :)

The next branch merged via format-patch/git-am instead of rebase and did
not hit any conflicts. Branch readded and integration pushed with
today's tag, without other patches.
