Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38835 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab3BSR7t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 12:59:49 -0500
Date: Tue, 19 Feb 2013 09:59:48 -0800
From: Zach Brown <zab@zabbo.net>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings
 allocation/deallocation.
Message-ID: <20130219175948.GQ22221@lenny.home.zabbo.net>
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
 <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com>
 <20130218230842.GN22221@lenny.home.zabbo.net>
 <5123249A.6080502@gmail.com>
 <20130219172115.GP22221@lenny.home.zabbo.net>
 <5123B9EB.7080502@tiscalinet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5123B9EB.7080502@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Sorry but this is very dangerous and it leads to very subtle bug: what
> happens if someone wrote:

"very dangerous"?  I disagree.

If you're worried about the value and units getting out of sync then you
offer some helper macros:

> printf("%d%s - %d%s\n", scale(123), unit_string(123),
> 	scale(123), unit_string(456) );

	#define pty_fmt "%llu%s"
	#define pty_arg(v) scale(v), unit_string(v)

	printf(pty_fmt, pty_arg(v));

The kernel used to print ipv4 addresses like this before it grew its own
%pI4 format specifier.

- z
