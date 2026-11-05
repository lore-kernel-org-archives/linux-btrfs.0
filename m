Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918426;
	b=FFbbXGl3kFaiPEmB5A6XiB+WSv8aE0eqJonOU+vi/lAGt7n+Su5FAEF5P0o9hZuQbINH
	 kfoqjhDYGJy3fD7FLTKQOR8rcB2hTb8tspnBERpdNoU8TwBZ5mcivOYEDEBwn1HR7/uw/
	 JvHojJylHyXn/c3JAsXFwKvSCwIX1wrSJLSnNiNcJ2j5AdW3BVRzoX3hTpkd4PpeM3FJS
	 K+4Z8K2OBB796R5xX2hcVCc3d4qDngq4Y6JggQGXKrJAVsTNBkrR1g/WHcETJABVw/Jbz
	 5KqFN6x+gq46787MUhVX+ewEP3nuqrIJMYSvvdM5sjzPUQ45M0BJVOoNf1rEhEYKLeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918426;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXtE+j/cqcFyda/TqGBQWXHPqYIyz06WBkp/r9gDWMQ=;
	b=P3jSfXBiT8uQxT8NSGGNj/O3/c7vs6cC3G6vCcuX9c3E+FAtWsuOkY8R3uZCMe0tho6O
	 TywH5hHwlNkQ6qEP/fGqsQVAcrHEAe32xwOaec5TfIuIjSSws2qZnGqpDkpchrFiBYtY9
	 viXT6oXpWYYBg+Yh1oP+ALgqP1Nb2HJG8F/oal5uPL2bM44vCY5H6MHpZE1qg7I5lWdJC
	 7J1Q3doebg4pH6jrPoX/J4wk+QfzfP2O/nKtekt7m7IfHWPXt+glQYBC3kIJh3Exsjsrl
	 nOuqN1SIWMm9G7wPUWZ84Wd+C4R3FbVdc6lP5CHkU4R7cnADcfLh9V6kY7e2M/xCqCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=WdsK6ZAQ;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D01606A328
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 22:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1D01606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=WdsK6ZAQ
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35c76e9614aso34143eec.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 14:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793918425; x=1794523225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UXtE+j/cqcFyda/TqGBQWXHPqYIyz06WBkp/r9gDWMQ=;
        b=WdsK6ZAQI72EOCMYCYaXRSMKwuGuxqbLxfLR1dRJuKcVkeKCeJf9a3fdRINIKra6BM
         TwnrBSX6pDDF0nK6ZFsaT2KjbT9jRQeMlwptUPIGgVGW/SyftUmoH6wBvym51nGWfaRU
         vW6ecCU8IrQKAWJHprqrTaYTLdvWuGfO9GOXAG56OCjZ6sSO85HXV6bKjRdTB9CuCeGQ
         p1BSIw3f3dVcRxdkmIZgfVb91pjuXsWPyLvBtb5rsXWFVI/vju2AFJFTIpnMi8dXEt5q
         ymGtUvIgJ63WFzFgJAXFW+PklozGO0UYW+n2ZTLZHFcsv3IsjgLnurBwHfaStrO8ug4S
         Ni4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793918425; x=1794523225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UXtE+j/cqcFyda/TqGBQWXHPqYIyz06WBkp/r9gDWMQ=;
        b=QlzyaEflBE8edsvwtaiKUtS+5fXTprqcV273vEetqA1mNPgdQCiChW+3nMjft6R076
         Nq3Ew/Yu7OFVSGUDueepKMbvZFrvz6eX8KRPM6kFeqbUTZBXRmxhESyWBoAePNCcJf+j
         JZ7ICQeHYJtYeWuqugVTlGnN3LnBR/e4PaDBWJxCRDigPdHiwQipIZzCpcwt7KqmP6lh
         l+21lW5JqWCc4Dwr33Ajz/Qz48AyI6ylQhyYQcLQX3XoAV+BmQFkVQvtcdvKpWg/+7Nn
         /Bs19FNrJL2+1BiBll4+qEYW8d3wCwu8tjz75/CsdgFZXTuMQWiF2tdgnJ+f8mHkqaWv
         4z/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzuHWhkvJth2L2JqeTtmLjIITej2znbMEbVIaPgI+Mz2Z8/yQPgDEq6ZNaErf1NJlF7kdr+JQmpFfFXAA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9mEOKrJ+yRXn6NbdAYuyFl4/zdw9OPdXAiLMVZvfeUlypQjYky
	2Ka3r8pAiIX2Omdj/PKIMEUpQQvONkvanhiSpYOCt8MyFd2tngOtcTX/OrU6PqjZLJCstY3s58x
	l6syYKhRe
