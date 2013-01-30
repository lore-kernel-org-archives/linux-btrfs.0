Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:55073 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3A3UHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 15:07:44 -0500
Date: Wed, 30 Jan 2013 15:07:41 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe Brandenburger <filbranden@google.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix missing i_size update
Message-ID: <20130130200741.GK3660@localhost.localdomain>
References: <1359574114-1804-1-git-send-email-jbacik@fusionio.com>
 <CADU+-uCv+wG7vt-8gwHUwNboRpBVg7e5pNJyT3KP=yrdd32-AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CADU+-uCv+wG7vt-8gwHUwNboRpBVg7e5pNJyT3KP=yrdd32-AA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 12:36:22PM -0700, Filipe Brandenburger wrote:
> On Wed, Jan 30, 2013 at 11:28 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> > +       /*
> > +        * We still need to update disk_i_size if outstanding_isize is greater
> > +        * than disk_i_size.
> > +        */
> > +       if (offset <= disk_i_size &&
> > +           (!ordered || ordered->outstanding_isize < disk_i_size))
> 
> "<=" for the comparison? "ordered->outstanding_isize <= disk_i_size"
> 

Yeah good point.  Thanks,

Josef
