Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12751486430
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983605; cv=pass; b=jxgUUkKJUv08sjdY6UxiH70FBBAZkR19nmrggTkPv9ugV9G19u84nMyihRfDD/Vw/gElmn8RCAoNY3Nm2gAlAPp945Rds92HnKfdUuu8rXcivUAtvpqt850Sxy3wrArabQpFQpS48ao43DnLfzCp6xUQ2kMFQVvv0KOrjS29IoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983605; c=relaxed/simple;
	bh=ivJeqPfMTsTUeSx6590z1lk4aDHgkjMlfMm80JLCSUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=skEEochM4S597czLhJxUUTNqoEHoU3Z8lzjGW/dLXjl3o7LXf5Aq/Uwn3fBb+5tOQKgc/b4NMlxTo3PfZVMPPTODPW2oc6VfLvc9AtV+uhzTfpjgStEHbLONnu4UXVe8Pr/7wfVtmIfEGrIXSYEPaWE2d5HjO7MqMBz+c31Q5y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com; spf=pass smtp.mailfrom=studiomoob.com; dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b=N6byS8WC; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b="N6byS8WC"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-533952f3714so43947981cf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 06:13:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791983603; cv=none;
        d=google.com; s=arc-20260327;
        b=eU4ONx3MM9Y72LN1uCcOKp5wgG6mZtHdQ6+shTIaTUTmUhWRwWKarvBVte1Q5GJmih
         FSum7fHTRgHCWF4767uGQUIVRhKAj1jEMvDhzAEfATZZRA35TdL2J6YRdMnXzVaGBTcJ
         2QbiwmZOSXzcA+I1FbnsCN/+WDdj0JKRaVKeJ3479euN6wDmrqOyZJ3dVT4i2UThD9Zh
         PzTYLA+p1IO+GfdercG16+GdEyP3XbB80CnSmH5tkZTTK2gZJLskGpTkuJE853lr7SSt
         1Wdl7lxsmugeU9mmZmcUioorrqECH6W+IFuLu62FIDzmEA+6q3l6TlTBacqQq9Yt+5JS
         rocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ivJeqPfMTsTUeSx6590z1lk4aDHgkjMlfMm80JLCSUo=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=c1LCHxoGpQ0QR1PSmCo3SLsFnFJivOHCNJHClHxSlpfCqM6eV9vsX75xz522fLclnq
         lONV4DEIqqp+YalR9jfKvkONRDxLduqizwFFnZ3cBTNXYl6QZNaAM/0Mf8dkdzH6qu/r
         HV4B5pW+yICc8dIG4vci7h3EAj9tC2JMbyJWr6v1aRlqFdWgB6HTHm4kXLQ9G0M8hqWD
         8wow67jrdhQUNACP4/VgfZRRexT46ki+zCjByAsrcKQrVgiC2wXZkIKRJeRpvJueWLy8
         4Y5PcizkKty7P8Mqxik6kciEhdAyEEYhfvN60Nr6nJciw/u1twKZd/WaryH1jrQm5mbF
         Fb1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=studiomoob-com.20251104.gappssmtp.com; s=20251104; t=1791983603; x=1792588403; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ivJeqPfMTsTUeSx6590z1lk4aDHgkjMlfMm80JLCSUo=;
        b=N6byS8WCcxbJIp/zFMiIJqJBVu7hjRhaMvkcZwlemmOo3znV3OgYScSuRD5d8avxJ3
         gI58A72VDacWf3Y+wSTDoye4mKYw+tXedBuboO+IuXvDOJ5CF5MwZiFtbapUFGgeead4
         w/KxSmhbnVHim9L/shhtRBW8GTrfpgb2W66Uu4XpXDBPOKqqinv5uIgyN2SNLt9F0nJG
         yrYReLil7p5c5TLcSHVckYtXuq+X31OCQSXPlJWly6stVRFXJmaawJ/xw/U2+hxsWqbN
         CgEzjcYqeY/ZITZ8NKx21HAZ80f32GZhJ+K+FpzvnkRuHnAMaPHJplAXNg9Fwq1sccj3
         6DGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791983603; x=1792588403;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ivJeqPfMTsTUeSx6590z1lk4aDHgkjMlfMm80JLCSUo=;
        b=mNra0G6Ccp1CppnteJtAalM9V6gcxYctLNrkqmMln1/19F1RignmhPtXENVSiMTIyw
         SKPSU29nLqYM1I6vnCth6AUp/jOo182UahOBbvvMdc7qNHDmeIshAEm+906x6kOww1De
         knVUmMwz07+8H05P2gvDXNh/dvQVb9QicE0YCRfbRH1dPmH3qRpNl3h0YU5vG8PQzcmt
         ChOZBZDfqX8ngohYnCwn+KCoO7ZZiSm/u++bsQwPspP2zEUul5lnxZBDXMGGFt4FKcmm
         gttb/hqUGh/h2gij58mrbdUeot2uqthSTM5b093Q5+ocXWncqRdKnqnhxYtdHUfPmoIX
         fJ9w==
