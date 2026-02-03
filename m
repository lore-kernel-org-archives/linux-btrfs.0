Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09846371070
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 21:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155274; cv=none; b=CnBsWs9QRvPSnZiVetX/fomofzUHLhxLvWkDefPbUjF8LBqRIDJRk2ndKVlExC5YbcHIDblYBui+fGRoicpkCXizDMCo5d5tNwvC203ua91NgLwQiRbWW1mwa1VisRP35J0ZvmNSgmDpoCxZFzmOzHRDiYB/SqDRUIGzE1TjV8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155274; c=relaxed/simple;
	bh=b1IdIezbrZh2yrnl96zbJVrO32XR9z7empZkeZqeXDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gP9858ChpHGcKpl/h4G/euKekK5YiSKuHGccZV8tI6nYu24acv7Z87a6uakCLmadT+gHcaxykHiorT0VyjQq+/7tDzMHrvMZ6BFTXpb0bisdTcaYHejW3iAK9hlQkOgCWrbIvu5ikPrfDATAFe6LClLuVbuymEZK9RZtAvPQkyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dy54mtUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dy54mtUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92350C2BC86
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 21:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770155273;
	bh=b1IdIezbrZh2yrnl96zbJVrO32XR9z7empZkeZqeXDo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dy54mtUrcYZZtuYWKhI+6IOQkOPN58fGff+Ga0Z/3KGHULKETGIYV8Hy+/QMa8JXZ
	 byjLoqufNrnc/s89QNpza7Aj9qiFoSlT9RvAfEIiFbYuvaC+M2cDNLj8XntFnNY+qK
	 vJGMfnbfmZ4R31zFh3Ih5KTVHF7EA/T/2cu2tB/iu4lBcvDRCNm8iR5NSqCAFPXNmN
	 kHf2dljmTeJedvahHktQ6CrOisIAT2siVXCgRiyr09dmFDg9YJ/8oo7OnYFIJDOiYW
	 6HW5ytSIbhl/0JvL6nTiG7jtrQ72vDj5JCVkqtjj/D2fyIOxiB5m4AW9ysclXTuHXy
	 7G1Yl7TScIl+A==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8869cd7bb1so1067808466b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Feb 2026 13:47:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWPMIgC31Dchj2bx24sCejk0oYgJs/itmpzgnkzaHr/Rn4hbm/Yze9VOBxBK7O6+rBRzosneh2N8NtQwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhubItwA9XYOGp6na6UPPf+LAoFmymp9HpafsmCd/sZsGUtl0t
	5ICyCLKhNQYLCR2vM1F1SaE+qmSKO5JBFmOiNd0zERcmdrvmE7nWH2ZbA0OhmsZOWl3NSGSm6lj
	ABmIb53SLMKdOUfUutgIg8vqke8qTUN4=
X-Received: by 2002:a17:907:72d0:b0:b87:756b:cfab with SMTP id
 a640c23a62f3a-b8e9f174718mr70215166b.36.1770155272114; Tue, 03 Feb 2026
 13:47:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770087101.git.wqu@suse.com> <eb573bac21a16092d8e9f64533c6b0d6ed6b16a4.1770087101.git.wqu@suse.com>
 <CAL3q7H6udGEXLxX_GWcSzD+T8hChfA5bPC5aYysqp9zOeuu3hA@mail.gmail.com> <10c18271-d154-4314-b74d-a8b149eef0dd@gmx.com>
In-Reply-To: <10c18271-d154-4314-b74d-a8b149eef0dd@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 3 Feb 2026 21:47:14 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6W3CiT5-8C-cpnxH0hYS5cU9qRuUy_g0tu536PNmY6Eg@mail.gmail.com>
X-Gm-Features: AZwV_QiSNliwqflMVSrVpX8hbSXd9FLqW_Gmhmfr5U3ABzsGt81d1u9qlyj7_o0
Message-ID: <CAL3q7H6W3CiT5-8C-cpnxH0hYS5cU9qRuUy_g0tu536PNmY6Eg@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: introduce the device layout aware per-profile
 available space
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 3, 2026 at 8:52=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>
>
>
> =E5=9C=A8 2026/2/3 23:26, Filipe Manana =E5=86=99=E9=81=93:
> > On Tue, Feb 3, 2026 at 3:01=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> [...]
> >
> >> +       list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc=
_list)
> >> +               device->per_profile_allocated =3D 0;
> >> +
> >> +       while (!alloc_virtual_chunk(fs_info, devices_info, type, &allo=
cated))
> >> +               result +=3D allocated;
> >
> > This can take some time, so:
> >
> > 1) Have a cond_resched() call here somewhere.
> >
> > 2) Compute only for the profiles we are using instead of all possible
> > profiles - we can determine which ones are in use by oring
> > fs_info->avail_data_alloc_bits, fs_info->avail_metadata_alloc_bits and
> > fs_info->avail_system_alloc_bits.
>
> In fact this will take almost no time.
>
> Firstly all core functionality are just integer calculations, which are
> very fast on modern hardware.
> There is no tree search to grab the largest hole, unlike chunk allocator.
>
> Secondly the allocation itself has no maximum size limit, thus even if
> there are a lot of unallocated space on each device, it will only
> handled in a huge chunk.
>
>
> In my quick tests, the fs is small and dev-extent/chunk/bg tree are all
> in cache, the runtime of btrfs_update_per_profile_avail() is pretty short=
.
>
> For 2 disks, the runtime for all 9 profiles is around 2~5us,
> meanwhile for 4 disks, the runtime is around 5~8us.
>
> Do we still need to consider cond_sched() in this case?

That's fine then, thanks.

>
> Thanks,
> Qu
