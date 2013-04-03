Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47223 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab3DCUgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 16:36:24 -0400
Message-ID: <515C92C6.8010506@sandeen.net>
Date: Wed, 03 Apr 2013 15:36:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: rjohnston@sgi.com
CC: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] cleanup duplicates in all tests
References: <20130403173245.376605011@sgi.com>
In-Reply-To: <20130403173245.376605011@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/3/13 12:31 PM, rjohnston@sgi.com wrote:
> There are duplicate blank lines, comment hash and lines
> containing duplicate seqres= declarations, remove them.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  tests/btrfs/254   |    3 ---
>  tests/btrfs/264   |    4 ----
>  tests/btrfs/265   |    3 ---
>  tests/btrfs/276   |    3 ---
>  tests/btrfs/284   |    3 ---

nothing but dup line removal:

$ egrep "^[-+][a-z]" bigpatch  | sort | uniq
-seqres=$RESULT_DIR/$seq

and every file still has one left:

$ for FILE in `guilt files`; do grep -c "seqres=$RESULT_DIR" $FILE; done | sort | uniq
1

Looks good to me!  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric
