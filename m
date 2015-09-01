Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3071 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbbIAHeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 03:34:07 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com> <d5c6fc74720d36f78e378a8bfa50aea164751991.1440997237.git.zhaolei@cn.fujitsu.com> <20150831144821.GU11834@twin.jikos.cz>
In-Reply-To: <20150831144821.GU11834@twin.jikos.cz>
Subject: RE: [PATCH v2 2/4] btrfs-progs: tests: Fix mount fail of 013-extent-tree-rebuild
Date: Tue, 1 Sep 2015 15:34:02 +0800
Message-ID: <013601d0e488$9318ddf0$b94a99d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

Thanks for review.

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Monday, August 31, 2015 10:48 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH v2 2/4] btrfs-progs: tests: Fix mount fail of
> 013-extent-tree-rebuild
> 
> On Mon, Aug 31, 2015 at 01:04:37PM +0800, Zhao Lei wrote:
> > +mount_test_dev()
> > +{
> > +	local loop_opt
> > +	if [[ -b "$TEST_DEV" ]]; then
> > +		loop_opt=()
> > +	elif [[ -f "$TEST_DEV" ]]; then
> > +		loop_opt=(-o loop)
> > +	else
> > +		_fail "Invalid \$TEST_DEV: $TEST_DEV"
> > +	fi
> > +
> > +	[[ -d "$TEST_MNT" ]] || {
> > +		_fail "Invalid \$TEST_MNT: $TEST_MNT"
> > +	}
> > +
> > +	mount "${loop_opt[@]}" "$TEST_DEV" "$TEST_MNT" || _fail "mount
> $TEST_DEV to $TEST_MNT failed"
> 
> This needs the root helper,
>
> besides I don't see a reason why to use the array to
> pass the loop options.
> 
Only personal habit, will not use it in v2.

> On newer systems the option 'loop' is not necessary and mount works with that
> 
Glad to hear it.

> but I don't mind adding support for systems where this does not work. However,
> this should not break current behaviour.
> 
> One thing that I find important is that the full commands are logged via the
> run_check helpers. So I suggest to add run_check_mount_test_dev helper that
> would wrapp all the commands. The combination of shell functions does not
> work in all cases.
>
Ok.

Thanks
Zhaolei


