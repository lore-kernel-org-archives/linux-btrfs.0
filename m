Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbbEMQbe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:31:34 -0400
Date: Wed, 13 May 2015 18:31:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>,
        David Alcorn <nroclaed@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        clm@fb.com
Subject: Re: Failed RAID0=> RAID1 Conversion
Message-ID: <20150513163132.GS23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
 <55532EA4.2080907@skagestad.org>
 <20150513111131.GR18480@carfax.org.uk>
 <CAL3q7H71A1mgLvPGqhuQp7mD+pxpR7JXdaz3dk3kRE4idYJTWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H71A1mgLvPGqhuQp7mD+pxpR7JXdaz3dk3kRE4idYJTWg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 12:30:23PM +0100, Filipe David Manana wrote:
> >
> >    If this still says RAID0, then you've probably hit a known (and
> > since fixed) bug that stops restripe operations from working:
> 
> As far as I can see, it hasn't been fixed as of 4.1-rc3 yet, nor any
> patch to fix it was posted to this list yet (other than Omar's revert
> patch).

Chris mentions a fix in the 'revert patch' thread.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/44477
