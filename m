Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbbHaOtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 10:49:01 -0400
Date: Mon, 31 Aug 2015 16:48:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs-progs: tests: Fix mount fail of
 013-extent-tree-rebuild
Message-ID: <20150831144821.GU11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
 <d5c6fc74720d36f78e378a8bfa50aea164751991.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d5c6fc74720d36f78e378a8bfa50aea164751991.1440997237.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 01:04:37PM +0800, Zhao Lei wrote:
> +mount_test_dev()
> +{
> +	local loop_opt
> +	if [[ -b "$TEST_DEV" ]]; then
> +		loop_opt=()
> +	elif [[ -f "$TEST_DEV" ]]; then
> +		loop_opt=(-o loop)
> +	else
> +		_fail "Invalid \$TEST_DEV: $TEST_DEV"
> +	fi
> +
> +	[[ -d "$TEST_MNT" ]] || {
> +		_fail "Invalid \$TEST_MNT: $TEST_MNT"
> +	}
> +
> +	mount "${loop_opt[@]}" "$TEST_DEV" "$TEST_MNT" || _fail "mount $TEST_DEV to $TEST_MNT failed"

This needs the root helper, besides I don't see a reason why to use the
array to pass the loop options.

On newer systems the option 'loop' is not necessary and mount works with
that but I don't mind adding support for systems where this does not
work. However, this should not break current behaviour.

One thing that I find important is that the full commands are logged via
the run_check helpers. So I suggest to add run_check_mount_test_dev
helper that would wrapp all the commands. The combination of shell
functions does not work in all cases.
