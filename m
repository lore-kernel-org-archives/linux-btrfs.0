Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793123600;
	b=jwN/t+FMlU+tHZ/Mx4usz/Avz2E3h0JRM2SsPxVi3VvMD1Tde7s6q08Se031px69ZAbr
	 OUYoqszk0Tg+TGi99SoBpF/RKSOubTBWESTPGl7NlyfjnbuOOHnYfdQnvr+aa/ZCbmElk
	 qsC99F0+W7BF8ae9bh0qhOk2l577wiubBY4/XKHgpvs0sa+vDlFXkWNL236HebOdmf9H4
	 yozo4FxJU2tP5/jIZSJiwo0i8wHTdxNNpHu6l+U3cl8m7kAf+x+eEU+zqT/CUk4XUPer1
	 HBZbk90Aef7Bmq3UCvYkha6abv2a1QAhnRC3f4ZRGjwFBq/5Ns9QbuQegAnvjVUN3tg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123600;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
	b=5X/aL9o4yAdL2Vo0fiVnGQo3hLQiHp0hFpa7RDQKVQhwicgPTenGy15+8WDpLwQj2vmp
	 g6DA/eD8oxTx+4s/Z+pIY98N4TcYPDysbzQFj2IA/u3I/YJcbWENgfWWtXj3u6fcPYRaX
	 2y5shjt7LYoMPc14vb1XaLHGViIhiz7bKQ8Uo77ZsegAUHbzjQLw66HpO8rtk4VmpBRWe
	 NT0CKiroOBTDtP1+B98iph+Me+HSctw9voCsaoe90itMGe8gPbmXUiQH/pV7oYhn7/QqA
	 clFz7YPUO7P6RFv2YkdkU7QxVRt3Ne/3ojUJvGPbOYXUBAMvo2Ayj8Ybl6H5SZ7Tflg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=inJR6ox6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A51606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 17:53:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7A51606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=inJR6ox6
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c450ab1483cso13279366b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 10:53:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123598; cv=none;
        d=google.com; s=arc-20260327;
        b=U9kHVLCh9taBMNrLdjcFSIqfW1S2i4QziYO58vKcPCpb9NTOTPfI4DWfiXn3gqZzCr
         H4ZRDY93wTj0n6YWvt/MAPyCG+OW6YGNA/9Ka1bM0AZzfoHFBQtQxe2GoZb8NQaaZvpr
         7ghuba9XecHZqxQJ94fjui1nPb2ogdu1PcKu2yTXigsT13yIfbpKyDeefXLB/3owLd6d
         gqOCQX8aXP/52vUsmQN/MORGau4cLQzNYY9cbxQ/HYcLkBWBY2aXegXd+N3kFjdYhDqS
         oAO2f1uzlwap3/5i7e4wrnDf99ri/mcW9lGA3gXZgab2ytMW1jq4kQZDcWDg2Eh14Ynp
         BTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        fh=sZGBc9KCdEfBCUgg8XnjXOrspPySrwEBoRaYf6XBKNQ=;
        b=clG4isr9juChElR02H42R5NHcBYhAJ2R9H62LzFZoJtAUk1Eg+4UDBw+mztta9Kp0m
         DlS8UslvuPp/7SZn1l74bGGY1GcMaX36y/3bacJZUrQlIEjdzvObqeDiZN1BWJQBeUe8
         DdDMr4hMFvGxd4/xIWp1oFiKVcpPZWzkRK4OTl42GcHOj5qBFbJDYeLD5SqGiRSJOqMM
         A/kQXUHT5SI9AaLVgXW+eN/4ed14AOhw2GaQCC/Hyxbk+YaYzoF4+tER6M515+DfWFZC
         Eus5O5uZaJLj62tB1Ydl89sef+DAgTppXCooN47gk5Rkeq6SsKpvTkTwldV2xCpdAHSd
         reAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123598; x=1793728398; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        b=inJR6ox6aQPgzkJ0wZYiPBugaLW1/kUDoRUxznaXNPrxE2Wn3DkQl3afONPaEwO9sl
         vnrt6FP9OFfRf9KWlwZNng3ZlaCrfp3bQxPXGc+Gx+AORrKLJ8WZpN9m6kJEM6IAqHPq
         Jk4iMXPxJgkZqxRsoYIxQcD6CPbdcJbwTT1mEJs9Oh6VfooqjmJi5DvsYqRTbZ70S79m
         W2gdT7rvplj4k08tnzQQgxgOTLo5uqZ4a0mScYBLYVaYMXTVeZPwvd3azNIWeu6/sXO8
         zyeS5P1gD5N0vXZJTHB1IRGypOyTZEZWjLyDPXDDqsHxY4MhwV784zCuBQDBJ99Srvxy
         lKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123598; x=1793728398;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        b=ZbfcntRV6Cqde1BzqSiJxINeaqMNcy68ohVi4qLOupm/ZCOWogF6wrLJKovZvKYcDk
         qy42EuuhiCVUMSvziSyl6ojELGfpfgcaRPpk9wRbM3BqOsQgJ8dWEnafstOdb3Ou4xwH
         kKLeJZCi3FmPnaPRaNQZhHHMDdvBOjn082nOZDE3cdi1anwmD+d3xVmZk6nTb9priMXr
         LD02MU6LOJueS8CXmViv0pKXw3Od5KTOsj3Q8W4NPUWxtjdmjS+dc0SX9SfrvNC0WiIx
         6q4Z5h/L2j24E+41spPm0HBeOjIqf8Qai1T144iYR9KZYeOUBZvF4dQS+yeXDaKLTg4d
         Vzpg==
