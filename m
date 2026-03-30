Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD0D36EAA7
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 21:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905475; cv=none; b=N9n3E1Ujim1J+tylfI1Yby21PqW1cfRLlTCg5ySVa1iSi/H2tLo97Pj3vQyUf1Ipftt8LbKppcBhhRaklUnYbYtrCQFiq2l//SKQD5dXtPzHKM6NpSfBZY6JZgBJQ/WFOypviXmYEW6GLoC5WvYL8wJCgoAs+axElzxPvc7B3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905475; c=relaxed/simple;
	bh=WwWooCoexibAG0fWo17ibT4hS8cO+WWH9RDin6qPDYc=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=tXM9eu8rNZ8+nsEtPr4a8de8DBV9VI9+yZM95S/iXgl+gWLkgn7mROGLyTQ5vgAY5dNWMjS36I72aMgX1ioEk9nIBwIhhqmj/gaeXC0EN18oKALUPHYlJrFR/6hfl4Kexakgc+EZ+L2COffA/pwVETTp1/2IAGR0nkOQXL5AXDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lmu.de; spf=pass smtp.mailfrom=lmu.de; dkim=pass (2048-bit key) header.d=lmu.de header.i=@lmu.de header.b=ORD1bJnA; arc=none smtp.client-ip=129.187.255.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lmu.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lmu.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lmu.de header.i=@lmu.de header.b="ORD1bJnA"
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4fl3nC00qHzyTL
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 23:10:38 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=lmu.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmu.de; h=
	mime-version:user-agent:content-transfer-encoding:content-type
	:content-type:organization:date:date:from:from:subject:subject
	:message-id:received:received; s=lm-postout21; t=1774905038; bh=
	WwWooCoexibAG0fWo17ibT4hS8cO+WWH9RDin6qPDYc=; b=ORD1bJnABqbbU+HN
	MsFmC6KNRJNC1roCHIoEIR9NA8Otz3mBf7GGgXRYB+J8mtlBo7I1FJYhntE4bbg7
	X4lKLIoaEAyRmcEri7gifq2Gp/0XfA57B6iGQEXBYiBfL0WdT17SPFsIxBnrwYYX
	XuG7A7PW8SPVH+zKhiljw1qT5pZB/yFiGHK8GGmtDvzUP0Hmmo5gfaBy4gOlQV53
	ryEA5WhCOSbkTPSmIwJDhMjIcZjjOtzKdTtFrRBYbLf+CKsNZ432O8l9Ngs2jdqQ
	ffLQTEIM9eJlYS1xEY+bClbCTZKQwkSuhull+Pw+9AesxYewx0+lgPH5QP07uuyj
	dJZ5Xg==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.872
X-Spam-Level:
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id NbomYI4WaP-4 for <linux-btrfs@vger.kernel.org>;
 Mon, 30 Mar 2026 23:10:38 +0200 (CEST)
Received: from [IPv6:2003:cd:df16:9b00:a661:c61e:e1ae:f175] (p200300cddf169b00a661c61ee1aef175.dip0.t-ipconnect.de [IPv6:2003:cd:df16:9b00:a661:c61e:e1ae:f175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4fl3n83jRwzyTZ
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 23:10:36 +0200 (CEST)
Message-ID: <4c1c079ff186368b087d01be870774be4e2bba5b.camel@lmu.de>
Subject: Space key logical 1048576 length 4194304 has no corresponding block
 group
From: Christoph Anton Mitterer <mitterer@lmu.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 30 Mar 2026 23:10:36 +0200
Organization: =?ISO-8859-1?Q?Ludwig-Maximilians-Unive?=
 =?ISO-8859-1?Q?rsit=E4t?= =?ISO-8859-1?Q?_M=FCnchen?=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hey.


This is on 6.19.10 with progs 6.19.1:
# btrfs check /dev/mapper/data-a-1 ; echo $? ; beep
Opening filesystem to check...
Checking filesystem on /dev/mapper/data-a-1
UUID: ff14e046-d72c-4671-b30a-6ec17c58a0f1
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
[4/8] checking free space tree
Space key logical 1048576 length 4194304 has no corresponding block group
Space key logical 5242880 length 8388608 has no corresponding block group
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
found 15744973131776 bytes used, error(s) found
total csum bytes: 15347594276
total tree bytes: 29036593152
total fs tree bytes: 11069259776
total extent tree bytes: 811499520
btree space waste bytes: 3687899842
file data blocks allocated: 22699997167616
 referenced 18205200039936
1


May have been there earlier (Debian was until yesterday or so on progs
6.18).

Is this something to worry about (the fs is very precious for me,
though I do have backups)?

The fs never crashed so I wonder how these free space tree corruptions
come to happen, any rare bug perhaps?


Should I re-generate the free space tree (which currently is however
not really possible though, due to [0]). So not sure whether I still
can/should use that fs until a fix for that is available?


Thanks,
Chris.


[0] https://lore.kernel.org/linux-btrfs/89188b7b8b5a1f9bb64af37777aec906134=
ad75c.camel@scientia.org/
