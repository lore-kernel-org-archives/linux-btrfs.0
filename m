Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3I0R4D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 13:56:03 -0400
Date: Fri, 27 Sep 2013 10:55:59 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/015 regression test for prealloc with
 balance
Message-ID: <20130927175559.GV30372@lenny.home.zabbo.net>
References: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +nr_csum_no_found=$(dmesg | grep -c "no csum found")
> +nr_csum_failed=$(dmesg | grep -c "csum failed")
> +
> +_check_csum_error()
> +{
> +	new_csum_no_found=$(dmesg | grep -c "no csum found")
> +	new_csum_failed=$(dmesg | grep -c "csum failed")
> +
> +	if [ $nr_csum_no_found -eq $new_csum_no_found -a \
> +	     $nr_csum_failed -eq $new_csum_failed ]; then
> +		return 0
> +	fi
> +	return 1
> +}

> +# This sucks but unfortunately it is the only way to be sure something didn't go
> +# wrong.
> +_check_csum_error || _fail "csum detected, please check dmesg"

In the future you could make them trace events and catch them for a
given invocation of a command with perf.

- z
