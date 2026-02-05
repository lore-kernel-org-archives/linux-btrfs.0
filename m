Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CBF168BD
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Feb 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770321621; cv=none; b=hn4MF3TRjgC1zp0cEvNqAL0t3UYX5jZQB33VOG7He+BS7kBkXTxaRIcwhlAt/7y+5J/QndxMUUbeW/rIheU887C4mjOu2hBSn2ZVanABs37vsxcLUQwo6Fg/7DrRlZbkVHvpYl40gggjOIJV17suSJzT5YOAV2J68IL+8AqPPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770321621; c=relaxed/simple;
	bh=1QZlZ5WlKV0gfqPzpcbemLOmSRAN2GTdyU3+wd7pJto=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MVAakeGMmNybfaVUppCqljC7y6sOM84hmkCHlJSBo7fyY3hdmG+rF/ymPGpyHsaLvXea45kbZT+S9R6/sCupi064w+PgIrv6odbKY+YmIm/VQF4oCavw+ssSPrtK7cvWRRCDIDUN0EthLNgQyinsFNBjtVJZ3oLdVSTG+dm7PkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45c733ccc32so875929b6e.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2026 12:00:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770321620; x=1770926420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QZlZ5WlKV0gfqPzpcbemLOmSRAN2GTdyU3+wd7pJto=;
        b=ePCAtZoVBkvCYJrOdC1/r+rzUzVyGWwrDkJwg72AWGGai2O9EpIZMVahe6IeJ8MMGG
         b8PBqxyPvIFik7o6XA9KcOiOIZOjDjvX/VSFcuVp8Jm8cqrHhGD2HMIal7zZSWKj4eVJ
         yV9UE3C4QKcItwIfBtOLe2rVoNwhECEPi3I+JHv2hXypm6AUyg4zk7cer6nrTGfUQAId
         uVxsehjY2QgQtqRZnDq68v8a0MXI5H/d+t8oAzVGg24i7r5AFoXcQ9QSBvn2NGoihV9N
         yFaSvgTp08d+KN5ftUn9xUHinoV5jzFcesSuX0GLbzlppQkxKzmKjz6awJgX5k/TtK3/
         7iVw==
X-Gm-Message-State: AOJu0YwzjPQvuxA1Ix/GQgnKsgON3a11ssZDBBiQ2ujurIHebicRFRyd
	ocG7Wwfedv0J/KuOz3ubUMMl+OZ6XVovdD1+WiPFaSHq4eeE35I1GngEHkaE+Q==
X-Gm-Gg: AZuq6aKof9fwg/snyzUyRCalGtYfK9Rw1kMWqGdY0vc3aaOo9897XQvb67Dyd3VUDtd
	K0A60LA5cohZcaikzgr2fmHV4VAk3PkwyBp46v6uIeixBDs/n9Ru5y/GryJKsoNNRClv6kgiRyL
	a63IcQRYJdMkrngG7QM8XNkkQPrBwvMoUCIu60w69prj1WmlkBZrq6i2XdEjFuuYpg7Dk6uqirQ
	ekW2BxMGVAtZToq67FP3+NRenDhF1C5ZFkPk7HgmcMpTGM6mQiSrfvqYclES5Awrk84qejVv4s6
	KTNFlOP2btoQVM7o1PJR1kdIagpWYpfEBtoUgOPEl2IZXqg5mA8jSSoPvUyuBx9hW5tQ/zpjRkS
	oa/dKTXK95VJc0vgQiL9g3WBmYwhnjUlA2sypk3P1+CpNFmSATx9nwiQQzm2KXfGHE0GUiNHbml
	kp7peh0hX7s6+RxQEqtyWCqh+QKJHcWliQE+W19HxWuVgQz5o43lYY/G7kL4hC3t2LUwFlFrkJ
X-Received: by 2002:a05:6808:1a21:b0:45c:8bc0:fcdf with SMTP id 5614622812f47-462fc9d8a81mr273271b6e.10.1770321619802;
        Thu, 05 Feb 2026 12:00:19 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d464785d7esm56992a34.15.2026.02.05.12.00.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 12:00:19 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d1890f7cefso1189227a34.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2026 12:00:19 -0800 (PST)
X-Received: by 2002:a05:6830:6517:b0:7cf:e4e6:2cb7 with SMTP id
 46e09a7af769-7d464695e26mr87871a34.34.1770321618438; Thu, 05 Feb 2026
 12:00:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Neal Gompa <neal@gompa.dev>
Date: Thu, 5 Feb 2026 14:59:41 -0500
X-Gmail-Original-Message-ID: <CAEg-Je-bgan3m1+45qcSxfRF=d1pmkkhSRmZ9FnovSqvD113BA@mail.gmail.com>
X-Gm-Features: AZwV_QiUNdjN_2m3xE9wwpU_EPVWUpUWGlthwdSNo2_zgRC3L2HIVy-JJ2hGxmM
Message-ID: <CAEg-Je-bgan3m1+45qcSxfRF=d1pmkkhSRmZ9FnovSqvD113BA@mail.gmail.com>
Subject: Btrfs encryption support progress?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey folks,

I see that the preparatory patches for fscrypt support landed in 6.19,
but I didn't see any refresh of the rest of the patch set for
review/submission. Any idea when that's coming?

Thanks in advance and best regards,
Neal

--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
