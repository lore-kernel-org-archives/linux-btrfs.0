Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795109669;
	b=ZsphZLelW5zjH1Q94H9gzxcIbqVBZm22kIxzn0OChyco8TNivJQL0GI//CQ7hT8ypQkL
	 9aaMuzjhhwo/s229k5VH5ZSW6Nrf7t5lKK7E8I9lCY8uwO5JnoNPRTNhXPcKktSt0dVZA
	 Qc8I34gAxWBWr+ZujHCvEi/xX3IoEBDyrm/WRiTpKoFHP2SBlfSoe07NjGh7KFgU3TYmV
	 mnxOBnpRVGDw9jM4JgR7yjZott3rb7X+AEjPxuSXrpcMxkZa4xRq9y1813dsHsCBRP9ih
	 dXCwz6PFqkkGe6idohoM7nno1jn+Hm2qTwYBXegYmlqrGUWWdDjLc3Lk/0+Nki3Viyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
	b=PVHC0/yzKZjAF3zdiR2gFv/o+42owWpP14HEEljqTuj/nLkPlsi6579do8G4P8tuDaP0
	 KtXwsllYfSxQQF/r0ueWzIKWtjrlWamg7spwGUHHdHL0vnG2skpRwSv5j9f/xveiGbynB
	 91XwH4JWn0cK91YyZSQlKSs0Ok+umeyByKNUe9Zq55TWU9plrzqifDY+j4mBmQ6A2Rmr7
	 /DytLgJN0XZr5znhHd3HipdJNEbuueqT1xEto9TfU1aJc/VAfUrEGrc8RwAm8Bp/jllLF
	 hqvs8mAYdqiwZ10ACoCOuBW8E8hqZIvA79h++LBSUbo6ERY585yTE0ZtEQXyR3ACf8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nGC6aRIF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF1A606A334
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 17:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABF1A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nGC6aRIF
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so4220506a12.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 09:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795109667; cv=none;
        d=google.com; s=arc-20260327;
        b=KkyNKydCY7DHK0/Co7CbgxDgNWuoIusS+jDehvfMynmPVm5qfT//ZQVnTh5qGC3M96
         3zazvVY+aJb7gUaXJKK1ANIBK0e3U8oEMS7GNKc1g5mG/b4aaTaZs/muapcQfBDL0lwH
         FEuU8V/LjZZA994P7gwYoAlgP6xVFQeekPtlvglWVNLRtX06xPHb8tmvgwR10JgnuC1D
         x5pyXJSk2lj2BtiPxgaFIZvlsjEJat4mzEt/32WGtE6tlSkgvWMNn7o3oyM056MRFnqw
         ALfzc1AKsUmVMnWlY98VOMwWZs7NsQehqMOkJXn4fPjW9UFy7SO4cBNBoLdi3aDggEhf
         BNvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        fh=PsQaC59Nuudc2LRRdImkGexwZ/qzFLnEcdHNZoGnbVU=;
        b=THY5xA2rPCXS7gWFv2HrMtJbRustd/8vOe8hsQ25d1/gLcacMQmpGxYhC0ehgZfkpy
         PyLS9XrwA2a8FzDXgXb4u5P5r4rm+Iu6jVCaFrdEW2Le/u22ab7p1fdHfXMnqTDk5teG
         eSmeqMrOVhWoSwS2dzMxaV7dAA5/rI1cB38/SgObbIKqIwgCfbiEsiIcnXN3FvP5dYSc
         y2iFHZJMw8A8c0ZK2dqy8MQ1cLXFoUlqum6161cKBTa02PGlhREE3WIkBbwzDpNDF9St
         Uuioo8/uFQnfxr5RUm6Uf886alNn3rTK61RHX53eJEMxqYIFPqZ5AgKVf7VQJjpZP7UC
         vqMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795109667; x=1795714467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        b=nGC6aRIFchP5t8lwJ/zVTOI/bLa8AV4FvgJg6w8MF9wmm1yRU1tUTokZFa/paaDJ8e
         5PUOtHahetL7iiRPD9uRZGlho38PnlwqF01pD+GRX36RYtqopRY+6tUdIUx/3qzL/D90
         5amQJu0ziL+hdep3ub8xpqOFUa0Nq+K1582CqDJ7KCIXsfa6geIe36gqovNyjbgAUMjf
         2HpGIgyOw12DPpv97GDYb45yfSyQVjodaas6oDy6hcvHkFleTSnYO0ogudCUxCFaFMOW
         LleZntAPokivShBafvD/8UUAi5Gk0sYRA3rFd7SRoFsU1qI4IwU8icU0s6XL5OAjoNTc
         ilJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795109667; x=1795714467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        b=EeXW0fyEWng6McgqU7wiFABDuEdbcH2UcqPn/miPwI6jdsRZSHmj19iT95cIFk1Sax
         tsOIl16kBPKMUHGQ3XferqUCP5yeX2qJ+JWYlYFbA7GqyKH9SUFISNOov8/24z8UBsd6
         VmnvVhOCr/udzCb2ABWAKxmfhEILjgXnFkECaFks+Ik6ICTuJaPmBHsH8S0vqpFZRAyw
         PIAKaeRBmDWN/fX1D0KqYFSnuMxSkFvhnnu3PhiG6IaHpCxGEKiD8K3gBrrZ01vrFFXa
         fgSIdgRAfkV5VILFUaMQikSv9OFY29O9VwO5qZ46ckZ2wsKbc6jHsm+takuNS9HAz2n8
         qwGg==