X-Gm-Message-State: AFq9FYJskpJgdF4sFRnCSd55b5ol2WJftO8kXU6/WyDFI0HXSW5HSeNI
	ggVG06Gkcw3RQm4SbG7tTDCZGs7LKcQcXNGMx+qbY5mgG1T6NGGB/aT4berV3rur6Hx024/nwRR
	XsVnqlenBk/zyJT9V3ehWFtMoYaUvfd1+W9CulgOpKmx3Vups/3kZIBA=
X-Gm-Gg: AYBFou17bfIYalce7b4aUWsyLrjWFAReYOS/jw6iKnw2qZAjftCtWwfIai3RtIuSN16
	YWyUj0t41hJzqh/Qnk0JK2n0v+eSrK14/Xn32fs3Ck6X7Cqf/jUG0Jzw1uGqzBmFK1oZE9YDqsg
	n4FdEDKvPeg42IKyRg4IDUpY9B73DO0Omn49e5TYFSdXqszC40sDY1luEXGJNglHyTKr/Fqueng
	R+hl9dHhYJF4kjGp4Z5+QRe4wIE4WnCjjM2ilR2bbsDufwxgvLaxJsRJsPBk9ykeac9Lt/Y5oSt
	p4eFG7MtKWx8qwjZbWvfi0/Bye9uArOebbWapYJQQE7MK90qIh2rhm47dXkuJctUhX0zUAnUVba
	TvBXaWUHaNq0T
X-Received: by 2002:a05:622a:4089:b0:535:19e2:6b79 with SMTP id
 d75a77b69052e-5359fde869fmr232686881cf.54.1791983602751; Wed, 14 Oct 2026
 06:13:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACU5Mh9KdABHuGXFTY3=s1DiPSPUSLabhWZnQRrYjnjK5PGPSg@mail.gmail.com>
 <a29f5513-1483-4064-bd8a-aa2399076bb7@suse.com> <CACU5Mh85r_7x48Rh4b6kC6_-tm0LJz=PZiJ6NBfOvcWxve0iBA@mail.gmail.com>
 <bde7518f-53ac-444c-8b0b-c434d08aef8a@suse.com>
In-Reply-To: <bde7518f-53ac-444c-8b0b-c434d08aef8a@suse.com>
From: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Date: Wed, 14 Oct 2026 10:13:11 -0300
X-Gm-Features: AclHuK8REz4rPYjaSCmFl4H3Lo0WqJl8Gq0h7Qip3yTPidN4teOa9Vcmm97Xgik
Message-ID: <CACU5Mh87r5P1PVkNMryYUGY0-QBooZ0Bq4Z5VHzP6JdxQ9augg@mail.gmail.com>
Subject: Re: [RFC] Stacked fs keyed by lower i_ino: detecting a nested
 subvolume root
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Oct 2026, Qu Wenruo <wqu@suse.com> wrote:
> Yes.
>
> And in fact the uniqueness of each subvolume's st_dev is already causing
> problem if there are too many subvolumes.

Thanks, that was the last piece. Closing the loop: the inode-256 test
is gone, and a nested subvolume is now recognised by the device
getattr reports.

https://github.com/studiomoob/llmoobfs/commit/caebf0a6d925e0790611c472778009fce15a248e

The mount records the st_dev of the lower root; a directory lookup and
the index scan compare against it and return EXDEV on a mismatch. I
compare with the root rather than the parent: every directory on the
way down was already checked against the root, so it saves a getattr.
The BTRFS_SUPER_MAGIC check and the btrfs_tree.h include went with
it, so nothing in there is btrfs-specific any more.

The anonymous-device limit is noted in our design record as a btrfs
limit the layer does not need to work around.

It passes our suite on ext4, btrfs and XFS, and under KASAN and
lockdep; with the check removed, the subvolume test fails, so the test
does see it.

Thanks again, this was a better fix than the one I had.

Claudio
