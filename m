Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:38240 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933763Ab3BSV1h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 16:27:37 -0500
Message-ID: <5123EE84.8000502@tiscalinet.it>
Date: Tue, 19 Feb 2013 22:28:36 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com> <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com> <20130218230842.GN22221@lenny.home.zabbo.net> <5123249A.6080502@gmail.com> <20130219172115.GP22221@lenny.home.zabbo.net> <5123B9EB.7080502@tiscalinet.it> <20130219175948.GQ22221@lenny.home.zabbo.net>
In-Reply-To: <20130219175948.GQ22221@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/19/2013 06:59 PM, Zach Brown wrote:
>> Sorry but this is very dangerous and it leads to very subtle bug: what
>> happens if someone wrote:
> 
> "very dangerous"?  I disagree.
> 
> If you're worried about the value and units getting out of sync then you
> offer some helper macros:

No my complaint was related to another thing; but I was wrong. Anyway
your suggestion is not so easy applicable, and (IMHO) I don't see any
difficulty to remember to call string_list_free() only at the end of the
code.

> 
>> printf("%d%s - %d%s\n", scale(123), unit_string(123),
>> 	scale(123), unit_string(456) );
> 
> 	#define pty_fmt "%llu%s"
> 	#define pty_arg(v) scale(v), unit_string(v)
> 
> 	printf(pty_fmt, pty_arg(v));
> 
> The kernel used to print ipv4 addresses like this before it grew its own
> %pI4 format specifier.
> 
> - z
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
