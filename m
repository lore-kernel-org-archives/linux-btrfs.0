Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AC8442FBB
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565924; cv=none; b=QOzEgouE1G5yaykQwlBKnjgNUAOuF4pWqyqbcRLwyc+Q3hj4qCZlwb3TZP5JfBNDfMTgUCawSXAkIWqNAlnTydW9fqb/tnf3H45gaGELjJfyB1rCgDS2PCHD4HoOhEHGsB7Bm9Wwp5MX37h7jX6+cut6IhhVAECJgj1qhzvSUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565924; c=relaxed/simple;
	bh=S+2GN7PTWYlX7vIi5meRzAftOiynEnpvDUBmD5vbmew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E3ebRTA1dsDIwsAwTJQOFEfR5H0YTTtN3e+b8iquGxgOwVs0lpzyZKBDVQtq7K1GG/RVmjWNemh5Rt9bN9oGav5V89neFagA2yUV58LD4sYeYtWivUwOy8htuIIc+OcWIj4F6Pbf5JRUSc5usz6lJmO+JJLH7A6uYEDls+owfOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzrAaqFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzrAaqFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1341F00A3A
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784565923;
	bh=cHFlNo4zqNw/rYUEiaWFNi3p3wuS381dNIxu5PJ3hUA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JzrAaqFvuAWT66jeNe0ahhF1eGCsq/QcfwWfShKUl2JwAVdGRf1laOyhD3qcR1pyG
	 dehjWY47h53Kl3wUgidFsKeOhu1wzuC2s1Tq47vBQDrXOOYzB6bhBk0kjtEnYt/1rc
	 MgtyHzVQ8V/Zj0vuiD0iAmAnNrSCuqpf6c/b/q4D8kECI+FGLcG6UYsOtF7e5J4SNA
	 Gn2wfDVZEvflANMdo7fV87vDJRC8mFG0tO+vkmB0COTGzGV2JXns09JpQqUXBLcMAi
	 /GtP6woXUjj8QD6QMhfhZAz/XSqWW+1KIg/zc5VSUWKnFAUCMSRWwQuFUewVb19jVq
	 avurs4KeEYAgA==
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-963a722ed59so1725621241.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:45:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpv+lCV0WhZ0zT/aIbv+wz9IBNbsEu7a97zYwVOitR9V2NxmB5esiyU4+zJ6iCwD9aZNv9tCvmjTGUouQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtGCaa7ye5U3mzl9lF3EBL6JcerNkIid+PPuzoOTPBddX+jDI2
	sLjkI4jOsJ0jh/bddbHdp3PS52q/nJ9OD0JUtJVOnH7OlHRYoT/PnET2ePAHoNtIqfz99tV0Mpp
	MxP6Am9NGJw8bUBuvHIbZw+GSLzJ8ix0=
X-Received: by 2002:a05:6102:3e27:b0:73e:5068:824d with SMTP id
 ada2fe7eead31-747536302fdmr3803746137.14.1784565922332; Mon, 20 Jul 2026
 09:45:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com> <20260720111849.1659111-2-johannes.thumshirn@wdc.com>
In-Reply-To: <20260720111849.1659111-2-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 20 Jul 2026 17:44:46 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7dvTuj+cuemk9qo3YK5Hqec6nM94HaaLjBHnRDL1hwrw@mail.gmail.com>
X-Gm-Features: AUfX_mz-qclxKGeOYnqm94uBWYv9X1MwfNp6KakmeSMJPIBfwemXW06FWAr5vwc
Message-ID: <CAL3q7H7dvTuj+cuemk9qo3YK5Hqec6nM94HaaLjBHnRDL1hwrw@mail.gmail.com>
Subject: Re: [PATCH 1/5] common/btrfs: fix awk field separator in _check_temp_fsid
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 12:34=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> _check_temp_fsid() extracted the on-disk fsid with "awk -d\" \"",
> but -d is gawk's --dump-variables option, not a field separator.
> As a result awk tried to open a file named " " for writing and dumped
> its variable list, polluting the test output with messages like:
>
>   awk: warning: could not open ' ' for writing: Read-only file system
>   awk: warning: sending variable list to standard error
>   ARGC: 1
>   ARGIND: 0
>   ...
>
> which made btrfs/311 (the only test currently exercising this helper)
> fail. Use -F" " to set the field separator as intended.

This is all correct and makes sense.

I wonder why the test doesn't fail on my Debian box.
My awk is a symlink to gawk and the man page, as well as running 'awk
--help', confirms -d is to dump variables to a file and -F is the
field separator as you say here.

So I'm puzzled. Any idea?

>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  common/btrfs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/common/btrfs b/common/btrfs
> index 30288f07b61a..d477bd9e38ea 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -980,7 +980,7 @@ _check_temp_fsid()
>
>         # on disk fsid
>         fsid=3D$($BTRFS_UTIL_PROG inspect-internal dump-super $dev1 | \
> -                               grep ^fsid | $AWK_PROG -d" " '{print $2}'=
)
> +                               grep ^fsid | $AWK_PROG -F" " '{print $2}'=
)
>         echo -e "On disk fsid:\t\t$fsid" | sed -e "s/$fsid/FSID/g"
>
>         # Print FSID even if it is not the same as metadata_uuid because =
it has
> --
> 2.54.0
>
>
