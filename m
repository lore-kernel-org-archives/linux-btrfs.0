Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A13D5663
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395951; cv=none; b=qZezd0bUs06tEdLph3Y03apg78GaNd2EtRSTtHv/cLia8bkA6dLIEOIWL0eViitFuCNDz2PEymZB0E/A3H4+vpEEBX4Ev9DlB0z/w+yQua2i4QdWFqj4JsoHvsD0+CrrgTi9u86Ae6sJnjoqqYTDQKd///iNx5jD2zicT9CQEw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395951; c=relaxed/simple;
	bh=helQnf4uLoT1OyuIg5OnuJwLEOvnehBXo9q4uBi5lqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IK/AdfHJdAjhgE3xVzGdWAF91PqN/QaI9lQQflCVd45jazLqi5hEAwayZVZfY4PudOBJwpL3kiB5n75umHQoNIyH+kvSq4tW1QpUAE4+RRiSCJV25gs1ejofHzEa6KA50ZZFAaHTl/gY2SgeR8zCHKVyPbl962RPT+wHzbfoBV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/TM46J0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/TM46J0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191611F00898
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395948;
	bh=GSkJ+CIF5AyBKo2uLXwMmgTq4soZQaA+s0sCvZ8yl/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A/TM46J0IFlEiDsm4Is52B2M7uNUbJwrAgIo4YiysFyIm5SeulEcbKR2tKkywcK9u
	 NzSDW9yNeZ71/OIDEkywhgAXj+vvM3glkuLjg0zwpiiDLVTqZdmF5fRNkRUayoF5ll
	 /m+TEdBjmoL2Jlr/Bt8abGicH/uxcz4z5+RCjWzUZYlxywtA2soDTCw4GbacXzk2KE
	 A9x211pHvdOHez8X/s6orHvdZBrmeh+m23Z1nrfDDuKMiqvLqSSupv8igF3Sk7MO5g
	 G03GOsNmWHxpC1dbEyGwcqtZwNecAAKh2qcX3ByP7vB/Lo+iLklCAZvXmLSIolR69U
	 uTE8dpkWrY80Q==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bebbc325000so310727866b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 03:25:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+jTwXIJuJSOBYnnBVFV4EcuFa99MonBLurpNQAP0TPcq4oJDtbpioxHbhUoNSyWwZf6MmRKH+7nuI3QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgpqcWXWbslnLQS/cv0NNiuSOU89qRMQxEOP7h1xtf4Zp82n1p
	5gLro+rec89iBfv3qX0QkqRvImC7QB8FlkbO0ny/F0sJZpvBjgVj+iBmYQaQInErokwTz5BydUW
	cjdle2CcIYyI20bunVNY3ElygFkPfvDA=
X-Received: by 2002:a17:907:3c91:b0:bef:36f3:7277 with SMTP id
 a640c23a62f3a-bef36f3857fmr149870366b.23.1780395946785; Tue, 02 Jun 2026
 03:25:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602043347.50381-1-wqu@suse.com>
In-Reply-To: <20260602043347.50381-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 2 Jun 2026 11:25:09 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7HxyDhgDShkDrZkoZgJ0yHcOB7wAr9u3kS-ZWaqSMQ1Q@mail.gmail.com>
X-Gm-Features: AVHnY4K9r2Ki_c560CY0aFZp4vmnxmLQ32OJH7wOYMbW0EEbjzDqiEsCxIvHTfM
Message-ID: <CAL3q7H7HxyDhgDShkDrZkoZgJ0yHcOB7wAr9u3kS-ZWaqSMQ1Q@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs: add a new test case for fstrim crash
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Su Yue <glass.su@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:34=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a bug report that btrfs/242 can crash very randomly.
>
> It turns out the crash is caused by a re-appearing missing device, which
> screwed up several checks in fstrim.
>
> This new test case is a more reliable version, dedicated for such crash,
> which will:
>
> - Create a raid1 btrfs
> - Mount with a single device in degraded mode
> - Let the missing device to re-appear
> - Run fstrim
>
> Which is reliably crashing in my environment without the submitted fix.
> And with the submitted fix, the test no longer crashes.
>
> Reported-by: Su Yue <glass.su@suse.com>
> Link: https://lore.kernel.org/linux-btrfs/wlwir19t.fsf@damenly.org/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/350     | 38 ++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/350.out |  2 ++
>  2 files changed, 40 insertions(+)
>  create mode 100755 tests/btrfs/350
>  create mode 100644 tests/btrfs/350.out
>
> diff --git a/tests/btrfs/350 b/tests/btrfs/350
> new file mode 100755
> index 00000000..1206d66f
> --- /dev/null
> +++ b/tests/btrfs/350
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 350
> +#
> +# Make sure fstrim will not crash when a missing device re-appeared.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick volume trim raid
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +       "btrfs: do not trim a device which is not writeable"
> +
> +_require_btrfs_forget_or_module_loadable
> +_require_scratch_dev_pool 2
> +_scratch_dev_pool_get 2
> +dev1=3D$(echo $SCRATCH_DEV_POOL | $AWK_PROG '{ print $1 }')
> +dev2=3D$(echo $SCRATCH_DEV_POOL | $AWK_PROG '{ print $2 }')
> +
> +_scratch_pool_mkfs "-m raid1 -d raid1"
> +_require_batched_discard $SCRATCH_MNT
> +
> +# Mount the filesystem in degraded mode
> +_btrfs_forget_or_module_reload
> +_mount -o degraded $dev1 $SCRATCH_MNT
> +
> +# Now let devid 2 reappear
> +_btrfs device scan $dev2
> +
> +# Run fstrim, it should skip the re-appeared device, as it still
> +# lacks WRITEBALE flag nor a proper bdev pointer.

nor -> and

> +#
> +# For unpatched kernel, it will crash with a NULL pointer dereference.
> +$FSTRIM_PROG $SCRATCH_MNT

Misses a call to:   _scratch_dev_pool_put

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/350.out b/tests/btrfs/350.out
> new file mode 100644
> index 00000000..e9aad823
> --- /dev/null
> +++ b/tests/btrfs/350.out
> @@ -0,0 +1,2 @@
> +QA output created by 350
> +Silence is golden
> --
> 2.51.2
>
>
