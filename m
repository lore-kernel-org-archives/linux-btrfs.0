Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EA432D7F8
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 06:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778135722; cv=pass; b=JVWhWP1eEVZCPk5oD6zos3lHvEVeYzBkm10/M0n8qf7xOgVI1nIiX17phROdk430UqrYZa58WaEwJtx2gVZfkYqBzWYMRPBISgdoyDuZyTY76DNxUsKCSukUvbDGtW3vuoKMONDfAT2Gs5uJkA/MmsactxIi8TOw98gw+/N6U8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778135722; c=relaxed/simple;
	bh=1e5QWdJdXYo85SIoew9kJElgC5BVkyxCQhjqgrYoXKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sTeSts788P1rUfyqI7/n8QZxYKTtX9C7wzRjnVxGKysPB2MqGHG4NeZJhISIv1KQzooo5toIcuBbD0LbTH3JdwK4rQZVNlpk/cF1zBDl6nyGYHMu+YRD+au/pqwQxKH0gdvLo4UVhnVU20qXYaPcBsZ1HOMyiJ7brju38d3FMOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFFihbVI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3IjTEko; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFFihbVI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3IjTEko"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778135719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
	b=KFFihbVIJG4kE9rDZOUB7cYtWDy3+tbLM+pJfHzh1QZwgX5tUnv4g2hIOqE7ZFt63RLv7o
	upPwq1l+xfDBRbqEHbUISAZoWbtMSHCPZ2qv7AVhn1mPIysh/DsJMxzaMZHOXHoAZGwIcp
	nh2NIjg6cqBNnk5tDtDbB06ygTTWMuQ=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-SrTz0GutMP-V7uN3p91H6w-1; Thu, 07 May 2026 02:35:17 -0400
X-MC-Unique: SrTz0GutMP-V7uN3p91H6w-1
X-Mimecast-MFC-AGG-ID: SrTz0GutMP-V7uN3p91H6w_1778135717
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64eb0bbab48so792615d50.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2026 23:35:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778135717; cv=none;
        d=google.com; s=arc-20240605;
        b=UJJ7itxhmiVXupAox502pIVxM6VXifXa4tsOYz4GjfV0sfqA92OlxYE88BMJ8PXjjy
         WwhiTch7cKdnhbD9IoXp4CqwXiJgkBo4q43S7aPoizcKwrZ7JbBZIO8AQzr8PYdef+Pt
         cBiPfylzkvEqxAMcg8x66JXR0ISQLnZEtnwgmv0l94UFbjrhLwSp08b0fdrMn6xUzVb6
         ghQMDp/EF5BZOBwQNeqa5nVeVWb7Bbk1J1tNV3jLZSTjQc7bDfpzL000excPFqPv2Zg3
         FX/r5STQdj1nCLAo+6KlPsVNSrpvRS37cD3rwsreK3NCpFMPUKfAgfB5ZCo7ruXSZk7p
         D1mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
        fh=4XIBAmHwwDFiXXl4tUpTW9dj0pLw1e7b4NvdzjFw6UM=;
        b=HptRYuexrP24Em4XCjZ8VFulKNP3y2tRYR2PYykoL17b+TwASB1zs1igW/Wg4whN/h
         Y+9bjblspTWm6Mwp0ioltIsrGC5dHuNaMLnZeYLgT4i8G9V7nKEfrLERNyDuNpTsDFMk
         zl4FJoZ/M1NHvi7cmxcZciRoj8OEDInEmlL+QI3/JiB/uxg01s1AQsRjf+YNYw2phjF6
         5f5whFhys2KjqeFj93GYA5CQp5IGP8Nvn11wAnmoQq5VpgMjPM5EXLeDFAQ4qjoyaoHi
         LshBvmWAzH5fFG0esGzAIp2B3hw9igF9nrdBa3dSmZ01/ATehRF7o2Itk24XA0yMggN9
         pm4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778135717; x=1778740517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
        b=B3IjTEkoYCKaxqLOVvghrAWTGPQ+CSJAHZDruS1jDc34+tlAtlnFgojqh6cUFopktv
         At1lJiEMpIBnSIFXUci1VdrTeftWTVo3ZxOzYwP7WI5db3xAKfn0xx3OFvLqKQzQCD8K
         1YaR73w6pecOa7I/WHBXeH2lUVoJ7cF6e3HM9HyRW+op0XDscsTndK4ddGj28Gjvp/xe
         jvXsZIQAd6lDqEvLRC5QJzOBVtQT8RtUp0RhZtS+sksgpGS4PAfbsV1wT81rVzQ3T2F2
         PpEUJqqlTuxE3sJJ84dR/ud5LDvvL9O8K2rb1yW6KTTZo+zPcKz1vcBHtNArvscxJozH
         Ie7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778135717; x=1778740517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BmF8e40h90ljVl04zACNPWVQcQh3Q1EW1p6gC9vnX28=;
        b=mrf2JDbjKu8kTQnGxOcEGsRRZKkqguy3l0ojCHsgdazBxw2JkH/r2ORdDFy66jcmc7
         w/YH/ZHEh69ZQsZ2VmJUdHUT1HcdUvgcPlWurAkbMSQjhN3CridO2F8AT1kzxdIpL0Nv
         /d3lMAWLj7fi93rfzLu3uPuJehdE0gPGhwZhdgADgr6Qetkn3J0Y/XqqOY6HZTsarhk7
         vTeMFVrgSwK0SzsiFRew9efolMq6IG1WYysZd0jQ/QQzo4MFSGFT0v6ZdwhbYfZijQqW
         uPuwoLb2nMiw/5DFLt3FrkpSN7RYGB1XtZAPru8V7GuD5snLIdicMykqGzimWRznkDZ/
         SU3Q==
