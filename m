Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793375326;
	b=hhQ2gK3M492c5LMEDdQKOHlp2iycN2Qt2Fek8bgANUbQSAOM57Jp8UfGevcKBd+lL+WR
	 sZPSqFED5JKrE30P6L3nVXBr78KiAFgSs8gO41beQcKgTimJOcrDJ7Ffw6hMA7xRbHTZL
	 qKpf8syVS9HynKpGW1Fmxz4h+Bg8EEaWHZrsD/b8c5mr2J49682XjWlYgdDIAATtWo60b
	 C618Q65IFCsBK5kOdD5QjICs+cssDknqkTNp/Sc14/RmhpX0DYyhs//f1Uzlg2bH5qaRs
	 AGFxH2nmlbGdQqobbG4gWBIFV+r8Yk8sBA5xM1x8z6QqTrdtVn38v6C+2eiXEfwd9aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=1SdZaLdPak2FKD5fnDB1khWRjdwvVonI2nIK2N8FF88=;
	b=pWaAUrdgWIrwU05QupyvRxQf4aaftpY4J9RhLOLL5kEAZJbKKCAt+oiJZpt83ukYHAxy
	 FeSw0op4AzjjcJRB8VWUs/6snBowWav/rY7C8dgSr5fIr054Qp9HYlpcT2o41JSoBPXhU
	 hiV3bUGvSzuoQnhbliLrr0srPxIDQaWAqy+LSUs8Q91GGv5buzLfaEBPfiP1FLoAw33eq
	 dhnOGNqzPEnfpKQrAMg6gHU0CpLAhDy9iPj4F3+g7wiRuuIwm6NLP0Hm2ZPmdUygEdM/e
	 AzUZ6dlXW9fuB1rwgVUY5GjLEmUYHRQyI2mtkY0tx7GGCxwttCgcLZiteHI53j7IkXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FoSgDxb1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115E606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 15:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6115E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FoSgDxb1
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48dfaa3fa12so1188450f8f.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:48:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793375324; cv=none;
        d=google.com; s=arc-20260327;
        b=cD34QIE6JmppUa6LYpVoExGWCWAa5KAAY6Exhc42UgD3vi10zpbaFM7bE3w2i3TRDS
         kf//Buj34cdiIOrWe6L1vW/zD9pAbLnCBWFMfjqvRm/JOpkY+5jomAsXWmbXj57G4OsH
         GUbcIYGjJzsdtWHwfTio9PjXpRLYVg/rTorIGTrinqNTWdkfCU8AOoCcBylUrVKGB4id
         vIerLatlZFxa4Vy7uGffZwppCQf2vvrFdAJ04CgJgtVoyuxQPduAGkQiImHU6lWcBAuU
         CQ3O2/48lU5EOutcZm6pRAEYSoEelvDLmxDwwFsCpazd7BU63Gpo8BVthJfuSkYRB27Y
         1cPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1SdZaLdPak2FKD5fnDB1khWRjdwvVonI2nIK2N8FF88=;
        fh=ZhLgSjzo6p7hA6f4VnzScapi00kTts8LttAtY+74eMQ=;
        b=XbN6fImyEWuFrCnBzfXppV1DREx8vu6ur1eYiC7VsNiyXnc4v3RMOyg6e61MykC/ny
         hxAXs145WqKR6QurWAHPP9ysA/axvGv+Dd2vNd/gBuwR/Y5ljWDosg340gESbGGjavZw
         kqL7JHL3fsE1zGUcGl+6oWnb25g/sDjuXhJ6aOjTIpfQu5HrTQDIgcUakOmbLyELaLiu
         /bmR/dDQk1r5d2CyLK0n2VSnGyW67qKDEuvW11Hq8FG/i817+Y/e/pKUk5VkNa5juDMe
         i0gJlzpIDekLgO6IrCzcHi7MTQyOTBADA7f80SOcK3v2yK4QFtbqtvSNslgIQDZZAqEb
         nLUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793375324; x=1793980124; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1SdZaLdPak2FKD5fnDB1khWRjdwvVonI2nIK2N8FF88=;
        b=FoSgDxb1/AUJvgrnmzZU/X9WmaTSJ8u0tEjdKqgvbA/fJSQ30+SG2wc5EhUAZBobus
         4AV5gBO5+alZS3l4U/ePOH6UZl3V0weYgjPdi/1US5hjE/h25EZgEJhFB0cfAQOlWMOo
         GxwdPdm88tyEA4NEDxI1546ZBMc5EjisbG8WazHLK72K5XgqN/9PyApULA9QmMf4kpuu
         LC0LcrK+PY4yuzO8YaV3IeCyyivuyqme5f3KVsNCUTqPqJhdOHVUJGxAaJYiEFngh86N
         MLMp+OyjDGIjAjmxwg9BVmvYs/WUZHUlAFzLGL2BXXlZoo30WE0EQbIlcJnyyQdo3APo
         Tp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793375324; x=1793980124;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1SdZaLdPak2FKD5fnDB1khWRjdwvVonI2nIK2N8FF88=;
        b=LA0eK4lCfBmCk4D8h4bP63N5thi21xIY1JEIRFIB/FLs/A3mGRvVx2c5nOqO047s5q
         +DbNxy13SVV2d4vf8Ld9Ipd/sdYwW6jCaKnY03b3OXxE9o9gsLQGh6GS7YXD5ZxFi7+y
         tp4OEoY555yIDtS64M7C2qevwnqeYYF1HKvAzXSu/cOnjybiXeApga1nw+hMRk8sU2fY
         NZA+dMYevoF3Qc2S2vzJjCuaPJu+D++eXFmuHsxvuvGMZuSgkREzNvibueyVzcczBK0a
         dcu44VQzptK/hXjLoFFgpgF7Y2NXDR6V5sjuyWMBEDfXBL3BbgRqvIByESfW052Lyk6p
         4Jvw==
