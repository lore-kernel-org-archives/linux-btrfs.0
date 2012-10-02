Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60242 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2JBPFw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 11:05:52 -0400
Date: Tue, 2 Oct 2012 17:05:43 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
Message-ID: <20121002150543.GW14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
 <20121002142538.GV14582@twin.jikos.cz>
 <20121002143232.GE2370@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121002143232.GE2370@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 02, 2012 at 10:32:32AM -0400, Josef Bacik wrote:
> On Tue, Oct 02, 2012 at 08:25:38AM -0600, David Sterba wrote:
> > Hi,
> > 
> > On Mon, Sep 24, 2012 at 04:02:59PM -0400, Josef Bacik wrote:
> > > --- a/fs/btrfs/ctree.h
> > > +++ b/fs/btrfs/ctree.h
> > > @@ -571,6 +571,7 @@ struct btrfs_path {
> > >  	unsigned int skip_locking:1;
> > >  	unsigned int leave_spinning:1;
> > >  	unsigned int search_commit_root:1;
> > > +	unsigned int shecantgoanyfarthercapt:1;
> > 
> > so you did not make it to LWN's quote of the week, can you please rename
> > it to something sensible?
> > 
> 
> I don't see what's unsensible about it.

Itsfunnybuthardtoreadanddoesnothelpunderstandingthecodewhereitsused.

david
