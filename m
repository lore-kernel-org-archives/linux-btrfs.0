Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f181.google.com ([209.85.210.181]:36591 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161506Ab3BONsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 08:48:14 -0500
Received: by mail-ia0-f181.google.com with SMTP id e16so2942188iaa.40
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 05:48:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
References: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
Date: Fri, 15 Feb 2013 21:48:03 +0800
Message-ID: <CAP9B-QnK_7KCQ5e0HvUAb-dMhqWK7UqYOn+0GZWaq=UzGL1Q2Q@mail.gmail.com>
Subject: Re: [btrfs-progs] testing btrfs hierarchical quotas
From: shilong wang <wangshilong1991@gmail.com>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, hugo@carfax.org.uk, sandeen@redhat.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

2013/2/15 Hemanth Kumar <hemanthkumar51@gmail.com>:
>
> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
> ---
>  hq.sh | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 hq.sh
>
> diff --git a/hq.sh b/hq.sh
> new file mode 100644
> index 0000000..6a0a820
> --- /dev/null
> +++ b/hq.sh
> @@ -0,0 +1,33 @@
> +#! /bin/bash
> +# Btrfs quotas test case
> +# Hi all,
> +# This is shell script to test the hierarchical quotas feature of Btrfs
> +# I created Btrfs filesystem on a new
> +# partition, then activated quota management ('btrfs quota enable'), and
> +# created a few subvolumes of multiple levels.
> +
> +
> +cleanup()
> +{
> +    btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
> +    btrfs subvolume delete $TEST_DIR/vol1/vol2
> +    btrfs subvolume delete $TEST_DIR/vol1
> +    btrfs subvolume disable $TEST_DIR
> +}
> +
> +#trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +btrfs quota enable $TEST_DIR
> +echo "quota enabled on $TEST_DEV"
> +btrfs subvolume create $TEST_DIR/vol1
> +btrfs subvolume create $TEST_DIR/vol1/vol2
> +btrfs subvolume create $TEST_DIR/vol1/vol2/vol3
> +btrfs qgroup limit 5m $TEST_DIR/vol1
> +btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
> +btrfs qgroup limit 2m $TEST_DIR/vol1/vol2/vol3
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file1 bs=3M count=1
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file1 bs=2M count=1
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1

btrfs quota limit is not precise. It allows a little deviation. So if
we limit a subvolume 3M,
what we can write must be less than 3M.

What's more, for a subvolume, metadata is included in a subvolume
quota...(4KB)..

What i really want to say is that btrfs quota is a little complex, To
test  hierarchical quotas feature
still needs more things to consider...maybe you should have a deep
understanding of it firstly...

However, this is a good start i think.  ^_^

Thanks,
Wang

> +
> +cleanup
> +exit
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
