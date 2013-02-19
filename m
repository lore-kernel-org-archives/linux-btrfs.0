Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38855 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545Ab3BSVkV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 16:40:21 -0500
Date: Tue, 19 Feb 2013 13:40:20 -0800
From: Zach Brown <zab@zabbo.net>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings
 allocation/deallocation.
Message-ID: <20130219214020.GR22221@lenny.home.zabbo.net>
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
 <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com>
 <20130218230842.GN22221@lenny.home.zabbo.net>
 <5123249A.6080502@gmail.com>
 <20130219172115.GP22221@lenny.home.zabbo.net>
 <5123B9EB.7080502@tiscalinet.it>
 <20130219175948.GQ22221@lenny.home.zabbo.net>
 <5123EE84.8000502@tiscalinet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5123EE84.8000502@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> No my complaint was related to another thing; but I was wrong. Anyway
> your suggestion is not so easy applicable, and (IMHO) I don't see any
> difficulty to remember to call string_list_free() only at the end of the
> code.

Understood, and I disagree.  It's simply not needed.

- z
