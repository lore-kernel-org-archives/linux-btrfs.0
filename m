Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbaEIUSB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:18:01 -0400
Message-ID: <536D37F6.90603@redhat.com>
Date: Fri, 09 May 2014 15:17:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: filter out selinux xattrs for generic/062
References: <1399664668-719-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1399664668-719-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/9/14, 2:44 PM, Josef Bacik wrote:
> If you have selinux enabled getfattr will show the selinux xattrs, which screws
> with the golden output of generic/062.  To make matters worse you can't just
> greap it out because we'll still get the preamble and newline from getfattr when
> the selinux attr is the only attr.  So this is the voodoo I came up with after
> way more time than I'm comfortable admitting to make this test pass if you have
> selinux enabled.  Thanks,

I thought that we were pretty much universally mounting with an selinux
context, rather than allowing selinux to add its own on-disk attrs.

Why is that not the case for this test?

Works for me on this old kernel anyway:

[root@bp-05 xfstests]# getenforce
Enforcing
[root@bp-05 xfstests]# ./check generic/062
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 bp-05 2.6.32
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdc2
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdc2 /mnt/scratch

generic/062 60s ... 3s
Ran: generic/062
Passed all 1 tests

Note the mount options above...

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  common/filter     | 6 ++++++
>  tests/generic/062 | 3 ++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/common/filter b/common/filter
> index 05dbae6..16a01ed 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -323,5 +323,11 @@ _filter_ro_mount() {
>  	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
>  }
>  
> +# Filter out selinux xattrs from getfattr, and if selinux is the only xattr in
> +# the file simply pretend like there were no xattrs
> +_filter_selinux_xattr() {
> +	grep -v selinux | sed -e "N; s/^\# file: .*\n$//; /^$/d"
> +}
> +
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/generic/062 b/tests/generic/062
> index 047c930..32f0bca 100755
> --- a/tests/generic/062
> +++ b/tests/generic/062
> @@ -47,7 +47,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  getfattr()
>  {
> -    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
> +    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch | \
> +	_filter_selinux_xattr
>  }
>  
>  setfattr()
> 

