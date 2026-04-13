Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2DD3D75C3
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776089560; cv=pass; b=XZTMRkYSSjvb6+TPfr9mtQOXkk0wwXUWDibGzEFRj+ClzLB59KeyMLJVEVIt9FMTpHooftGagEodhzCEZs8pc7BquebWdDFwRdstlO422NEKa9NfBZ7jww9gTWXO/a9QD4JnwxDXiBTUz0/IKzg0EbnLLQqkRGpt9iarH30L+4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776089560; c=relaxed/simple;
	bh=v3ZnpFHjlXYZIgsCW15LcqTLBZOOQBJfhilSswAKE9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ea8ST1wx/ckghlm6uvDgVf0qbBxahqVpOQ1dj67QxZRtkTh4BLtJhCzLrAzxiIakfoGsnaSOiLNLanQPLzEiL9eJdAcp0ha8Wf4zab43ZNckAPB/JfA1iPv4Muqz1Dk4HqrSviX6w2XAZfUdl4V+uHoVOU1E5fAwi7oGm59daMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FHJeLDQa; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FHJeLDQa"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so6309401a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 07:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776089557; cv=none;
        d=google.com; s=arc-20240605;
        b=KJA7Xy3PgglkN9gQgw7E8WfVan4fl40Zj+yvknTG0XrYvoyddplP1hU1QNA+uWA/c2
         mhdyhEjAB6mCAP4msCqhHnQGDXmfoksfzAiEOUP7OQkaDe1HOkcU9o8s1fpUHlbUyDjP
         TJj+dWJJ3VPf2o+7Yd6L+L1JoSdetVsQop0m78P4ZsP5h4IeeWGkP6k05TiMARZ/J5ju
         nfMW4m/BDnhn+b1XbvlcXub19Vfzt1OXZyORhxfvmuI2f6wuUoXAUqI+cXDpjwO35Up0
         u1uAsGO+W62ZG5Rfms1A3VE+jHrmxzFuEKIT+BjeIotrP+AKuXE0cGFq5vELjBnvML4p
         arnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G1R4Np5laA7U14JEdrWzvRl8FLy5wMUhT7h+SGtQ+ZM=;
        fh=yYRLyibmrY/d2jxFINRTKHuKgQaFAeaerGbjCpYUWMc=;
        b=aI5084bKMZDb5XOM5LD66pA50vC0MbF0u8Mga2QRXY2yVZjglgjG2Wrt5U26ji/EV1
         u/4RM82KcerMXrxM+BsKJtqK9CG4iJjijLZg98IfY/qoxN7fkFUj7jtU7/Cy3HPIfVFr
         Ddbl09JRWHWCsoWUjKe1WyTc/nwVW1zLnCK4LYtbQQnW3dCVGRdN+7MQIMD7CXlqjUPW
         e873WoN2i3vy0gd/QnMV8wEp6B9iaeF150drnaKlNIXgbnIz9O+ygouN9iPRvNvNWaIS
         NoXqDyG3e6i4fVFOFcQ/7UxlwFJM4i+qdLsWk1IERG5qipWJC2h6E162rD4aQuPX83RN
         rwyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776089557; x=1776694357; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1R4Np5laA7U14JEdrWzvRl8FLy5wMUhT7h+SGtQ+ZM=;
        b=FHJeLDQaiZQHx/Uh+1PFfKasgrq57Jt3kWnVDRBiOobPR5w1mgPRxRy8xR03RMNCPS
         hzb3T2xnBMPudkTvBVcSwehOle3IRy0MaBkXo2wpnjtRdpZ1C5B202G1iti6iCEmvuSK
         aP0bhGk0N/+9Oo70WPv/aXnUUgHcHaeKNMP8TIsWq4xusBW3u3v4BWm65HeLWTVezC28
         21I6em83pi7uGWrVmq9KCm+BM+6JYQJ3MFnKcma6uOcmDupMtKni292NmAMts+u6OO5N
         I6ncVnLftiPLFQiwQf3KXrWvzWWF1ko9/0GFH0xbFGIOHdKmsczgNP+U0rbd2apcuroM
         Bumg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776089557; x=1776694357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G1R4Np5laA7U14JEdrWzvRl8FLy5wMUhT7h+SGtQ+ZM=;
        b=JGmy1sszKaSCH8PDzI7URw2s7QN10siKx+5EssUOe6ixTDEmM16ZF9cTQNaqIXcXsr
         x84/hc8QzMPOOygU2+ihxckZPWJSPOfsyWoIzajl4Ym5CzdfsXk0/p9X/QrE4B1mNn+T
         igUMfE9Ew17GWU1K8M7tACDokE/cwZS/gjdad/tQwVKmmh75m4NOPtHGXbMaAIgfYYcW
         /8fosMfT0zvIbVurrRJbN44dkprHcfcFHyMjBNIBmOWoXAPvQol9r1MMivj3tp/27zha
         DexfZWJmhEZPDHYyhWSBH7wYYNjD3Z9HQUJXCG51hM/gZX+h+jpmqlCTyxC2qxvaqGQf
         7GiA==