X-Forwarded-Encrypted: i=1; AFNElJ8UdqzKunuuXAjbCO4Do3qcuriutFH09J+4w4woq2oYedspPTe7m5XdK1zxEPkBNsrI/1RcWX2wqMPoNw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk7qhS1m9aXkZxKyB7MI4WkDaLJ1p7r/1bQvVpRRUGAT19Ok+F
	SE1gLPMS7ggMvgkt6bgHV55Ca17WTHcoUyRnMiYheLSAw1r70j0x9dpYAHMte8tZtPdC5RZ49fC
	1R4hPEm1vfL1gfqLJxXPpgxqZmLVW0xsR7PzIRjNGNOQFgwYBuKM3TvJOFbhSz7uB7xogo68i+l
	EEIVwA7SoWQDRJB/53n7U06a2YSwN8uWS4hFYbMZk=
X-Gm-Gg: AeBDieuzsLDbtXvcVWvQkxAhLom5baOdomMNmAr6oDABG4r2pkURHDLC4HKDgMAimlX
	2bPO1/FIfFoYD/7SVPOYn2aP3HfOgVvlpQwhwKxAdaqdArQlloLtKse+s9Pmc81G4L0nuMNMLfb
	gwy9yFBoKtio3ScgC1IknNYsXDr+IIaIwUn8eXlGSl99/KbG7+NTtUlEHnmgN4Hjjgd2/6SCFwC
	8M0o2W8gP1nAA==
X-Received: by 2002:a05:690e:4145:b0:658:e45a:e477 with SMTP id 956f58d0204a3-65d7e72eademr1206507d50.2.1778135717214;
        Wed, 06 May 2026 23:35:17 -0700 (PDT)
X-Received: by 2002:a05:690e:4145:b0:658:e45a:e477 with SMTP id
 956f58d0204a3-65d7e72eademr1206480d50.2.1778135716760; Wed, 06 May 2026
 23:35:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429152924.727124-1-ziy@nvidia.com> <20260429153538.727855-7-ziy@nvidia.com>
 <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com> <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
In-Reply-To: <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 7 May 2026 00:35:28 -0600
X-Gm-Features: AVHnY4Lrljxe6KvxlSyOqNI3gvAzejJ0XLC-pzb1vAYqjO_YkbxwJ0hvJkZ60ks
Message-ID: <CAA1CXcDj7Y7Z26f2o211fYewgrfBNOS7SfZ8Xroiv1ObC8dDRw@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 6, 2026 at 7:15=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 4 May 2026, at 18:11, Nico Pache wrote:
>
> > On 4/29/26 9:35 AM, Zi Yan wrote:
> >> Change the requirement to a file system with large folio support and t=
he
> >> supported order needs to include PMD_ORDER.
> >>
> >> Also add tests of opening a file with read write permission and popula=
ting
> >> folios with writes. Reuse the XFS image from split_huge_page_test.
> >>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-----=
--
> >>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
> >>   2 files changed, 102 insertions(+), 41 deletions(-)
> >>
>
> <snip>
>
> >> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing=
/selftests/mm/run_vmtests.sh
> >> index 3b61677fe9840..854c5c3e3a6ae 100755
> >> --- a/tools/testing/selftests/mm/run_vmtests.sh
> >> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> >> @@ -490,8 +490,6 @@ CATEGORY=3D"thp" run_test ./khugepaged all:shmem
> >>    CATEGORY=3D"thp" run_test ./khugepaged -s 4 all:shmem
> >>  -CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
> >> -
> >>   # Try to create XFS if not provided
> >>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
> >>       if [ "${HAVE_HUGEPAGES}" =3D "1" ]; then
> >> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; the=
n
> >>       fi
> >>   fi
> >>  +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
> >> +CATEGORY=3D"thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TES=
T_XFS_PATH}
> >> +else
> >> +    count_total=3D$(( count_total + 1 ))
> >> +    count_skip=3D$(( count_skip + 1 ))
> >> +    echo "[SKIP] ./khugepaged all:file" | tap_prefix
> >
> > This leads selftest runs to always litter the output with SKIP when run=
ning this with the wrapper
> >
> > make -C tools/testing/selftests TARGETS=3Dmm run_tests
>
> Yes, this is intended to let people know one case is not tested and skipp=
ed if XFS cannot be created.

Yes but it prints after each test case run, not just the khugepaged runs

>
> >
> >> +fi
> >> +
> >>   CATEGORY=3D"thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_T=
EST_XFS_PATH}
> >>    if [ -n "${MOUNTED_XFS}" ]; then
> >> @@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
> >>       rm -f ${XFS_IMG}
> >>   fi
> >>  +CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
> >> +
> >>   CATEGORY=3D"thp" run_test ./folio_split_race_test
> >>    CATEGORY=3D"migration" run_test ./migration
>
>
> Best Regards,
> Yan, Zi
>

