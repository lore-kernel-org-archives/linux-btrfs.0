Received: from par08s09-in-f2.1e100.net (unknown [74.125.230.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103FB274652
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 03:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782185003; cv=pass; b=KuhEMPiG+uIhoDTpno3YhP7Ks2gmuWxNL6HJgPKPJoQUdfI1mOhdRHPtyupx0UOFlRn045IdlQN0E6MYPCVPR7ZlArNfwEWlwbJsOoWbGtKfbskCCkt/+0ZdjutRrmIz/ePqGKa/Hpiaddp3WeNieLcjbq9Kexdb4l70hvaFiBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782185003; c=relaxed/simple;
	bh=8VY169yoDsUZvQnSUr11UinOfgNn4qBwIwWdTDzWtAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDnsKcyx/ZOpRZwtMbZZkgHj55YxaEYfUmblFN3XC9IySeeAF7Flpp69XAMQnhYMyGi6laAnFu7rf4AAixkel6+6wrK8saPhN7YIWayhelDbXzsIgSjMruihk+iHLnh+NcuVcPVQY/Vjae+Vd7N6IAQ74RKQSWNAw2IMZotksf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rqPhzzNZ; arc=pass smtp.client-ip=74.125.230.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rqPhzzNZ"
Received: by par08s09-in-f2.1e100.net with SMTP id d75a77b69052e-519bcf4e3c7so124991cf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 20:23:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782185000; cv=none;
        d=google.com; s=arc-20240605;
        b=EmhfGKIhrGAhPvg/qHX1Vyv00Ap/Xti9TR81fogWCFZC1gwDbbpNLpH4kvmkEaCkR2
         8np+4KnhH9ndR4A3RshAnDbRHUiyobRKYCVsh9yU5C1/CrluDM7Gl7LQxmQy4b9Vd0ci
         pS+XgUKV4EQ4pkTEfXLcDzfqedVYLa7SOp5uIOHSx5bo6foO9otAEDovbdw3CaPdglqu
         5RW1JakEmElvzzkE9F3yGqEP/8aTZEGFvUtfVTOu6IMtUZEChb+VYMeTgVfPCO8s+Aci
         V7mfadGj7fKPR5o5aEs9pgp5ytQRfRyn6b3HA9JlwQqanA3iBHSAk+XfVnqJn0WMD4+M
         l4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MIA2uFVOtEWuSWuTv7b9wc7gp6As3ibpW7FusqNpJ8Y=;
        fh=psZItFL/+FAht2iyKn0EbGwZHdBOp9HV7cfx5z6Su0A=;
        b=dNL+mG6TcTqyfO8v41gLhHjQ7sowQNn8bZHd8xk9J3vy7cu/Dn/xtgwsxzu2i9nWqH
         6V/WC8H28GUp0mTnyZsLrCBlv0Ba6H3qJnUnJnFsZWQyOUc0XPE5/wuczdAR/Yn/CDgF
         bFtGS5R/K6UsXFmSZ9ZDxYOBMH9KwxB7xidg/U+/GzsV8Yb69aNbZF/f96112z76QNFC
         2zq4c48S4PQGovY1c9pdU/wlab6oOTyS+iYVAqn0G0By451pzUmn1+iggEZhbxItO/bB
         Crjtoi1I2Dtn1OfEgkNoIcrzh0YqG6Uzq2DyHaQO0JhpPDwPVpVhIRSrRnlsSzyiVM+U
         dNCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782185000; x=1782789800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MIA2uFVOtEWuSWuTv7b9wc7gp6As3ibpW7FusqNpJ8Y=;
        b=rqPhzzNZbbxYhDFbzotwvmbJ4jAGF2vE8qT5WGJDiWLkdk7TGTib2XPdOarNlI6cgY
         dS5Wu0LW0ZGHrAi6duGjc/VcixYgFpcdbmsrIJCy5BGDDwyMUOuT6j+XqSdImATyTef8
         VWTm9qA5ymX896n71Swg/rTmegdzi4IprWzHZwzSS5uvE8RlkqXvKX/GyPzX5TB8V8RN
         0H/yeJtPOTTDND+ippd7TEPdf6WMwu60w8vA3KNHMZcc/wJcEn+VizeGPU8YUvJVVguD
         eo4V/c7bd1cOY+AlymXqLli87itfdbPGPNSjDiXsABcvtHVngE0S1EWOTvBGk016LoRK
         oxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782185000; x=1782789800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MIA2uFVOtEWuSWuTv7b9wc7gp6As3ibpW7FusqNpJ8Y=;
        b=T+1188mpcn/5SxxJNFYN9SJq62upjqJyAYkRASeHbVac9NOHglr7uxPQRdqUSIGVOj
         3yH9EW8COQQI6jsZRiDCFE1MQBSrqkLnZlPk1qrpaxcf2UPvp9xFkZCDi7Z7PSVcUVAf
         W8rHzDGSORFLyX0J5sagArvJcoLqXaL4Chuc5uMLpsQCHR0WFp4NnFcWc5gXjwac5cbd
         wl7BGDIHy74BM2mfEXSW2qhclIyT2+kXRz5AR06rTxQaT8mxwFUNGZk3vt0Y2190z5d+
         3nKdBhYlGr2WKmWhWuzIAzpK5KyD/8s6hA2tdGHFT2N1zaSIArEiG0Hwzjen8G/OKmmY
         cjqg==
X-Forwarded-Encrypted: i=1; AFNElJ9CM77MF58xwJ9o0t2DAMPeDctUdXpzeaGhnGwQi4xSZqGc4rHRCyzLTvnFCTlsvGffgrM1GPfIY228nA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSU9Ftad3taoDrWBkvBIU6F29HBhALNF1YYxG9WEJnqkm767wx
	Q/4vO9wjZ+TJ/YM5hHFYMEBDCvZYil/HGBn+gXeAn7+hgoy0KzgYcgTts6qXLbAf7KyT5kVupRc
	oEczD1v8EmvIphlskKtg/DvuNNz986fs=
X-Gm-Gg: AfdE7ckuzqtJF3k4PHWr7SpG5W0xG6N13GyJ+uamYjtvQESm1uiEYLcVifHkdhqkyqD
	X1b0I377qgmPZmYvy+CmXlVf6S/ff/Igxo+15nTfDiNNdAMqmu3+kTkVNvHi0egfCDaP0uxMXTh
	3nN6kxp0hDifB3C0nRcvPqkx3rijrOwEFYFaRsR23zpsZc6TGpWHhazf0cknQMdsNTzuY4ClokH
	rHoj5cqdGsdKAw7I22GleoZgLAW0fLNblymIIZVkciSlL+6dpWBdGtbyyy8Yj4l2/KJ8GV9jQhs
	/NRGTWWrLiSEpK39ZLn68jKUow2q
X-Received: by 2002:ac8:5889:0:b0:50e:6311:7380 with SMTP id
 d75a77b69052e-51a4f4caa39mr32137051cf.6.1782185000501; Mon, 22 Jun 2026
 20:23:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
 <CAAuSuOoNE4wgaqx-5MH_cqpeu0MyrUikrVS98K2H4xLnRW5mxA@mail.gmail.com> <20260623000756.GA150664@twin.jikos.cz>
In-Reply-To: <20260623000756.GA150664@twin.jikos.cz>
From: sun k <sunk67188@gmail.com>
Date: Tue, 23 Jun 2026 11:21:43 +0800
X-Gm-Features: AVVi8CcZh1KZ02gLX-0ATqAcH-H159OekAywx8sEpX05A9XcHPw5XpFddie_E9A
Message-ID: <CAAuSuOphPez=WPHA-r8oP7kXOffV8Z00YXscd0kUFZE9pAjUSg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
To: dsterba@suse.cz
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 8:08=E2=80=AFAM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Mon, Jun 22, 2026 at 08:00:06PM +0800, sun k wrote:
> > Looks good.
> >
> > Reviewed-by: Sun YangKai <sunk67188@gmail.com>
> >
> > BTW, this reminds me the print-tree result of dir items that points to =
a
> > subvol, which currently looks like this:
> >
> > item 4 key (256 DIR_ITEM 224155391) itemoff 15967 itemsize 48
> >                 location key (43123 ROOT_ITEM 18446744073709551615) typ=
e DIR
> >                 transid 896627 data_len 0 name_len 18
> >                 name: home.20260621T2000
> >
> > And I wonder if we can also print the location key's offset field as s6=
4
> > to make it easier to read.
>
> It should be consistent for the ROOT_ITEM and references and we can
> actually print the name of the tree, as is done in dump-tree output.

Hi David,

I'm not sure if I follow you here. The offset field of a dir item
which points to a subvol is
a little special. Its offset field will always be `0` for subvolume or
`-1` for snapshot instead
of other values. While in root tree, the offset field will always be
`0` for subvol and `generation`
for snapshot. So take this as an example, when location key is (43123
ROOT_ITEM -1) in dir item,
there's no such an item in root tree, but something like (43123
ROOT_ITEM 8750971) instead.
8750971 is the generation when the snapshot is created. So I'm not
sure what is `the name of the tree`.

BTW, it might be a little off-topic: IMO this design is used to search
the last snapshot when the
object ids of multiple snapshots of the same subvol, which are created
in different generations,
is shared. But we never allow this and always allocate a new object id
for snapshots in reality.
I wonder if we can use this to make snapshots really snapshots instead
of a read-only subvol.

Thanks,
Sun YangKai
