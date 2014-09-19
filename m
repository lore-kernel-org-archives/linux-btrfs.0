Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35694 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaISM00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 08:26:26 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: rob@robspanton.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
Date: Fri, 19 Sep 2014 14:25:52 +0200
Message-ID: <1779590.cL85uaaAL2@vajra>
In-Reply-To: <1411129114.1811.7.camel@zarniwoop.blob>
References: <1411129114.1811.7.camel@zarniwoop.blob>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 19 septembre 2014, 13:18:34 Rob Spanton a écrit :
> I have a particularly uncomplicated setup (a desktop PC with a hard
> disk) and I'm seeing particularly slow performance from btrfs.

Weeelll I have the same over-complicated kind of setup, and an Arch Linux 
BTRFS system which used to boot in some decent amout of time in the past now 
takes about 5 full minutes to just make it to the KDM login prompt, and 
another 5 minutes before KDE is fully started. Makes me think of the good ole' 
times of Windows 95 OSR2 on a 486SX with a dying 1 GB Hard disk...

Now, let me add that I had removed all snaphots, ran a full defrag, and even 
rebalanced the damn thing without any positive effect...

(And yes, my HD is physically in good shape, SMART feels fully happy, and it's 
less than 75% full...)

I've been using BTRFS for 2-3 years on a dozen of different systems, and if 
something doesn't surprise me at all, it's « slow performance », indeed, 
although I'm myself more accustomed to « incredibly fscking damn slow 
performance »...

HTH

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

Un homme ne doit pas avaler plus de bobards qu'il ne peut en digérer.
-- Henry Brooks Adams

