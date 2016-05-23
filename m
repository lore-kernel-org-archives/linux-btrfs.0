Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbcEWIQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 04:16:32 -0400
Date: Mon, 23 May 2016 16:16:29 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH v2] fstests: generic: Test reserved extent map search
 routine on deduped file
Message-ID: <20160523081629.GH5140@eguan.usersys.redhat.com>
References: <1463038659-21976-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463038659-21976-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 03:37:39PM +0800, Qu Wenruo wrote:
> For fully deduped file, which means all its file exntents are pointing to
> the same bytenr, btrfs can cause soft lockup when calling fiemap ioctl
> on that file, like the following output:
[snip]
> +
> +# then call fiemap on that file to test both the shared flag and if
> +# reserved extent mapping search will cause soft lockup
> +$XFS_IO_PROG -c "fiemap -v" $file | _filter_fiemap_flags > $tmp
> +cat $tmp >> $seqres.full

$tmp won't be removed after test, in _cleanup() it's removing $tmp.*
$tmp.out is better.

> +
> +# refact the $LOAD_FACTOR to 1 to match the golden output
> +sed -i -e "s/$(($last_extent - 1))/$(($orig_last_extent - 1))/" \
> +	-e "s/$last_extent/$orig_last_extent/" \
> +	-e "s/$end/$orig_end/" $tmp
> +cat $tmp

Same here.

Otherwise looks good to me.

Thanks,
Eryu

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/352.out b/tests/generic/352.out
> new file mode 100644
> index 0000000..a87c507
> --- /dev/null
> +++ b/tests/generic/352.out
> @@ -0,0 +1,5 @@
> +QA output created by 352
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +0: [0..2097151]: 0x2000
> +1: [2097152..2097407]: 0x2001
> diff --git a/tests/generic/group b/tests/generic/group
> index 36fb759..3f00386 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -354,3 +354,4 @@
>  349 blockdev quick rw
>  350 blockdev quick rw
>  351 blockdev quick rw
> +352 auto clone
> -- 
> 2.5.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
