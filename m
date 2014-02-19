Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbaBSRXg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 12:23:36 -0500
Message-ID: <5304E891.8040606@redhat.com>
Date: Wed, 19 Feb 2014 11:23:29 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for
 btrfs
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <5304D1F6.8040902@libero.it> <282C2CC4-898B-40A6-82CB-27461AD77C5C@gmail.com> <5304DC5B.9050707@inwind.it>
In-Reply-To: <5304DC5B.9050707@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/19/14, 10:31 AM, Goffredo Baroncelli wrote:
...

 
> The error message says that the value is out of range. But doesn't tell which
> is the parameter involved.
> If you have a command which has several arguments, and the user pass a string
> instead of a number, the error returned doesn't tell which argument is wrong.
> This is the reason of my complaint. 
> 
> At least add a fourth parameter which contains the name of the parameter 
> parsed in order to improve the error message.
> 
> I.E.
> 
> 	subvol_id = btrfs_strtoull(argv[i], 10, "subvolume ID");
> 
> If the user pass a path instead of a number the error message would be
> 
>   ERROR: xxxx is not a valid unsigned long long integer for the parameter 'subvolume ID'.
> 
> Or something like that.

I'm not so sure that this is needed.  Adding it makes the code a little more complicated,
and requires each caller to send in a string which may get out of sync with the actual
argument name (or the manpage, or the help/usage text).

The user has *just* typed it in, so it won't be too hard to see which one
was wrong even without naming the parameter, i.e. -

# btrfs foo-command 12345 0 123notanumber
Error: 123notanumber is not a valid numeric value

or

# btrfs baz-command 0xFFFFFFFFFFFFFFFF 12345 0
Error: numeric value 0xFFFFFFFFFFFFFFFF is too large.

would probably suffice, without bothering to name the parameter.

I'd also suggest not referring to "unsigned long long" or "out of range" which
might not mean much to people who aren't programmers; "not a valid value"
or "too large" might be clearer.

Also, what if someone enters a negative number?  Right now it happily
accepts it and converts it to an unsigned value:

# ./test-64bit -123
Parsed as 18446744073709551493

but an inadvertent negative sign might lead to highly unexpected results.

Just my $0.02.

-Eric
