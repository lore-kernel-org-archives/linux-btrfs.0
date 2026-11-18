Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023477;
	b=BmUCQeEY1d5Fm2nW08nQYQPlwtp8POON91O4JFVbsqkR8hGIlnomk/Wnsi6d9tenxSpw
	 XCvQIBz+ZNTeC/qbW9jH7TX/otdqOnmTuywGnrpnqso/ZjCQS0QaeIL/JK5cnNJHUbbhX
	 cohUWNJ9mNRLD0eYLST28J4VRFK3xl84iKT3yjrhoVjZ3RlMvFPNwjbbTkmcaL3KXWgII
	 syxtFUWevt/UdHzqOqOaXC8ELr1W5qiFo3vB3GeOtzjapUE7mqu3z81n9Zsb2BqxpNhS4
	 VQb6HSVpkGci7GxqeZfNiiC1tYulqvgM+M1MpgK6h5wc9TAGSkawOMztmx4vIyEXN1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
	b=PvKmtD44e1xjDMR/I/2udQOBlYwF6ZVmn84FfZ273vZ+WKUfF3l0tnDSf24WYtSpjoPf
	 WlLCF6T78Olj3dUxOMLhh6cpwDcXncbe6NfTttpgRoUlTqqhdEe+686i3nrANZgUljp/r
	 4ci19ayPzH0Jyzq5lQ5Lxt0o2ctcowCEGYYmnUT0DiSdEKwDSFYzI/Qp/ZkRfReSzyTWE
	 TN70bd3CJm0V9ygcJvkZhU9Tu1IpxaRXHUf+G9BnxX6S1jzGcQB1ugjdg48aVyQckDJNK
	 wuTgNQWNspiEov54miq4W0pvUb8RAkoTdEU4VCEB/2ssIC9rB2xr3UuuxhgeASMUM8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4Fx1cvZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3003606A331
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 17:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3003606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4Fx1cvZ
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c40e30c26a4so14886766b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 09:37:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023475; cv=none;
        d=google.com; s=arc-20260327;
        b=DUvRPp5MkduRQA4LgwCEAApXek8D0hZmHIKYxSPvVK8gIfLGEtA5Ls5UO3O3fTS8cW
         Q37KvRJ4P+shZNVatM5yPsWYtA+XEKhhTHV+J62EFzqvy2wB5hS0OYAqeQ4HkOdqfSNF
         E7soFHydlmQifVcbcQaKJa5qUyY36T0PjnVex8zZSY8xmwxI9kJxutEV6n4usBK/sHfL
         ROLbzOL/1nbrkPOETX306lvGosxDgT7rr3k2qy3AfsBJkYgCzWz+Y+cJaKvGFcVOvyGe
         Gm9KxhtKLDF19Yfom53t2H8RuLqyxgs7VhoJgG0hHCZeEUeWmeHA6WTTi5/aIWTJzVFK
         LFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        fh=lRXJ3kY5K9N0abSvSWdK2/ASg+tIj/9eAls8/uIsMdw=;
        b=qrii62WcACfzWV714N6POa3QDpfxI2RmheP7nq1oye2IC4aWYqAILc6UVJ9ffsuR/M
         uVDgq07Ium6pS1eHeG9xCcFGSIpID4Um+i7T0eL7m4IcejogUi4Hf2vQP2HdaS+DCVZT
         cQybrjGaxGv+6y3twTEbBLDaZgV5U4o1A7DPHwNXdCm2iLe2715oT9uaPobJe6azCUAP
         4gTzAWHifyAZyu6uMSTjCGtIFfX0s3kUhi+k8oyVQvgjDwT1gBIu+Q3ZeiU12eTXKJQs
         yf6BBwTxEMWJqoGbtZ7r0uEdZIjOTfgJgW8jinb6VwCrowMQmLHRd1zGyDUM/HKy7X4f
         pnQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795023475; x=1795628275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        b=B4Fx1cvZRSB70oxXa7PXzsQOiKHd8kick7ujHIg5sKZfXngwM/J3md0QrwQw4limgc
         gzD04fGPnUdH4vsdPqK10mZdRL8XnpJIKSo8akWEM5mP1fwpa3D6R1ZVi3kB4ftkkRYT
         t3eglWK1B2yIv1p5oKl1PvLjjuez6SSOZkvKdegYNTew2mBmZIppnHMoZW7XAD514J2T
         Wkz+jc4JDJW+IYh3dYSMGjOQlspp4IYbioQrh478oLfKYgEeEOCfp3zOdH8mfHNwLEAs
         a87jaYO1D21yfJt0MK/CqLT0XQY2LPKrrUvneOLh7WazFrteu6Qq14s3DdjdZZ4eW7Xb
         Uy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023475; x=1795628275;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        b=fvZbQeerB80Bw7/TMXNRYpVXVC8yoT+1aSMQVGmUoUoT+a1JWrlHKbE78h7R4ah4Sr
         lBfVOMlcFnjf3RuRMBjRqHUfvgNjGt4pp7JpDMd/72UnL5PRLTgsX0OdRHqm0J3Fl0v4
         czoIuZiZ0LpGPN45sR4wFkOEm5ciYdE/HGm3excvi9l6nWpLHe53B7L0qM8iZh1vBZtz
         brfwsCdGWbX8OFQ/qjqTxnsCbEJ1lsRgY8pbhoSY1ZMMG1tMJ5QdVYHYD/SlAqWmWcqa
         pZ9CTY+gBIX6Yfzq2DD5PFJVCcVLx4MEVEYL/qUlYCoL3DgFxhUMIW49xCFb4UdiMfHt
         pdGw==
