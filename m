Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BF9301486
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 02:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779762733; cv=pass; b=SdgLeZWXN16UJZcs57/qloF3u3y/VOTYmMV9EGDwLaY8+2mBCXIQNfnn5RBJYFsD/d4F1VW0jeEuXqCUot69NFbNUY+AegjKqiFBuKBtwGvE0w/HyH4vihBOTQmjx65fS6IRYlshLAUIinHET9ApKjSHYaORBjFnI5LJ9jfH1FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779762733; c=relaxed/simple;
	bh=BCGafYXvUOztxj7MzIvv73nlDQ98LrNK9WPwKleo10A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EMmC/7WlhE9CHE6ugcm4xXNtzgOxysZ2YqhnVxLMqtbkeaFiXFfqqM+BU2VmJQzNZogOO5NJZ7wS/FG0igvvIZIkuiwrsZz91ldCEFZXQ4GcjbXp8gf8/E/CvOLa5TAE0SGFg3LF0IXRayv8EGqOfJvnG2gbrYAp4z1CEnV7Xow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDe8T6d2; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDe8T6d2"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7cfc382d896so53474677b3.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 19:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779762731; cv=none;
        d=google.com; s=arc-20240605;
        b=A1M6rnC1PYBaVE55ZMZbrkjD4BWTbarM+lZ08YSlu9Kg0N7nfyM93Eu34M8iDsH0J9
         RmDvikkBT4r1gOgK4Ce5abWU0QATaWdzCQNN4zWC6JsNX9OQfZuW90nFxfLKt+fjDNBN
         9IsRotosmp4y/SnPc3pWvMKsm3YxyRr7QDP02uYoEnVzND7h/GkRl2kD1T49YHN2d0TG
         /6ZJna+TZEmsAZ7rG3WN79zy6OxPA+9g2JnYv9spIwdIEXcad9iDVkvcToU6WhgBbZ/q
         DAVVURceBs9cWFsGVJUouVibrE+REdYZcTHZqlReiWEG+6VPalbTvW9S1o2W7OalOxgX
         nYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=BCGafYXvUOztxj7MzIvv73nlDQ98LrNK9WPwKleo10A=;
        fh=ISiNP3p754Api29cakcQUATzJd03XtTTEagwK3THA7o=;
        b=XF9NYK4MkqybcJejJRsQYLULRcHZCXZNiGmdjGnfTMrzhll2Ey3KUnzZnJ07wg0f8e
         FbSRu2thk3v/WoEkIRq/73X52CKDqxg50EX9urYHVSs7TMwKsA0FXiwV3wFZwtSA5y1A
         FXxsLhWY6vBcbK0w+uSiIugE9tTGDFtGuB/nZVhF8dXnXCTPXa5Jvi7YVIgmQaA5cl1+
         cO9Nkojalgwnjyr7QeB8fDfhcx91kEGvZUs7c3qi/tQCLFXAvWWpqiI1sXNhkRYL+fd6
         KxY2XR3Klx3xHBvtn8a3yCDjXcHzHOhbYodkOahFdpeiPUMwOCPcBPXVnD8amUt3/Rzo
         anFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779762731; x=1780367531; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BCGafYXvUOztxj7MzIvv73nlDQ98LrNK9WPwKleo10A=;
        b=LDe8T6d2k/7LF036yS+cGOIOSfmw52MTVrbI5Nn0//a6Mj9xN88huqgYtrv/Pi6YZn
         HkrpBjIK49yYrMywxFhaurGj5PbnOfnWbuRRBxH5WZ80nmwzslLKRxJSxtGLW2uz+Jb5
         ybLq+7eLTnTAgnT22UtTIWh3y8jamsyXISC+gQxtFsG4dfpjLDT6XwGCDKGDv4SbIBT5
         8ijnibSd8kKai9pusdbmd/zRHx6v1Xh3l3XtSFISsGjMrlwBG8s6CpjJ/D/u1s92P9Qp
         XVrYrZgWquWQA8Ka2NZum9zbdw0dUs47thVHpbgOWASR8HABurtiMaGn83wW3PUPloy3
         gXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779762731; x=1780367531;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BCGafYXvUOztxj7MzIvv73nlDQ98LrNK9WPwKleo10A=;
        b=J9C4sBljR5rDl2HEvJ3apAEz7wtYJLPf+GyuKTpq88S0vr3cEAG2Qcbo3c6svQ7iCS
         lMKnteNSo/zeEn75UU2zinwLGj7SeVtL9TnSwcVqN0rO3PACZhT/UkLfFWrvbrkcH/28
         RW0a3SOlI3gk7GCXS2+/Fxb021tYKl08uYZ/bwR6CLPNxq6wxiKIdLq2WAlDjzYEL36f
         DHuFabhHXrjjtUm5g6h/6MuE4oYUvOxEAB4JpuFP80NDWH9RZeWhV8myOLfQ0O0+I6n7
         xigGOzKAbx5MSTNVkawvFpCzMqW362Rvt9JNKqscRM51cQbfdMOpepYJR49ps/Got0NX
         pSFg==
