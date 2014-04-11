Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34460 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDKRw2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:52:28 -0400
Date: Fri, 11 Apr 2014 10:52:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
Message-ID: <20140411175226.GL7322@merlins.org>
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com> <20140411061048.GD7322@merlins.org> <20140411173628.GG29256@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140411173628.GG29256@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 11, 2014 at 07:36:28PM +0200, David Sterba wrote:
> On Thu, Apr 10, 2014 at 11:10:48PM -0700, Marc MERLIN wrote:
> > > --- a/Documentation/btrfs-replace.txt
> > > +++ b/Documentation/btrfs-replace.txt
> > > @@ -13,6 +13,9 @@ DESCRIPTION
> > >  -----------
> > >  'btrfs replace' is used to replace btrfs managed devices with other device.
> > 
> > I would add a quick line here saying that it's not currently supported for
> > RAID5/6, and to see btrfs-device for add/delete to get around the replace
> > missing problem.
> 
> I've added the quick note when committing the patch.

Thanks both.

Generally, would you agree to putting more links to the wiki in man pages
since man pages are not forever but sure take a long time to update on the
installed based and the wiki can be up to date for everyone right away?
(I'm not saying to remove info from the man pages, but more something like
"btrfs is changing quickly, more up to date information can be found on the
wiki page for
raid56: https://btrfs.wiki.kernel.org/index.php/RAID56
or
btrfsck: https://btrfs.wiki.kernel.org/index.php/Btrfsck
btrfs restore: https://btrfs.wiki.kernel.org/index.php/Restore

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
