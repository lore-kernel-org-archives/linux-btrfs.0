Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627082;
	b=sqwD2pxpNURzwwwDunyj1jsFWDrlyox0z2RpQt3hQENCk4vB5csfBoiICDCKkyCJtAwi
	 bJG/HM4i8km2C7EpJUQWHydvzvOFhv6ABgNgxkkz/e22n6xF/I96+sqJizmmJU91jB8bp
	 ETdQsY3+Bp1ghn5lpPJjDEkBAc09tqBcWEiWxxxWHduvM1XT/PMH32llJoKu3RG5qticb
	 ja2u8bDfcpmw2ka2oIdXJcaR9sjky/brePq4i/UsgergK+7smOA9E8rYI2wQxffKsjf+O
	 kKHybBujmQVb7s8UD/ttJxINgzPHO7vAezD4C3MvcD6FH5tYzT1V1hC2NJAgUMq5i9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wCsrlj2L6zjqB33Ast7cbJ+UpGvbZhXlTc+v7Iwr5Y4=;
	b=yAzMJXBSXjNm4qMlG8ogfCA7N2J14ZBARieXHYO/6Ok2S5krTXFdg02NCkh/GDdtoFrb
	 OlQX/NttUBmw6dUqz6oFwhMhOJ9Zk/XsS+q2FZJ7gkF0TRCIq80fRvmdgy2d9o+HxPRDo
	 l+/Vmiri6L7lDzzLKdx1gB9yB1f2JZRAhVP0F83KbSBm687ytLqswSidNLQMRgckI2PGC
	 seS3PZVyVCLO9GidnT1Yt6nazlk0dF55B9deSVMQypznJFpTLzqHQIS451gcTkwy8C5hc
	 THNXxLhHS61umQOp3fLXrZtzyIwuu0zDDWTo165mFc3TJanHDtRICOZtUusnwPHOwjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C51D606A326
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C51D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b51389f58cso66507587b3.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 09:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1795627071; x=1796231871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wCsrlj2L6zjqB33Ast7cbJ+UpGvbZhXlTc+v7Iwr5Y4=;
        b=NSWjJ1iUECaItAnSN36JkBuxnJeihAN1EnFqPIS4u87+AdZkqu0BV4VfhwU3YOP+Ur
         87mcA2IFlmnUIjtuKeln/royBzYUY3o0XOTPbzKwWPBEQNuQV7iqlg1EzveubuZg6Z/R
         Qtc/eQJ/UwYC1JHV3JJm/rKRvENuDxeGm4bMUEpmsMqKqRq9N6ldLEXE2rF+RHxB9ZkP
         4HTvEIVHpr/ASt3QJyxQ0Mj3jHjBg2taPpLGqXvsSIorNPm7IQFEkrL82gkTpQSl/764
         DxVuEwAFEetlrEBtLbvcBChVgzW21WCK9N7HRxMEKsSKHwVgnELMPATFjhA/tbka6uex
         qJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795627071; x=1796231871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wCsrlj2L6zjqB33Ast7cbJ+UpGvbZhXlTc+v7Iwr5Y4=;
        b=MOw36RCASNjJKQU04zlJlih2JSd273VPz7KLgAjUGle+XoaJCxj9rJmP2JsLIELn8v
         6PAhRoeud32La3aQpJDfju+HRY4R762YK/u8emjRZiPX+m5q8Id9naqe85k+vI9Kfg9Y
         Ear2KCPdUv+WwMQgHe/qWndBsS9OQTe9NXNuH5sxrIdKKR7VwM5T97lhqdvO8ElyOt8Q
         9QKckpr4Ov4KABJufkGYNEyr/ZH/5f8xIbBs7vsc5Zhww5Vs+9xYqzu3mXKl9F4BZBYz
         bBoG7doLgFuDIrNUnfQxuXi4ZfT6FFm2DvcxNkSosMK59Qs5x/6mlVgu69WZ28ZTU5uE
         3oKg==
X-Forwarded-Encrypted: i=1; AL+hErEosWvGe6hBzhy85l1yF3uk0T0bn9ciBw3qXElkWxfWNbX0OxBcveNZM2Iw/gG40IhgV+vfeTLcfrYQKg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/xqx5rTJ/MRWvRmX098Gpz8HDz5iXfWcw67w4FlvoJNS3C4/AA
	ZmErJL4B35It53ZFVJNQ8mutLStZHIYh98ZPtdEL/Ahf+IQrk6ApuijQc346qFHEQulzoO02rBQ
	SwY4u96qV