X-Forwarded-Encrypted: i=1; AL+hErG0ZANQVtbqgWUL7uTOMhqCQ/V2NWRO0VI6VRVMKKmXogyX/K33N/hnYo9+lJ+DDSDAfWMd+uxRjn8+5A==@vger.kernel.org
X-Gm-Message-State: APuU4Z8WAczmX9QXJirTNQk9IXNYlRB339Li9BQQT9Zlyk3SS6Tar0xx
	uc22v4hOM/R3SRm6ok/Cu+ZUr4l9SW0XiuZdrSfqODvyZXfjN3r8aDOoKn9pMXe7ZPoEeROK9yP
	CpGIQ0lezK/FXZjKktUezUa1dGZswtbU=
X-Gm-Gg: AYBFou1bmQ4cZWl1fC3VecOPgPr570IbYB63/EjaoPXyit2DVi9Ztf5HBm+31EHPIW1
	qCObNxxn76hQQ2eRal+pUp2qthO0AXPeAZwi7dXWCc04JtZpioCq9zKEYaD7U9wOYAtI77oY0W4
	l+Z9IJ0FdWKBum47exhaSerKODqftSMlqYJSwa8HfcU++qYaXWAuxxroc8/73b55RdH8Vo9cnwu
	wGgw4jqigPieWMYFktIKIfafMR4FdRDwKLDrW+4qiVlVzcvrt/OmhI+TeaRsyQF0W7O5egMMWzK
	4pkt7IilltqJB2gRrZpktBGM0QC6fQi0/IcCsMyUTi5L1qOw4oMZN2d18VyiwVRujyZXQWuLef8
	60vMxsBv5bPgapXYBK13nR98Z9SX+ZsVuXRMORpIlrCdsJZZvt5KgucLFtcordYoKee3nWQ==
X-Received: by 2002:a05:6402:70c:b0:6b8:7d98:4826 with SMTP id
 4fb4d7f45d1cf-6ba37d5bf0amr50117a12.11.1795109666761; Thu, 19 Nov 2026
 09:34:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-10-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-10-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 18:34:14 +0100
X-Gm-Features: Aa3M54rix9St5Car4447U2IPLFR0HdY95bNJiBlGTi0-FAZstJdvxSGCP5IQDxw
Message-ID: <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Implement provenance time (ptime) in ksmbd, as introduced in a
> previous commit ("vfs: add provenance time (ptime)").
>
> Map it to SMB's CreationTime, making it settable by SMB clients. When
> reporting CreationTime to clients, prioritize ptime over da.create_time
> memorized in the user.DOSATTRIB xattr.

That doesn't sound like the right thing to do.

If the server stored a CreationTime that client had set, you cannot
override this.

When the client sets CreationTime, the server can decide if it can and want=
s
(may be a policy decision) to store CreationTime in PTIME and not store
it in user.DOSATTRIB.

Fun fact: the user.DOSATTRIB format also has a mask so storing the
creation time inside it is also optional.

Thanks,
Amir.
