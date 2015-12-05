Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:34236 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbLEFwx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 00:52:53 -0500
In-Reply-To: <1449286104.18841.14.camel@scientia.net>
References: <20151204120529.37E47D5A28@emkei.cz> <20151204130758.GR8775@carfax.org.uk> <1449286104.18841.14.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: attacking btrfs filesystems via UUID collisions? (was: Subvolume UUID, data corruption?)
From: Christoph Anton Mitterer <calestyo@scientia.net>
Date: Sat, 05 Dec 2015 06:52:51 +0100
To: Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Message-ID: <01D8193E-AA40-40F5-BAC7-0C711AA2E0B3@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thinking a bit more I that, I came to the conclusion that it's actually security relevant that btrfs deals gracefully with filesystems having the same UUID:

Getting to know someone else's filesystem's UUID may be more easily possible than one may think.
It's usually not considered secret and for example included in debug reports (e.g. several Debian packages do this).

The only thing an attacker then needs to do is somehow making another filesystem with the UUID available in his victims system.
Simplest way is via a USB stick when he has local access.
Thanks to some stupid desktop environments, chances aren't to bad that the system will even auto mount the stick.

If btrfs doesn't handle this gracefully the attacker may damage or destroy the original filesystem, or if things get awkwardly corrupted (and data is written to the fake btrfs) even get data out of such a system (despite any screen locks or dm-crypt).

Cheers
Chris.