X-Gm-Gg: AYBFou3PlIsKLRLMgyHCF65wnS3OrXRRITpIaws0VpZCPuXassyfsAgH46cTkcnPBfb
	7ezsJ8nvC67MMUw8l2sIcQSDqc+9z4x/xTaz8Xbv7lPobTJDh5HExoAYUt3VYoxmU+JtjcoX6qz
	nfstXiLlivroxvvW8tILi+V1YXbpQvkZxYgiKTPbiCAc2nAnb3eK1RmPBNG8Tii1/LMbbRvBAvB
	6ISPUYsjhSRgBN5ZyYbbBiyHi8MZJUeut5PuKo96cS+mMdTbzq3F9RGlkWL9fxqdPLhFjoe6RYF
	Pk11gQZGJrjh3VLJVkjyOP5p7nVzwpsokd9IA+qT+2CwJrTcMVCNZjnRAP37LomCfz0LEV75fXk
	U0U1AMllBgWSjQk6mrtD1Lc10kyeyTJIpMjmh1huad7A41pJxdmPhCY29FDJxJTIkwUzvx8xFl9
	3cPq28QFBfHBn40lJR/HWOnuayglMRO6vqxjQH6yzo3Uv6cqSYzBE9L1inzccGVj+A+CoBsfM4m
	tXCGfuqx5+Yoi/XAV4reqp4q/YCeuYZwjdM+6oxYPkE12mzBwrXQ4B4T+bnL0P/SA/lblreoJdn
	48lIXgKvxrTUlebcw6/5kWA1lei3Bf9sDj/nrdDBnU2iXOnN3BH5Rj6THw==
X-Received: by 2002:a05:693c:41d6:10b0:36a:1008:5815 with SMTP id 5a478bee46e88-36f729d054amr794897eec.5.1793918424869;
        Thu, 05 Nov 2026 14:40:24 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa651c57asm251536eec.2.2026.11.05.14.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:40:24 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com,
	mason@kernel.org,
	josef@toxicpanda.com,
	fdmanana@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+dc9291cf132691aeb478@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: overwrite a leftover balance item instead of BUG_ON()
Date: Thu,  5 Nov 2026 15:40:22 -0700
Message-ID: <20261105224022.254528-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <4c59541a-3f19-4ad3-bef3-59b9c42c2e90@suse.com>
References: <20261105214738.111967-1-smish149@asu.edu> <20261105214738.111967-2-smish149@asu.edu> <4c59541a-3f19-4ad3-bef3-59b9c42c2e90@suse.com>
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

On Fri, Nov 06, 2026 at 08:39:01AM +1030, Qu Wenruo wrote:
> >
> > Both assumptions can be wrong:
> >
> > - insert_balance_item() inserts the item, then commits the transaction.
> >    btrfs_commit_transaction() can fail without aborting the
> >    transaction, for example when btrfs_start_dirty_block_groups() fails
> >    to allocate a path.
>
> I think no call site can handle a btrfs_commit_transaction() failure
> without transaction abort.
>
> This is a way bigger problem than what you're fixing.

Are you suggesting that the right fix is to make
btrfs_commit_transaction() abort the transaction when
btrfs_start_dirty_block_groups() fails?
