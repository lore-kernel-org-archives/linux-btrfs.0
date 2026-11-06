Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793931845;
	b=IMKGYDhUFdXNvEItHCNsdGTvWw6V5C+XZQH1B+wPulPTjhmOAANtWEfmhMReeWIVP93+
	 i/INI0SWspEcPsYZfqAHZHUYt2CjJiNUe3OEVCbFYrvNRveyP0rJgR7eu4Gv9wiQZme53
	 gNZ0K7i6hSFkCuIA/uyCOoa3NEzvx7xz9HRoK+ZsffWSf9HzlaUQC436nOWMaxe1vUQjn
	 RPQeyQMmQwSYxU7mvlEQHdn91PpELXyqwZmyhVKDSBHdVmwnrgnxn1LFsvwa4aW7HnH0a
	 MoB7YJyU/zFQEQdKaGeKpB2ZOgFfFw5ofN2KmUylEIAoGRAg3mTg9+BYToAipS1MdDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793931845;
	h=DMARC-Filter:DKIM-Signature:Message-Id:Mime-Version:Content-Type:
	 Subject:References:In-Reply-To:From:Date:X-Lms-Return-Path:
	 Content-Transfer-Encoding:X-Original-From:Received:To:Cc:User-Agent;
	bh=DL4INYl/cbKLXbP+4pZ6BO9v9PTq9Y2JVDyR4Vmi1aM=;
	b=fJnFFv1iNBk2404WRMQjbZSBSPzXnDjcb2sNyUPlciVyc5LNtl91MjwI6KXHW4lQba2K
	 ZAc20RUamAueWMBNpdnWI/rKWvdrAm9+W7mY/YL51rn2NBHRs+nrr7s5wasNK7IAFdVES
	 qxgZdssIKDoy5747BXVWCovPsQUAiXBC1vU4TtSKEHmTI6sgy8g+sdPeVX4+ia8nAbljj
	 RErAX+vmmp4LQyuB4bNKTzOqmpPxbsYgVrOciHwoW7Ha02bqFsqsCuQV2JUdoummhfCyg
	 vGCayrtgP41I5j5ZyFtaIzB45OdBz2yvsZeyQgDtWqgVlVUBHgx0dun3Ax4tyZBEUUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=AqC2Ufo0;
	arc=none smtp.remote-ip=209.127.231.41
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FD0606A333
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 02:24:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66FD0606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=AqC2Ufo0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793931835;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=DL4INYl/cbKLXbP+4pZ6BO9v9PTq9Y2JVDyR4Vmi1aM=;
 b=AqC2Ufo0cxRwsWxcNG7/utwWmoxoc1eQ9LQAk5qBG+E7Wf+8jWAARB/nnVmFs4o4omc2eU
 VgduRhQyjng61PZeUHybErOTDpjyGKEzogVcKTkdFyFx8hrC+NaVwu/fEdo0YBjySFbtBf
 pNkSSPzHJxI4uvBYBjtNdwH5LETOXTAcHSC74iMPuB/PJyDPoYjtpm2m+3g2+YDD115lxb
 +77rwF8XSceXsouho6ffJ99H+/5RAqFP4i9CrxGda7v0Gb1maG7kUfQJh8FHcXZ6BtppZh
 83daHFyG0wNCU8RFtkSfvATm/nk7C6IbC4dUJOLFiReKrHZt5fLrYKNmZg4mxg==
Message-Id: <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on host-managed SMR (WD HC670), fs forced read-only
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com> <ca6f02ee-8b39-4e90-9006-a6f0606e26f8@wdc.com> <CAD=K2o_-NwLNpvNE+OreAmsvX+izzZnb2R1nCBV0gDf6fH=kmw@mail.gmail.com> <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com> <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com> <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com> <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com> <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com> <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com> <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com> <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com> <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com> <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com> <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com> <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
In-Reply-To: <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Fri, 6 Nov 2026 10:23:49 +0800
X-Lms-Return-Path: <lba+26aed3a3a+6f1b2c+vger.kernel.org+zhudongjiang@fygo.io>
Content-Transfer-Encoding: 7bit
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Received: from [192.168.8.64] ([183.34.160.174]) by smtp.larksuite.com with ESMTPS; Fri, 06 Nov 2026 02:23:53 +0000
To: "Jochen Philipp" <a2jphilipp@gmail.com>, 
	"Johannes Thumshirn" <johannes.thumshirn@wdc.com>
Cc: <linux-btrfs@vger.kernel.org>, "Naohiro Aota" <Naohiro.Aota@wdc.com>
User-Agent: Mozilla Thunderbird

Hi Jochen,

Maybe this patch series could help:
https://lore.kernel.org/linux-btrfs/cover.1787887776.git.zhudongjiang@fygo.io/

Would you be willing to give it a try?

Thanks,
Dongjiang
