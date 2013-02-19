Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38822 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab3BSRVQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 12:21:16 -0500
Date: Tue, 19 Feb 2013 09:21:15 -0800
From: Zach Brown <zab@zabbo.net>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings
 allocation/deallocation.
Message-ID: <20130219172115.GP22221@lenny.home.zabbo.net>
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
 <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com>
 <20130218230842.GN22221@lenny.home.zabbo.net>
 <5123249A.6080502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5123249A.6080502@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Of course, if after string_list_free() some dynamically allocated
> strings are used then bad things could happen.

Right.  So let's not make that even possible by not having the code at
all.

> Sorry I don't understand the differences between {leaked, scaled,
> raw}_string. Could you elaborate a bit ?

The code I saw returned an allocated string that the caller has to worry
about.  Crummy code just ignores the problem.  You added the global list
of strings to free at some point in the future.

I'm suggesting it not allocate at all so that there's nothing to free.

Instead of:

	printf("%s", pretty(value));

	char *pretty(u64 value) {
		static char *units[] = { "KB", "MB", /* etc */ };
		char *str = malloc(20); /*  should be 21 */
		sprintf(str, "%llu%s",
			scale(value), units[scale_index(value));
		global_list_stuff(str);
		return str;
	}

Do:

	printf("%llu%s", scale(value), unit_string(value));

	char *unit(u64 value)
	{
		static char *units[] = { "KB", "MB", /* etc */ };
		return units[scale_index(value));
	}

(all rough code, obviously)

Then there's nothing for the caller to worry about.

Right?

- z