X-Forwarded-Encrypted: i=1; AFNElJ/PTJQA4U06pHMDBuImE4tnxddWlWjWh1Jl77FpX2wqC6TYJ/Bep+4BmeuHy21YXFga+YkYtkbURyw2Mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvtWbiVo6TkW9XEyUQImRBJFNU28cQhbiFJeMLAkU39OJ087I6
	GluU05hrDCBZs4UHpQEaIQ6eFsA6+yRdMLARqzk2VwslgepgK6TNArEzAT9lG0Qbiq5VnMThRAa
	TVO4XjG/3d4iTzmLl2DKp0WXSjJAUynM=
X-Gm-Gg: Acq92OGF8yf7TeOSmZSZODl7coF7ak1YgvXEWiWSMe20u1LPahbLd34kQK6cLsANwaW
	G5Sb5EpZpGkyy0ziP9FFmR0XUdGC4MCIh71cavEsb1vBJ+mpyJGrZHW5lg/ixJ77aXWPxkPy432
	o2RSNNXo0O/GMGUcekaBbrZpIoLpF8JoV5ODYHYuD832NKEptmVgp3mwiYqePGO1+JgukO/jQ67
	7PxJXjJzkXlRVYQqQcoMbYoQdHbpTCFOwPMSGW0tEhY4bpFjTkKIIkAO6vVks1zGLy3mwzMok7p
	XJa76KRoWDR2mtxgllMmDnIiook3P4uD1A++D7b/
X-Received: by 2002:a05:690c:b98:b0:7b7:5f48:d9ae with SMTP id
 00721157ae682-7d3378b6ce1mr169324387b3.24.1779762730949; Mon, 25 May 2026
 19:32:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Brian Thompson <brianbthompson@gmail.com>
Date: Mon, 25 May 2026 19:31:34 -0700
X-Gm-Features: AVHnY4JQK-W6E8CvCWz6uu8un3b5oz9VlVSksnufxQRzneHNcH4uzGMefrxTuFs
Message-ID: <CADcHvwe-mbZ4uTBHQ0zG0=QbdqyO6sEyg2FWExBdDfLc0eA_Tg@mail.gmail.com>
Subject: Re: I Need help. can't open btrfs drive after power outage while
 copying files
To: quwenruo.btrfs@gmx.com
Cc: Brian Thompson <brianbthompson@gmail.com>, linux-btrfs@vger.kernel.org, wqu@suse.com
Content-Type: text/plain; charset="UTF-8"

THANK YOU SO MUCH. btrfs restore seems to be working now. it's still
copying data to another drive. I assume the btrfs restore program will
stop before the incomplete file that was copying. It's still
transferring, and it looks like everything i thought was on the drive
appears to be in the temp directory on my other drive. so that's great
news. I really thought my data was lost. Thanks so much.
Also, I assume by the current way this is going I will have to
reformat the 12tb drive, after the data is safely copied off. I assume
there's no way to fix the btrfs partition in it's current state.
Either way, it's good to know that I am able to copy data off the
12tb.
