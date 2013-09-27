Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3I0Scy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 14:32:54 -0400
Date: Fri, 27 Sep 2013 11:32:46 -0700
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: device add should check existing FS
 before adding
Message-ID: <20130927183246.GW30372@lenny.home.zabbo.net>
References: <1380303005-10164-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380303005-10164-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> @@ -49,14 +50,17 @@ static int cmd_add_dev(int argc, char **argv)
>  	int	i, fdmnt, ret=0, e;
>  	DIR	*dirstream = NULL;
>  	int discard = 1;
> +	int force = 0;
> +	char estr[100];
>  
> +		res = test_dev_for_mkfs(argv[i], force, estr);
> +		if (res) {
> +			fprintf(stderr, "%s", estr);
>  			continue;
>  		}

This test_dev_for_mkfs() error string interface is bad.  The caller
should not have to magically guess the string size that the function is
going to use.  Especially because users can trivial provide giant paths
that exhaust that tiny buffer.  If an arbitrarily too small buffer in
the caller was needed at all, its length should have been passed in with
the string pointer.  (Or a string struct that all C projects eventually
grow.)

But all the callers just immediately print it anyway.  Get rid of that
string argument entirely and just have test_dev_for_mkfs() print the
strings.

- z
