Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22FD382F15;
	Sun, 23 Aug 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787500678; cv=none; b=QmdZwfsJl7vAYlGgbx8X7lNAG+gYvHy+OepbWIU6SctbeNsV6J0xHCcKubBaCD7hGVMfUzM62MO7+jW18Y/ShXJxskLpjum3z2bFe3cCLoLOEgES8VgK6vPRf7+ahIWlmtiwtpA/CJUE7GdlY1eFAebhG9AoYrHxnkFJJTFSACk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787500678; c=relaxed/simple;
	bh=jiFwZFp0evlJn4u9xurLfqyhGtWOp+pe2r3tMsa2MGg=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=Ln/T9YU8d6YrGWs1ILKGRcVkTTXJuV2Q3SA+fps2lPCFWvkNkJZzdeP2ao7psbLgqYKPvP6n1hJuFYV8zyzCH2FspTRc+CRo4TtvRtPK8nqIJQUEAb9yp20NnKun0zAF2eZ4T1efDDqs3qudwheHobPCwEkxvjJqlzbJo7qxonM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=rQNjsoBY; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="rQNjsoBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1787500638; x=1788105438; i=markus.elfring@web.de;
	bh=jiFwZFp0evlJn4u9xurLfqyhGtWOp+pe2r3tMsa2MGg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rQNjsoBYOJ3MuLibf+MSM7+xBUfroun04ceHTS11nMODZsyw7R++APMFNTUK0XNQ
	 q4Tg3Yv5xWlPVS6YEITFlCW6C5plegmsBCJtSPKiNbKMVdtAIhPFHKa80v4Ej1mNl
	 9/TWXjhMrR2O3DAY53rCGz5Iqr8A+hvxMpXTPvLZTj1iklvo6Xg9gFyNHA7zYbEnf
	 c2DpZs3D+TIiTaIBYH+QWYHuLothCKxAnOc2iDJrmS8Dn6Y3hkN1p5VAOWSbnH6zB
	 NCqkmjEAbNCJkLVSYTwNlmvhaUwTpUAlUmq6xv6gx9gAjoVGQjbIYYlQLkt9Keg9y
	 eNkYvkGjOT2Z5LUA8Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N3oyy-1wpbwr3Cqm-00tQtB; Sun, 23
 Aug 2026 17:57:17 +0200
Message-ID: <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
Date: Sun, 23 Aug 2026 17:57:11 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
 oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
 Hillf Danton <hdanton@sina.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QnMg56S+5Tqqo8eAfWX216+eTqfSXkK364Kqj6Wla68OHJ9vWef
 hMDfSrwlSvuHhfznQOUUB18LnI+yR7uGCHeTwBbWWOOeBinz42ro0JGgMJIZL5Js6DmOozz
 yq94Y/NwWLFY13eVvZiGh79Z8FezWYeQTEDjFJya3MGzybnnMhcQrJrZr84vA181oNEV7Lt
 CmMcwSTbGK/qeQZVfBWpA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KQEXKRtTgg0=;0CdyXlsceYWAmCK+ZH8RqnxfaAR
 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
 9QT8eWLHaw0O+6GTMMJE=

=E2=80=A6
> Therefore, this patch introduces a grace period for =E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.2#n94

Regards,
Markus
