Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102357;
	b=COwTz6Koab1KcB9+VPWKGZ7yh1txfvlV993Youitl5YusnouzUrw1cnQMemc1pxPJX03
	 ThYOEqN4E2j4EXKlCvBr8CwQmdlhQWtLMyKy5i/0UwjhGqs6ZCNr0/4DfaaNcO7486+dT
	 oZr5kitjHT9GmtNVHkdmvBzzc2Ug52w0thc9nziCQvWO2rQNX2kvuetuVo4RUzK2e6Qh7
	 bfGP6RQygKayL22882bPu3xtLa3OfekGvfaP0tfDj1vC8zxlNdAWM/0r94KbuA8r7jQNp
	 iY1v9HwLdlEM1PttQ0SE9mgfOCKQ8hdOhSjRE5/P+340C7gGWLqgtVfvcbsrL6+rvvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
	b=HZNM8vsLoO8iIDTuIX9X3bGjoYN/9NcYLjwlasXu8I1TtI0/m9no8PgHSx6Do1s6wT1g
	 p9gKHZK4QrqUEH4MTj3bq1Y+R3dP5tqcNWhh94VLxgjWvEKFtRtzzRQ4iA1UZgRCAVjJN
	 TcuSUC3gmGaK9NV5DHnWRi4gjAFiBIrI8RueoRd+9203IkwskL3BBizRTFK/EZOtkZ4Bg
	 Lsm9Al4Ba0AhYkkzbnKEFDlHVFvh8cf7ZFqEjcOTbrbp7inj6ygeo/LBdm1fPTKGDqz+N
	 hd/Ve9xivEnbmPduqF2RFmuVq5b6h/0w2QkvUv1aQTCZyWCApLPFKQOvpiJ2KIjbjEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V;
	arc=none smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49249606A32A
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 15:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49249606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3ab30b3212aso21399021fa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 07:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795102355; x=1795707155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=EriZpb1V/2zno0fmMO54HL34Ty+nBUS/4UO0C6MvrvxZFEYE5Wk3AXr9C+UsTd1EKu
         e7VRl67WTxEo3VDt+hkZtLmFiEHnR1zJiLfC/Bq9BJKAFBDFohxqHF5Q1gg0wFZRWOaP
         GGmxEOrPJV8MRv3PkF03h/86SpZPKw+8KkyhjjjSRymeueMiKP4mQ8rtd0qNdqm/fzoE
         MNeg/d90yqGf1ngIGXcTcG1X2LenLIoGjIMBxdm9LKyp4bnMI848kU3NoOJqH9CbrAin
         fitPeVcUyIY+ve4q72M8iKNlPUyICj34RV6qW8QMN0CuPmRvl1c9rcr7e4C4EfPjdOm/
         0D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102355; x=1795707155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=HsC8uIbKkqAAy6JWRaVAvSxYe3dojMSHoZLhuOLXQ1SLPvtTKsXZJ25b7sywi+yx05
         qzPxJaxL5Tpcr1qvY5mQeJ1JZHxP35ZWNZEDXulzJE099gljPtpGoOPGloHnDLrzoe2o
         lt4btsBG3uzJpw1zLkMtnv/KPKMS4fd0hwNaBdOzjUHoUF28U+N80KYCw3P0GLKLvkJN
         77Zwg0WrEGERWSKA/oHsI/1AjZkDyRt2bVzfl5GEiEmtMA0OAsoLsmb6mWmKf8nbnPP4
         0x8zQBYHPbHSpeemnNNBH+7G2AWb3bsJw9ya9uXgDhxH/jKR8rCrAIhkbtmZu/p6HyXw
         PtjA==
X-Forwarded-Encrypted: i=1; AL+hErFrxjPJwrH2/g+1EG+rsg6tvgoa5f1IJfGCV35FdZJSq9fVqkybz6/7wNoagWuvnMhmgnxSmMQz1IP62g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/hD87JPx+tgxd1X5ulmx41xqNkhuwLha+klrbSD5pIEXx7qagu
	HRKQ5EIhU5fZTFFMofWMngRFeqbFPSiwU+R2QNm7qiaInHjAUXy49WnK
