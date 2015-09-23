Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbbIWMZt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 08:25:49 -0400
Date: Wed, 23 Sep 2015 14:24:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs-progs: tests: Introduce
 fsck-tests/018-leaf-across-stripes
Message-ID: <20150923122453.GW12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442992715.git.zhaolei@cn.fujitsu.com>
 <41f2b91edfcdba796ca331bafbc6195544609c14.1442992715.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <41f2b91edfcdba796ca331bafbc6195544609c14.1442992715.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 23, 2015 at 03:19:05PM +0800, Zhao Lei wrote:
> +
> +image=$(extract_image "./default_case.raw.xz")
> +$TOP/btrfs check "$image" 2>&1 |

It's better to use 'run_check_stdout' here as this will store the output
to the log as well. I've fixed that and applied, thanks.

> +	grep -q "crossing stripe boundary" ||
> +	_fail "no expected error message in output"
> +
> +rm -f "$image"