X-Forwarded-Encrypted: i=1; AL+hErFuXEwAfLtNlMKFgKJNj+W0bnNETNH7F29+hO7jMl9ccZWGYnTgQRBhF0r08v9u4B1yKdLNnchSkzUYDw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/F+5450eu0x/Y2efE/iOtjjX/jXEmclxEaELJB2ozia82dtpEY
	KPlyPVLBYInM4hLgre2IWyZx79YY2FMRYo4dVkJYtGLaskWxf7O3h71CmybwxtZ4lTOOpoezqh+
	QSNg2MU6Tslk74wiIPKiPtjxQhm98eC8=
X-Gm-Gg: AYBFou241YoWYbVTzXK5r2ZyZa6FVEK4mtGfeK0sR3F314mHtlhLJyjMPNlcgvQGYAU
	VPGRf69+Ee21SHqpbk1RnfEzv2VvFgnYG6woBQ+WlAkbZDgO0RLyXLmIKgCZJkvy7RrzEIGRsPE
	cNEVZ08syOhKeoDG8dKYxc/dk3qMWdLSkBZl1vrUyrVi224kewTDkKEPhUMgwzJMtWhMX33FqzJ
	cWixGUNfMpHccyKe4TTGi5Ie6d1o9aKTfkcsuWOiqw/XnUjzbl5DzyxKJZdiufvd+Ha901YKXAI
	h9T26JzrAiw/HyR7OWgHJfWAOBqTKXJ8YIIc0CGUkg1gixSIEuQrPue7Uo9vgQD+w/NHgS1NY6V
	xlCqDSRy+8WsbzFgYKXJYOan4jwyfYtCYQta2rcJEr/P5+78wWb41DB6oN5+grkxsa/wbmg==
X-Received: by 2002:a17:907:da1:b0:c49:b6db:1 with SMTP id a640c23a62f3a-c5126364307mr15604866b.12.1795023474965;
 Wed, 18 Nov 2026 09:37:54 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com> <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com> <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
 <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
In-Reply-To: <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:37:42 +0100
X-Gm-Features: AclHuK9j8na9qQXXbOgij3n-j2Bo4JySgielhO0fgIJ-weX9anWXgtr5UxF7Q-Y
Message-ID: <CAOQ4uxguPD+PWEUZtAzSdA-15d_C5cn=34ZmCm0v_b0MWK_sfw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:14=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Wed, Nov 18, 2026, at 11:36 AM, Amir Goldstein wrote:
> > Can't an NFS client be connected to another NFS server
> > implementation which does allow this?
> >
> > I can't wrap my head around the problem.
>
> You already named the problem in a previous email: What happens
> when the NFS server's kernel is upgraded from an NFSD that exposes
> only btime to one that picks either ptime or btime?
>
> Clients will see a file's btime before the server restart, and
> afterwards, they will see a changed TIME_CREATE but the file's
> NFSv4 change attribute will be unchanged.
>
>

Indeed I have.

My newish proposal (on cover letter thread) is that we
abolish the ptime/btime duality and make mutability of btime
a pre-fs decision which is advertised via the get_fileattr() API.
So from the user POV or nfsd POV the values will never diverge.

Thanks,
Amir.