X-Forwarded-Encrypted: i=1; AKwUvBy9Fbpfv/yXkxmkaCeax2cXB7kiX26/nbPiRC0d22d8tVwPp8uCd6pmyuUcrrGEsxVgYJmmK/255Ak9zw==@vger.kernel.org
X-Gm-Message-State: AFq9FYI0jjBSqhYVKNprm/9DgvIcnZVGF7nU4WR5m/JR6tKF4wmp+Xz8
	vLKrSxv2KnJhMRsR4DMti0xuePeBkODVi6Go/LXozBTxsaCwqroor3bxcRZpjHWtpu2gostprrb
	xwCg2AYSHdR3oYWvA56r4akS893arDWZD7DWrf5C5
X-Gm-Gg: AYBFou0SZqNzxqxDgp7DIpq6zaNRdNl8TOabbQirxjSdoBNRfAJiSLz5HxXWX5xps4Z
	6NztsA0HLIBuTgVOTVP+R1E70kJOvVg63hcy2jKyrf6ckwAgOwIsCcMkkQKlX2pb7Ia7Z+MFPDT
	shNPJorT3DBY+S/iH97v2khgq+4QOjFAdfdNS7vuqxCk4KjgVcwMYrVW4l+IGeVav512lEbAuo2
	tQSaZlrjRqI+vxOlZdEhQoWlCeDb0G1pm4Kjf7miEd+F+fP0y7V1QFWhjGKXrrNW1xkYtvKjlsO
	5Nqam+gDxOAB4WX/pRaG+tKM67iAy87pF3HcFU1XGDiuIE4Oln2TvHQXR8h7FNbaMJkM110Szk0
	CVscazaPJdbCeXsOgEeknaMql/89ld1lkEP9TKO94ZLrI/g7ttvu06RgkFsrd/PwPfFoscZerhH
	ZmFRh7rgyutIR+D7g0PparIhIex3Y65lJeYRcVzd8H4Q/YzEi8YpII7HE2ZoAEgiH34Aq1PRSxW
	bdt7fDJo4NGgw==
X-Received: by 2002:a17:906:dc8e:b0:c31:e958:408c with SMTP id
 a640c23a62f3a-c46bde8b464mr1159692166b.38.1793123597614; Tue, 27 Oct 2026
 10:53:17 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-2-jthoughton@google.com> <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
In-Reply-To: <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:52:40 -0700
X-Gm-Features: AclHuK_7gnb7g4GjAy_SA5zcAxXhabVZixR-oCAtO-qS-tkfEqOEG_LlV9pvyY0
Message-ID: <CADrL8HVgOYb1hzWDJzm4sCrEAR7PL1xBv-1zTGebTusPoDsGXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 7:41=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Thanks, Jens!
