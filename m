From: jim owens <jowens@hp.com>
Subject: Re: Metadata Duplication on a Single Disk Btrfs Setup
Date: Tue, 12 Jan 2010 13:27:52 -0500
Message-ID: <4B4CBF28.6010602@hp.com>
References: <26a1f7961001121008u2d55eacobf2efd7a8ad39c7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <26a1f7961001121008u2d55eacobf2efd7a8ad39c7c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder wrote:
> On a single disk btrfs setup, such as for a desktop computer, what are
> the implecations of creating your btrfs partition with '-m single'?
> 
> At first, I assumed I would want a single disk desktop setup to be
> configured as 'single'.  But that may not be the case for metadata.
> 
> I see that the default is for metadata duplication in a single disk scenario.
> 
> Is duplication of the metadata important for recovery from common
> desktop user problems such as power interruption?

Duplication of metadata protects against unreadable disk blocks
or disk blocks that have garbage written in them. Power interruption
can cause that in rare cases (and on some hardware not so rare).

The more usual power loss issue is incomplete or stale data.  Even
single metadata mode should protect from that.

So the short answer is it provides some additional protection
at the expense of more space used.  How much you need that extra
protection depends on your hardware, power reliability, and how
valuable your data is.

jim
