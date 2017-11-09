Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdKIRFS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 12:05:18 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 85498AAB5
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Nov 2017 17:05:17 +0000 (UTC)
Date: Thu, 9 Nov 2017 18:03:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: test/fsck: Introduce test images
 containing tree reloc tree
Message-ID: <20171109170325.GQ27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031060758.531-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031060758.531-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 02:07:57PM +0800, Qu Wenruo wrote:
> +++ b/tests/fsck-tests/027-tree-reloc-tree/test.sh
> @@ -0,0 +1,22 @@
> +#!/bin/bash
> +# Make sure btrfs check won't report any false alert for valid image with
> +# tree reloc tree.
> +#
> +# Also due to the short life spawn of tree reloc tree, save them as dump
> +# example for later usage.
> +
> +source "$TOP/tests/common"
> +
> +check_prereq btrfs
> +
> +for img in *.img.xz
> +do
> +	image=$(extract_image "$img")
> +	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
> +		grep -q "Errors found in extent allocation tree or chunk allocation"
> +	if [ $? -eq 0 ]; then
> +		rm -f "$image"
> +		_fail "unexpected error occurred when checking $img"
> +	fi
> +	rm -f "$image"
> +done

Please use the test script pattern with the redefinition of check_image
and followed by check_all_images. An example is in
fsck-tests/022-qgroup-rescan-halfway. If you copied that from
fsck-tests/020-extent-ref-cases, then this is a good candidate for a
cleanup. Thanks.
