Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C1A33B6EF
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 05:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782970826; cv=pass; b=PB6IrhqY6yOj09WkDzaubJZQlm2EKBfDyhvaXRDhOdPE7r4FRmqpMmo/l4IaQ8+LZ5Kuc9QZVKcg8EA3J45bSInEg5zPIoS8okiVqtZ/IiE32cm9SxD/2FZyDBm5ReDKhez0TSiKKIHZYeecftxfVfilcswiNJ545ULd6YHdYII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782970826; c=relaxed/simple;
	bh=i2ojhQoVEcDFgHQgtSuWOz0d+zf2mBSXnkjH+DpM2q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t8uH2SUGiTcumFiNW7NNsWx9dHaOZmvjtGd41GQXbn40mNaM9r5Y0BTAp49kVDpigMMt7RK55611HYUFNI4mV1VqvwZRQpFjN1vLvCHiG+tM27V5NFH3bi9S4++o3+zCu4RZfQB5Pv3WeE1o3WNcc3V/I3ObdKT7g+4BL48SPLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SmLVturZ; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SmLVturZ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47488efcf30so819624f8f.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 22:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782970822; cv=none;
        d=google.com; s=arc-20260327;
        b=VNPxPiN/SKHI9hoQLgmQonKSg4treuhTz1/OLmLUIIm4AQzQBuGuCCZhGNteQ5pz5D
         u6ZNAL6b2PFfUsfAoDnw6nlFFR8+Ms9KEn+ko1EprPboBkisOpoGH0qWWAwl9eyFhsw0
         CMUrnO2RsC42hoyIqS6HIDcZ7G6ICRnz6u48fwfvs/QGCsl+Ur2VPTgjnr6N2GIsatWz
         prNsFWYfCI2Op2/ypF1KXuyljNcoH0A9qysDRH0oxxbaUJAi7Akc3+ZAM0Fl9C0Xc4VY
         s7MzbnTnu96eHqz2UqAeADXcbszqaycyNgY4V46AUcrurotNcnFimWkw5jsa6+1IRhh4
         V4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2YEzrB90Y1Du4fo3AHklyEGKwgWUetGfW0hMbewDp1I=;
        fh=QAWgDFdPtzHOkBdyz4BYXAk3U/BvH9Z8KzWbXTGgt9c=;
        b=l3uuY3yL+cel2hfmgknz9sfYg9O6kMxzRAvT8TXX8WTr9hdEOYjov6R1vIUJ4rjCOz
         XK7Qy2CURwCwOFKRkP8eFcFLd4iRlmgzmPG1DQsrlxMsr7cNPqBaPn3xZXGl+CqJy+fk
         nD+nAr4LPnfD1ylXNqlAKeI8GfqH1r8dH3mBRhegDFbMqyOfWZ81NiRTn20UbwqZKLc5
         WRx4GWz4ubvzFDa+uVP/Qwq2W+6iVrW9oL891WmxQ8BzjPXTSuU5LkaIj+xncc9hCo5Q
         BIwhV1kZNIQSUG4GiSV1GvTT7ZWMekr2fvWXXX3lhvcnOeNZTJxuvY4I+hxGmcXVmNdr
         kDSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782970822; x=1783575622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YEzrB90Y1Du4fo3AHklyEGKwgWUetGfW0hMbewDp1I=;
        b=SmLVturZ6+BTQGwcifIB5XHuY7ufo8luvhiwdKc/Sry4RMjHLaS1436WPhmcVQuRxN
         8x6lKu5jBqbVpTMykhUEupJNMxk+igi03TcDWYDj065o/cj1C1Z6pdIHLVYwqQOq6u++
         MdwiKWThHPfhzG8qVEnmhmoc//hXe8h0nbvXZ37KrxS00A1ECkjPT7e5ueT/M+J7mnTC
         3HgWkpqXjciMF88FVhHg6CFKDN6OHaBnYx9Gm/C3H1dBR5ntlTV5kj1jHhXqYTyGCbkK
         SrhvCW94szjjmkKN35kNAIaE5VBuXLC5H4DQ/SbXfmxdUp8worSmBpS+PN5/mkeIOL1h
         Xzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782970822; x=1783575622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2YEzrB90Y1Du4fo3AHklyEGKwgWUetGfW0hMbewDp1I=;
        b=efpEhQevAejAnQ3qqFMOViCvaFskzO6AMKveATUg8D8+V48luaDHRILUg+Fm0AKACQ
         N6fnE/fKwobe309lh5ihzEcyzMNzMjZ/xq5lUDQeC+AMBrAp8ewJOn11kMbVXz6oV5if
         nN4saot3SdhtkwFq+OEs2IhasdBd3XjQGiVYZb9BxI1Gv5bFf/vg3reUNA65SxIYmBqD
         YLfKxypv5PXEzkZxn1HXVisCwVXQ87dlTIIBfl5pCp1ppyO7FjhYmuUsGQ2jQ7cip9Qw
         dIYoEqz/BVNZdwMKkYRQx5fgeC4Lxn4UMjfqyf+QmKu7oV1GZj3DvgVq2EBM9safYbkd
         IgbQ==
