Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44196 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3BZLJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 06:09:56 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Date: Tue, 26 Feb 2013 12:09:53 +0100
Cc: Zach Brown <zab@redhat.com>,
        Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?q?Kj=F6rling?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com> <20130225173808.GH22221@lenny.home.zabbo.net> (sfid-20130225_205250_875827_BF73B40B)
In-Reply-To: <20130225173808.GH22221@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302261209.54617.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 25. Februar 2013 schrieb Zach Brown:
> > I updates my previous patches [1] to add support for raid5/6.
> > These patches update the btrfs fi df command and add two new commands:
> > - btrfs filesystem disk-usage <path>
> > - btrfs device disk-usage <path>
> 
> This seems like a ton of code.
> 
> Here's a thought experiment: What's the smallest possible change that
> could communicate the information that people don't have today?

The kind and amount of information output of these additions have been 
discussed several times before.

I found the output provided quite useful. As others.

Free space seems to be a complex matter in BTRFS and one conclusion was that 
its not easily possible to provide a single number to show how much space is 
free.

I´d still like that for df, whose output is quite bogus in certain BTRFS 
setups at the moment and does not give applications a realistic estimate at 
all. One example is raid 1 with 10 GB each disk. Shows 20 GB free. An 
application which wants to write 15 GB will fail. Which can break installer 
scripts, package management, cache software or anything else which checks 
for free space. Thus I´d like df to default to *minimum* free.

But what is it concretely, what you feel uncomfortable with? The Linux 
kernel is also a ton of code.

I´d really like to see Goffredo improvements go in instead of them being 
discussed endlessly. So I´d like to feedback to be as concrete as possible, 
so Goffredo has a chance to work on it.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
