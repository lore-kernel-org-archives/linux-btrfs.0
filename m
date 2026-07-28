Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5430568D
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253126; cv=none; b=NJ/G1ISBhSp4gn5OvG18oer0y/JXhLUsq+UdVhZMeuZBpxZikpEBKwp4Fk0/ePnMwR+MDsEnWkSyuoo6GNgRTUDZ8UIwLT9QcsJ+qC7U6kETpPUPY2F/bfi7Il5ryCJC/euTgFnEdATWQRUbmipreSpaqS020fXvUnwjLNWTVNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253126; c=relaxed/simple;
	bh=by4p+tUelnvKOV6LN/svUDk5d6hILMv0whqswTbgH+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ljzzKsEzqrHO0wegWEyhPjDX50qebjw7J9oRqjrdvl3JyDgcyHc9x7ouasCP/fs3GKOESyUiia3rLREluONu84tduYeyQ5irJBdXvrXiEjrxL96c+v5OdMRl9hDqVtAx5PqyryyVMtHNb5t7pRUpX2O1gj26qZOeqavbg9BGTt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJcdyiB/; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJcdyiB/"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c169ae1cb26so192665566b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 08:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785253122; x=1785857922; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AKw3n7wVTjlHjI7qBp6R9/RnufPbGuLg8YNXSKa7mF0=;
        b=AJcdyiB/eaGdyFn5wQtAPxmR48YGIntSF/H6k0/kW6+zChQQmEOPXUYJxXA39b7lF2
         AJy1MZhmdbcKYantaZnGHtvOOFw8ydguA1wUQ91jUZhhGT9xmqG9zas973B2A1XO7EKK
         gnqZeZ4pyoqqZ+dgexT0/2iiOswxPnWC9p7/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785253122; x=1785857922;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AKw3n7wVTjlHjI7qBp6R9/RnufPbGuLg8YNXSKa7mF0=;
        b=gJ6gYY1+FR5TuNFX+xPM203oIGhn36QRQyhJ6MOnphs/UEICtEU9m+jIewlZkKucRo
         i2kcbiqqW/MBG6Knimsw4W9aH+PO2ienIf3K/LA5ZRLlxP7OEPZekq0gq7qtWJrAv0i/
         0T32WuHQaNQPapiRua6ffg/63FPAVgSrEGBOqTA8cKiRILZxwrbB/VdOd/vVSsibGXWd
         wN49MBNbL6eOkspRZ0vKJg0PennZlQof55DL1d/N7mcC8I3xeJR31pAK3j3JQ4WoLcMq
         3fjYoP9bpuz8pK0+xy9D/QCjLegIEMSk1pDsR2xot7GC71CkEt1aP6HuFFaCpmmNmHgz
         F7wQ==
X-Gm-Message-State: AOJu0YzjOX+RULxOM1GApaUbtpLrEbuI7sQzAjMRDW+xdVqfNJDHq20A
	sYJZC2KPAlGOicusFJp7glmP73ynPHdo3+yDVeZzWlDmAAbbe23W5KnCrtbJjzKP2x37kVJuOc8
	penqUA4Y=
X-Gm-Gg: AR+sD11ucbgf9qtcMWBdlUH4UeL7KTmSFuHMZIV0+4Ygvtp34vCuhknsH8+E1leFnbV
	Cm1DVL0vUHKYjosGQHI/yjcr2UleSTXRP7ABAQb9gsXajHdWeiSoFG2AFMJsyrNwfVPMtiaiZIq
	rH1AGY5Hw2WMv3eD6Lqzs55bpTMQS/aKahqtYhIjluAMwg9W2uJUX8FHEqFUAM5ka+MGgfY/c0B
	nDDAISg6WIxhn9er4Nydc20LBnKgoCYP431lCsSBawwNn/Ey8Uhq+tZoFCJT9OQCEpaBGChTBkX
	dexYVcL2hS+utj1WPzqySKnibCfQQdVfvPF0OeAl32m62+UbrVqDM4p1pYHNSMBLYECSWUCroN/
	AbIAL58EoQmzDiCjbOd7Z6bvAwMjmqvkHiiJT64zAhevS/T93mz2+lDsFMW/ZG5hujVz3Y+NPf0
	NNuofkbYnqs79JnfKPePYpfMxHC4Aiek6AoP5cMWB9UNopDm2sENc=
X-Received: by 2002:a17:907:94d2:b0:c1c:4c72:e6df with SMTP id a640c23a62f3a-c1f716a6f58mr170562866b.0.1785253122515;
        Tue, 28 Jul 2026 08:38:42 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb5746da2sm4098034a12.21.2026.07.28.08.38.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 08:38:41 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15e03c2763so206512966b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 08:38:41 -0700 (PDT)
X-Received: by 2002:a17:907:944d:b0:c16:6be0:77d4 with SMTP id
 a640c23a62f3a-c1f71cc9410mr175648366b.14.1785253121400; Tue, 28 Jul 2026
 08:38:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785171953.git.dsterba@suse.com>
In-Reply-To: <cover.1785171953.git.dsterba@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Jul 2026 08:38:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wioZpQZHObXOKW27Fvrxgc2H7t0TR6p5Hx1atsOjC3gsw@mail.gmail.com>
X-Gm-Features: AUfX_myXF0-iRssUBWSlyooCZKRqIMy81o1pU6uW86lCjix0TIAJ93ptmaxqvXk
Message-ID: <CAHk-=wioZpQZHObXOKW27Fvrxgc2H7t0TR6p5Hx1atsOjC3gsw@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes for 7.2-rc6
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 at 02:25, David Sterba <dsterba@suse.com> wrote:
>
> A heads up for one more fix, for a problem that resurfaced last week. In
> short we have to bring back the "fixup worker", detect and handle pages
> set dirty without filesystem notification. There's a reliable reproducer
> for at least one such case. The fix heavily builds on the removed code
> so we have a solid base, the new changes are wrt folios and subpage mode.

Ok, not optimal timing, but I guess if it's mostly resurrecting old
tested code it's all good.

          Linus
