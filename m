Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm15-vm7.access.bullet.mail.gq1.yahoo.com ([216.39.63.193]:21343
	"HELO nm15-vm7.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750740Ab3LKEwd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 23:52:33 -0500
From: <linoc@pacbell.net>
To: "'Hugo Mills'" <hugo@carfax.org.uk>
Cc: <linux-btrfs@vger.kernel.org>
References: <1386615086.1044.YahooMailNeo@web180901.mail.ne1.yahoo.com> <1386619322.61331.YahooMailNeo@web180902.mail.ne1.yahoo.com> <20131209200856.GF9738@carfax.org.uk> <1386623127.31132.YahooMailNeo@web180903.mail.ne1.yahoo.com> <1386623231.94746.YahooMailNeo@web180901.mail.ne1.yahoo.com> <20131210121904.GG9738@carfax.org.uk>
In-Reply-To: <20131210121904.GG9738@carfax.org.uk>
Subject: RE: Btrfs questions
Date: Tue, 10 Dec 2013 20:52:15 -0800
Message-ID: <00dd01cef62c$c42b0270$4c810750$@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

thanks

-----Original Message-----
From: Hugo Mills [mailto:hugo@carfax.org.uk] 
Sent: Tuesday, December 10, 2013 4:19 AM
To: Cirillo Costantino
Cc: "linux-btrfs@vger.kernel.org"
Subject: Re: Btrfs questions

On Mon, Dec 09, 2013 at 01:07:11PM -0800, Cirillo Costantino wrote:
> resending in plain text
> 
> 
> ________________________________
> From: Cirillo Costantino <linoc@pacbell.net>
> To: Hugo Mills <hugo@carfax.org.uk>
> Cc: ""linux-btrfs@vger.kernel.org"" <linux-btrfs@vger.kernel.org>
> Sent: Monday, December 9, 2013 1:05 PM
> Subject: Re: Btrfs questions
> 
> 
> 
> thanks Hugo,
> 
> the link you sent indicates that has been "submitted" but it is not in 
> a kernel release... does it mean it could be in a 3.14 or 15 release?

   Unlikely. There were patches a couple of years ago, but they weren't
accepted back then and would probably need some additional effort to make
them work now -- even if the general approach was accepted (which I'm not
sure it was, from memory).

> with the release of Haswell from Intel, persistent memory will be 
> possible and cheap... portions of this memory could be made visible as 
> block devices and mirrored for protection to a neighboring system for 
> later replay in the event of a crash or power outage; how are such 
> feature request be included in btrfs?

   I think you're confusing two things (or possibly I am) -- transactional
memory and persistent memory.

   Transactional memory allows for [potentially] more efficient algorithms
to be used in concurrent systems, reducing the necessity for explicit
locking -- that's unlikely to have much direct effect on btrfs, as I suspect
it will largely be implemented in the kernel's lock primitives, and
"ordinary" kernel code won't see much difference.

   Persistent memory simply retains its state over a power-off, so in that
sense it looks something like a directly-attached/addressable block device,
which have been around for ages in the embedded space (although the
approaches used there, like XIP, may need modification to scale up
appropriately).

   Both are useful things to have, but I don't think you're going to see any
gigantic changes coming out of either, other than access times for
persistent storage coming down as a result of persistent memory.

   Hugo.

> lino
> 
> 
> ________________________________
> From: Hugo Mills <hugo@carfax.org.uk>
> To: Cirillo Costantino <linoc@pacbell.net>
> Cc: ""linux-btrfs@vger.kernel.org"" <linux-btrfs@vger.kernel.org>
> Sent: Monday, December 9, 2013 12:08 PM
> Subject: Re: Btrfs questions
> 
> 
> On Mon, Dec 09, 2013 at 12:02:02PM -0800, Cirillo Costantino wrote:
> > 
> > 
> > i am looking at using btrfs for a new project and i have a few
questions:
> > 
> >     * i have heard that as it currently stands Btrfs has some issues 
> > to be used as a Lustre file system; is he aware of the issues and 
> > any plans to address these and integrate Btrfs in to Lustre
> 
>    I don't recall seeing any Lustre-specific issues being reported 
> here. Do you have any links to bug reports with this configuration?
> 
> >     * any plans to support native clustering on Btrfs
> 
>    No: 
> https://btrfs.wiki.kernel.org/index.php/FAQ#Will_Btrfs_become_a_cluste
> red_file_system
> 
> >     * on ZFS the ZIL is a separate device, any plans to implement a
> the B-Tree log on a separate device?
> 
>    Not that I'm aware of, but it may come out of the work below.
> 
> >     * any plans to allow to have a file system metadata be placed on 
> > a separate device
> 
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Device_IO_Priori
> ties
> 
>    ... but it's not being worked on right now.
> 
>    Hugo.
> 

--
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- There's many a slip 'twixt wicket-keeper and gully. ---       

