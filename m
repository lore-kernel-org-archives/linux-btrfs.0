Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:40262 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758605Ab3BSRn2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 12:43:28 -0500
Message-ID: <5123B9EB.7080502@tiscalinet.it>
Date: Tue, 19 Feb 2013 18:44:11 +0100
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
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com> <1361221473-20347-2-git-send-email-goffredo.baroncelli@yahoo.com> <20130218230842.GN22221@lenny.home.zabbo.net> <5123249A.6080502@gmail.com> <20130219172115.GP22221@lenny.home.zabbo.net>
In-Reply-To: <20130219172115.GP22221@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/19/2013 06:21 PM, Zach Brown wrote:
>> Of course, if after string_list_free() some dynamically allocated
>> strings are used then bad things could happen.
> 
> Right.  So let's not make that even possible by not having the code at
> all.
> 
>> Sorry I don't understand the differences between {leaked, scaled,
>> raw}_string. Could you elaborate a bit ?
> 
> The code I saw returned an allocated string that the caller has to worry
> about.  Crummy code just ignores the problem.  You added the global list
> of strings to free at some point in the future.
> 
> I'm suggesting it not allocate at all so that there's nothing to free.
> 
> Instead of:
> 
> 	printf("%s", pretty(value));
> 
> 	char *pretty(u64 value) {
> 		static char *units[] = { "KB", "MB", /* etc */ };
> 		char *str = malloc(20); /*  should be 21 */
> 		sprintf(str, "%llu%s",
> 			scale(value), units[scale_index(value));
> 		global_list_stuff(str);
> 		return str;
> 	}
> 
> Do:
> 
> 	printf("%llu%s", scale(value), unit_string(value));
> 
> 	char *unit(u64 value)
> 	{
> 		static char *units[] = { "KB", "MB", /* etc */ };
> 		return units[scale_index(value));
> 	}
> 
> (all rough code, obviously)
> 
> Then there's nothing for the caller to worry about.


Sorry but this is very dangerous and it leads to very subtle bug: what
happens if someone wrote:

printf("%d%s - %d%s\n", scale(123), unit_string(123),
	scale(123), unit_string(456) );



> 
> Right?
> 
> - z
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
