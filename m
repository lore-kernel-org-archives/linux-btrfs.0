From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: How to know the origin of a snapshot
Date: Fri, 21 Oct 2011 13:54:46 +0200
Message-ID: <4EA15D86.6060601@jan-o-sch.net>
References: <CAKrYomhcMnaaBjhuATGbiMGTQ+uFBiuzwY2HgubeEeY0PA=sHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ryota Ozaki <ozaki.ryota@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKrYomhcMnaaBjhuATGbiMGTQ+uFBiuzwY2HgubeEeY0PA=sHw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 21.10.2011 13:02, Ryota Ozaki wrote:
> Is there a way to know relations between subvolume and snapshot?
> For example, can we know a subvolume from a given snapshot which
> stems from it? For another example, can we get a list of snapshots
> from a subvolume?

Currently, there's no such relationship. I plan adding a stems-from
relation in order to support incremental btrfs sends, but that's not
thought to an end, yet.

You can get along with a simple name scheme for the meantime.

-Jan
