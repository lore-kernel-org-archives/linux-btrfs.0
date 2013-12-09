Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm10-vm6.access.bullet.mail.gq1.yahoo.com ([216.39.63.158]:31499
	"HELO nm10-vm6.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753993Ab3LIVHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 16:07:12 -0500
References: <1386615086.1044.YahooMailNeo@web180901.mail.ne1.yahoo.com> <1386619322.61331.YahooMailNeo@web180902.mail.ne1.yahoo.com> <20131209200856.GF9738@carfax.org.uk> <1386623127.31132.YahooMailNeo@web180903.mail.ne1.yahoo.com>
Message-ID: <1386623231.94746.YahooMailNeo@web180901.mail.ne1.yahoo.com>
Date: Mon, 9 Dec 2013 13:07:11 -0800 (PST)
From: Cirillo Costantino <linoc@pacbell.net>
Reply-To: Cirillo Costantino <linoc@pacbell.net>
Subject: Re: Btrfs questions
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "\"linux-btrfs@vger.kernel.org\"" <linux-btrfs@vger.kernel.org>
In-Reply-To: <1386623127.31132.YahooMailNeo@web180903.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

resending in plain text


________________________________
From: Cirillo Costantino <linoc@pacbell.net>
To: Hugo Mills <hugo@carfax.org.uk> 
Cc: ""linux-btrfs@vger.kernel.org"" <linux-btrfs@vger.kernel.org> 
Sent: Monday, December 9, 2013 1:05 PM
Subject: Re: Btrfs questions



thanks Hugo,

the link you sent indicates that has been "submitted" but it is not in a kernel release... does it mean it could be in a 3.14 or 15 release? 

with the release of Haswell from Intel, persistent memory will be possible and cheap... portions of this memory could be made visible as block devices and mirrored for protection to a neighboring system for later replay in the event of a crash or power outage; how are such feature request be included in btrfs?

lino


________________________________
From: Hugo Mills <hugo@carfax.org.uk>
To: Cirillo Costantino <linoc@pacbell.net> 
Cc: ""linux-btrfs@vger.kernel.org"" <linux-btrfs@vger.kernel.org> 
Sent: Monday, December 9, 2013 12:08 PM
Subject: Re: Btrfs questions


On Mon, Dec 09, 2013 at 12:02:02PM -0800, Cirillo Costantino wrote:
> 
> 
> i am looking at using btrfs for a new project and i have a few questions:
> 
>     * i have heard that as it currently stands Btrfs has some issues to be used as a Lustre file system; is he aware of the issues and any plans to address these and integrate Btrfs in to Lustre

   I don't recall seeing any Lustre-specific issues being reported
here. Do you have any links to bug reports with this configuration?

>     * any plans to support native clustering on Btrfs

   No: https://btrfs.wiki.kernel.org/index.php/FAQ#Will_Btrfs_become_a_clustered_file_system

>     * on ZFS the ZIL is a separate device, any plans to implement a
the B-Tree log on a separate device?

   Not that I'm aware of, but it may come out of the work below.

>     * any plans to allow to have a file system metadata be placed on a separate device

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Device_IO_Priorities

   ... but it's not being worked on right now.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no.  5: Manifesto Promise
---    
