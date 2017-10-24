Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbdJXIvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 04:51:32 -0400
Subject: Re: [PATCH] fstests: btrfs/143: make test case more reliable
To: Liu Bo <bo.li.liu@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <20171023205733.14896-1-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <40f9e8d7-6736-a5f2-bba0-56703d5108ca@suse.com>
Date: Tue, 24 Oct 2017 11:51:30 +0300
MIME-Version: 1.0
In-Reply-To: <20171023205733.14896-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.10.2017 23:57, Liu Bo wrote:
> Currently drop_caches is used to invalidate file's page cache so that
> buffered read can hit disk, but the problem is that it may also
> invalidate metadata's page cache, so the test case may not get read
> errors (and repair) if reading metadata has consumed the injected
> faults.
> 
> This changes it to do 'fadvise -d' to firstly access all metadata it
> needs to locate the file and then only drops the test file's page
> cache.  Also this changes it to read the file only if pid%2 == 1.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  tests/btrfs/143 | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tests/btrfs/143 b/tests/btrfs/143
> index da7bfd8..dabd03d 100755
> --- a/tests/btrfs/143
> +++ b/tests/btrfs/143
> @@ -127,16 +127,16 @@ echo "step 3......repair the bad copy" >>$seqres.full
>  # since raid1 consists of two copies, and the bad copy was put on stripe #1
>  # while the good copy lies on stripe #0, the bad copy only gets access when the
>  # reader's pid % 2 == 1 is true
> -while true; do
> -	# start_fail only fails the following buffered read so the repair is
> -	# supposed to work.
> -	echo 3 > /proc/sys/vm/drop_caches
> -	start_fail
> -	$XFS_IO_PROG -c "pread 0 4K" "$SCRATCH_MNT/foobar" > /dev/null &
> -	pid=$!
> -	wait
> -	stop_fail
> -	[ $((pid % 2)) == 1 ] && break
> +while [[ -z ${result} ]]; do
> +    # invalidate the page cache.
> +    $XFS_IO_PROG -c "fadvise -d 0 128K" $SCRATCH_MNT/foobar
> +
> +    start_fail
> +    result=$(bash -c "
> +        if [[ \$((\$\$ % 2)) -eq 1 ]]; then
> +                exec $XFS_IO_PROG -c \"pread 0 4K\" \"$SCRATCH_MNT/foobar\"
> +        fi");
> +    stop_fail

Tested-by: Nikolay Borisov <nborisov@suse.com>


>  done
>  
>  _scratch_unmount
> 
