Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:54599
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764210Ab3DDSBk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 14:01:40 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: minimum kernel version for btrfsprogs.0.20?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKcLGm9EXpKp6w+6MrYQzLgNYEFjP6KTS7GBjZP_dXoH3on8sQ@mail.gmail.com>
Date: Thu, 4 Apr 2013 12:01:39 -0600
Cc: cwillu <cwillu@cwillu.com>,
        "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <9DC03118-3C03-4B8F-AF82-B358ED18797A@colorremedies.com>
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com> <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com> <092651F7-2FAF-42A2-A5B5-F4E4377A6A12@colorremedies.com> <CAKcLGm8oNvQ7OO63TS389qDo3xo_41s1BO5POG8CR5=_nd2Z2g@mail.gmail.com> <DE18F344-65F0-4398-BD5D-B197C858D889@colorremedies.com> <CAKcLGm9EXpKp6w+6MrYQzLgNYEFjP6KTS7GBjZP_dXoH3on8sQ@mail.gmail.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 4, 2013, at 11:00 AM, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:
> 
> I disagree with cwillu regarding the default setting for extended inode refs.
> 
> While the extended inode refs are a great addition and solve a long
> standing problem, it appears only the 3.9.0_rc kernel consistently
> works with extended inode refs.

And extended inode refs are related to leaf size, in a way that explains a default 4KB leaf size being mountable with older kernels, but volumes created with larger leaf sizes aren't mountable? Just a yes or no is fine, I probably wouldn't understand an explanation of the relationship.

> 
> There should be at least a few working kernel versions out there
> before this becomes the default.  Options like this that will make
> btrfs unmountable on older kernel versions need "buy-in" by the users.
> 
> There is still the capability to enable extended inode refs with btrfstune.

The behavior, in effect, acts as a change to the on disk format. It won't make sense to most users that default 4KB leaf sizes are backwards compatible with prior kernels, but 8/16/32KB leaf size is not.

It's likely I don't know enough about kernel and fs development, but my instinct is that a longterm kernel needs to support a feature before the feature be a default. If the experimental fs card is applicable, I'd still say that this seems close enough to a format change that it should be postponed to a planned point in time when also implementing other features having a similar consequence.

Otherwise, people can't regress to older kernels at all. And while the most common convention by far in btrfs troubleshooting is to go to a newer kernel, finding regressions either in btrfs let alone elsewhere (e.g. video card drivers) is rather significantly inhibited by being unable to mount a btrfs volume. The prospect of a (final release) Fedora 19 created btrfs volume being totally unreadable by anything less than kernel 3.9.0 is a bit eyebrow raising.


Chris Murphy