Received: from par08s09-in-f3.1e100.net (unknown [74.125.230.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC9F17BA6
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 13:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.195
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875983; cv=pass; b=NwBn5GSDO04Y0HXnDGTA1yK3fqPB6FyCCRIaU3jTbXN5+2orb5XKjm6YfyZnhIR8xl0fi4ELBSywjLJocJ94IZ7bm7zxhaXe9Iu74plqiHGmyU8LjQ9OnqcT04wbhelK9YCx5RMmZN0nTJ1tHcGvCenrJov7u47EbbGBO5Q/bVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875983; c=relaxed/simple;
	bh=g8PuOrB5yePAekHLV+qF3am7NC9QsTrYLuOh26RuCPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tydeOj9HGptM1pfZ24+VKKuHZpSYGw5UZz2k4o+5TdS/BAiOm/b8r80PInp6v6FuD+8JjqXc+hy8Ph/0pliviAD0xcGzrp8R7+Nyad3Z2au86z/hTioHiJeK9VPpueFy/GEcTIfjNbbT0UbniYVtP18UUF/7FLVmOKvpeE2HpWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sh2AYe12; arc=pass smtp.client-ip=74.125.230.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sh2AYe12"
Received: by par08s09-in-f3.1e100.net with SMTP id d75a77b69052e-519bd35cf08so32261cf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 06:33:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781875981; cv=none;
        d=google.com; s=arc-20240605;
        b=fY8ms+FRhNgHX9lWoxGLP3RsPhMf1dsHGQ7NMq77iHg76LqlzrFd/SFwjG2UN78Hz7
         3ZX7q5V5ZcdYqjSBNYifpA3bOsu8nse9JP5lytGvOCYiSA4VKXpUf3euzcrpvgfTxMaG
         aM1FN7XChkPbhOpwuH2qlFenhAwVQ2IB97MsOCnyX6PSDgtv5QRJXDokqZyBFPUZKgnh
         +XPHqdHatiBZ0IKICOiDTBtzfS6FtGXqDw0L4VZ8evAxL6AGBx6MJw5YPWgAZLaGZsUa
         zsA2h9Ujb1WYv7/sAUUO+8SKIOoHPdtFgkbTvFiLVB7wtrPi2mBRqJtpD8bQcxmP4bJA
         uVtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=g8PuOrB5yePAekHLV+qF3am7NC9QsTrYLuOh26RuCPE=;
        fh=2VjqIDvTqDhjWPgitG/C1aY7mIOZqrp/iCU+QoOKWXo=;
        b=MGmaXRs1y+GFVjzQ40yMPkbQjvdQjryREPOqYrdW4tvFMgKvd4FnIh+R0hCYPnYoXo
         RB1IBWUxUsn+KECNQ7nTUJVHF50UQ5WesG+w3y35Mpj8zu1BAu8+o43POPRq/Zviq4DW
         fPiq/VarlWVpe06FSybqeFpt2MEO96rpHIAm3e2INgUomGqb55qBcdCpWLYg4ljI8Hd8
         RJ2q4J3JEkCaG+ogi7olm5PtHbCWSlKqNgSESM6s7w8SeUMsLop+tncWDMq1zvzcpw87
         WYbuwmIjVseGm51YyhiIWs6rujXNz3AhbIWvd9aNWj+6Tc9JETMKX8TLO2c1wK/AL2vr
         gdZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781875981; x=1782480781; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g8PuOrB5yePAekHLV+qF3am7NC9QsTrYLuOh26RuCPE=;
        b=Sh2AYe12nqbPQpvsIu0vpupqtKyWfJ3cCMIEyLYqd+3i7oXXcnzR9LAbnI2icvRPtJ
         rUCe9VmpQ5snqvcIpcApwNuMNJVcdz8a7p1grrPt6/F1DHgMoXs9hrB7sxnPE8Oj9RuM
         JumSaX69ZgglgscrvbrvbhgXdKVmnD1/+5BgQbc0k/0KJ4rH/ouA7FPA9D4ll6XkNKDw
         q2rUPZ7OA5TDasjPc+qSwUJJqczdvYZR6g41WGyLmQInsVGvWlrAAVTi6q02tzJu8286
         CgQdPPnllTgoL4OlZBzajFMG03lUGtJlZ6TYz6dFlOylWnvE9ia98j8iGfF3HODCuvKs
         BS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875981; x=1782480781;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8PuOrB5yePAekHLV+qF3am7NC9QsTrYLuOh26RuCPE=;
        b=PinfmLMv1T6eoQQEFzWNeqk5hK0KXljxNHenHGf94rNsdF1muQFP/CRJPd1aU8LhmL
         ZU+JFkSJ/ZEi9bwyuD10A9W15v811Uo1Z9+RkSJP7t2DAoHNgZyQjlEzMKzTJIRJfMQl
         w2yLpahsfLiHbRx5AmCGi/4GFllYA3yS1OL4qhgWw3VJ79LhgUwkIFhD9S8lRf5gM8ld
         Vh74MdOD8zggT05UHMytf3QCjQp/3ZOhjuHOhz6mpyFrkiLc3OkP4t5HPRNSPV8NFQDM
         PVn+Vkp/x421OJBQrSYUGYarqoNl0AiGks0SkxNOxxMwFp2jNU09Mdg0ur00I/Nnodd8
         uBTg==
X-Gm-Message-State: AOJu0YzOkWxXenoGaE17yT0OHlc0/hjUIZp6KO4mZ34465MtgXGI1qCG
	WhFjNfRSIbtb9jwdo5BRRdMBu+eTrtDT8FEHlw9+O64mQywDyA+M/iJLuo82fILeb63lIrX1ad3
	FHFp4xJfh/rVEqFaq1RMg3KJ3SqDDndQ=
X-Gm-Gg: AfdE7ckZVRcxmmzfwybvPMA9RzB+239LN2ZxPrmLiUPhwp7Rk9v/s/o2Zks3CRoY9tk
	Zo96vpM8RjDBZDGI2dBr0rGT0eZZQF4X97wmpzg6/Y/w6f7WOBXJGjARM3h1RtBAbfGscygU8Zo
	laTLEPKiDlFqN3uEKhh4Z+7T71Gih4m4W1xgSOzJIMZB8FRa2tloeZOYjBQ/aFkZ24Dw9Tt7jZI
	xCMB9zzmzmFUmmkXCPvRRYREtVDjoDEqHUmqwOqHtJXs8AWIuyqmwSvT2RNt3BNIrPES0crLBIB
	B0rf172kfxsZn459zit6aSu1QHfGqg==
X-Received: by 2002:a05:622a:1345:b0:50d:9138:3322 with SMTP id
 d75a77b69052e-519fef470e1mr6911901cf.7.1781875980444; Fri, 19 Jun 2026
 06:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775589916.git.boris@bur.io> <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
 <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com>
 <20260408173425.GA2076825@zen.localdomain> <CAL3q7H5O47v2BW2pckyF9qgaLdLHefD5Bwh3VS+xgkBAUyYwPg@mail.gmail.com>
 <20260410230528.GA1449614@zen.localdomain>
In-Reply-To: <20260410230528.GA1449614@zen.localdomain>
From: sun k <sunk67188@gmail.com>
Date: Fri, 19 Jun 2026 21:32:49 +0800
X-Gm-Features: AVVi8CeTtfGiKWLijl4GIGxFaEFlbZYNtFaK_p0yv-0KKDYEuD5MnVWkFD3gqtM
Message-ID: <CAAuSuOq3esyDEqTzNUNn-x9XWtP14CHP8p=rNV9Yr12PUY8QQw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"

On 2026/4/11 07:06, Boris Burkov wrote:
>>
>> Yes, we have a lot of places where we don't account for everything.
>> Either because someone forgot about it or because we don't know in
>> advance how much we will need.
>>
>> For example, assuming an entire delalloc range up to 128M results in a
>> single extent is very optimistic.
>> We assume this, but we don't know until we actually run writeback and
>> try to reserve space - a 32M write might only be satisfied by
>> allocating 8192 4K extents due to fragmentation - yet we reserve space
>> accounting for a single extent.
>>
>> I've seen cases where this resulted in a transaction abort, with
>> -ENOSPC, during ordered extent completion.
>>
>> One thing to pay special attention to, is that if we start reserving a
>> lot more space, some tests that currently pass may start failing with
>> -ENOSPC or they may take significantly longer due to more space
>> flushing.
>> It's a very tricky area. I've experienced this pain several times in the past.
>
> Yes, I haven't concretely felt this ENOSPC or excessive flushing pain
> enough yet, so I feel a bit guilty for just cranking the rsv up and up
> and up without any consequence.. Like, why not make the depth guess
> 8->100 and be even better? (Obviously bad idea, just rhetorical). I also
> wouldn't propose reserving space hyper pessimistically in every
> dimension, like assuming min extents instead of max extents.
>
> I feel we have an inherent tension between optimistic reservation (e.g.
> assuming we delalloc large extents) and pessimistic reservation (e.g.
> assuming we have depth 8 and cow every layer with a split).
>
> What do you think about moving towards trying to make on-average
> accurate reservations?
>
> What I mean by that is something like:
> do change the start_transaction delrefs to account for cow "correctly"
> detect / track depth (per root? global max?)
> track splitting "risk"
> expose a better sense for the fragmentation to rsv (we have the size
> indexed free space rbtrees already)
> etc...


I've also thought something about current delayed refs reservation. With
16KiB default node size, we currently reserve 256KiB/128KiB for each
delayed ref, and we'll reserve 1GiB for 4096 delayed refs in this case,
which seems way too much. I don' think it makes any sense to reserve
more than 20GiB space for delayed ref while the whole extent tree is
less than 200MiB, which is the case usually happen on my machine.

And when we run delayed refs to shrink the reserved space for delayed
refs, we may get more delayed refs, and need more reserved space for it,
which is also quite painful currently.

I think the root cause of this is how we calculate the reserved space
needed for delayed refs currently.

First, IMO reserving space for cow tree update is a little different
than delalloc and we should not just calculate with N * nr_ops(currently
N is 128KiB or 256KiB). For delalloc, we reserved space just for that
allocation. But for delayed refs, after one delayed ref causes root node
cow, the next 1000 or more delayed refs probably will not cause the root
to cow again, and reserve space for 1000 times root node cow is
meaningless. So for delayed refs reservation, or other tree cow update
reservation, reserving space for the whole tree instead of for each tree
update operation would be way more efficient.

Second, I think we should reserve enough space for its self update from
the start instead of when we want to shrink reserved space for delayed
refs and run delayed refs. And the worst case for extent tree self
update is the size of itself IMO. So we can reserve those much space in
advance, and reserve extra one node size for each insertion. I think
that would be enough in practice since the only reason that we reserve
so much space currently is the concern of the tree node splitting worst
case. But with no new insert, we'll hardly cost more space than how much
current whole extent tree occupies in practice, and with new insert,
we'll never cost more extra space than nr_new_insert * node_size.

Thanks,
Sun YangKai


> And instead of a mix of over-guessing and under-guessing we generally
> try to right-size the guesses, and bake in some intentional
> conservatism.
>
> Put another way, it feels quite precarious as making an "improvement"
> like not reserving all the impossible depth reservations actually just
> enospc aborts everybody horribly because we relied on it getting to the
> global reserves. Or perhaps this change of mine will cause horrible
> flushing problems elsewhere despite helping this heavy writeback
> workload.
>
> Working on this would of course require investing in some more workloads
> and/or reproducers to cover the various tradeoffs you brought up.
>
>>
>> So it's probably better if this patch accounts only for delayed refs
>> generated during extent completion.
>> I noticed you already sent a new patch version before I could reply, I
>> will look at it now.
>>
>> Thanks.
>>
>
> Thank you for the in-depth discussion, by the way, it was really helpful
> for me.
>
> Boris
>
