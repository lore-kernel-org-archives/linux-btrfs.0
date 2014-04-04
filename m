Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39883 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaDDWga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 18:36:30 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 05 Apr 2014 00:35:08 +0200
Message-ID: <7675297.F25Z3Ox7Yz@tethys>
In-Reply-To: <20140404150906.GR7442@carfax.org.uk>
References: <2692878.dRG1K49eOP@fnix> <20140404150906.GR7442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 4 avril 2014 16:09:06 Hugo Mills a écrit :
> We don't have lots of reports of massive slowdowns
> after a long period of use, so whatever you're doing, there seems to
> be something unusual involved.
>
>    It's almost certainly not your fault, but there would appear to be
> something in your configuration or your use-case which is leading to
> these problems, and without knowing what's different, it's hard to set
> about identifying the problem.

I would have hard times finding what ! I have seen this on each and every 
machine on which I have installed BTRFS over the past 2 years. These first were 
Ubuntus, now there is one Mint, 2 Arch, 1 Fedora, all with decently recent 
kernels and "alls updates applied".

All those machines do "mainly boring office tasks", email, web surf, word 
processing, spreadsheets. No databases except for system packages DB and KDE 
"akonadi" email storage... Few compilations, if any, no heavy disk tasks, all 
mounted with noatime, space_cache, inode_cache, etc...

No torrents, no bitcoins, very seldom used Virtualbox (and this is nocow).

No filesystem is over 80% full, some are below 20%...

No filesystems currently have more than 4 active snapshots.

All get slow like hell over time.

> How are you measuring the slowdown -- do you have a
> specific piece of benchmarking software, or just anecdotal evidence?

When your system slowly shifts from "normally responsive" to "dreadfully slow" 
over time, that starting any app takes over a full minute with HD LED steady 
lit, that booting bhas become so long that the GUI DM dies of timeout before 
it even starts, and you have to restart it manualle... you can tell it's gone 
"sloooooow" without any benchmark figures...

(Disk health good on all machines...)

Go figure...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

