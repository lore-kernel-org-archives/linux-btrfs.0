Received: from rebatir.fr (rebatir.fr [212.129.56.80])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF3B317152
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 02:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.129.56.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777257834; cv=none; b=HcMpK9d+EKh2FB9GbMnbZHFqB5XhMDntxIAuhJ1aGucKYAFzQKcqGkVhdEo2MVOLCpjfJGCnIOFiCpGXlVgrQ7QuxUbrrgPdnBRoY26JEEKWd005id10QF69/tmKtutFQm1/ZZfQ7cuTMMrhg5j5V5PhjbFg9p/d9Jc8AX/DBEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777257834; c=relaxed/simple;
	bh=qRiM9MNqUAw83u5XrkN4YbdfzK6riH8UrntduSH8R18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aO2ZecT1FC9klrmt7PFfQkPBVuQ/P+C7HTChLEn1MuwndcBReanLCgC0a9mN9Q3azirmZmlFwC2gVDgr7GRiB398tv0XIZEp5PDjhd3kDIr8QKjjfRusdPCrI19f77C4YFQVHXtwQSGDxTX70nLp3RQOBHFfO8BXs4Cw8QZNTBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illwieckz.net; spf=pass smtp.mailfrom=illwieckz.net; arc=none smtp.client-ip=212.129.56.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illwieckz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=illwieckz.net
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by rebatir.fr (Postfix) with ESMTPSA id 97DF120298
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 04:43:50 +0200 (CEST)
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12c1a170a50so12113819c88.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 19:43:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YwigxzbxiUeCLuSjYiGr6eBSoLBk9xS/ugq15vmqrleAF99E8Ou
	aCaOnfmIiSJxDCe+oLNF/pni/vekuOcuM2qvsm133uY86fcG58UCW+mHC0Ac9TtWJDPQ/OvLSIR
	aGFsD/gQVVc/hsdqm6xGEU6LRY3yenio=
X-Received: by 2002:a05:7022:4596:b0:128:d450:bc76 with SMTP id
 a92af1059eb24-12c73f978fcmr20157878c88.26.1777257828605; Sun, 26 Apr 2026
 19:43:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
 <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
In-Reply-To: <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
From: Thomas Debesse <dev@illwieckz.net>
Date: Mon, 27 Apr 2026 04:43:36 +0200
X-Gmail-Original-Message-ID: <CALpuBKx=EQY=-K5VtLKATufdAbptZD0x6ZiSgbXZgOAG8Q8vAQ@mail.gmail.com>
X-Gm-Features: AQROBzCgAYISeReEWbMViQs5qtp7BAspuye23U9ULneIb9GYPL3PwLSItdUDKxM
Message-ID: <CALpuBKx=EQY=-K5VtLKATufdAbptZD0x6ZiSgbXZgOAG8Q8vAQ@mail.gmail.com>
Subject: Re: corruption after block-group-tree conversion, how to recover?
 (data is readable)
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Thomas DEBESSE <dev@illwieckz.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 27 avr. 2026 =C3=A0 00:18, Qu Wenruo <wqu@suse.com> a =C3=A9crit :
> Unfortunately, transid mismatch is not reliably repairable.
> I'm afraid restoring from backup is the only reliable solution.

Thank you for your answers. Is the data from the =E2=80=9Cbadly converted=
=E2=80=9D
volume be assumed safe?

The idea is that, instead of overwriting the =E2=80=9Cbadly converted=E2=80=
=9D volume
with a brand newly created and empty btrfs volume and copying the data
from backup, I may consider the option to create the new btrfs volume
on brand new devices I may source. I would have then the option to
copy the data from either the backup or the =E2=80=9Cbadly converted=E2=80=
=9D volume.
If the data is safely copyable from the =E2=80=9Cbadly converted=E2=80=9D v=
olume (once
mounted with recovery options), I expect copying from the =E2=80=9Cbadly
converted=E2=80=9D volume to be way faster than copying from backup.

Also another question: if it happens that copying from the =E2=80=9Cbadly
converted=E2=80=9D volume can be assumed to be safe, would `btrfs send` wor=
k
or do I would still have to do it the btrfs-agnostic way, like by
using rsync?

Thanks in advance for your answers, that helps a lot.

--=20
Thomas =E2=80=9Cillwieckz=E2=80=9D Debesse
