Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2B23EB809
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780414832; cv=pass; b=Xisz4/zCj51do8l/DAp/hAREsuzaazRHbqBCcg7cJUYIkQUpy6lmrF2jg27zWPEf1yiM0eLT51wAztLhXHGf/B4+LM2+GT+3lBqihsy7hT4Gf08DV+CVw6hCLj4220FBAZFnAhY5cXM1/zA6UfHs3P4uku1BAKD5ICIF8sgJZ0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780414832; c=relaxed/simple;
	bh=2kjXAA2wLFrGv+3hjn4+I6i0VMavSnbOGhrx/ntqI9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GFULodCNJx7UcWob56j7IFVBAUFK08FT1wljA09VQitltdEFac/dhUmcrjti/aihFPG83M2HwbPz0ZxJlvOE2uVnyeJaLXEff4AwV7kyiDCoScrQobqSCXsJkISNXTvPMxvplym2rsiXgF9zPu5PJfCr1B9pbrCksCniFDwm508=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Mn1qivDU; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Mn1qivDU"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa66893e9fso2962362e87.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 08:40:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780414829; cv=none;
        d=google.com; s=arc-20240605;
        b=Ralh+btcEPKGaTKbVeZgIUAnLPywbWZF85QYyXlMKQyH5l4CxROTMeXZouBOlogy8v
         uyfBYDVKUx0I9n29hJVZCbmGqJIDvuVlUlLFl1vrjeDMUmIZjRSODhSp5MON55Frmizi
         smFFk60vfPjm3SkBjV/F8kVs8oEhtp2e0l2QNjQlD7CduhBvEKnFpgFsCb9HwndWl5tU
         oDSPCrG+oYSnJ3Sz/Dhf3sClwR9OAQewU7zeDzbYYxdwX6YLYjNAawcZIQggzdzSs+82
         i/OuDJj9NAQbyQ9QfnMbyrO5Is/mYR18wKaIkq3Gll3jensQdXySxHhlYpMIgBKlsyTU
         zMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aEtD8hxNg/VcUNyGR5DhYhXuytGGiBX+hioXfUqOqqs=;
        fh=v1pEqaEjMJ2YMyYxGegvI1TmBsleAyxAxd9qQoZFqVQ=;
        b=c74dpeOGcHJrAp4wD7cgYt0Z1lYImHVMf2Mcugr8td9zRSJ0san2UE+LFnJf/5PCHE
         GBaR+GxSJ071cN3KWwHOp3NDpWSiqCWPwqazjwh2yCbIhFYfzXxB5WtPJR/eqfEEBWdK
         ZOSCD7QoGcARdM6KYH6Pni+3pbLB80yQfZAl+W9JyLNbciDAyMUXivNw4Q2p60DWvp0+
         +goiB8E4zritXp0b1GaiG/t+5rPs97tImqJER1JLoeeE7QDKXSY5wH3/OLHGKp3/JHfx
         +a51RlfQZHpNc06ZMNQakW2+RgRow5Ovzx+ZzEUb+kSP6TwT/3Yfjh6TzfpjQCAcsymD
         P8+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780414829; x=1781019629; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aEtD8hxNg/VcUNyGR5DhYhXuytGGiBX+hioXfUqOqqs=;
        b=Mn1qivDUJuTDv4nRrkLvggj7zw5KU7AtEBHP+nD2aPyIuss84DlMD0jRtLUFzRDtM3
         Rjc68fHyks1R97ChDe177MTNiqSg5nWID9QdgOyv4lKk6+BOPNOeTxivDZ06HRnVB1ys
         cS6MzXnMQZQW8YhJ3FANILFcY30lEZFxIIoHfbjpYO/5B+frvGGCV+hcZkYv17oMq/lP
         6Ue5D9ARUy8t4AdtOm4YsyInRDyBCI+yXzxKVt88uzESKkDGtdGq09WBxfwrou7U6KFz
         2/xrtbf+20ky1SNyG+Vy/Lngxt+uJMAjevZALDZ65FUN0qAUBuGuqZlQIkvNkK42jV3e
         Tr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780414829; x=1781019629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aEtD8hxNg/VcUNyGR5DhYhXuytGGiBX+hioXfUqOqqs=;
        b=OOBBohNVG8bQFTT02d3n4cCwkNthoqWuhF6F1X7ygcHVIfUP76UZ/iJcHim+/S3cMh
         iQN1jaUEe5HFvLvOKtk1hc3Q6PA1qvDesDAHQgLqU6Mbfra+rSiMGf0XSFd5QJU6iSvJ
         jFiE4DmAYH7Cqa4VvGXku0gxNYUT1qob0ddzTKj3db6gNmoI/VjLHsvUhQaNdylTGmv9
         vhlEnjPe5nrz8uELx+RrdcQZyQ8G1I6PBfsn5FcjFaTJdbl6sDs+51G1pyUC5nOhmXSo
         dvdZIFUXlSa02ZzfjInHAUgd3N+aCkiJcWlMTlo8Pp3QAb45CjlHE5RC8eX+D28K0vaS
         NRCg==
