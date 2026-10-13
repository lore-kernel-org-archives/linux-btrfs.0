Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E50F1F4634
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791869543; cv=pass; b=Wc2P5Abi/W96kiAT7hftosq79z3+kD4H6rOIHY7eK8S4tg+7vKPoH4DO0HEAa4OXMyhMVVdAPM8RXQhnwGypsKf2SgflWMWXPFowGYCsYvWkFgHugKtP0G2w7rhuQZysl4aq6PVVHMZfaxvgeuVKmEw6GPJbXuBT/Q+rGZr9enI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791869543; c=relaxed/simple;
	bh=rHIqiUCkGFjVcqSJ5zvzbmf3v0o2ZQfmavOkdjTZVbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i2pc7gkz0WPK3RHjrVmGiqOYKcAorEyJHobN9+443tzbY4IfTCSCjLzlU1HsPo7ZG9cwBikfX2sWjt3Or06WQpx/zGBhlECQQIkq1kShPei4nv4GqYf9yCbwTj9lPiq7DJ6l9A3DSCbpjs/NsvnmGiao96HcvNud8ktf6HkjdyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZM5JMX73; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZM5JMX73"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c14a06c95so1902423f8f.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:32:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791869540; cv=none;
        d=google.com; s=arc-20260327;
        b=Xx7d0sEbmWjH3gTN/6AOT8AzYiK+QbGRfBJvUzhFAjzHN1otEfe/TDXOqHq1fj9Dyd
         Zl0p6rzp5lPsjt3l/368Ysyx+1rX7dzyUH7TZEzwUOEEeJ8oM84U+fLNRKVzyE3S5ET5
         H2N3pWjvGdZAvjVEDyl2+SSYlk4bBpziGbyzoTZu5pfzP7DPbofBjdh7JfMhEclrS2Nd
         BDQIvoXmW6UUHr3bgD+PQ7cV2jLsO9CC1StTVmQ2BoRkrAzMgKWUjLSllCB7h12bByk/
         2pDVhWL8KxRwoxmaBU0OpRRn9j72cJI4keJvCagrrPFwJzfv5A4i3kItn5BQYLyL69Rw
         ChkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l2rPePOT0qwxcv9sA6tFp6kLXpu1kOfjmigItp+zYG4=;
        fh=SBw4DBdlxaG9T9b9BhTc4wVDzmHZt0OwxK95SdwPd0k=;
        b=Sfb+p4pDt4Yy2U9A7sDGF/0S1k0XVLpkeRRLQ8t495fxGN4eMJl1C2TpC4itI/wykW
         b9uFmiB7o/bf0KB0Prk5ItDIzaFPQghN8jINIuwv98Hde9YIYb2BO0z+QzEwQCM2f7IN
         cUeXo9GaK23FwhdEfL0G/WUpQAa7EsEavUjYnlCl6L/n1bDL40Vhds79ssResh+8MN8L
         MBFd/BqbGWBw9w51ifqXcPaJiSEcOy29xRvxGN1Azy2gxF5YW9umWmIaAhR3hX1mXkl0
         d6DXpVCprKYl89YHNvv7JhRsZ5yO3b3/5Sxs+O/w9y7UxYTagAEqH70NTOEM5I2cY34i
         a9ww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791869540; x=1792474340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l2rPePOT0qwxcv9sA6tFp6kLXpu1kOfjmigItp+zYG4=;
        b=ZM5JMX73HYEUbLJYxfbSWApfQTHTIRyqS9ZS+hwNI5rHCNt6TlMymsBdv9gYN8Yy0i
         O7fOXNMPehgp8duXm/X/PaAzhBM18xESpZ2GOYoUB/JcIK6/kekoWGsA63o6jK27mNgv
         Kpzgu9DRuYgCiZOM9juD22VWuJJFjnagdgmSXy+mp2nxXOTJCWDMZWWxBZeijDwhpBsL
         CO772/dmtROtHnL3ZoRnvKLDCBUmuZqVCg7gzE58C38hIz1rFCyURWq8CcLtpRug7T32
         gO/qrx++3tVs6rPhaeBUDfyDz3oAY4OtKwackG9f76OQlo4uZYBiPkL5mozFTVGm3DNc
         iWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791869540; x=1792474340;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l2rPePOT0qwxcv9sA6tFp6kLXpu1kOfjmigItp+zYG4=;
        b=0V6XBIFCDP1DQZ/Lo4M/9NmuynAubftCaou/jGdQGLY+GCUN+/M3W/Y5b7bOewjuFh
         0ztnggaRXa97DXDBnJDYGcrQs0wGed90/8Csb2ZFd5IloQehrf+ks5xHoqgTgptMKUi5
         eNlvK0EhfQ8G9g2VHrFUAHGbMeqF0I5fEAHq3JyPrt277dcmJYOsL+ETrAu1jJjRqpvq
         2dO2kCUj7Vg1V8xBQtDat7hCnkTr6kZhtM0P1bYGKXvVOegsl7MFf2TIqCBVrjj4RTM+
         +fWxXgkXzO9h+VOIErZBHh/5p92DG8uKR/em55BbXbLy+cqiab+5lVRxpohMe9gvgIDm
         q6fw==
