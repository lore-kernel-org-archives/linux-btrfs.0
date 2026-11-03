Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725714;
	b=MEttNPoa+igL25nfUvcI2FWs8rWwGi1wz/2NfEo0TI+WoHknejAnBQwvGX4K2w/1HLL0
	 d6bS02DPssmBIfGqXiRWqfh7CLUyG7Fb75ii2SUglX1n7WRkU8cpPI+NWfzW5A0rLHoI9
	 LB2X9qqVpLHQJgkWADAiU7aIL2SYyb15vAOzLvsTputQuZr1KQw/T06UDLc6v+NCwMTx2
	 JaONBNo81TgOCn4YciqRwNzoKJ1s//kJN9DJ396xduGXCU5iRbgKyLIMmebFq+ubZeIn3
	 tsbiVvePEe5gqvQ9NoI0QcPD45Lfn0BxgraH1K9KGKl9I+VbV0SJSlMiZOuB2ZxXZ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725714;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Message-Id:Subject:Content-Type:
	 Content-Transfer-Encoding;
	bh=VidHxMavyyRVsx321h0xNxj0xyUJo8V4arzlZXveJF4=;
	b=CPhQjxE/qHG17M6dIzGFruT1E+gKJ58ibRJgPUwXQU1q1pfPAPQ8rzAyTPuBT1Dr0xft
	 kId4LZPGHZG7384xhbDxThAqtJ9+fePQL4+2/fuIePnGscfCU8C+BtVyiDTOggtINuHeK
	 dn9oWt0KIhuI6WgihmmgAyQeVIsVWKl3E/J4NS5yubc7hLZG/DOcqN2QCeHhtJJSCJo25
	 8dAHNGP10mXIYUwm5W/tPj30kB31DNTjIMWOEZhBZfo/F4jHJcdqtGwJy9WQDvlvcOfD0
	 GfykmtxR33WiWhPhzUZDjDxc1cNWo0MOSqga2Odh1YVSLhS0EGi3aWI4+xsF4aPd6Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=colorremedies.com;
	spf=pass smtp.mailfrom=colorremedies.com;
	dkim=pass header.d=colorremedies.com header.i=@colorremedies.com header.a=rsa-sha256 header.s=fm3 header.b=coxNWYzI;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=iXjpc2ha;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898EB606A327
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 17:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 898EB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=colorremedies.com header.i=@colorremedies.com header.a=rsa-sha256 header.s=fm3 header.b=coxNWYzI;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=iXjpc2ha
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DCD907A0155
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 12:08:32 -0500 (EST)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Tue, 03 Nov 2026 12:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to; s=fm3; t=
	1793725712; x=1793812112; bh=VidHxMavyyRVsx321h0xNxj0xyUJo8V4arz
	lZXveJF4=; b=coxNWYzIYlRwznl5qaDketAvKKLp0okLFbplhVNezt8h3z8PMD9
	e0GAKG5AcrdLdXGL2MYN8Xd58iXYgRIBb+ai2TdrWij0i5fEYAxeUwT3/8HINu+U
	Z+5D/NZ/n4Ib3cEeNlPTQQdiucstVEDvh9AQgvfnTezG7iVFoPrliFP1anM2mNvw
	nLsLXri6PbDHeJ3OxtC1klDh5hruMEmDYQGbyRTNTpEbZqORjodYsezi5V7smCuH
	v7a7lgkwDaC9lTwaPzjR7HNjpppyoUrLlpxROVh5pxxfaCp5/D4EAotoxgevOeQG
	v+ozgrx0/Npm9X3YEz+nJ8tnO2FhsB8txfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793725712; x=1793812112; bh=VidHxMavyyRVsx321h0xNxj0xyUJo8V4arz
	lZXveJF4=; b=iXjpc2hasP3aQ/OTpBO7ZsYgWw+wWBkk31s3uX1j/4XY4qNWwtj
	xidM/QE6p/iDx1jUjJxbBfG2ZUx7d3DzJjgEZTLqus6vOW9ZcBa2u10MlH/vIriH
	B6HRd8m7N/UVwgroZ4ZgifpVZ6rWlq/KNgk4aF7HBpG1hLzcvmPSTOr8aQosLHEk
	YbMy1UE4DgqbIT+1A7wRyT/i8dud6cSemH+7yzMeXBz9trEPCZRfeeC9rGVzUzXA
	K+7vZ2BLxfoIUq8mckjPlC8yJLiaNaW87nIJhgkb3qsn5d5UGLflMe4aCbKjqLjB
	ZZPsDZX2RGvP/99nKCUBx10VNk/4oSYerQg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=colorremedies.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793725712; d=colorremedies.com;
	mf=PGxpc3RzQGNvbG9ycmVtZWRpZXMuY29tPg==;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:KMOO7f1hr175s8eGJm9YZ1S20rDYEu2oqkVrnarZNL0rPUf
	zzl5uBC1DJ97hUQyIdBYJKEe2pCh4Ql5EhqHjHA5duCjmrlNVDRL8kr5wA2DzKsc
	RUoej8/XATXEHRYW1Ogxtf4FE5JDq6ftdoTzfSG2JxstVbzd89BMu60ttlLKeoo3
	bx0zenw2jV2I6JRhzq+1OJspxsXfIaqOK+WFbFNGkF31gN8N+6XglLVpRukZvjyz
	aMy2zds/rznWw/pQYRuNbqfrKB1YT4Z9SxPH9FazYCnYe7Rl6URFEwwn2XQFiOMv
	nW3dCxvH2vf0ArNPuWAgbrYJkMhSUoujt96xCxw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=content-transfer-encoding,content-type,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:dtC5QA7Ra8bMWHycK8lHkQpsflP9crx1ptjwjZG4HRI=:VidHxMavyyRVsx321h0xNxj0xyUJo8V4arzlZXveJF4=;
