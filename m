Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3IIQcH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 12:32:07 -0400
Date: Mon, 9 Sep 2013 18:32:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add make test framework
Message-ID: <20130909163204.GR32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378493456-5382-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378493456-5382-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 06, 2013 at 02:50:56PM -0400, Josef Bacik wrote:
> We need to start adding some sanity tests to btrfs-progs to make sure we aren't
> breaking things with our patches.  The most important of these tools is btrfsck.
> This patch gets things started by adding a basic btrfsck test that makes sure we
> can fix a corruption problem we know we can fix.  Thanks,

That's great. I hope we're going to gather more tests so let's separate
them to more categories from the beginning (mkfs, options coverage,
corrupt-block, restore maybe, dunno what else).

This makes it possible to do a quick run a subset of the tests (eg. mkfs
related) after a fix is committed.

>  tests/bad-file-extent-bytenr.img |  Bin 0 -> 4096 bytes
>  tests/fsck-tests.sh              |   34 ++++++++++++++++++++++++++++++++++

I suggest to put them into a subdirectory (eg.) 'fsck' and prefix the
images with numbers (just a sequence number).

> --- /dev/null
> +++ b/tests/fsck-tests.sh
> @@ -0,0 +1,34 @@
> +#!/bin/bash
> +#
> +# loop through all of our bad images and make sure fsck repairs them properly
> +#
> +# It's GPL, same as everything else in this tree.
> +#
> +
> +TEST_DEV=""

I found the current test hard to use, eg. I can't just do 'make test'
from the toplevel dir. The script fsck-tests.sh expects TEST_DEV to be
set, but there's no way to do that, because it's set unconditionally to
empty string.

> +here=`pwd`
> +
> +_fail()
> +{
> +	echo "$*" | tee -a fsck-tests-results.txt
> +	exit 1
> +}
> +
> +[ -z $TEST_DEV ] && echo "Cannot run without a test device set" && exit 0
> +
> +rm -f fsck-tests-results.txt
> +
> +for i in $(find tests -name '*.img')
> +do
> +	echo "testing image $i" >> fsck-tests-results.txt
> +	$here/btrfs-image -r $i $TEST_DEV >> fsck-tests-results.txt 2>&1 \
> +		|| _fail "restore failed"
> +	$here/btrfsck $TEST_DEV >> fsck-test-results.txt 2>&1
> +	[ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
> +
> +	$here/btrfsck --repair $TEST_DEV >> fsck-test-results.txt 2>&1 || \
> +		_fail "btrfsck should have repaired the image"
> +
> +	$here/btrfsck $TEST_DEV >> fsck-test-results.txt 2>&1 || \
> +		_fail "btrfsck did not correct corruption"
> +done
