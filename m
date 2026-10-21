Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792568915;
	b=uvjhGLCgk2+hjy7LPZxVjMOTe5h+PQMcIO/+Tocf3j7B6cRKUNp9t6ms8cnoeVewOcUj
	 0Skc3W96FV1X9pHq0Lgpmximr4aTRdw6pS84066Ofgc2Hu8nB2Kj20mOSvH+Q/DIRYAB5
	 QCXMWG+Rk+ZSG1WgVKAf3C9Y4zlg7C6CD+aMINP9ZLvfcQlS1Y1b89wfe6mvkyUr91rkZ
	 ujC8NC9EriKfJO2kvmmyVU67/Bi7twktHgH7oO2iUB+guczREV5laSDD+rpgpNH81tNgk
	 48P63O0zpVp1vH/vfu3LJlA0YWfsjYKSEXyBtAkilm3YmQ2KTSchYYbozuq/vT126Ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=+fNxdXlvTUDPSplmlXrq2RiuO2LvgShMMhH3RofBUMk=;
	b=EQOfEZJ8N+Fyo7BMC1toWubBpCsbkVoG31WE0AjgklIy2EAnkUG3QsdEejMErxz+U9By
	 NHz5l6lmh/oe50CpLcfM5r5YrliPoRvog79rgiIdOsgAIrO0EBhI4ydQ7Ef5DToU0XQIU
	 siEYfqY8lSQAnLwaCGb7mLj/yeLD+QTKGFJoy7awcG3CyGHd+5QCq7PsGXrz+jxMBMphU
	 o4x1g6LikggjkH+kTWM0MyCQ4U5LWbCflt456sV7DQlEdMXEc+sK/WvyOuJ08cHiAoJOc
	 G9NEf0hFRZBD14bcMsLrYKYi+H6YHtZEezxw6EekzryG3tfzOTmxtjRe8HxirseOcOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=V7VOZeCC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6680606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 07:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6680606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=V7VOZeCC
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48dee593f18so312935f8f.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 00:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792568913; cv=none;
        d=google.com; s=arc-20260327;
        b=AU9ezDgmtWs4nBgmhU61ikUl9jcV9Ov8vAC1mfLJdSXoi9o5SuR5TGWYzVXfWH3b5d
         kKeQHV2XJbFBewWPbQrwpkN4TVubMeK3J/DEewE/EAGqg5gx6rkcykbILpllXFYWyif4
         ELdzpWRXsn7u0EQT8Qapq84eefw5FVZMc4jvjgc9AysLOLn0AoqbVf9lTeczsNXEVLJh
         I+nPG5rYzsVODCOgDjycPkyowIZhBGZ64sMAVDmxujBr4gCqKSRncoeHgXuXn3ECRiil
         kkC/8PydywIboq8GhYsz7FxDJwx4na3GEgeLvN4+yTh7KalKdnLTUMtEL26Ry4owfxfI
         Mg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+fNxdXlvTUDPSplmlXrq2RiuO2LvgShMMhH3RofBUMk=;
        fh=DNhRoUogv4njemsTPAOB4Tb4wfg3Mu7IYlLDA9H4+4Y=;
        b=Wptwp4Z0smz23xCz96ZdSsgjeBwZYc0IDPfCDGbRKKzilZ3rG4sTQLmM8QE9WM7+Q5
         t9RYq39gTfG8qmmqFVblqVKKVcIfE1SqEbZ5ofQBpw5RhaTaiiYOAKF+SU0Ib9ro6W1W
         DhrORRVxHORtMUDJ9ixA7w/+9Q/p+XoizHxf3K8ZvRfpTr4tmxanRF4VnYC9v+FnyOS3
         kZXVfWQOMST3jlAw5nMZtiLX72NqGbRwo6EIYtL9WuSUBCKi9sgmEWSBIdS2clLNdrnX
         Bce7d4YkxMmlIKzfrqGzZ1nhQ08xqG9gaNbSNJDOD95yVS7pegF56k4bLhvx3P7cG0cd
         0UHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792568913; x=1793173713; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+fNxdXlvTUDPSplmlXrq2RiuO2LvgShMMhH3RofBUMk=;
        b=V7VOZeCCg94wuML56qt5D7otxRaltz0ryhMGITBUBkI0IPYpfg2GPLtsZyH6ZdWKQE
         /KbJlSYGawP+3m1E6tibw3+ibfujkGxp7Swh/5zJIuNBrcsDntfQ1w5iME9aN6SLgHn6
         N74tlf+lHIPy6qC3kqc5npfjMp9nNll4S3obT0Mqua1Dooe4tfjhvF/jEFVsBzTQPLnt
         K86tA70WdYdf+cra9VjFyGkenhvLp1pRPLreSrqaMERAg7Eej2wn/97orBwHvFV+4Lio
         OTkktbssJs/j4mNkcYpcGsyM6KH0IBXxyZvTG+nErhI8GFOIvJk1IMRxueOibOdRRYXF
         ekgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792568913; x=1793173713;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+fNxdXlvTUDPSplmlXrq2RiuO2LvgShMMhH3RofBUMk=;
        b=JkXNQ3oRQQn62DKS6zhC6iSXfYxyN/p1PcwLlpUypK9RosrXBaDpSoRxGafIJLBo/K
         Ngu89C2gTME7MHh8StaiJ4b2QjTKEucRnNURkNXpBEaY60/GsO3NxbGZpNzXsBK4p/fJ
         z6x5sinYXWU5fDwbP7BZbg7x3VXASPbiPgvKt/j+3KjGnTiK4a9qCCiw1uATrxGqEtKN
         pUsssAKs60UQ8g7mxXRv73kS/vI5rQHc5kmXnvavW50WWVkeS3Y8AwKb6nH6er2j95VK
         i5BjWydI16lZwXN2TBDaMrORRTmicCJAXGJaTqISTKLzZzx2/gLKjmKTDabbsUdUq/W2
         yjYA==
