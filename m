Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012AbcCDJ1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 04:27:10 -0500
Date: Fri, 4 Mar 2016 10:26:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs@vger.kernel.org
Subject: Re: how many chunk trees and extent trees present
Message-ID: <20160304092652.GI29310@suse.cz>
Reply-To: dsterba@suse.cz
References: <loom.20150417T081705-332@post.gmane.org>
 <20150417091911.GK22084@carfax.org.uk>
 <20150417172928.GT25622@twin.jikos.cz>
 <56D8F9C7.70609@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D8F9C7.70609@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 04, 2016 at 10:58:15AM +0800, Anand Jain wrote:
> 
> 
> On 04/18/2015 01:29 AM, David Sterba wrote:
> > On Fri, Apr 17, 2015 at 09:19:11AM +0000, Hugo Mills wrote:
> >>> In, some article i read that future there will be more chunk tree/ extent
> >>> tree for single btrfs. Is this true.
> >>
> >>     I recall, many moons ago, Chris saying that there probably wouldn't
> >> be.
> >
> > More extent trees tied to a set of fs trees/subvolumes would be very
> > useful for certain usecases *cough*encryption*cough*.
> 
>   I didn't understand in full what's the idea here, but let met try..
>   would it not defeat the purpose of encryption which is not to let
>   disk have the un-encrypted data ? Looks like I am missing something
>   here.

Depends how the encryption is designed. The separate extent trees would
allow to have mixed data in the filesystem, encrypted or not.

I can start with a normal filesystem, and then create encrypted
subvolumes any time later.

The idea of multiple extent trees:

Currently we have only one, all subvolume share the extent tree, can do
reflinks freely. We can create a subvolume (S1) and ask for a separate
extent tree (E1). Now we can create snapshots of S1 that would share E1,
and reflink accross snapshots that share E1.

Why is this useful to encryption: all data _and_ metadata blocks tied to
E1 and the attached subvolums are encrypted, the plain text is not
accessible without the key.

But the separate extent trees are useful on itself.
