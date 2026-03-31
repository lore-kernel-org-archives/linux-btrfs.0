Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDF33590A9
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774989591; cv=pass; b=DZCUBRHDittI+jOTcUsBdgoFW4RteWBAgnPQQjbl87TJnaAsZJpyE1gQoSdBc42K9IyfZO7ujRvZsQ30D9PvQvrHXRuRMvV2YJQQfSJSmQUCf0Jcy5oecVI6b+eomkN+PvzCQPMU/cRW4yM2q/xwM9QrhNnXicqwt+fg6bRCsbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774989591; c=relaxed/simple;
	bh=8NGCN2uRKgpR2nvZMIOlPy8zJmYv5pSJnYgE208jz+Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=eRv8NsiErShCFwiDX2ajstsHK+UEJhXpMi7btcMsZY1OYoVGmDcuJdpdh17srh+ISya4Rf7VynDTodUHe1CNNZ32HtaZgETeQnypVFdQByXk6fXZpx0zM/9CWQCGYuYezbcsU+hALq7BMWSBVJsNE6NYh2F6Cm3WaMlXlAywtrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=ZFc19tpk; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="ZFc19tpk"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6470d549e10so924357d50.3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 13:39:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774989589; cv=none;
        d=google.com; s=arc-20240605;
        b=ZThzDSTQoj25LbnNT6frzvT8y0sfVy9quNuplMQ+OYDhWP2qiJPWqPd4cVvHz+BhbN
         5v67nBZPwe5ApKKdB4GyG7kqkcGcvSAuj7TMGONglU6HkzlFJAeDDIkQJvlTJHgSTlXq
         8ZookYOJhE0mF3pHOzSdcMNMJtJuEbgaLM6h6YSTH/XH9y77GkKuFZ4xEKGsQAadFZ3m
         C5hX2ftut36cIjmhLnXBgxWgpeWp8HbLzi+xkPpTjIA5gnq4QZYCQUW3jgYFwtTxmd6e
         1lhYSevAzwc3jZA6Iwx9fV67qv+Xue3O2OlxoUW54FYuWoau1tDIOTqcs50PFvru2YLT
         97rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=8NGCN2uRKgpR2nvZMIOlPy8zJmYv5pSJnYgE208jz+Q=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=O+HVe0AtWzNfHB2zxrQJngHvOuhEdZeTPmzmZTnet22RGK9+J7lQmU4jbcHjsCGXOK
         0jKr7SNzQjOSQoBJLJv1DI8pM1xi0gpr5oLXIHtojDhyR5euUdi6FEIOQdVm88WQ0BVD
         EbQyQQVmMh3e7n3G00ENMubt6b7InOgfpMz2OBbv8c7jR+wNcbV5knsoZ7FVfJohlnDH
         8UHJ17iFjFLzGuJ5l8o8nqsX4d6zv/a+TU6O3JGoZglhHHMVgh1U0d5PeV/MIkdFeQ7f
         f81eoQtismgA6PTkAuDf6EYtMVzCMV5VuEDUgczgAqZbWtDzXbgNQVp6xFfyfUJWp8el
         npDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1774989589; x=1775594389; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8NGCN2uRKgpR2nvZMIOlPy8zJmYv5pSJnYgE208jz+Q=;
        b=ZFc19tpkj3E8OmfNXHdYReAPHXTyKtXPhY3AxnAudqeBJUGV4baH38rnWs+BPt2AV3
         m2cW6rBKkt4FJ/+diUr5OzRdiBvecCu2z7BkpafE5DVlUG37i6Zgo00sxEvP0FRSuUWb
         faigNs4N4spJwWgRFPjwux4J61FRMoY6hvzT4WKxSpyvW4VBiFAN5cgpNfi0vElcfWY9
         h0GDisxkVG6TenbHnnyF3U5nSPjHVm5UYootyYFYkZEn0s1EYtsRx796sWAi2WS2OnJ5
         k3vnnV3ZKDVMwHk8yoJaPail/c2cZsDjQ1hr7nQDMxkmAsKKPjZtCxUXtGOPF2gdSycf
         PFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774989589; x=1775594389;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NGCN2uRKgpR2nvZMIOlPy8zJmYv5pSJnYgE208jz+Q=;
        b=VCJn/yQ8uvvpj0+Sat23GhFMjmXGw4UwdxyrBABOf1hD5t2uKL9newHkQfo4f+D9eG
         8A/tF6eJgrsYGyE4iBit2q4pq/GH4TLVpkWl/jJ5xUvD3Oh0ClCyrMTtOfYSQJ1VC8Eb
         O5ZAYna/V1iLryZi0BK+Kg1B8MygsK3ETYa0Ssd0cokdmsHwDjN3KpaWgx5aYNcmR3Sc
         58yxn/Jr2JsCEme5Yi9XaVenz79S8b60bnYN+/UfMzb1mfzXsfykTTEUKO55H4d46ddw
         cSQcPb2tQwOD3m7HTmXUSMnj1yNBynCwxhP01CtY+PcB9UWwKxZrccWhCl0Db1ULqT7x
         z/HA==