X-Gm-Message-State: AFq9FYLO3BUQYaVu6wJORqZQTZDkdj1CvJPcTqWsbLGKyT2PIuQro493
	WtmriW20oJYloUB0BmlAmpSitQh3rWLIQ7sOLfpxZpOA+AhUzaW8Dqz3HVlZjvuOhPXIK5pDd1z
	EiONoAMXkh9OgTJG5joDeJOZRbCZ4VjF0FtTgyvb9Hl7LXPJT6MoIpGc=
X-Gm-Gg: AYBFou13SOH4iaKGsVhx8pXVn6TXaosh9xM3zA1hhu6smH9Aq8deG+TisdWOv0CRzko
	J91kD0GVYS98pkQqRhadJcY9PelOuB64ZME8JBkwuXI35NRHTWvUxI0Y9jh4oK8zcGFmiVHypQZ
	4GdFNfcHpNcscr52dkJK5u273YBRNlTAYGog2NBNv1YRbJSjOYZQV/vzADY+llJP3nlCiW9q12k
	9W36dFAZ3lEzOHbvocOc/UW8hunz44LT8AnO3beCfL2Z8duJ++4MigMI1W3ST8s+kAY03ErkJ2E
	48fsSwTnLJ6vj9SetqgMm0LrK8oXJ8NMeqvYFAUULpSXwXeALOBzuRFhJJ1NWO7UwHFP9we+H7Q
	mn5wJwbWIcBnvt8PrnV/qoJzx4VFBwGZapchBsFUQ+xj9nDis6v5acM8fQO1zEC4V9LB2fx9G25
	1gUvHNR7DOGKSs/knwdzHB5tr4uv4mVLS43JJZ9NhzvNuBeYqYcivSifE=
X-Received: by 2002:a5d:5f08:0:b0:48d:fd4d:7fbf with SMTP id
 ffacd0b85a97d-48e2642ceb4mr2475730f8f.4.1792568913161; Wed, 21 Oct 2026
 00:48:33 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
 <20261002073715.2191177-4-johannes.thumshirn@wdc.com> <CAPjX3FcGedb5oap18m7wvKRvaR=wcUJVUVazg0_--RN-9SqzDw@mail.gmail.com>
 <152061ab-a3ba-4137-9100-6dd05c3ec0d8@wdc.com>
In-Reply-To: <152061ab-a3ba-4137-9100-6dd05c3ec0d8@wdc.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 21 Oct 2026 09:48:22 +0200
X-Gm-Features: AclHuK-pqNUV7YRnjLmvjB-rtVVKP1wpEQzXxM86VewaODJ93JxRL5UBYbuQqVM
Message-ID: <CAPjX3Ff=3UTnw8ySk2gUp4sVpqG000htuX795v7sv8bM+3Ae8Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] btrfs: zoned: requeue block group if zone reset
 bails out
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 at 09:26, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
> On 20.10.26 14:43, Daniel Vacek wrote:
> >> +               continue;
> >> +
> >> +requeue:
> >> +               spin_lock(&fs_info->unused_bgs_lock);
> >> +               list_add_tail(&bg->bg_list, &retry_list);
> >> +               spin_unlock(&fs_info->unused_bgs_lock);
> > No need for the lock here, you're adding to a private list on the stack.
> >
>
> Fixed/dropped

Sweet. With that

Reviewed-by: Daniel Vacek <neelx@suse.com>

> >> +               if (ret)
> >> +                       goto out;
> >>          }
> >>
> >> -       return 0;
> >> +out:
> >> +       if (!list_empty(&retry_list)) {
> >> +               spin_lock(&fs_info->unused_bgs_lock);
> >> +               list_splice_tail(&retry_list, &fs_info->unused_bgs);
> > So you're picking from the head but putting back on the tail, right?
> Yup, this is the same pattern btrfs_delete_unused_bgs() uses. I don't
> think the order is important, the list shouldn't grow too big anyways
> and we're getting rid of these block-groups.

Yup, I don't think it matters either. I was just wondering if I'm
missing something more to it. Thanks