X-Forwarded-Encrypted: i=1; AHgh+RoarnfxWD4zbQKNPow25K7AzjvIeNXjvztCrGL6aCFqSnF2qBNocN5toMWvqemCpWFqIat0J6SbaNm2Cg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzESpb6XF4bbmzn6z1SW2EF/JglqxNGa5lXGJve5C1b+rzGcsAo
	00ziir8KzNYAGzWXe57o4kWD2CimLZwU6oaW6q0aByOei0IpTvC3ORJ93YX79C0MRC/gcXGc9pt
	0etodZjVNSKjHqo/DtDgeBOyks1JzC+9AwfwCce0Aqg==
X-Gm-Gg: AfdE7clzR4XkLduFqH8hyuCLnpyXbvExIy6I1wj5I1lcrU4R1zpdDspgymgaIOHs7+8
	xMfL8pu2zkKwsWVWID1lwPDEQ0u4Kyzu7YyGMEUvCYmczkqs7wUFCOSH5ZGoLbfa5+kDIjot10V
	PJcyJqQd1wyG9JV9DQ48rdvPo/fXOT3NWXRfukSwcU7E1ujMIkeUUPrRSxH40cYHTbUHn2aR+OG
	axqm1xt9FR3Ow1/XW8krbVHzZQffxqvlqDWmytDsnlZYFI0pAVpGiDievwwa4cX0xmsEx2Pm4qR
	KqbsrdkLENwCyKHCTwhMe8QCGdkeE3hCXPGP2/KkgTkiclFc0S4ZdGYNluAk4VaXlcWBwg==
X-Received: by 2002:a05:6000:29d7:b0:476:5c84:e830 with SMTP id
 ffacd0b85a97d-47757e57f36mr5188843f8f.9.1782970821945; Wed, 01 Jul 2026
 22:40:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
In-Reply-To: <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 07:40:11 +0200
X-Gm-Features: AVVi8Ccbl2nIrhORZiJeUEZoHUN6evrMkvyqiKTwAG9k151BYKk05_HGbsTeivM
Message-ID: <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
> > On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>
> >>> Encrypted file extents now have the 'encryption' field set to an
> >>> encryption type.  Let's print it.
> >>>
> >>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>> ---
> >>>    check/main.c               | 1 -
> >>>    kernel-shared/print-tree.c | 2 ++
> >>>    2 files changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/check/main.c b/check/main.c
> >>> index dedb4db4..a32247b3 100644
> >>> --- a/check/main.c
> >>> +++ b/check/main.c
> >>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_roo=
t *root,
> >>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>                if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
> >>>                    (btrfs_file_extent_compression(eb, fi) ||
> >>> -                  btrfs_file_extent_encryption(eb, fi) ||
> >>
> >> May I ask why preallocated file extent would have encryption value set=
?
> >>
> >> My common sense says that encryption policy should only be set for
> >> regular file extents.
> >
> > There's nothing wrong with pre-allocating encrypted files. Unlike
> > compression, the exact size is known beforehand.
>
> IN that case, does it mean even a hole will have encryption value set?
>
> This looks weird. Is there any special reason for setting encryption
> value for hole/preallocated range?
>
> Can't we only set the encryption value only for regular,
> non-preallocated extents?

What's so weird about it? Since the inode is encrypted, related parts are t=
oo.

--nX

> Thanks,
> Qu
>
> >
> > Simillar to NOCOW, the encrypted data will be stored with the next writ=
e.
> >
> > --nX
> >
> >> Thanks,
> >> Qu
> >>
> >>>                     btrfs_file_extent_other_encoding(eb, fi)))
> >>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>                if (compression && rec->nodatasum)
> >>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> >>> index 0afa3696..159f0825 100644
> >>> --- a/kernel-shared/print-tree.c
> >>> +++ b/kernel-shared/print-tree.c
> >>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_=
buffer *eb,
> >>>        printf("\t\textent compression %hhu (%s)\n",
> >>>                        btrfs_file_extent_compression(eb, fi),
> >>>                        compress_str);
> >>> +     printf("\t\textent encryption %hhu\n",
> >>> +                     btrfs_file_extent_encryption(eb, fi));
> >>>    }
> >>>
> >>>    /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK") */
> >>
> >
>
