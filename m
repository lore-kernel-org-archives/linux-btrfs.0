Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:51352 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757818Ab3CYNnZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 09:43:25 -0400
Message-ID: <5150547C.60606@sgi.com>
Date: Mon, 25 Mar 2013 08:43:24 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Dave Chinner <david@fromorbit.com>, xfstests <xfs@oss.sgi.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests 276: use _require_no_large_scratch_dev instead
 of the removed _require_nobigloopfs
References: <514AA503.4060101@gmail.com>
In-Reply-To: <514AA503.4060101@gmail.com>
Content-Type: multipart/mixed;
	boundary="------------080504090506070201060309"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------080504090506070201060309
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 03/21/2013 01:13 AM, Wang Sheng-Hui wrote:
> _require_nobigloopfs has been removed.
> We should use _require_no_large_scratch_dev in the test script.
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>   276 |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/276 b/276
> index 40b30cf..87363ca 100755
> --- a/276
> +++ b/276
> @@ -58,8 +58,7 @@ _need_to_be_root
>   _supported_fs btrfs
>   _supported_os Linux
>   _require_scratch
> -
> -_require_nobigloopfs
> +_require_no_large_scratch_dev
>   _require_btrfs inspect-internal
>   _require_command "/usr/sbin/filefrag"
>

Thanks for the patch.

Not sure what is wrong with your patch (trailing space maybe),
but it could not be imported using git quiltimport.

The patch itself makes sense so I have committed the attached:

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

commit 07c1f8d7bae36f2c28ffee6f09c318b1142b6f90
Author: Wang Sheng-Hui <shhuiw@gmail.com>
Date:   Thu Mar 21 06:13:23 2013 +0000

     xfstests 276: use _require_no_large_scratch_dev instead of the 
removed _require_nobigloopfs

--------------080504090506070201060309
Content-Type: text/x-patch; name="p276.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="p276.patch"

>From patchwork Thu Mar 21 06:13:23 2013
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: xfstests 276: use _require_no_large_scratch_dev instead of the
 removed _require_nobigloopfs
Date: Thu, 21 Mar 2013 06:13:23 -0000
From: Wang Sheng-Hui <shhuiw@gmail.com>
X-Patchwork-Id: 5083
Message-Id: <514AA503.4060101@gmail.com>
To: Dave Chinner <david@fromorbit.com>, xfstests <xfs@oss.sgi.com>,
 linux-btrfs@vger.kernel.org

_require_nobigloopfs has been removed.
We should use _require_no_large_scratch_dev in the test script.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 276 |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/276
===================================================================
--- a/276
+++ b/276
@@ -58,8 +58,7 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-
-_require_nobigloopfs
+_require_no_large_scratch_dev
 _require_btrfs inspect-internal
 _require_command "/usr/sbin/filefrag"
 

--------------080504090506070201060309--
