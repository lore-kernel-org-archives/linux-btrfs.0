Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D423038F24C
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 11:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561502; cv=pass; b=EisVNfJ0jaLjBUiAByKs4PLufvJli7mYTuafh/suDho0QZMuaACXTpv1FuxWN0F6crDC0cxuQ7jK/M04g4ZFrvcJLFhOnYVP687+xvL/+c6YdVyF9WuHIm5baCR8HvVZ0JqRpp9Rw2Ct/4tN6QAzy1cxw4HYdTVKEcJO6bRGd0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561502; c=relaxed/simple;
	bh=HBOc+GYFvYqchLyuVLSS4dCVw9sjzz8Ra+d8nRrHoK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qfWYqCRN+5SSRk8BxdyLTHVrP6bLZHJSzVyiFv1jdkLKz0iiX6idG2HJNN5goxnxNT8JsxHxkCPQSGm11kSH8h/pB0IbQR4cuhu/PLNJu7hZK/czU6nekiyJhTUKZ4t3PMO93w9lCcAmXBegRzodItIkpPFRfEKuz6IOikTwj5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=BLnlk1m6; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="BLnlk1m6"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79fd7f2a857so5884037b3.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 04:31:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775561500; cv=none;
        d=google.com; s=arc-20240605;
        b=CrqYKMB10+bm3P1nSQTMeiDEPDjKY5X8cA5Z8ah3KfEKQaVwNAWAXZWQ07xh9ar+qm
         WmKziSqLPFBN8ZCxIHaFKhQTSsQzsV224NwScQclcq/ZeMFq0g4fG66qklgI24fdv2NG
         OFsPdRSQnC9NYpyahCalQxDutPBpiS1TLP9138ThBx8ALeUG9UHgUrykkAOs6TsgRddd
         MZyXJwuprwqD/Ov1FmUkPXJD3q941qgpdOyArh5eCXqDCQ818DUvGX9BinNHetGZcgYy
         N6NjxAImS+OhhqBUUPyBaKU/vweviDWUpnN5KYvrwqFj1jFTDvySsQ3LKxH0pQp/Qfr6
         PqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HBOc+GYFvYqchLyuVLSS4dCVw9sjzz8Ra+d8nRrHoK4=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=ATygyWptDfkaATRJFYi0qHwLCdiUCagrbJ44f57garMyA6dYzQ5iscokS6mtDO8DJt
         2h367rCEsxxyLEkDMSpDCJ7fF1D95J5O6HfzX139TM+Z0PVuOIohIi9fbkzwmpoSRcIX
         E2YYS1urO8o3/pKU08udMeZx0PW0jo8yc3f6jBCI2PHbesORuda5AJxQPqTHVEYpLgUI
         CniRuWOPDF8efTPQm+37iExtGKpX6Di2/9JC2hBnY/TH5ilb9fCyZbhhcddLJTfdS0HE
         Rs5OIITccDkS2dR9Uwg+L+rF6CtidY14hrpihbEAY0xmpR54dnFF7033UMrjQCK6gD7+
         dZWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1775561500; x=1776166300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBOc+GYFvYqchLyuVLSS4dCVw9sjzz8Ra+d8nRrHoK4=;
        b=BLnlk1m6OOo9ObBvMFiFhXsMRbgRBhbe4xm6Jr6qW7b/YN9d8puPJLridF8seLILc1
         KFj5jfnLwpd5lziHDBb/sr+rdT3EhttEx9oa9hnyEIULVqH19jCZgB1AH6vgdbucMiy+
         yv0zzciP8OP/KK7WJAKc0/gdnkS6Dm3Yifk+c1XWIJS8BIs8TFRhuj2KiHaCCQDKFBKG
         G2r0emf5TCByJE0DzqnA/OHgbivbjtJu7VDagnTBfaqSXsSy9iCscKiyoY1YM8N9RAtp
         v61zfyB/cYJRFGl/kWLtyjf9ZtohUCLbke1pfU2cQYI6phspWJhksSmlBBjcepLSgj18
         T4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775561500; x=1776166300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HBOc+GYFvYqchLyuVLSS4dCVw9sjzz8Ra+d8nRrHoK4=;
        b=FhqIUC+hL3xae8eaK24LRm1xHE538BpUyjX2OdIcCCbJmcWKF4Zdti+umX33HlTxVo
         op5AhDmYXSTUtkKJME8VRVyXruB22gc4aGvIHZkBmri4+abijNyjZ/cjrG6dhcAhV0MK
         gfA7W5/oyy7fac23YaJjQ8bwDaMsX8i8WUKGRMuVVBNHD7SsMCMQ3FWvIZUgeTPBjBkW
         1gg3j+GqJWH7mCT0K8wke9oD9z+quj6bGZOTdaDI3jBIAlOtDWgf85V+uyy+Eg+j+yHa
         D20dUMDT/oWXwCnYx0a4eRurN8xvscKPp8sF0FqdeT4hnR6SvNF58e/nUQoHiWNzVRjw
         aH4Q==
