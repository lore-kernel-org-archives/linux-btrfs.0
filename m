Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:42670 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2GWRGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 13:06:55 -0400
Date: Mon, 23 Jul 2012 13:06:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
CC: Josef Bacik <JBacik@fusionio.com>, Wendy Cheng <s.wendy.cheng@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is a
 ssd V2
Message-ID: <20120723170652.GM2118@localhost.localdomain>
References: <1342811743-8748-1-git-send-email-jbacik@fusionio.com>
 <5009B323.3040607@libero.it>
 <CABgxfbFUQn0F4LDpUH=xcmwL_YTGK4HbU2-z0+3iW5uk=+xp_A@mail.gmail.com>
 <20120723124620.GI2118@localhost.localdomain>
 <500D835D.6060105@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <500D835D.6060105@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2012 at 11:01:17AM -0600, Goffredo Baroncelli wrote:
> On 07/23/2012 02:46 PM, Josef Bacik wrote:
> > On Fri, Jul 20, 2012 at 04:38:59PM -0600, Wendy Cheng wrote:
> 
> >> However, this should have been a task for the admin (or whoever types
> >> this mkfs command). It is not a filesystem's job to assume how the
> >> firmware works and silently ignore the DUP request, *unless* there is
> >> a standard specification clearly describes linux devices that claim to
> >> be not "rotational" should behave this way.
> >>
> > 
> > The admin can still use -m dup if he wants the added possiblity of protection,
> > this just makes the default not dup.  
> 
> Josef,
> 
> this was clear to us with the the code at hand. However, what was
> pointed out is that is change of a well established behaviour without
> documenting it not informing it.
> 
> I don't arguing about the rationale, what I am telling is : ok to the
> change but you have to inform the user.
> 
> Saying "but the user can revert the change passing '-m dup'" is not a
> valid response, because the user *could* revert the change if he *would*
> be informed about the change.
> 

Yeah sorry Goffredo I agree and I changed it locally, I just haven't sent it out
yet.  Thanks,

Josef
