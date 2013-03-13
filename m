Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244Ab3CMVbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 17:31:18 -0400
Date: Wed, 13 Mar 2013 14:31:12 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>, Peter Stuge <peter@stuge.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] restore: Add regex matching of paths and files to
 be restored
Message-ID: <20130313213112.GA3565@lenny.home.zabbo.net>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
 <1363109897-7931-7-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363109897-7931-7-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The option -m is used to specify the regex string. -c is used to
> specify case insensitive matching. -i was already taken.

I guess that's cool if someone really wanted to use the full power of
regexes.

> In order to restore only a single folder somewhere in the btrfs
> tree, it is unfortunately neccessary to construct a slightly
> nontrivial regex, e.g.:
> 
> restore -m '^/(|home(|/username(|/Desktop(|/.*))))$' /dev/sdb2 /output

But that example is just bonkers and suggests that we should also
support globs for fnmatch(3). (-g is for glob? :))

> +	const char *match_regstr = NULL;
> +	int match_cflags = REG_EXTENDED | REG_NOSUB | REG_NEWLINE;
> +	regex_t match_reg, *mreg = NULL;
> +	char reg_err[256];


> +	if (match_regstr) {
> +		ret = regcomp(&match_reg, match_regstr, match_cflags);
> +		if (ret) {
> +			regerror(ret, &match_reg, reg_err, sizeof(reg_err));
> +			fprintf(stderr, "Regex compile failed: %s\n", reg_err);
> +			goto out;
> +		}
> +		mreg = &match_reg;
> +	}

And this should probably be in a helper function.  Especially if it also
grows fnmatch() support.

- z
