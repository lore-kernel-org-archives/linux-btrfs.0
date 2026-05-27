Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779482DFA3A
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892036; cv=none; b=WlK/lnEnIh31yflgp86OMY7tZjBLmAK1Q6/4DAq59QdTFZLzWTcNVPZ4w+hgNPC+53lwvDR9GfskAQWPu3DDSJZ69BHFk9KlxRSAAReL0rvIe8ynzU0osA883GTgW3Bu8JAq4ZEa9OVfRc5P086jVi0dTyhj6+VwVQog4HB+C0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892036; c=relaxed/simple;
	bh=zYSiVygun1gq9hDOfe+bvAI/q49J/ionupF7mO0EVbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=krWHtzf22J24Ay/0I1kjfp7jibqBxptUiq8APAGEQi+Jqmg2QeLXwUPHFT11NM+MpkvEDOAYqsz1UAQUF5uNwUBG+1je7DNhffiW/VX1b8Unz+sfiLkkaSm01R318Azp5eHhxUE/2s/2V+Qkk6bupmZ0LXYprE07j8rbJiGbMWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a79nNhKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a79nNhKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B681F000E9
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779892031;
	bh=guZs8WtxL9AG6fXuY6JT062ELqFghnw1sE0oB3puiQI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a79nNhKVoO6W6BakLya4s18wXy/kE4+F9lr5UTg0b3RfsUiC1ymmDgBF0cl0Cty95
	 TfvfWjT5cuCZGFANk41hOeQeJzjZuVkYtZCBI3YQg8qAPuuisyqI1wsvaLxrKKvrMx
	 znCuDllGaeWt9Z+zNWmT/XzmRwXupGFeVjMpVYF+YZWR2gkwgjz1IpP6sdokhtCZP5
	 APVuiFYGVoRbXrRDQaZuUKze5NLlzO5QUisfs6ywQ+ucnbiPz6+PfveJPIu4cQoInu
	 ZfXp9i2rUr3fMjjNJ4EWEBEUfbs/XZQK9dUigezzJ7ZUMisGqP+stdJwQAvYG+UsrO
	 EM12T1dVtK49Q==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bcc9fdc959cso2058917166b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 07:27:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9G7gEzcNHajLnxInMPkdjQh4tIzg4ICHnppvOmU1hS22hxVkA2RfWNCYOFbZD5zTmnnnZQy6pf0UOsEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIQqInce4x8hUQyxDHsvyJ+Wl/X0+Omp2k6W857wUBlFYi6aO2
	lXPnNHeZ+wGcVIfYIczdXVQtkmp7M5V68HnHmqB2ikikkWDjmOq7B33jX8xaFCyKb+pQ3t5KaMk
	8g85Xo6V82MT30sMvXTK66Sc7MDQvjJY=
X-Received: by 2002:a17:907:c003:b0:bd4:7bed:512a with SMTP id
 a640c23a62f3a-bdd2580bc63mr1478418066b.30.1779892029718; Wed, 27 May 2026
 07:27:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526070055.60193-1-wqu@suse.com>
In-Reply-To: <20260526070055.60193-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 27 May 2026 15:26:31 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7Axijwfd_c3X2Ni1XEu4=0wdf3Cc6tqKF8+O+Rx++fPg@mail.gmail.com>
X-Gm-Features: AVHnY4LGea6gSHZBESG0pIFDXrrxG-HDgVxYtXdJ8q9u6SrPSP-D1Zt-GQJTAqs
Message-ID: <CAL3q7H7Axijwfd_c3X2Ni1XEu4=0wdf3Cc6tqKF8+O+Rx++fPg@mail.gmail.com>
Subject: Re: [PATCH] fstests: generic/362: remove the old file to reflect new
 mount options
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 8:02=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [HIDDEN BUG]
> There is a btrfs bug that will only trigger on newly formated TEST_DEV,
> with mount option "nodatasum":
>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMP=
T_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>
>  generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//=
generic/362.out.bad)
>      --- tests/generic/362.out  2024-08-24 15:31:37.200000000 +0930
>      +++ /home/adam/xfstests/results//generic/362.out.bad       2026-05-2=
6 16:24:40.201201849 +0930
>      @@ -1,2 +1,3 @@
>       QA output created by 362
>      +First write failed: Input/output error
>       Silence is golden
>      ...
>      (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/x=
fstests/results//generic/362.out.bad'  to see the entire diff)
>
> But if one has formated TEST_DEV, run test with default mount option,
> then change the mount option to "nodatasum", the test will not fail
> anymore:
>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMP=
T_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- /dev/mapper/test-scratch1 /mnt/scratch
>
>  generic/362  0s ...  0s
>  Ran: generic/362
>  Passed all 1 tests
>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMP=
T_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>
>  generic/362  0s ...  0s
>  Ran: generic/362
>  Passed all 1 tests
>
> [CAUSE]
> Btrfs' nodatasum mount option only affect new files, but the test case
> itself is using TEST_DEV, and never delete the file
> "$TEST_DIR/dio-append-buf-fault"
>
> So if the file is created with default mount option, then all later
> "nodatasum" mount option will not affect that file, thus hide the test
> failure.
>
> [FIX]
> Always delete the target file "$TEST_DIR/dio-append-buf-fault" before
> running dio-append-buf-fault command.
>
> So that the new target file is always newly created and will follow
> btrfs' new mount option and expose the failure for nodatasum.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> I'm already looking into the test failure, because it's mostly hidden by
> the btrfs' falling back to buffered IO behavior.
>
> With the incoming IOMAP_DIO_BOUNCE usage inside btrfs, it will expose
> the failure unconditionally.
> ---
>  tests/generic/362 | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tests/generic/362 b/tests/generic/362
> index 0cfaa726..86191e57 100755
> --- a/tests/generic/362
> +++ b/tests/generic/362
> @@ -20,6 +20,10 @@ _require_test_program dio-append-buf-fault
>  _fixed_by_fs_commit btrfs 939b656bc8ab \
>         "btrfs: fix corruption after buffer fault in during direct IO app=
end write"
>
> +# Remove the existing file, so a new inode can be created, and will be
> +# affected by changed mount options.
> +rm -rf $TEST_DIR/dio-append-buf-fault

We can just remove the file in a _cleanup function - that's what most
other tests that exercise faults during direct IO do, like
generic/647.
Some tests like this one are missing that, and there's at least one
more: generic/708. We had several similar tests, and many were copied
from another test.

Thanks.

> +
>  # On error the test program writes messages to stderr, causing a golden =
output
>  # mismatch and making the test fail.
>  $here/src/dio-append-buf-fault $TEST_DIR/dio-append-buf-fault
> --
> 2.51.2
>
>
