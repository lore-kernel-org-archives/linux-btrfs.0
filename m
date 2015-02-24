Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbbBXXkK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 18:40:10 -0500
Message-ID: <54ED0BD5.3040504@redhat.com>
Date: Tue, 24 Feb 2015 17:40:05 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] fstests: generic test for directory fsync after adding
 hard links
References: <1424370551-18884-1-git-send-email-fdmanana@suse.com> <1424820589-3593-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1424820589-3593-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/24/15 5:29 PM, Filipe Manana wrote:
> This test is motivated by an fsync issue discovered in btrfs.
> The issue was that after adding a new hard link to an existing file
> (one that was created in a past transaction) and fsync'ing the parent
> directory of the new hard link, after the fsync log replay the file's
> inode link count did not get its link count incremented, while the new
> directory entry was visible.
> Also, unlike xfs and ext4, new files under the directory we fsync were
> not being written to the fsync log, nor were any child directories and
> new files and links under the children directories. So this test verifies
> too that btrfs has the same behaviour as xfs and ext4.
> 
> The btrfs issue was fixed by the following linux kernel patch:
> 
>   Btrfs: fix metadata inconsistencies after directory fsync
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Make use of the new function '_require_metadata_journaling' added
>     by Eric. Make the test pass on ext3 - unlike ext4 (and xfs), the
>     file hello gets all its data synced, so we don't get an empty file
>     after the fsync log is replayed.
> 
> V3: Make our file 'foo' not empty and verify that after log replay its
>     content remains unchanged. Motivated by an issue found during development
>     of the btrfs fix.
> 
>  tests/generic/060     | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/060.out |  11 ++++
>  tests/generic/group   |   1 +
>  3 files changed, 187 insertions(+)
>  create mode 100755 tests/generic/060
>  create mode 100644 tests/generic/060.out
> 
> diff --git a/tests/generic/060 b/tests/generic/060
> new file mode 100755
> index 0000000..0d459fa
> --- /dev/null
> +++ b/tests/generic/060
> @@ -0,0 +1,175 @@
> +#! /bin/bash
> +# FS QA Test No. 060
> +#
> +# This test is motivated by an fsync issue discovered in btrfs.
> +# The issue was that after adding a new hard link to an existing file (one that
> +# was created in a past transaction) and fsync'ing the parent directory of the
> +# new hard link, after the fsync log replay the file's inode link count did not
> +# get its link count incremented, while the new directory entry was visible.
> +# Also, unlike xfs and ext4, new files under the directory we fsync were not
> +# being written to the fsync log, nor were any child directories and new files
> +# and links under the children directories. So this test verifies too that
> +# btrfs has the same behaviour as xfs and ext3/4.
> +#
> +# The btrfs issue was fixed by the following linux kernel patch:
> +#
> +#  Btrfs: fix metadata inconsistencies after directory fsync


I still would like to know *what this test does* - not some narrative about
btrfs's troubled past.  ;)

Could you please add that line or two, and feel free to keep all the detail about
the btrfs-specific bug later?  We're getting a lot of these tests, and a
short description of what a test does is just How We Do It(tm).  It saves having to 
read a lot of bash code just to get some idea of what is under test.

i.e. like this, or whatever is accurate:

# Test that link counts remain correct after fsyncing a parent directory
# containing hardlinks, and subsequent log recovery
#
# <insert fascinating btrfs story here>

Please just do this; it'll save people time, down the line, if/when
this test fails in the future, or needs to be maintained by someone
else.

If btrfs folks don't want simple test descriptions under tests/btrfs, your choice,
but I really would like to have this clarity on the generic tests.

Thanks,
-Eric
