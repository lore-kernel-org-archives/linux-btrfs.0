Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54873 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418Ab2JYNlY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 09:41:24 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1338564wgb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 06:41:23 -0700 (PDT)
Message-ID: <1351172653.1923.10.camel@hughsie-work.lan>
Subject: Re: Naming of subvolumes
From: Richard Hughes <hughsient@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 25 Oct 2012 14:44:13 +0100
In-Reply-To: <20121025132825.GD25498@carfax.org.uk>
References: <1351168220.1923.6.camel@hughsie-work.lan>
	 <20121025132825.GD25498@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2012-10-25 at 14:28 +0100, Hugo Mills wrote:
>    How about user xattrs? IIRC, that's the user.* namespace.

Yes, but we still need some kind of metadata standard. For instance, I
might want to put a list of packages that were changed in the metadata
so that admins know why the snapshot was created. It's highly likely
distros like Ubuntu won't want to do it using the same mechanism (i.e.
using PackageKit) but having some shared specs is probably a good idea.

>    The only convention I'm aware of is Ubuntu's use of an @
> substitution, where the subvolume to be mounted at / is called @, and
> the subvolume to be mounted at /home becomes @home.

That could work I suppose.

>  Both of those
> subvolumes are stored in the (otherwise empty) top-level of the
> filesystem, which is not mounted in normal operation.

If we do one upgrade a week, that's 52 subvolumes cluttering things up.
Should the subvolumes be placed somewhere upgrade specific? Any best
practice ideas on naming? e.g. @system-upgrade-20121025?

Richard


