Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51228 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134Ab3JPPKY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 11:10:24 -0400
Message-ID: <525EAC5F.3040201@sandeen.net>
Date: Wed, 16 Oct 2013 10:10:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, dsterba@suse.cz,
        jbacik@fusionio.com
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
> This test is motivated by an issue found by a btrfs user, addressed
> and described by the following GNU/Linux kernel patch:
> 
> https://patchwork.kernel.org/patch/3046931/

Hi Filipe, thanks for the patch.

Usually we don't want to add new, possibly-failing cases to old tests;
that makes it harder to identify when the code regressed vs. when
the test changed to test new things.

It would be better to just copy the framework of tests/shared/051
to a new test in shared/ and test only this new inheritance
problem.

Also, I'm confused about this hunk:

> @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
>  getfacl --numeric largeaclfile | _filter_aces
>  
>  echo "1 above xfs acl max"
> -chacl $acl3 largeaclfile
> +if [ "$FSTYP" != "btrfs" ]; then
> +	chacl $acl3 largeaclfile
> +else
> +	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
> +fi
> +
>  getfacl --numeric largeaclfile | _filter_aces
>  
>  echo "use 16 aces"

What's that about?

Thanks,
-Eric

