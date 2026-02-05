Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90543149C6F
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Feb 2026 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255892; cv=pass; b=CN07abqkhuYMm/2CImSPkaFqB5tgtQMdKnB/uKNZIAqelHlCmXso2PKv7IA1Fvfu2FC76wFnsme+RXYX/21B8bDiHlD4+DRpBTohAi67gKUBZjh6zuJMKpfT0bx9L99T6aJvPu8XXH5tr7Fv2EbF0fZcg4yLrMS3TDHOoHGx5wA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255892; c=relaxed/simple;
	bh=MZ577Rqir9zL4zQGiKoO8E4HEOqmfKPihTxD5gYnXvQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mROLzOwDoyPRQw2/HIQrLmwKiSyxkV29QlZrKv9mqt38HP/GeO/xhp/LOHS0GhJjob8CADB6gco4JAhfcJ+zD2BGly6FJe6yswFQh75i87flItfswDi/YvVNp7YlI//J2s5geR6iHNgvPLwZgLPKtSU52JLk8ILA3K6nQXebBZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.212.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E74C87617F5;
	Thu, 05 Feb 2026 01:44:45 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-123-63-99.trex-nlb.outbound.svc.cluster.local [100.123.63.99])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 111F376178E;
	Thu, 05 Feb 2026 01:44:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770255885;
	b=xAODWldqDFr03D5K0NU7fBadTKw7SiD532YkMmFA7KM2UwPldutkP6xcHo0EcUGMXV5ysa
	9ZX9ZN/NS/BRpsR7+gQ1fNo3nbXb4S7MVnztosWQZQeLJbnpfVqBwZ5Z9jmm8rn+4gGI2Z
	C5dD9wkFQen1n+XLBCyU08q0nToa3XZij0ACNun9n3CpJS3D5vtYgNFfSapjcTX7pbxN5r
	6k2GcDOBBPwHRlF57e1lDnmqENwLSzTxokqGIP+aePsObxVLOo0EADmpz7jK/p1OCSwrCS
	4T9WicnA8hFzxT4lCJjYc82Dz+QXeZ/GJNm+L3rIWW+rDd4ofKQp3e1aB62q6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770255885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZ577Rqir9zL4zQGiKoO8E4HEOqmfKPihTxD5gYnXvQ=;
	b=00mNFRvh6eRb1GBtg37EZl/lhkqV0IEoDE+czUdUhBfSHPH4uEzjs3BfpX7KSDtc8pBDnN
	GoBFNWaqzkZ+N6oDDxMJp1VssoMoLvSqJ2Ulvr6kFIauIwRcIxROtBS7EkjFYz5HgviPbM
	ENbRxizRrToe7xeyrYPSJPmtc3suH8tb/GQZeU2eFthFK9fABYJnTHhJ7RZuGNxIgHpBDb
	UouONkaou404Se1H2tQ2SQQtK8/4oTYkDVZzJ0Hw3B6tVdItRmFeOe4cSoRoDvsB24I2kr
	bDkbskBuO+4/AKh/2FhfA5M5MGQBsMgRTy38dMM4syDIRY4PFi4LhZfcMr7ERA==
ARC-Authentication-Results: i=1;
	rspamd-5b979ccf89-qqlv6;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Duck-Lyrical: 4da368d34760bcd5_1770255885772_3817145836
X-MC-Loop-Signature: 1770255885772:1506577193
X-MC-Ingress-Time: 1770255885772
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.63.99 (trex/7.1.3);
	Thu, 05 Feb 2026 01:44:45 +0000
Received: from [212.104.214.84] (port=48212 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <calestyo@scientia.org>)
	id 1vnoQG-0000000Ahpp-2dI1;
	Thu, 05 Feb 2026 01:44:43 +0000
Message-ID: <84b22b2cc7534be60eb423973336101c9e9b9ad3.camel@scientia.org>
Subject: Re: We have a space info key for a block group that doesn't exist
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Thu, 05 Feb 2026 02:44:42 +0100
In-Reply-To: <fc2f1d31-7f2c-493f-be42-2cb8c1fd5a17@gmx.com>
References: <f3574976d7b5bc8f05e42055d85d4b61263bc5c5.camel@scientia.org>
	 <c07b6fde-03a3-4c97-9f59-866c81e78b85@suse.com>
	 <31615495f428dbe499ae5f5a109cc6c74c8979ca.camel@scientia.org>
	 <fc2f1d31-7f2c-493f-be42-2cb8c1fd5a17@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-8 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey Qu.

Took me a while... but I=E2=80=99ve tried that now (kernel 6.18.8), but eve=
n
after clearing the v2 space cache, btrfs check still finds the space
info key for a block group that doesn't exist:

# mount /data/a/1/ -o space_cache=3Dv2,clear_cache
# umount /data/a/1=20
# btrfs check /dev/mapper/data-a-1 ; echo $? ; beep
Opening filesystem to check...
Checking filesystem on /dev/mapper/data-a-1
UUID: ff14e046-d72c-4671-b30a-6ec17c58a0f1
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
[4/8] checking free space tree
We have a space info key for a block group that doesn't exist
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
found 15359868010496 bytes used, error(s) found
total csum bytes: 14972501936
total tree bytes: 28026028032
total fs tree bytes: 10490626048
total extent tree bytes: 773816320
btree space waste bytes: 3556556510
file data blocks allocated: 21845206437888
 referenced 17683364839424
1

Still nothing to worry about? (in terms of possible corruptions? right
now I=E2=80=99d still have backups of all data... but probably not forever)


Thanks,
Chris.
