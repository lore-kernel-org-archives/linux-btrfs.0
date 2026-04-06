Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56525388E6C
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 16:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775492298; cv=pass; b=OAoZebmAXNvmNT6cwSyu6jP1TariiTlW2fdotZxVEnFyYPCDwbBWjchMauctCjhh2GBN1t1Cxc9g5jHKUAz5wvv9reFBu/+tD6i9ckw97NKdcTm9kv4n5FBFp183cLhrXcQrlCcO8VPkoHuNcAGuDFHIk1KR7luB5Pd1LMBt5b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775492298; c=relaxed/simple;
	bh=Sx2PROwTq3F7LwsAWn5/F82tCZkIr3+uQglxsvyYeyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XwaB44fFao+PFeNbPSFRHvbe/BhQy+mROTkrlh2PiypyZYAcY/zujoRQkBt+EZVS7YYW62u6k8aqFO7c05rqmT0pHPPwZ/I7IM7wvzPAM5pjqwSKUy2N9ExAjUBliAqZUUU70/4DZH4htARjFR3h1NVRnl/5OseplcsctejYtLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlLkC7yg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=m0CsCown; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlLkC7yg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="m0CsCown"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775492296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
	b=RlLkC7yg4IBd7ns0ST/m+OmUaBgr6RrzcA8EYdQnEM0n+PZcNsSgiMF1vUmN4nUo1eesbA
	A07CviY2y30c7CZJw0PztQYFjfbOytVeqUA7cSG+Fq6zv/fGaFq2P5ZKwhvJ/FkxolIALG
	uAHqFCD4Wsnp9hM33qIWmOr1/w2rh2g=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-veL3nOUmOX6Aw3w4FTFnpw-1; Mon, 06 Apr 2026 12:18:15 -0400
X-MC-Unique: veL3nOUmOX6Aw3w4FTFnpw-1
X-Mimecast-MFC-AGG-ID: veL3nOUmOX6Aw3w4FTFnpw_1775492294
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64eaa6294d9so7585078d50.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 09:18:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775492294; cv=none;
        d=google.com; s=arc-20240605;
        b=IWey/fdVnkQwd5bmwluBjIzza+vge5x0lEZ8PWOzWEhLk3nFWp6FgmfNK01m65fK9A
         IErZPXG8uDfgKb8JjpBRTZLXy6WJ7r8Gnt1F39owjHiqE6PyA4H9nLSxxRvsQH858O43
         +708LRmmT4E77iqk3xMoB7rvTDxQBlDFZNjbFdobQX/oPgPGgyreBaTP5NqG8pGIdi0O
         H8fdt5/io45N9hVM11D7uFwPlQmMcQdMMxB3JeIFmcpVL8NUg3WqKJLscSvwusHfYWSQ
         Rwr/NVAwU/SSFn98EsihI7HkIKHASF89i2mZwNjRIB+WL46Ctf+DWuffW0nM6oZauwMb
         tT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
        fh=em3ZZpg3VNNW1JcklXogPzPv3jmuHuNW5M/zIPRQt2I=;
        b=ha7VJQS1DFcdNbik+lFAFjrVSO5XceNb4mZxgqerCByvb4tyiE7A1c2qAVxcF7p3Yw
         BLt/oCN5LZZYxAJAK8zVB2xbCPL1UcATnOJ6PxvRWDio/qOa2nfKwJyXNtuLxbVPSZqj
         W/b/lxukJ3IuqjgQ7i7x2kSPmSsi/g9NS+X54BmNlND6pG22pOpoOUED/AfcC0k9EkNb
         xBkRLQ/60YtlHj0sWXbyIY1OWJDazslWbMI1mrFOJdV1MMJ4PjsdbjpXbmC6PtbfDF6z
         e13w3wbHLXM/QHiatKoA6/EufxAnvolkFAwpDS3MDrV3NPgRMTnHVXHJVTHK3ySJL1xE
         mz2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775492294; x=1776097094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
        b=m0CsCownH60XUKHXy5xxIjn1/Dmiq6QRWQ1Uw7wo9+06jplbmFMAPxMSJ71Rrw57wW
         27SD8QUL9gdLl7OjqvMMCVLff+dm27CxsJ1W8+uPYMgIiwrZEiUx3+IIn8KRuAnrnkbS
         zXm0bfCQNEUDUFTtx3bPwCLCYe2Q6hcfFyVK0lxGqzkoVuITF+4dyzKbpiFvKjYuPSe9
         YRlZsfxPeXyOJEIZbWtfblkO6iO3utO/36kN3AYojjhgI4zKMzIw2vBkPpto3JO71o0S
         KaWxrxa+8XDzeg2TGAgeafZM2HQ1BGyWH4PTKY/DBMnq6m7STq27GncYVzf9IVY0GvFc
         nNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775492294; x=1776097094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
        b=F+25nbIRlN3xdWXcxef4XCNlQdobRnSkdfT672o4Z5YXP+737YPoXFh3pJrGb+e+P9
         HmTNm7ufD3fdkwN2eCYq4Nkvz58Q9prxdpfGbPC6KLXIrydx5MzLORyO5LovE3KhHoTg
         DW+8oeNDpvVpFuxe67WF53Ilo/Vj6i2EMquNK4L9l6P60oIGN5uD9hbXjpEEAg2XLpEv
         W/FtW6eMIUPAq6bvGASneLzIbY6j6Ri1+YYpZQ0Sk+Sn3BPPo/EHLEpkZhWc9F7azJYj
         fa1/5YRQu3uyoIwFGoNHiExcZKVwyIBIr35Oc/3xwxL+AG0bI5xxGBVrRnmBDOHfwdRm
         XKTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi3VPfC51D9EbFJ86m99IxErtVIJPz+2ybK4DFZXFGRYK9qvhp1zSKdxoYu9O3Vqv4IudZPCyTitcPKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhWV8wJcqMBgyRT2wn1GRpY3jXLmQ5Vc5ArOZQ2U8mvmL5fJKd
	3HMb3GPpXKkUEcc+GoC3MvANXNkpZTBoj3nMaLKTmSl0DnZPUv3dMQMLafTp2waudZYGdQiS+4X
	GTUukZIwo2Vq5N4XzUT4xkIZ+fWAhhlR9EsaU5iLynO2pQpkyZS5xOGYU+2994Bn97EEYUJZks9
	DJVda9q/L76uOHeQVfcM+Ol6hNzxGjjvl2hGVUUZk=
