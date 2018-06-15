Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756616AbeFOVGY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 17:06:24 -0400
Date: Fri, 15 Jun 2018 23:06:23 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-btrfs@vger.kernel.org, snitzer@redhat.com, hare@suse.de,
        axboe@kernel.dk, mwilck@suse.com,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] btrfs-progs: detect zoned disks and prevent their raw use
Message-ID: <20180615210623.GQ5527@wotan.suse.de>
References: <20180615205937.8192-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180615205937.8192-1-mcgrof@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2018 at 01:59:37PM -0700, Luis R. Rodriguez wrote:
> +static int is_zoned_disk(char *file)
> +{
> +	char str[PATH_MAX];
> +	char *devname = basename(file);
> +	FILE *f;
> +	int len;
> +
> +	len = snprintf(str, sizeof(str), "/sys/block/%s/queue/zoned", devname);
> +
> +	/* Indicates truncation */
> +	if (len >= PATH_MAX) {
> +		errno = ENAMETOOLONG;
> +		return -1;
> +	}
> +
> +	f = fopen(str, "r");
> +	if (!f)
> +		return 0;
> +
> +	fclose(f);
> +
> +	return 1;
> +}
> +

Seems this needs to be extended to ensure this is host-managed only, will spin
a v2 later.

  Luis
