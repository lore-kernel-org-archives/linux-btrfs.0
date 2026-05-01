Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22BB35AC18
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777666946; cv=none; b=HXBfrBxC8RAG6SaicciFAupAgFLTPFlO0iLzdLItQ+niMqJfkC0xR62QZinJTLklypn9bXO0Pa7eNnCmw/biIfgvfzAf7mZjWcRJakudZsvje8fy9YS0tBKroM28ZmBrlN3by0l5YUmBo+qKpnnTVPnAXW+eUQwmSodJ7R5ZHAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777666946; c=relaxed/simple;
	bh=W79f0O4+07Uq8JYaDRGyu25V0Zk1fpM5XPn9TuP4sS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iXtNjV0vUGUHy8K6hIHercYpSL/Tg2QZQz5R93CIksmySDo3MwZCUOE1SCwSmlg88nNEdz/2bVMPXyQP7y7VqFnjaliPodGkcKN9GLi/kY7eqZ0zUU/9E99UKFHD06gNS1+ZSvzL50zfpK4o51L0B6hgxxsE6eHxUNn7M0ot3mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-47c7b282e21so308841b6e.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 May 2026 13:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777666944; x=1778271744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pO7GZBnDE1ae9FWZpwz1lza3aQT+nmAa0tLzWm8ZGxE=;
        b=qAVW3ZABwPAR/esmvrZT0Bl8I9wjJ4qUpXsq+iA7l2MsnKFdIHQ2xJk/n32jwmn70a
         KoKVUHzVRxI9DUOx2ZFl8s/tYILYZQFs6+V+0pMNm9VHo+S/aPLYgGa5FgI0e1bMnClV
         +hWJ40k6d9UXPE1cWfM0zBRU50sUT+wVY5R7EdDS0jklme2Z/zevVDPEhcB70cDbkgT0
         YjXi0FQVL6JNbTKaR5OhNbxpNhdX2GEmcHJh7oCswAtHdEcy3rHEnXyj3bkWQORFNkDi
         QDbakpFdqa/R9uCNBa4940skkD5L6og7gNVHEbPni4kbMrUtbkVrldYsBm9SA9iCOOOz
         vWBg==
X-Gm-Message-State: AOJu0YzyTutCc7cc3w6FRJmRovmWVuALJCWYE6JSTy2K+nFCXaIflTEl
	MG9A/zbUIEIfUVzL6ChsB5SuUXq4NO6KiJOT5FF3aD6dqdSE9h2NBK9YQKDrJw==
X-Gm-Gg: AeBDieuvAhpvKWFQRlR+2G82Pi71s6SCS1tJlqEPOzY+dMUb+WmJxEdymkeRmvhuTXV
	q83nIMQv5bQ4xmTugiQD+sldjM9BApVNWY4CPUqjy86HgF2EXwdLc6ef6iahORdsmMUtrFk+Y+Y
	3/GvqpU7rsGNdQQBwL9RmPzcN6BBMBxARGOOOCgDBTfBfDCMiwcZpWIN6X6Z88xlVEEXYVpjY7v
	ulmVrDQJLNxye9J1MBgT7plBwCJv69vH9aLNN435i1htZk+fcdxJL1d79U7RLAHtUC1FWLAaW8H
	9eUOU04sgzdB2WjHwRpZJRsZZlHlWKWaLSOTvPEORreK65XHTIzCYgqkXdL5gAMmTn1K5jIoX95
	1TwWDd3E3np/DWFlmHvEvioDHq+l7VSKk32L07voDGfhi41YDSO6VsHH2XSGFtGO20jyGCpiMaE
	5KBQkTIZHnRJRPE+jmush2Cv0IDRtQKyCsUWLRsFPeXf3YPdTGm/7TzbzI1OYt7jh8hKMXnzmuo
	sN0K1JlA4N8kekXYD3gHGkBSmtdWkkwJkJCEgUqNFqfjGtcIJNGnBw0hnleUhdr4Tzhzoa2bf2N
	7BegVlb4
X-Received: by 2002:a05:6808:1798:b0:47a:8c2:a571 with SMTP id 5614622812f47-47c892a7702mr598069b6e.33.1777666943642;
        Fri, 01 May 2026 13:22:23 -0700 (PDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76400690sm1951830b6e.7.2026.05.01.13.22.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 13:22:23 -0700 (PDT)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dea1272943so1330659a34.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 May 2026 13:22:23 -0700 (PDT)
X-Received: by 2002:a05:6830:82ea:b0:7dc:db04:d30b with SMTP id
 46e09a7af769-7dee12a4b82mr657212a34.9.1777666942730; Fri, 01 May 2026
 13:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
In-Reply-To: <313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Fri, 1 May 2026 16:21:46 -0400
X-Gmail-Original-Message-ID: <CAEg-Je_E3f_Wy-0M20rUp5Zd7Yg=s6SuaJ2==08W1C7EOYscBQ@mail.gmail.com>
X-Gm-Features: AVHnY4K4UuGguF71IhZwOKrWQ8BPdmj0-pwGI7t7y2D3n5bO_hqc1U-7Z75oQeU
Message-ID: <CAEg-Je_E3f_Wy-0M20rUp5Zd7Yg=s6SuaJ2==08W1C7EOYscBQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: docs: update the qgroup performance hit
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Max Chernoff <git@maxchernoff.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 6:44=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Although we have mentioned the qgroup performance hit, we have never
> explained how large the impact is.
>
> Update the documentation to:
>
> - Explain what affects qgroup performance
>   Including snapshots and reflinks.
>
> - Explain that the automatic rescan can cause performance problem
>
> - Add extra warning to avoid qgroup
>   If there are too many snapshots or reflinks.
>
> Reported-by: Max Chernoff <git@maxchernoff.ca>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM.

Reviewed-by: Neal Gompa <neal@gompa.dev>

That said, is there actually anything we can do to make the
performance not suck with qgroups?


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