X-Gm-Gg: AeBDievN6zpynwSm2JICjYkrgsGsJjaHZEl+n5qIT4vFDgDLqoQDb/CHOdVMtMsUSWf
	xvG6zNJJb9fnf2jqh2UMOP/DkqdBjSwvWV7iBD6NZOG2g1PcT1t6vagV4e/joowP73MqN/5fXIZ
	/7seO1zMG2p3os9LIYls6fXeHqvbw6VAEbZ/ek+95uuXfAgzrTljK69kIO/+HZHqbKumefqlnRe
	nb0SJLz
X-Received: by 2002:a53:d9d1:0:b0:64e:a3c4:aabe with SMTP id 956f58d0204a3-6504873ee85mr9904451d50.26.1775492294232;
        Mon, 06 Apr 2026 09:18:14 -0700 (PDT)
X-Received: by 2002:a53:d9d1:0:b0:64e:a3c4:aabe with SMTP id
 956f58d0204a3-6504873ee85mr9904421d50.26.1775492293619; Mon, 06 Apr 2026
 09:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327014255.2058916-1-ziy@nvidia.com> <CAA1CXcCmue7iX3O9RLo7wR5EqASvJGCLraw1+iQMZ98BiMJwrA@mail.gmail.com>
 <737AA503-E522-4F01-B78E-AB6C6B2E89B0@nvidia.com>
In-Reply-To: <737AA503-E522-4F01-B78E-AB6C6B2E89B0@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 6 Apr 2026 10:17:57 -0600
X-Gm-Features: AQROBzCfrg9zP5e6CbYyk2TsG4-q8UqeZvpk1DLrJKBq311IS7ZVoH1gcE7n3p0
Message-ID: <CAA1CXcC-vggwd-Z3h_PAfSk8U0ZvoQH-FpwhD=9XZHUnEGkcTg@mail.gmail.com>
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 5, 2026 at 7:59=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 5 Apr 2026, at 13:38, Nico Pache wrote:
>
> > On Thu, Mar 26, 2026 at 7:43=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> Hi all,
> >>
> >> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creatin=
g
> >> read-only THPs for FSes with large folio support (the supported orders
> >> need to include PMD_ORDER) by default.
> >
> > Hi Zi,
> >
> > Thank you for tackling this :) Ill try to review the next version as
> > I'm a little behind on this thread.
>
> Sure. Thanks.
>
> >
> > Should we guard collapsing READ_ONLY_THPs with a sysctl? My fear is
> > workloads that convert READ_ONLY THPs into writable pages (assuming
> > this is common/possible; my understanding of FS is rather low),
> > leading to storms of thp splitting. Do you think this is a real
> > concern? I guess this is also true of read-only-->writable fs-THPS
> > even without khugepaged, correct?
>
> Why would a read-only THP need to be split when it becomes writable?
> After this patchset, a read-only THP can only be created on a FS that
> supports large folios (to be precise PMD THP). That means any write
> to that read-only THP would just change it to a writable THP.

