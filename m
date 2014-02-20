Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbaBTQmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 11:42:23 -0500
Date: Thu, 20 Feb 2014 17:42:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for
 btrfs
Message-ID: <20140220164221.GS16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 19, 2014 at 07:17:51PM +0800, Wang Shilong wrote:
> +u64 btrfs_strtoull(char *str, int base)
> +{
> +	u64 value;
> +	char *ptr_parse_end = NULL;
> +	char *ptr_str_end = str + strlen(str);
> +
> +	value = strtoull(str, &ptr_parse_end, base);
> +	if (ptr_parse_end != ptr_str_end) {
> +		fprintf(stderr, "ERROR: %s is not an invalid unsigned long long integer.\n",
> +				str);
> +		exit(1);

Calling exit() in a helper function makes is unsuitable as a generic
helper or for use from any library function, though all the places where
it's used are in main() so it's similar to usage(), and makes handling
errors in command line arguments easier.

I'm still concerned about the generic function name, but don't have an
idea how to fix it atm.

> +	}
> +	if (value == ULONG_MAX) {
> +		fprintf(stderr, "ERROR: %s is out of range.\n", str);
> +		exit(1);
> +	}
> +	return value;
> +}
