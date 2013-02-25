Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759163Ab3BYRjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 12:39:41 -0500
Date: Mon, 25 Feb 2013 09:38:08 -0800
From: Zach Brown <zab@redhat.com>
To: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH V2][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Message-ID: <20130225173808.GH22221@lenny.home.zabbo.net>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I updates my previous patches [1] to add support for raid5/6.
> These patches update the btrfs fi df command and add two new commands:
> - btrfs filesystem disk-usage <path>
> - btrfs device disk-usage <path>

This seems like a ton of code.

Here's a thought experiment: What's the smallest possible change that
could communicate the information that people don't have today?

- z
