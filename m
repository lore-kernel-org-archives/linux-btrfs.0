Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38780 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3BRXIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 18:08:43 -0500
Date: Mon, 18 Feb 2013 15:08:42 -0800
From: Zach Brown <zab@zabbo.net>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings
 allocation/deallocation.
Message-ID: <20130218230842.GN22221@lenny.home.zabbo.net>
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
 <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 18, 2013 at 10:04:26PM +0100, Goffredo Baroncelli wrote:
> This patch adds some helpers to manage the strings allocation and
> deallocation.
> The function string_list_add(char *) adds the passed string to a list;
> the function string_list_free() frees all the strings together.

Please don't do this.  To verify that a given pointer isn't freed before
it's used we'd have to make sure that there are no string_list_free()
calls in the interim that would hit their pointer on this global list.

As far as I can tell, this is only used for the pretty units?  Instead
of
	printf("%s", leaked_string(raw));

how about

	printf("%llu%s", scaled_value(raw), static_unit_str(raw));

That'd avoid the need to pass back arbitrary allocated strings and this
code could go away.

> +	if (!strings_to_free) {
> +		fprintf(stderr, "add_string_to_free(): Not enough memory\n");
> +		strings_to_free = 0;

if (a == 0) a = 0?

> +		count_string_to_free = 0;
> +	}
> +
> +	strings_to_free[count_string_to_free-1] = s;

NULL[-1] = s?

- z
