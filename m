Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:65102 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3BZL2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 06:28:35 -0500
Received: by mail-qa0-f51.google.com with SMTP id cr7so2341747qab.10
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 03:28:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302261209.54617.Martin@lichtvoll.de>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
	<20130225173808.GH22221@lenny.home.zabbo.net>
	<201302261209.54617.Martin@lichtvoll.de>
Date: Tue, 26 Feb 2013 22:28:34 +1100
Message-ID: <CA+WRLO-Tx0sUQd3ibszckzayUFvK9KJqWcQHrkDoEf2F-yo-+Q@mail.gmail.com>
Subject: Re: [PATCH V2][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
From: Gareth Pye <gareth@cerberos.id.au>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Zach Brown <zab@redhat.com>,
        Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 10:09 PM, Martin Steigerwald
<Martin@lichtvoll.de> wrote:
> I´d still like that for df, whose output is quite bogus in certain BTRFS
> setups at the moment and does not give applications a realistic estimate at
> all. One example is raid 1 with 10 GB each disk. Shows 20 GB free. An
> application which wants to write 15 GB will fail. Which can break installer
> scripts, package management, cache software or anything else which checks
> for free space. Thus I´d like df to default to *minimum* free.

Is that any better than the script failing to attempt to install
because it needs 15G but because some of the storage is used in RAID1
then df shows 10G free but the 15G install would work fine. If you
could force the tool to install where it know it doesn't have
sufficient space?


-- 
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