X-Gm-Gg: AZFdTZfLhaQIFNCJOceowrWpvfjhMi6vQiFFP8bGJE3km2UNc1HI2B2K/EPdZMhPDHb
	cLYQ21kRMn4b23G1+oQjMHlo+qAGdDSc81UVdK7LhMb+L8yLhoKdXBh/T+xDPGIqGetVrEoUbbY
	qHb30rpJkl3hAQKyvD2pq86UYCrvwRgMma9V8bcEKz/cWr1onh4wCayJk+O2j/6QcEIks2bUVfr
	gvjCYGKC0jdnagLBascg66gFvUEcXCo+j/Wtcdg9y2jf3tu88gkJmOjiksqDZvseyLbZxOr7Fi2
	mYR1UlsGWsFjfuYtApgrY39PmFSxulPJm1KHybwGlmCA5BcH954YptYkMEAgGabhHtUBK4RDjwX
	VHYjgJXXK10ZN3AowHjP2gU/VnPxLtJP9pcJNewuz8QbMad1YA7L5vmdpZuFX+qPeGJ1rZIJp0a
	i+lieczK31fhqhFfklAJIRYjUEyN4TQFD2L0ZdBffqlo3DJAFJbBjGzK4DMPOG/dzRQBgCsK+CH
	u1KvMOz9G+FxfBEeiqS9DX37L97vSUCIax8VUPvBRMtXkZd4lf5myWE1ET80aeaQzvD0ct3o0Ue
	ZlAuqWOijZJBMpBONV8xsBwRlHkMbZGe9TuiXyWJnf/WOZDfxzgq+uAs6y9AcIKg0iYBxtHj7g=
	=
X-Received: by 2002:a05:690c:7348:b0:8b4:e905:e772 with SMTP id 00721157ae682-8b52050a47fmr74530757b3.92.1795627070780;
        Wed, 25 Nov 2026 09:17:50 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5201b8cd0sm75087847b3.2.2026.11.25.09.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 09:17:50 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
	linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove "rescue=usebackuproot" from "rescue=all" shortcut
Date: Wed, 25 Nov 2026 12:17:40 -0500
Message-ID: <20261125171741.3518473-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9155e9f6-9d76-43b3-bd20-a4c98a9f2c84@gmx.com>
References: <20261117030353.1738805-1-hengyul@cs.unc.edu> <9155e9f6-9d76-43b3-bd20-a4c98a9f2c84@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Qu,

I found this while comparing the behaviour of different kernel versions.
I used an LLM to analyse the problem and to draft the patch and this
message, and I analyzed the result myself.

On 2026/11/17 14:53, Qu Wenruo wrote:
> Furthermore, one can even argue that this behavior gives a higher chance
> to mount the fs.
>
> Thus counting this as a bug is very weak argument, thus the whole point
> of your patch may not even stand.

I agree that slot 1 helps when the newest tree root is damaged. But
"rescue=all" is also what people use to copy data off after an unclean
shutdown, and there slot 1 can be worse than the newest roots:

1. The data extents freed by the last committed transaction can already
   hold data of the transaction that did not commit, while slot 1 still
   points to them, and ignoredatacsums reads them without an error. In
   my test, user A deleted 30 of 60 files in the last transaction, then
   user B wrote and fsynced 60 private (0600) files before a power cut
   (I used a copy of the disk taken at that point). With
   "ro,rescue=all", A's deleted files are back, and 30 of A's files,
   owned by A, contain B's data. Copying the data off with the owners
   kept hands B's data to A. With the newest roots (v7.3, or
   "rescue=all,rescue=usebackuproot_0" now), A sees only the 30 current
   files with A's own data.

2. On the same disk, "ro,rescue=usebackuproot" fails with "chunk ...
   has missing dev extent" (-EUCLEAN), while the newest roots mount
   without errors. I also have a syzkaller image that mounts with
   ignorebadroots and usebackuproot (plus some unrelated options) on
   the parent of c73eb6f72741 and fails with -EIO on that commit: slot 1
   has a bad checksum, the newest roots load. So slot 1 does not always
   give a better chance to mount.

I have two suggestions, but in the end it is your call:

a) "rescue=all" tries the newest roots first and falls back to slot 1
   only when the mount fails with them (similar to the retry Boris
   suggested in his review of your series).

b) Keep slot 1 for "rescue=all", and document in btrfs-progs that an
   older slot can point to reused data blocks, which ignoredatacsums
   then reads without errors.

Thanks,
Hengyu