X-Gm-Message-State: AOJu0YwsLyUVW1op6LZDcWx+o2cqDllFOb0J7dDLJNOjlDciPjHpsvPz
	wugOpqqhubh3gsRae5ilYlL+dPNUxiOSxwVVX4liJkQ8l6DddnZu78Or+IhuH3/ZbSIPToRhGmu
	mhQMlAYavb6pgYr1E0d64u2jRCVNdpbEySbBAibuBCw2Dke0gudMOQ3o=
X-Gm-Gg: ATEYQzzflPaq3Zz9Cb7MXmHjCxhRCu8EZYq9nG4Vzhihfui/qmhB1ZIAU3G7uMe66u4
	jQ6jvxhBnytKyo7XU0f+sp4RuugXrhVyBgNQA8L1VrrI8AhqIv0ouejzXK2CAkR2qSzZe7dmb6t
	U+NGj2awbUnK2cpvzm/5/7sV7BdtWa3SpSPag4gQG/Hlw7MC4xNpaRuAzl152mo93v6VRv6pgMG
	uHVf1lWtNpytRBzuf2auhkNr9GrBr6CwAA3gfOQQ4E4iajh1K7wpBI/qydJZpG8ysMK0uCsXZC9
	fiKri2ZYjn4aWFu8kX5WtAYFkKAONED1qP5wwn7X2TVsFKeo
X-Received: by 2002:a53:ac8c:0:b0:64c:aaa5:ebb3 with SMTP id
 956f58d0204a3-6502fd951f7mr635825d50.2.1774989588520; Tue, 31 Mar 2026
 13:39:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Tue, 31 Mar 2026 22:39:37 +0200
X-Gm-Features: AQROBzDZLiZyRCDniegAKe57tvYy0jvpLZp7oX1IfLhBRkg8dGIqtyOa3rOsQrg
Message-ID: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
Subject: Problem mounting 4-drive RAID1 fs after replace was interrupted by
 kernel crash
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I have a machine with a 4-drive RAID1 btrfs filesystem attached to it
over a USB3-to-SATA bridge. They are not connected directly over SATA
because it's an Intel NUC, so USB3 is pretty much the only sensible
option.
A few days ago, one of the drives started failing so I connected a
second USB-TO-SATA bridge (the first one could only hold 4 drives),
inserted a new drive into the new bridge, and ran:

btrfs replace start -r 7 /dev/sdk1 /media

Devid 7 was the failing drive, and sdk1 is the new (larger) replacement.
This all went fine so far, and the replace was happily chugging along
for several hours.
Unfortunately, at around 7.1% done a kernel crash happened (I believe
it was unrelated to the replace operation, but can't be sure -
unfortunately I didn't save the errors it printed) and I had to reboot
the machine.

After the reboot, attempting to mount the filesystem gives these messages:

BTRFS info (device sdk1): first mount of filesystem
d18c93f8-d80a-4aa7-adc5-86d457ddde20
BTRFS info (device sdk1): using crc32c (crc32c-lib) checksum algorithm
BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but
not found in chunk tree
BTRFS error (device sdk1): remove the above devices or use 'btrfs
device scan --forget <dev>' to unregister them before mount
BTRFS error (device sdk1): open_ctree failed: -117

Either running that command and/or unplugging the new replacement
drive, instead gives me these (either action results in the same
messages):

BTRFS info (device sdg1): first mount of filesystem
d18c93f8-d80a-4aa7-adc5-86d457ddde20
BTRFS info (device sdg1): using crc32c (crc32c-lib) checksum algorithm
BTRFS info (device sdg1): bdev /dev/sdg1 errs: wr 0, rd 16, flush 0,
corrupt 1054, gen 0
BTRFS info (device sdg1): bdev /dev/sdh1 errs: wr 0, rd 0, flush 0,
corrupt 379, gen 0
BTRFS info (device sdg1): bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
corrupt 1652, gen 0
BTRFS info (device sdg1): bdev /dev/sdj1 errs: wr 0, rd 0, flush 0,
corrupt 1522, gen 0
BTRFS warning (device sdg1): cannot mount because device replace
operation is ongoing and
BTRFS warning (device sdg1): tgtdev (devid 0) is missing, need to run
'btrfs dev scan'?
BTRFS error (device sdg1): failed to init dev_replace: -5
BTRFS error (device sdg1): open_ctree failed: -5

So... it seems to be stuck thinking the new drive both should -and-
shouldn't be there. Huh.

I already asked for help with this issue in the IRC channel, but the
friendly folks there told me after some debugging that this was a
problem for the mailing list. So... here I am!
I do have access to other machines I could potentially connect the
drives directly to... but I'm not inclined to think the USB-to-SATA
bridge(s) is/are the problem here. (Unless somebody here says
otherwise, of course.)

Thanks in advance for any help you may be able to provide!

Kind regards,
Jaron Vi=C3=ABtor