X-Forwarded-Encrypted: i=1; AKwUvBz8NbXKcPFuaT5FrzxIQl6tMt+zv4utkYgH+RjacYUf7Pwg/ahbf6XB50V6qNEdnyiOSss2TiLXY2GtXA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJFTuD5hjJrGoEXA3fXKoQznQ2FF9kxV5/KGkStFoX9PJFbm+iF
	T5DYPW+xEfwkNQODupTMxYNJShN4n8wokAwumtr+09fZ4lykCgI5UIuDO5tpVWAwSbT1sIdAf6R
	D4UIuUMvGvP89YoesuoR1o6NXJWfrQB4M/q5ZwSSD9A==
X-Gm-Gg: AYBFou3oj0bCrsd8X7ddN+y/50DHMjLMV9qwuIsAPcvJkFseDXMbbz4aZcXBQ3VOs42
	JTCn6TPmSYvIKdXWt7ebVFJe2CrhXU16PDRn6L9nPm1m/1poEDSbB0MFRoUMfW2vBm/SY5iIb9L
	MDoeb4joyt3hV7QxOr/tfybKDVxCgrQQtn7Wu52KPezyxNBOMfxCAWFG9JoNpNRmHzAoNBEpZcd
	fifg8WyA5+ZR7xbJ2z8qqR9gZD4BM4DVXea2QdRlrZOTJSpkoJFzxBNwrRfOtIh5GFvqfAfffCO
	oN1/Q4r+PhfCgLCVhNrC58mAIZKn7vZJNQKsYVUsJ5eu3BzdGw9cHo5RRs4SZT/WBd0QL1/rUeU
	Nws+XpctEN+phfTle/TEqXvBfR9NIhL16FD6tIgwFHs6v/RlkzlelGOvO0Ybx4Mdkn+Fjl2G+ba
	LQzddvcUsuUK9E2xDw1WqQTqPPBeDjjxb91A==
X-Received: by 2002:a05:6000:40db:b0:48e:5d06:8b66 with SMTP id
 ffacd0b85a97d-48e6e2dbbc5mr6990214f8f.19.1793375323759; Fri, 30 Oct 2026
 08:48:43 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <CAPjX3Ff-zn2hda=deMvCGM1UMM6Zghh-ywabBMTqFUbzC69YEA@mail.gmail.com>
 <PH0PR17MB427723A82BCB2A6FCD37B329BB662@PH0PR17MB4277.namprd17.prod.outlook.com>
 <20261021155016.1isOptPI@linutronix.de> <PH0PR17MB4277D532F68355EEF5E4F8EDBB662@PH0PR17MB4277.namprd17.prod.outlook.com>
In-Reply-To: <PH0PR17MB4277D532F68355EEF5E4F8EDBB662@PH0PR17MB4277.namprd17.prod.outlook.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 30 Oct 2026 16:48:32 +0100
X-Gm-Features: AclHuK_-FcdAqoQLHCObxIK71YflbVTMDyBFVxGFqrn4PvFFk90oar9YPmFwNL4
Message-ID: <CAPjX3FfYBZUsP681PUyf53QRssi8Ceq=tPV=bWNT2+_t8Jfqtw@mail.gmail.com>
Subject: Re: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
To: "Naulls, Peter" <PeterNaulls@eaton.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, 
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 at 19:48, Naulls, Peter <PeterNaulls@eaton.com> wrote:
>
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> > That sounds plausible. I did ask if RT tasks are involved and I think
> > the answer as no. With just SCHED_OTHER tasks it behaves as spinlock_t
> > on !PREEMPT_RT (except for the preemption which should have no impact).
>
> Yes, we are not doing anything special RT wise apart from the kernel enablement.
>
> I put Daniel's patch into 6.6 and ran it 100000 times against a ramfs btrfs image
> and then thousands more times against a flash backed btrfs mount and no problems.
>
> I'll await the final word from him on this before committing to it for our work.

I posted a refined version for review. My testing was OK with that one.

https://lore.kernel.org/linux-btrfs/20261030153617.329733-1-neelx@suse.com/

(Forgot to CC Sebastian, sorry. Though at least the linux-rt-users
list is there for reference.)

--nX

> As some background, it appears the bug was introduced in early 2022:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5fd76bf31ccfecc06e2e6b29f8c809e934085b99
>
> And is present in all kernels from 5.15 on.
>
>
