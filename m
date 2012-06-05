Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48243 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab2FEJ5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 05:57:46 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
Date: Tue, 5 Jun 2012 11:57:45 +0200
Cc: Hugo Mills <hugo@carfax.org.uk>, Maxim Mikheev <mikhmv@gmail.com>,
        Liu Bo <liubo2009@cn.fujitsu.com>
References: <4FCC6F44.2030503@gmx.net> <20120604170422.GD15986@carfax.org.uk> <201206051155.14398.Martin@lichtvoll.de> (sfid-20120605_115658_819797_5AD8D2A2)
In-Reply-To: <201206051155.14398.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206051157.45469.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 5. Juni 2012 schrieb Martin Steigerwald:
> Am Montag, 4. Juni 2012 schrieb Hugo Mills:
> > On Mon, Jun 04, 2012 at 12:24:05PM -0400, Maxim Mikheev wrote:
> > > I run through all potential tree roots. It gave me everytime
> > > messages like these:
> > > 
> > > parent transid verify failed on 3405159735296 wanted 9096 found
> > > 5263 parent transid verify failed on 3405159735296 wanted 9096
> > > found 5263
> 
> […]
> 
> > > The largest recovered data is 12Kb.
> > > max@s0:~/btrfs-recovering./recovered$ ls -lahs 3728819929088
> > > total 28K
> > > 4.0K drwxr-xr-x   3 root root 4.0K Jun  4 12:06 .
> 
> […]
> 
> > > What can I do next?
> > > 
> >    I'm out of ideas.
> >    
> >    At this point, though, you're probably looking at somebody writing
> > 
> > custom code to scan the FS and attempt to find and retrieve anything
> > that's recoverable.
> > 
> >    You might try writing a tool to scan all the disks for useful
> > 
> > fragments of old trees, and see if you can find some of the tree
> > roots independently of the tree of tree roots (which clearly isn't
> > particularly functional right now). You might try simply scanning
> > the disks looking for your lost data, and try to reconstruct as much
> > of it as you can from that. You could try to find a company
> > specialising in data recovery and pay them to try to get your data
> > back. Or you might just have to accept that the data's gone and work
> > on reconstructing it.
> 
> Only thing that comes to my mind thats still tryable without involving
> a data recover firm or engage a developer for an improved recovery
> tool is:
> 
> PhotoRec from testdisk package or some other data recovery tool that
> looks for headers for known fileformats like I think foremost.
> 
> It has some drawbacks:
> 
> - AFAIK it has no means to glue back together fragmented files, so
> these are likely gone or truncated
> 
> - filenames are lost
> 
> - directory structure is lost

It won´t work for striped files either, so it may only help for rather 
small files depending on BTRFS RAID 0 stripe size.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