X-Forwarded-Encrypted: i=1; AFNElJ8jb1btdMLnCmx6WU8CrH47D+DzBI5hz9yNJgucbYfA4wxLB+AWlnBKqgeA12jRwFdwQUT1gNL8t6didA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8R+Bc5cf784LvXZYOI+3J5SuY0UilYgCPV0amd9qZnKqKwuIM
	klR9gCdhr/wW1OaYYWwkWHq45/rJhLy51DCTIutccm8L9fx/BEEPmH371L6MU8RxAu5dwOX6Tux
	wep2v0MVWCzvxZSuqB/FOxmM7Pczrwqu6dB0ApGz8vrJjT5Mx69vMDX6ROw==
X-Gm-Gg: AeBDievwCOVxqFE59EGNivoUgxFB3NkYyWvoPDL0Uvrvd4l4qrA8pQ6i35FBiAArvTj
	gQdSUaLMTZifx9AlLOC3BrBwZ5EaP0FJzna2JJzhraJeAZSuErCxIKMelacvcWuUphAn1mgQAsR
	JDsPZ1VaDZP+q8ciV3+yAxJCbSLHB5GeL1Az130anugnlb6M7uUuGgX/nJxuOVHcIpzen2koFv7
	ASnQ2iOcQ87B7IS8gfi6BYEZNANvJZhKJSy7KqOU3X6OntdIN+focrtizNk/HUgAGRmX6SXYmfg
	mhK+5EvcO2tGiursd7XsKRdf95PlGczxJ20g+vkBzpbv5+Z58LxnYVsZOkKhnE5QTQE72UP6+Yu
	UlodbEuejDGbMUsc=
X-Received: by 2002:a05:6402:a0db:b0:66e:5622:a2e with SMTP id
 4fb4d7f45d1cf-670798f065bmr5690575a12.22.1776089556418; Mon, 13 Apr 2026
 07:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260408174642.136962-1-mark@harmstone.com> <b0a7acec-73ce-4cc2-aecd-d0f686a36e4d@suse.com>
 <33a920c9-c876-45bb-b1aa-eed42472efc4@harmstone.com>
In-Reply-To: <33a920c9-c876-45bb-b1aa-eed42472efc4@harmstone.com>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 13 Apr 2026 16:12:25 +0200
X-Gm-Features: AQROBzC732rYPrTlVmBjxhYNkDPfBANWQAzNx335SesFJ8m20G0LyRSU0P_K6ak
Message-ID: <CAPjX3Fc9_sLKh6m_9zX5hDKpwZ8+msnzh12+PTkrQaCYvL5BmA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, boris@bur.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Apr 2026 at 15:14, Mark Harmstone <mark@harmstone.com> wrote:
> On 09/04/2026 12.08 pm, Qu Wenruo wrote:
> > =E5=9C=A8 2026/4/9 03:16, Mark Harmstone =E5=86=99=E9=81=93:
> >> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> >> query the on-disk csums for a file.
> >
> > After some more discussion, now I understand why you want an
> > unprivileged ioctl instead of splitting the workload into fiemap + csum
> > tree search ioctl.
> >
> > You want to do extra permission checks, which is impossible for the csu=
m
> > tree search ioctl.
> >
> > And if we allow unprivileged csum tree search, it will expose all the
> > data checksum to an attacker.
> > The csum itself is not enough to re-construct the plaintext even for th=
e
> > weakest CRC32C.
> >
> > But it is still enough info to know other aspects of some data, e.g. if
> > some blocks are all zero, or some two blocks are (possibly) the same et=
c.
> >
> > Not sure if you want to include some short words on this design decisio=
n
> > though.
>
> That's correct. I'll make sure the description is clearer for v3.
>
> The reason arbitrary csums can't be returned to unprivileged users is
> principally because it is a good indication that a known block is
> somewhere on the system. An attack vector might be an unprivileged user
> scanning the whole filesystem to see if a known vulnerable ELF file is
> installed.
>
> >> This is done by userspace passing a struct btrfs_ioctl_get_csums_args =
to
> >> the kernel, which details the offset and length we're interested in, a=
nd
> >> a buffer for the kernel to write its results into. The kernel writes a
> >> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> >> csums if available.
> >>
> >> If the extent is an uncompressed, non-nodatasum extent, the kernel set=
s
> >> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> >> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> >> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
> >> the precomputed hash of the zero sector.
> >
> > Well, for mkfs it's going to skip the range as a hole, which is even
> > faster than using any precalculated csum.
> >
> > Although keeping the ZEROED flag may be useful for future users, I woul=
d
> > not mind to keep this flag.
>
> I wrote this before you added your hole-scanning code to mkfs, but I'm
> keeping this because it's cheap and it might be useful... and you have
> to handle the case where userspace asks for the csum of a hole regardless=
.
>
> One non-mkfs use that springs to mind is that XORing all the csums of a
> file together should give you a pretty fast ad-hoc checksum.
>
> >> Otherwise, it sets the type to
> >> BTRFS_GET_CSUMS_NO_CSUMS.
> >>
> >> We do store the csums of compressed extents, but we deliberately don't
> >> return them here: they're hashed over the compressed data, not the
> >> uncompressed data that's returned to userspace.
> >
> > Consdiering we're already treating prealloc/hole with a dedicated ZEROE=
D
> > flag, just to keep things consistent, it may be better to provide a
> > ENCODED flag, to indicate the range is either compressed or encrypted
> > for the incoming encyrption feature.
> >
> > We still don't provide the csum, but just let the user space to know wh=
y.
>
> This is free, so there's no reason not to.
>
> At any rate, it ought to be erroring out if the encryption field is set
> on the file extent. From the looks of things Daniel's current encryption
> work is setting this.
>
> There might one day be a use case for returning the csums of an
> encrypted extent, but as with compressed extents this shouldn't be done
> by default. At least there would be a one-to-one mapping between file
> blocks and encrypted sectors, so this could be done by extending this
> interface.

