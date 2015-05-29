Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbbE2OEx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 10:04:53 -0400
Date: Fri, 29 May 2015 16:04:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Plans for a library for btrfs?
Message-ID: <20150529140450.GT23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CANXojcyqXUNhWLa4ybGyhXceqLdb3DdvM-TvEtwf-KOM6YOsUQ@mail.gmail.com>
 <pan$a6415$36d8c1c4$3981516e$b8dcb148@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$a6415$36d8c1c4$3981516e$b8dcb148@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 27, 2015 at 05:39:34PM +0000, Duncan wrote:
> Stef Bon posted on Wed, 27 May 2015 14:31:28 +0200 as excerpted:
> 
> > I'm working on a program (using sqlite, FUSE and btrfs) to provide
> > backup and version managment for users. They can enable the backup
> > service for folders they own, and select files they want to backup using
> > mimetypes.
> > 
> > This program, which I've called fuse-backup, creates backup subvolumes
> > and snapshots by calling an extrenal script, which does something like:
> > 
> > btrfs subvolume snapshot -r %PathToBackup%/ %PathToSnapshot%
> > 
> > This works perfect, but are there any plans to do this with a library?
> 
> A library is covered on the wiki, project ideas page.
> 
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Provide_a_library_covering_.27btrfs.27_functionality
> 
> Status: Project not claimed, no patches, but there's a couple possible 
> places to start as parts of other projects.  See the link for more.

AFAIK Karel Zak started working on libbtrfs.

https://github.com/karelzak/btrfs-progs/tree/libbtrfs