Ah, okay. I was misremembering some stuff.

The concern I spotted earlier when investigating read-only THPs for
khugepaged was this:

For frequent yet short-lived writes on read-only pages (e.g., package
updates, log updates)
Wouldn't we get destructive cycles of cache invalidations and refault storm=
s?
Imagine such pages are shared (library, execs, etc) across many processes.

When these files are marked for writing we must invalidate all of
their mappings, destroying their Page Tables and PageCache. Now all
processes must refault these mappings.

Once the write is complete, they are eligible for read-only promotion again=
.

The part I didn't understand (thanks Claude) is that this truncation
path in do_dentry_open is only taken for mappings/Filesystems that do
not support large folios, as only those filesystems track
mapping->nr_thps. Furthermore, with FS that natively support large
folios, khugepaged does not need to re-collapse these pages, as even
if this was the case they would be refaulted as THPs.

TLDR: My concern is not a real concern.

Cheers,
-- Nico

>
> Let me know if I miss anything.
>
> >
> > Cheers,
> > -- Nico
> >
> >>
> >> The changes are:
> >> 1. collapse_file() from mm/khugepaged.c, instead of checking
> >>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order=
()
> >>    of struct address_space of the file is at least PMD_ORDER.
> >> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
> >> 3. truncate_inode_partial_folio() calls folio_split() directly instead
> >>    of the removed try_folio_split_to_order(), since large folios can
> >>    only show up on a FS with large folio support.
> >> 4. nr_thps is removed from struct address_space, since it is no longer
> >>    needed to drop all read-only THPs from a FS without large folio
> >>    support when the fd becomes writable. Its related filemap_nr_thps*(=
)
> >>    are removed too.
> >> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
> >> 6. Updated comments in various places.
> >>
> >> Changelog
> >> =3D=3D=3D
> >> From RFC[1]:
> >> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
> >>    on by default for all FSes with large folio support and the support=
ed
> >>    orders includes PMD_ORDER.
> >>
> >> Suggestions and comments are welcome.
> >>
> >> Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.=
com/ [1]
> >>
> >> Zi Yan (10):
> >>   mm: remove READ_ONLY_THP_FOR_FS Kconfig option
> >>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
> >>   mm: fs: remove filemap_nr_thps*() functions and their users
> >>   fs: remove nr_thps from struct address_space
> >>   mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
> >>   mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
> >>   mm/truncate: use folio_split() in truncate_inode_partial_folio()
> >>   fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
> >>   selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
> >>   selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in
> >>     guard-regions
> >>
> >>  fs/btrfs/defrag.c                          |  3 --
> >>  fs/inode.c                                 |  3 --
> >>  fs/open.c                                  | 27 ----------------
> >>  include/linux/fs.h                         |  5 ---
> >>  include/linux/huge_mm.h                    | 25 ++-------------
> >>  include/linux/pagemap.h                    | 29 -----------------
> >>  mm/Kconfig                                 | 11 -------
> >>  mm/filemap.c                               |  1 -
> >>  mm/huge_memory.c                           | 29 ++---------------
> >>  mm/khugepaged.c                            | 36 +++++----------------=
-
> >>  mm/truncate.c                              |  8 ++---
> >>  tools/testing/selftests/mm/guard-regions.c |  9 +++---
> >>  tools/testing/selftests/mm/khugepaged.c    |  4 +--
> >>  13 files changed, 23 insertions(+), 167 deletions(-)
> >>
> >> --
> >> 2.43.0
> >>
>
>
> --
> Best Regards,
> Yan, Zi
>