X-Gm-Gg: AZFdTZdMqtbSZ5uV5AsWMhWT2GhYR0XOoRW53umKcCrW1rwmai8gVXhfR/imn6WIoyc
	NuI5TxvPnAVLUKT9rW9B0bPxCRUr3Nq5X+sCOGiid0FJvaL+LnAcXjuUtElPFTo/ZtSXx50Resr
	ZDygb4lAvCMrMTYjVCbJYjBzFkCzXLt1eM/geH/92Xy0CU23hkGq9bTFNg3NSLsCedxRJ99hb0q
	5y35MmN5sGp+XUI8f+I3QJeD8cDOKZZZXhytDqYUQl1b82vJXzXLLJ/EKruaY2Q/iAhfC/Sf2zv
	thOT3PUEwxjmMmbtZB3JKTCszhlHTiXhNhna/7DhMTAiSl+ylNLWZAilvZrUCIrCueLpaM0XFCy
	C5pw/iEd3vgVuECFhEdk2FVzYrjgDDFPXWTANP09eXJcJdvzmENJCUScCMoAYmffHOSumjOyRis
	oRjYZwhtXrIQKuhTklX0TEmqKqttGgNI+ERkZqlkJU/1L/jqBOCWDI4hGW2TrO9TdcqeacRzDSl
	nwBITesEiMxG/lwmgUKNr8sbPqo3mLcO6rk3cT2ulQqwDf/gTsmaB5BL9R5bgcgenytw3XgzPKv
	hVS1eGcDk8jU+bHL7O3otSQeACZbzboPNx1j9xaxcHvHPMbnxij1jYvx4bZHK/xb70zKkJdkakd
	OESNZ5A10xR99/UtW3ZK3fFV6TiNcSpRspYOIGlwuoXgT4FUmdLmDLIwcf+o=
X-Received: by 2002:a05:651c:a149:b0:3aa:ef31:e51e with SMTP id 38308e7fff4ca-3ae7fa644d5mr1204161fa.19.1795102355312;
        Thu, 19 Nov 2026 07:32:35 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxegwnwppvr5uhf9-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:c16c:a39e:e605:54b5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ebe67e2sm11532121fa.33.2026.11.19.07.32.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:32:33 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: koraynilay <koray.fra@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 17:32:22 +0200
Message-ID: <20261119153222.65195-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 19, 2026 at 01:00PM +0200, koraynilay wrote:
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).

Thanks, that is useful. I agree it would go there, whichever meaning
it ends up with: as a newly added flag its bit would be added to
FS_FILE_ATTR_XFLAGS_MASK next to FS_XFLAG_PROJID, since your
fileattr_to_file_attr() masks the value with it as well as the mask
bit.

Your mask also changes the question I asked Christian. With it, a
plain "may share" flag works the way stx_attributes_mask does: a
filesystem that sets the bit in fsx_xflags_mask answers, and one that
does not (btrfs today) reads as "not reported" rather than "not
shared". The inverted meaning was only there because file_attr had no
such mask.

One constraint for that case: the flag has to stay out of
FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
FS_XFLAGS_MASK is reported as supported on every filesystem, so a
plain flag there would read as "supported, not shared" on btrfs.
Outside FS_XFLAGS_MASK the flag is also never seen through the legacy
FS_IOC_FSGETXATTR, which masks with FS_XFLAGS_MASK. That is fine,
since only file_getattr() needs to report it.

Christian, with this mask on the way, would you take a plain flag
(say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
that filesystems advertise through fsx_xflags_mask? If so, I'll build
the RFC on top of koraynilay's series instead of using the inverted
FS_XFLAG_NOSHARED.

Thanks,
Lauri