X-Gm-Message-State: AOJu0Yythcsgg4dh37rOB5aWcfIBnB+AqiZNcXpfpKOtlOkUFOOTIfAP
	wfuAFLYbD8b4SJGwS6tnqMZzGiZGWOpUClxYq4xU5jphzGYpuS6BoXHs/1Glq6OGXaRcgIVirDf
	az0G8FxKj9I7QgdNtzNxFHHGSh2FD02IOPy3GpWNIAw==
X-Gm-Gg: AeBDietpK8hn5MR6uZBJqEkwT94+XZ/OynngDNOAoqwS+HAVp5zo0Dzm3hGYIIG+ZUQ
	3Jvq9nOMRtYLd696ZupyC+jx+/tqsoNVRsiPn6ESa/0utzmPfLyUh25mbELiUGHObwTPFPkn823
	Wv2ILSB/3rq1rE3OuRtYmqzGiMMRBcTFvO0uGGwHtolEHxf1+dKqXhFd/JsFDTXJzQUO5RpYmBu
	MqY69bWA0sDMVtGhulpIKmEgWMqJW7iYt/ItpYyoliyursMltR/+hBcTk41MW0Pxx2d9Q5Z6E24
	5cN8tptUwSnf2T0oDRMH9HOxMVCjCkYBF9iXWg==
X-Received: by 2002:a05:690c:6f0a:b0:79c:ed68:2ece with SMTP id
 00721157ae682-7a4d82d0da4mr115669207b3.4.1775561499813; Tue, 07 Apr 2026
 04:31:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com> <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
 <d470a043-72c0-4124-800c-385c19007b9e@suse.com> <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
 <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com> <CAF1bhLWnf2CLnZ=BbBVS1je8a7LYacbKDAaLYNgFzY+Z1=L2=Q@mail.gmail.com>
 <a2e56b07-b0fc-485c-8a68-2136e595ec3b@suse.com> <CAF1bhLUGwb17jVD-7cVqA1OTRRRYbt_ow1+GZYbFgChN8mdKtA@mail.gmail.com>
 <22009c9f-f4cf-499f-aad6-70e94874dadc@suse.com> <CAF1bhLXNCeoct-SPoeLWXUKEmZnbjd0gXLmJqDdEmoPOg-FwZg@mail.gmail.com>
 <04b365ed-0d98-417f-907e-892d18429be1@suse.com>
In-Reply-To: <04b365ed-0d98-417f-907e-892d18429be1@suse.com>
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Tue, 7 Apr 2026 13:31:27 +0200
X-Gm-Features: AQROBzAu28LrH2tJC1cfzbRLnr2lagJMTS_MJ2AmVvkXnfhsEybhgBDbdQ1om1Q
Message-ID: <CAF1bhLWPGnkyvNaSytR6kKLYVOqmiUddWpMqJrEUiRcj5R78ig@mail.gmail.com>
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 7:41=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/1 09:17, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> > On Wed, Apr 1, 2026 at 12:33=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> [...]
> >
> > That seems to have done the trick!
> >
> > BTRFS info (device sdb1): first mount of filesystem
> > d18c93f8-d80a-4aa7-adc5-86d457ddde20
> > BTRFS info (device sdb1): using crc32c (crc32c-lib) checksum algorithm
> > BTRFS info (device sdb1): bdev /dev/sdh1 errs: wr 0, rd 16, flush 0,
> > corrupt 1054, gen 0
> > BTRFS info (device sdb1): bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
> > corrupt 379, gen 0
> > BTRFS info (device sdb1): bdev /dev/sdj1 errs: wr 0, rd 0, flush 0,
> > corrupt 1652, gen 0
> > BTRFS info (device sdb1): bdev /dev/sdk1 errs: wr 0, rd 0, flush 0,
> > corrupt 1522, gen 0
> > BTRFS info (device sdb1): start tree-log replay
> > BTRFS info (device sdb1): enabling free space tree
> > BTRFS info (device sdb1): continuing dev_replace from /dev/sdi1 (devid
> > 7) to target /dev/sdb1 @7%
> >
> > Thanks for the super fast response, and good luck patching the regressi=
on.
>
> Sorry to bother you again, and I wish the replace has finished without
> problem.

It did, thanks! (Though a day after the replaced finished, another
drive failed - just bad luck I guess - going to start another replace
today...)

>
> If the replace finished, mind to dump the dev tree again?
>
> # btrfs ins dump-tree -t dev <device>

Here you go: https://transfer.ddvtech.com/koToYlIWj9/replaced_device_dev_tr=
ee.txt

>
> Recently I believe I found another minor bug, that if you have a device
> status item (which records how many errors you hit for that replace
> target device) for the replace target device, it will stay there forever.
>
> Normally that dev stats item should have no errors, but if not the next
> time a new dev-replace is initialized, that new device will inherit that
> old numbers.
>
> It will help a lot if such dump can be provided.
>
> Thanks,
> Qu
