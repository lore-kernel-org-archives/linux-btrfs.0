Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63106 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161562Ab3BONuP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 08:50:15 -0500
Received: by mail-ie0-f179.google.com with SMTP id k11so4762987iea.10
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 05:50:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
References: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
Date: Fri, 15 Feb 2013 21:50:14 +0800
Message-ID: <CAP9B-Qm0pv8aEopQPiN8wJezaUm9M=F0Mn1YBkcgm7FPt62TVA@mail.gmail.com>
Subject: Re: [btrfs-progs] Btrfs quotas testing
From: shilong wang <wangshilong1991@gmail.com>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, hugo@carfax.org.uk, sandeen@redhat.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello

2013/2/15 Hemanth Kumar <hemanthkumar51@gmail.com>:
>
> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
> ---
>  quotas.sh | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 quotas.sh
>
> diff --git a/quotas.sh b/quotas.sh
> new file mode 100644
> index 0000000..7e64578
> --- /dev/null
> +++ b/quotas.sh
> @@ -0,0 +1,30 @@
> +#! /bin/bash
> +# Btrfs quotas test case
> +# Hi all,
> +# This is shell script to test the quotas feature of Btrfs
> +# I created Btrfs filesystem on a new
> +# partition, then activated quota management ('btrfs quota enable'), and
> +# created a few subvolumes.
> +# I have lmited the quota to 2mb and tried filling it
> +# its working as expected
> +
> +
> +cleanup()
> +{
> +    btrfs subvolume delete $TEST_DIR/vol1
> +    btrfs subvolume disable $TEST_DIR
> +}
> +
> +#trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +btrfs quota enable $TEST_DIR
> +echo "quota enabled on $TEST_DEV"
> +btrfs subvolume create $TEST_DIR/vol1
> +echo "vol1 created"
> +btrfs qgroup show $TEST_DIR
> +btrfs qgroup limit 2m $TEST_DIR/vol1
> +echo "qgroup limited to 2mb"
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=3M count=1

the same comments as before..

Thanks,
Wang
> +echo "tried to write 3m worth data"
> +cleanup
> +exit
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
