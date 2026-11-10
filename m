Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794333109;
	b=XyBEwHy+pK5CVQvGshxh0Bck5P+oPIHYi0a84g+8delUQVadnBIwSphtyaqMRKwK/rf9
	 YOGgHrfI/xQ/k37JKGGBlQ+o6wXmY1dg1o9bHSVjadTNjXvUlDczD93YqCSmo9a3wguI+
	 OWwPPxbCUfDv8yYgoG2OT16SxQNgSisbRvI20nAzA0jb6t4JJrRn10zIMrjsMjIIet1n8
	 h6JlmSxblMjWPKBw91n7C3BjItkmfZqFNTDpWBG8Ti4hrvE39SrASOgKVRips31jb/I2N
	 4pJfkQrMo6n6Pf4rgNrVx4YvdK5Ufy+NnY73FO5mrdcJMx2+G49uI714s4pzHqA+89A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333109;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=rUgl3YJBpJAx+6H58F1cAJCSkIW5spFZJGxP0tuRVNQ=;
	b=X8SvYgBLr+dpygnGgo8uWk7hUp9iqz5hGOlG4uAI5CNb6QVCOElTdUgf3MkGmrrENzsP
	 IHMJR/G68cZwv4b7a7/hd3RZsyo6bIr5D8+XlMM45+l2As+/rLrigNYzB37LSMamINSPa
	 S9DiBwllHlJzqAZZQFpgWeV7gb2buEaXr/slcubSDmUaoowZyCuSuGkCmIKlH/oat3Mov
	 cYDONqYbeXVKoVE4qIx7KGh6/gK2PDleDvwrgprp9juYB4nX5rJucvZQ9r0PkEuub6Udt
	 bIUiY5qu203LdyJkeYrbdhBfjRLOo4ytwJ4nDP9rFCCe9jr0CyJbLpad2gYjFPRjGRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=sim7gu6vf5dpdajihjvtv52vba.protonmail2 header.b=De1prwLW;
	arc=none smtp.remote-ip=79.135.106.119
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CE5606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 17:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47CE5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=sim7gu6vf5dpdajihjvtv52vba.protonmail2 header.b=De1prwLW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=sim7gu6vf5dpdajihjvtv52vba.protonmail2; t=1794333104;
	x=1794592304; bh=rUgl3YJBpJAx+6H58F1cAJCSkIW5spFZJGxP0tuRVNQ=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=De1prwLW6VQHU3Jnvt4Jy0Ui6e+FEfbhq0LXmFXccPtSCYFW7Qz/oeJ7sPLQvkDek
	 6uuWC9QhDAmpWoHMKKgGergZsU5pdJec9g77uFbERUP3fJ0C2h61KfmbTYpzjsSEe/
	 AV0/Y5lNtdnkEL1BbzWwce7K8BATanWxzBxeRfqovFguD04ZGsjeWXy6P97Tr2iGtk
	 6cZCN4mUSGicQq5Q6wWZ8i5l1fBta+bpQWavFIjUb4RW/k7pk+sv5X2t/iUMjDTjbo
	 aztSWJ5lhL0OA2CbyWZywPDk6vbNNB2KZDSLSb7tqs5OqeMgiy5rv4EyJtWWAdRqtz
	 TmTUyUZoqMQxw==
Date: Tue, 10 Nov 2026 17:51:40 +0000
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Subject: Static review: QGROUP item validation and read-only subvolume behavior questions
Message-ID: <B_lvw-WNI1mnHnK011Sfk_ZNaL0eg5uOfD2T3q-vOfWv8426VwPA4NPpWaAcHxRZf3OrzGzwZjckHqKEKUS7UQJk6TEN_7xD1SkwM5q8hsw=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: 1764981d5a0e8e46a9defdd36d9b318898b65a39
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello btrfs developers,

These findings were identified by GLM 5.3 during AI-assisted static review.=
 No dynamic reproduction was performed.

I am sending two hardening/behavior questions from a review of fs/btrfs at =
commit b3dfbde62cf1981c4638939c159dfd087b7a72e9. The source anchors below r=
efer to that reviewed snapshot, not a claim that current main or released k=
ernels have been independently reproduced as affected.

1. QGROUP item-size validation

In tree-checker.c:2400-2470, check_leaf_item() has validation cases for sev=
eral fixed-layout item types, but the review found no cases for BTRFS_QGROU=
P_STATUS_KEY, BTRFS_QGROUP_INFO_KEY or BTRFS_QGROUP_LIMIT_KEY. The correspo=
nding reads in btrfs_read_qgroup_config() use fixed offsets at qgroup.c:463=
-485, 531-541 and 543-554 without an item-size check. The assertion at qgro=
up.c:411-413 depends on CONFIG_BTRFS_ASSERT.

The hypothesis is that a short QGROUP item could pass generic leaf checks a=
nd cause accounting values to be read from adjacent item bytes. Accessor bo=
unds checks at accessors.c:63-66 appear to contain reads within the extent =
buffer; this report does not establish a kernel out-of-bounds read or a sec=
urity impact beyond the mounted image's accounting state.

Would exact-size validation for these items in check_leaf_item(), following=
 the existing fixed-layout validators, be appropriate? A useful regression =
property would be rejection of undersized QGROUP items during leaf validati=
on.

2. Existing writable descriptors after a subvolume becomes read-only

The review suggests that an O_RDWR descriptor opened before SUBVOL_SETFLAGS=
 marks a subvolume read-only may retain write access through some mutation =
paths. btrfs_do_write_iter() at file.c:1403-1443 checks shutdown and filesy=
stem-error state, while the reviewed btrfs_write_check() at file.c:1027-107=
2 did not show a read-only-root check. The read-only check in reflink.c:857=
-864 appears confined to the clone branch. SUBVOL_SETFLAGS at ioctl.c:1327-=
1413 did not appear to invalidate existing descriptors.

The proposed scope is buffered/direct writes and potentially encoded writes=
 through pre-existing descriptors. The review also raised dedupe, but did n=
ot inspect the full VFS dedupe path; dedupe should not be described as chan=
ging logical file contents without that analysis. mmap has a separate appar=
ent guard through file_update_time() and btrfs_update_time(), so it is not =
included in this hypothesis.

Is open-time enforcement the intended contract for read-only subvolumes, or=
 would mutation-time checks be useful? This is an unvalidated behavior ques=
tion, not a claim that the flag is a security boundary or a request for a C=
VE.

Best regards,
Noah Weinberger

