Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:54362 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab2HHPkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 11:40:04 -0400
Date: Wed, 8 Aug 2012 11:40:01 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: Alexander Block <ablock84@googlemail.com>,
        Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove mnt_want_write call in btrfs_mksubvol
Message-ID: <20120808154001.GA4185@shiny>
References: <1343949380-15398-1-git-send-email-ablock84@googlemail.com>
 <20120803211317.GA10080@localhost.localdomain>
 <CAB9VWqAU5THN7Lb9Y35pGBr1ewmtYmqsX6B-x7Lx3BiAUW4FgQ@mail.gmail.com>
 <20120808152059.GY17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120808152059.GY17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 09:20:59AM -0600, David Sterba wrote:
> On Sat, Aug 04, 2012 at 01:39:25AM +0200, Alexander Block wrote:
> > On Fri, Aug 3, 2012 at 11:13 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > > I'm confused, this isn't here in btrfs-next, so is this a problem still?
> >
> > It's in linus current master. Lio Bo moved the call out of
> > btrfs_mksubvol into the caller. Later a commit from Jan Kara tried to
> > move the call inside mksubvol below i_mutex. If I understand the logs
> > correctly, It was then merged incorrectly.
> 
> How should we resolve this? The patch has to be pulled via a separate
> branch, based on top of linus/master, as cmason/for-linus does not have
> the clashing freezer patches. And I do want to see the fix in master
> rather soon as it makes testing tedious.

Right, I'll fix this up in a separate send to Linus.  I thought I had
this fixed in my original merge, but either way I'll send a pull to fix
it.

-chris