I'd say there is no reason not to return the csums. Even for
compressed or encrypted extents, you can flag them ENCODED and still
return the csum (given the permission check). Userspace is free to
ignore it.

Note that you can read/write the raw data with the
BTRFS_IOC_ENCODED_{READ|WRITE} ioctl.

Other than that it looks like a very nice speed-up.

--nX

> >> +#define GET_CSUMS_BUF_MAX    (16 * 1024 * 1024)
> >
> > SZ_16M.
> >
> > [...]
> >>   long btrfs_ioctl(struct file *file, unsigned int
> >>           cmd, unsigned long arg)
> >>   {
> >> @@ -5294,6 +5622,8 @@ long btrfs_ioctl(struct file *file, unsigned int
> >>   #endif
> >>       case BTRFS_IOC_SUBVOL_SYNC_WAIT:
> >>           return btrfs_ioctl_subvol_sync(fs_info, argp);
> >> +    case BTRFS_IOC_GET_CSUMS:
> >> +        return btrfs_ioctl_get_csums(file, argp);
> >>   #ifdef CONFIG_BTRFS_EXPERIMENTAL
> >>       case BTRFS_IOC_SHUTDOWN:
> >>           return btrfs_ioctl_shutdown(fs_info, arg);
> >> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> >> index 9165154a274d94..d079e8b67fd740 100644
> >> --- a/include/uapi/linux/btrfs.h
> >> +++ b/include/uapi/linux/btrfs.h
> >> @@ -1100,6 +1100,25 @@ enum btrfs_err_code {
> >>       BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
> >>   };
> >> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
> >> +#define BTRFS_GET_CSUMS_HAS_CSUMS    0
> >> +#define BTRFS_GET_CSUMS_ZEROED        1
> >> +#define BTRFS_GET_CSUMS_NO_CSUMS    2
> >> +
> >> +struct btrfs_ioctl_get_csums_entry {
> >> +    __u64 offset;        /* file offset of this range */
> >> +    __u64 length;        /* length in bytes */
> >> +    __u32 type;        /* BTRFS_GET_CSUMS_* type */
> >> +    __u32 reserved;        /* padding, must be 0 */
> >> +};
> >> +
> >> +struct btrfs_ioctl_get_csums_args {
> >> +    __u64 offset;        /* in/out: file offset */
> >> +    __u64 length;        /* in/out: range length */
> >> +    __u64 buf_size;        /* in/out: buffer capacity / bytes written=
 */
> >> +    __u8 buf[];        /* out: entries + csum data */
> >
> > Maybe you want to push more explanation on the output buffer format.
> >
> > The resulted buffer would be something like the following example:
> >
> > Input:
> >
> >   inode has [0, 4K) hole, [4K, 12K) data, isize 12K.
> >
> >   args.offset =3D 0
> >   args.length =3D 1M
> >   args.buf_size =3D 1M
> >
> > Output:
> >
> >   args.offset =3D 0
> >   args.length =3D 1M
> >   args.buf_size =3D buf_size_out
> >   buf:
> >
> >   | [0, 4K) ZEROED | [4K, 12K) HAS_CSUM | CSUM | [12K, 1M) ZEROED |
> >   |<------------------------ buf_size_out ----------------------->|
> >
> > As it takes me some time to understand the output buffer format from th=
e
> > code, which is different from my initial impression.
>
> Yes, that's right.
>
> > Another thing is, it may be better to add a flag/version member to
> > btrfs_ioctl_get_csums_args.
> >
> > If we need to add extra flags to entry->type, or utilize the reserved
> > entry padding for something, or even introduce some new behavior to the
> > output buffer format, we must have a way to tell the end users.
>
> No objections here, that sounds like a good idea. Thanks Qu. One obvious
> future flag would be to return the csums of encrypted extents rather
> than ignoring them, if there was a use case for this.
>
> > Otherwise looks good to me.
> >
> > Thanks,
> > Qu
>
