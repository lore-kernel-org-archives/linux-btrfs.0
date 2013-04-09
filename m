Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761010Ab3DIWKm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 18:10:42 -0400
Date: Wed, 10 Apr 2013 00:10:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Chris Murphy <lists@colorremedies.com>, cwillu <cwillu@cwillu.com>,
        "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: minimum kernel version for btrfsprogs.0.20?
Message-ID: <20130409221038.GJ18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com>
 <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
 <092651F7-2FAF-42A2-A5B5-F4E4377A6A12@colorremedies.com>
 <CAKcLGm8oNvQ7OO63TS389qDo3xo_41s1BO5POG8CR5=_nd2Z2g@mail.gmail.com>
 <DE18F344-65F0-4398-BD5D-B197C858D889@colorremedies.com>
 <CAKcLGm9EXpKp6w+6MrYQzLgNYEFjP6KTS7GBjZP_dXoH3on8sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm9EXpKp6w+6MrYQzLgNYEFjP6KTS7GBjZP_dXoH3on8sQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 04, 2013 at 12:00:02PM -0500, Mitch Harder wrote:
> I disagree with cwillu regarding the default setting for extended inode refs.
> 
> While the extended inode refs are a great addition and solve a long
> standing problem, it appears only the 3.9.0_rc kernel consistently
> works with extended inode refs.
> 
> There should be at least a few working kernel versions out there
> before this becomes the default.  Options like this that will make
> btrfs unmountable on older kernel versions need "buy-in" by the users.
> 
> There is still the capability to enable extended inode refs with btrfstune.

I agree with you. It's my mistake that I left it enabled by default in
mkfs. It'll be fixed in next integration branch.

david