X-Forwarded-Encrypted: i=1; AFNElJ+8Bs8OtfKRDF76HTHH6O9CAdhVUI1W4hhIWWBDXskOnrURpBxBzE+uzz7t0+27kI+gNTcgOJoyV0OIhg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWjL5IZIO8Dzk8wtrs+REzfs7OZsTuRdpohv2idspbjVXK96Gl
	5TGEwwwgu+n8WIDpcs9RIPCoi6aZ1TemTpc/dexMPBEcTDBYLBNlfNpu2nxCtKxYK5p+k+Vhaak
	g65Lo3vPv7nmYunAE6sJQEWNsPhI8+dynxl5GNzurUg==
X-Gm-Gg: Acq92OEVH3rkgU+5iOO4mWxxxRHORJz+RAXgNTlQp+/sGIe+ZKpCEQABWX2MLZuAIn5
	zNvs8ht4CxW8/aoh++xSlqgJ1kKb35etFP+3SgR/UhfEEAWMI23y3ChuoxHkdGqA9jLud44mYly
	/89PwyDOqI8FXFWWGFmnQ0JW5vzIC5uEMZwzmKCVOMKUmpD3ryFJvG++E8LMvleh0myI8DXVqxT
	OiaAPx1kIVW4vQIKcl7TwQxrb2HpZfJIrZ7Kyd5J9g5qm/I09KE4Xa17H405n9p1aIfc8T333SG
	PoqPf2QbiV0ulMXIhRqiOYyxwxDRBt4WNnlySSIbnIaXiLBpuok=
X-Received: by 2002:a05:6512:3b93:b0:5aa:6946:6e4d with SMTP id
 2adb3069b0e04-5aa73e869fbmr2011392e87.19.1780414829469; Tue, 02 Jun 2026
 08:40:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
In-Reply-To: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Tue, 2 Jun 2026 17:40:18 +0200
X-Gm-Features: AVHnY4IrC3v7DxirGvbL-x9msqCUhkWKM8os_9YP3A_wZai3oWBbplXMrP8K4u8
Message-ID: <CAAofZF6yRBmPEumtAC3R_io=PSz1YZHCaqNne8mV2a2G-v0TzQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in btrfs_init_workqueues()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 4:46=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> After commit 21c05ca88a54 ("workqueue: Add warnings and ensure one among
> WQ_PERCPU or WQ_UNBOUND is present"), there is a warning from the
> btrfs-qgroup-rescan workqueue at run time:
>
>   workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Drop=
ped WQ_PERCPU, keeping WQ_UNBOUND.
>
> WQ_PERCPU is included in ordered_flags after commit 69635d7f4b34 ("fs:
> WQ_PERCPU added to alloc_workqueue users") and WQ_UNBOUND is set in
> alloc_ordered_workqueue(), which btrfs_alloc_ordered_workqueue() calls.
>
> Drop WQ_PERCPU from ordered_flags, as alloc_ordered_workqueue() notes
> that only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful.

Acked-by: Marco Crivellari <marco.crivellari@suse.com>

Thanks!

--

Marco Crivellari

SUSE Labs
