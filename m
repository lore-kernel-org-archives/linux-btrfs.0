Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:56500 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeCOCyX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 22:54:23 -0400
Message-ID: <1521082459.4631.18.camel@scientia.net>
Subject: Re: zerofree btrfs support?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 15 Mar 2018 03:54:19 +0100
In-Reply-To: <20180314193847.GR32007@twin.jikos.cz>
References: <1520650525.5641.47.camel@scientia.net>
         <20180314193847.GR32007@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.


On Wed, 2018-03-14 at 20:38 +0100, David Sterba wrote:
> I have a prototype code for that and after the years, seeing the
> request
> again, I'm not against adding it as long as it's not advertised as a
> security feature.
I'd expect that anyone in the security area should know that securely
deleting data is not done by overwriting it (not even overwriting it
multiple times may be enough).
So I don't think that it would be btrfs' or zerofree's duty do teach
that to users.

The later's manpage doesn't advertise it for such purpose and even
contains a (though perhaps a bit too vague) warning:
>It  may  however  be useful in other situations: for instance it can be
>used to make it more difficult to retrieve deleted  data.  Beware  that
>securely  deleting  sensitive  data  is not in general an easy task and
>usually requires writing several times on the deleted blocks.

They should probably drop the first "can be used to make it difficult"
sentence... and add that even overwriting multiple times is often not
enough.


> The zeroing simply builds on top of the trim code, so it's merely
> adding
> the ioctl interface and passing down the desired operation.
Well I think what would be really mandatory if such support is added to
an 3rd party tools is, that it will definitely continue to work
(without causing corruptions or so), even if btrfs changes.

And if it's just using existing btrfs kernel code (and zerofree itself
would mostly do nothing)... than that seems quite promising. :-)


I personally don't need it that desperate anymore, since I got discard
support working in my qemu... but others may still benefit from it, so
if it's easy, why not!? :-)

Cheers,
Chris.
