Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbaLIKfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 05:35:44 -0500
Date: Tue, 9 Dec 2014 11:35:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: Chris Mason <clm@fb.com>, cwillu <cwillu@cwillu.com>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
Message-ID: <20141209103543.GB20595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <547B5724.1060507@libero.it>
 <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
 <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
 <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
 <1417793566.21214.11@mail.thefacebook.com>
 <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 05, 2014 at 04:01:37PM +0000, Dimitri John Ledkov wrote:
> The other suggestion I received is to ship a systemd unit that does
> unconditional btrfs scan pre local filesystem target... =)

While this works (as any ohter user script/hook that preceeds local
filesystem mount), I'd rather avoid adding more such workarounds to the
user/admin side. It took some time before all distros added the device
scanning into initrd.

(You don't propose that approach, this is to discourage people from
doing that as their distro default.)