X-Forwarded-Encrypted: i=1; AKwUvByEWJBu1mtt+2o1DLL8WKKFItkItORyRa5x6IUKFw9UEgTNZ4t0616LfYd7sAb0jiNea6xK/gDSFa7p7Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYIjtzKdbPCwZ+vciirvbB9teI0OFuFy+fXTWQiZh2T/igd4nGJW
	ZJHHDnGvX/a38Lj0sU6ox+VLVptaQedMKXUy3+pmEWAGcdS9x2y8r0xkHQ7af8OA4Z1AEvkGgHd
	qB2tbxBePr4Bwme5HBWoOLe+r+wbK7go/hqgjgnBe+Q==
X-Gm-Gg: AYBFou362aZb0QopXONlfKjHCXZX7XpG4SspoCG3b5+w+IPodHROqWI18ruNNDk6o7U
	Nj/SMDNE8sTfSNtXwvAuvpSVDlZXJUy1dKJukD2I5ZpVfgV3kugMXkwL7ufVGihuRNFcMD/JtFz
	pOu9B6S8fZ/aXS3XX+f0ExKeQJdYAkDbyAXtHM8uMU8l/yRWwZ+DFuGLNFSyi3CACKSWAqedfwc
	wI1jO+mNXXYF9+e7Xtee4EfHIxuRobdetvyYywJtxtDyhFJv24l44+L8pBS6udd3qA8u20/FmVI
	2RzA/gdaSsie14qhv4K8ZeCnitdUf07LtaEtQTqk/Mue+MUWGF0b/sSoF6fxVwFSig8jpfYqwN/
	AeX48LANpCEGqEoEyZxgyZVX1h49zqDMMUzvYElHK6Syx9lTjMtCX
X-Received: by 2002:a05:600c:5493:b0:4a1:78da:d271 with SMTP id
 5b1f17b1804b1-4a18e4ee976mr248659425e9.30.1791869540475; Mon, 12 Oct 2026
 22:32:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791706855.git.wqu@suse.com> <f6c20a7063b1f67881a61cdbd707f4634df9ed0c.1791706855.git.wqu@suse.com>
 <CAPjX3FfauJ8S7ShhusSm7WX5MEMa3uDwEi-=F_BdA+RM0f_DJQ@mail.gmail.com> <CAL3q7H4D+1-7KbayR_NkFvOsfO9Gjcv7+zhPCxcr6f1==YpMqg@mail.gmail.com>
In-Reply-To: <CAL3q7H4D+1-7KbayR_NkFvOsfO9Gjcv7+zhPCxcr6f1==YpMqg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 13 Oct 2026 07:32:08 +0200
X-Gm-Features: AclHuK9IUE0-9vBHoDql1vf0XvQquiiYs0h0wGm-xfmJ76pO5KGIo2bbgVpbvVQ
Message-ID: <CAPjX3FdZOgBm=3jAvD8du1=F5dB3zJYp-NQ-NWp+bipy+0oedA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] btrfs: fix use-after-free on quota enable
 allocation failure
To: Filipe Manana <fdmanana@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>, 
	syzbot+947286c775f432b073a8@syzkaller.appspotmail.com, 
	Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Oct 2026 at 19:20, Filipe Manana <fdmanana@kernel.org> wrote:
> On Mon, Oct 12, 2026 at 6:16=E2=80=AFPM Daniel Vacek <neelx@suse.com> wro=
te:
> >
> > On Sun, 11 Oct 2026 at 10:22, Qu Wenruo <wqu@suse.com> wrote:
> > > @@ -1296,6 +1297,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *f=
s_info,
> > >                  * sysfs entries.
> > >                  */
> > >                 btrfs_free_qgroup_config(fs_info);
> > > +
> > > +               if (quota_root) {
> >
> > How about
> >
> > +               if (quota_root && !list_empty(&quota_root->dirty_list))=
 {
> >
> > to avoid taking the lock if not needed?
>
> What's the point?
> Is an uncommon error path in a sporadically used ioctl worth optimizing?

Why not? It's not a huge effort; it's just one simple check.
But yeah, it's not a big deal.

--nX

> >
> > --nX
> >
> > > +                       spin_lock(&fs_info->trans_lock);
> > > +                       list_del_init(&quota_root->dirty_list);
> > > +                       spin_unlock(&fs_info->trans_lock);
> > > +               }
> > >                 btrfs_put_root(quota_root);
> > >         }
> > >         mutex_unlock(&fs_info->qgroup_ioctl_lock);
> > > --
> > > 2.56.0
> > >
> > >
> >