X-ME-Sender: <xms:EBXqaubkKRc_FH3c5D-vxAi_lwAaCZWlVZbIjUbl3af0zzR-S5hTyg>
    <xme:EBXqasPtE9TYxTWHcuztAkH1Wvv3FZreElR6MPh7NbHl0a1mu9sF04kS3iVeNIRoO
    wFGWWTP9TQmgIYMzthXxdLtGj9vm2_Wi-iNlyPZXqoHxyUpPrDAjQTJ>
X-ME-Proxy-Cause: dmFkZTGS49JzJqHdxIgbG6D//SmNnAMFJqBi0iRIm180jwHrYrg0mHUAaevgOhSYRbzMwx
    JuaqcDe56/yHs6W8afxtnKL19tg/n0FEJ43Ey9KQ7uaZmFboPdA97KtA+HLuena6ePinA2
    snXx9l53s1vtumJVCZwt5pQgi2afdbxmQp6BmY705zFuhqoXNPgtzQ9Ideb3y/p0frFgPI
    BbFm3hop5ITCjo3YhR1pJ2Y8mF1VIq8abFyVgwRtXMO479UxNJlsNOkgpnMIsRbrGL8G7A
    a2I4csOyHdOe/ciWk+J8v7MebmMIhsuvYwn5KqmR2ySeIBhnYyW7gj+9n3La63aHFO+jMl
    vmOnAAT046cvBBIDZwL2e+HK9JEXINty5CP9XFZpE5QHR6rR3bmAqRi6xpAax7SUw2STqA
    5VAqJkzYaRiHP8/nfZFUPBl3WQL85D4ineO6sJ6vs9AdQRQ1JhPqfnI6WVEPr8e6EdoXzM
    QrQsKhB9qREsreuuT9OmLvlu9bqZJG9zXsVv03mQGStuKWO89GGA1CffRBnxT7Ozc5ceS2
    qj4XdTcF9cbG9bF1yOKSI2puhYdKwxvcgx6Q6/8blq5gcniIenWwxlSjtg7V2i37gwKxOA
    stvwSPPLfuRAiWc/AP3dz7B+JK3QsiYMQbRS7huskA1J3gHLl9nAhHbb75jw
X-ME-Proxy: <xmx:EBXqauozp3y87PS8V-uiIdoxcoIElNUBj_VfR9jcXHqbno7sa_N44Q>
    <xmx:EBXqasnXAnxpeu4h67ydA1Fd8Jv9vjV8cvJNtz_4qf_GlH49jXJqNw>
    <xmx:EBXqagFshTfRKRvYpeLI_dRscQheYRySRAXRZLPRwYhjsVyhJnc-WQ>
    <xmx:EBXqalrPbrM8rNG3ptKuY9p-GQ_KlJFMlosruA56VreeLnjjxANJGA>
    <xmx:EBXqao-EcTmeAnmBw_0KnutT2FH5PhcLdes8g0z2U95cG1yRG5mP4MnP>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7997C18C0069; Tue,  3 Nov 2026 12:08:32 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 03 Nov 2026 12:08:12 -0500
From: "Chris Murphy" <lists@colorremedies.com>
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
Subject: bitflip in extent tree questions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

User reports transient Btrfs corruption.

$ sudo btrfs check --readonly /dev/nvme0n1p3
Opening filesystem to check...
Checking filesystem on /dev/nvme0n1p3
UUID: 73b0efc1-1bbf-44a9-b61c-f4b8936608ae
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
data extent[3068469248, 4096] referencer count mismatch (root 257 owner 3844574 offset 382279680) wanted 0 have 1
data extent[3068469248, 4096] bytenr mimsmatch, extent item bytenr 3068469248 file item bytenr 0
data extent[3068469248, 4096] referencer count mismatch (root 257 owner 3844574 offset 382541824) wanted 1 have 0
backpointer mismatch on [3068469248 4096]
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
found 851404390400 bytes used, error(s) found
total csum bytes: 828557228
total tree bytes: 2640494592
total fs tree bytes: 1551499264
total extent tree bytes: 167936000
btree space waste bytes: 398250390
file data blocks allocated: 10191907336192
 referenced 895043592192

Clear bitflip:
382279680 = 16C92000 = 10110110010010010000000000000

382541824 = 16CD2000 = 10110110011010010000000000000

The questions:

1. In 3/8 checking extents, do the 1st and 3rd lines tell us that the metadata profile is DUP?
2. Why does the kernel not report a checksum mismatch? What does this tell us about the nature of the bitflip?
3. Is this almost certainly logic board memory induced or is it possible it's a drive cache induced? Seems the lack of a checksum error tells us the checksum was computed after the bitflip? Therefore not drive DRAM?

What else?

Thanks!

--
Chris Murphy
