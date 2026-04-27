Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EA436167F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777321940; cv=none; b=pI4n14qNzh0BygJ6l81TyjO4BM9K/zC/1nOd9TCPf5H1qK6s1pgYGVUjpRUoHZHAhzzZG+Nv0BO2fXWxzafdb0Nh+1AC0J8ACB6/8hIIDEY2dQCJjnyWBLuSYLaWsxHzmm1+mQLxNlfLi0n6cwY/XMPGI4q745NQ317sqRypNDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777321940; c=relaxed/simple;
	bh=fE2C0ACOdn4QYkMZ+VIu+HL1E0jyN/5xZgeCVAOA2BU=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcADI++WDJu3MU2lcKufHNKL1nawyhVnAXsMyLKjZMWkkkV+P8jmfw0brjjASczYA++Mzru9YT0CB5TWKt6zcH9MwyOarcayO+qci4LA9i/zQ/fPaoauMI/BUAIvicwPhg2K9KFUc9Eg4qLX8SNd8as4Hsf2x58EyXD67G1p/ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=MmaeB6I5; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="MmaeB6I5"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g4Fbx3Ymcz9tk6
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 22:32:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777321933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fE2C0ACOdn4QYkMZ+VIu+HL1E0jyN/5xZgeCVAOA2BU=;
	b=MmaeB6I5CQgtTcvacs7bjuUED1wAA5+6FtUhbwT8ih2ztVfRLJO5ab4DuRyeSH7pp880xN
	/rMD8HIUbOpbNhXjca243emQmZlJIDyZ0a+6xlsVyPgwfNj1wd7Lrh9Xh/wumjsBhQxnP1
	xxQtrFa9E6ho+6RWT7blc5pGMh7+i6XEikoHRITcQ98mhiQDFnAaG4b+gDyouRN3CPLy4W
	cZAwQ8ZU0gnWdOz48RHw1wtxt8OESGUr+o4txgEXl/A+q/RgTxULhRGQ7al+pRz704zqbK
	LP6/axiNSRA2TQ0f0dmFHg8kmUFj0qQm0uM1IZEa9OrZHQN5kCw2YuQADrKfig==
Date: Mon, 27 Apr 2026 16:32:06 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs@vger.kernel.org
Message-Id: <ID66ET.91J1PP272KJY1@mailbox.org>
In-Reply-To: <b53641af-f231-45b9-9d4f-21e1ee8132c7@gmx.com>
References: <SYK4ET.WNV9390MEC881@mailbox.org>
	<b53641af-f231-45b9-9d4f-21e1ee8132c7@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-x6wBgCb1QqRadaEG/tFB"
X-MBO-RS-META: 5my4gtah3ssj7ftu4jifxd6inr5ymocm
X-MBO-RS-ID: 70e0ec184f5b8ff3103

--=-x6wBgCb1QqRadaEG/tFB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

I have the run the check command, which reported a variety of errors.=20
The output is attached.

Are any recommendations available to attempt restoring the volume?

Thanks.

On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo=20
<quwenruo.btrfs@gmx.com> wrote:
>=20
>=20
> =E5=9C=A8 2026/4/27 09:22, brainchild@mailbox.org =E5=86=99=E9=81=93:
>> Hello.
>>=20
>> I am struggling with a poorly behaved BTRFS volume.
>>=20
> [...]
>> ---
>>=20
>> No errors are reported in the kernel log, only warnings about=20
>> skipping =7Fthe swap file during scrub.
>=20
> If you assume the fs has some corruption, none of the above is really=20
> useful.
> A full "btrfs check" is strongly recommended.
>=20
>>=20
>> Second, within the logs generated for Timeshift, a concerning=20
>> pattern =7Frecurs, as in the attached example. Further, during the=20
>> periods in which =7Fare generated logs such as the one attached, the=20
>> entire system lags =7Fconsiderably. It is clear that the volume is not=20
>> healthy.
>=20
> The lag is mostly caused by qgroup.
> You have a lot of snapshots (shown by the super large snapshot id),=20
> every time a large snapshot/subvolume is deleted, btrfs will try to=20
> disable qgroup to avoid such lag, but if whatever script/tool decides=20
> to rescan qgroup when the snapshot/subvolume deleting is still under=20
> going, the lag will be re-introduced.
>=20
>>=20
>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the=20
>> =7Fproblem emerged. I upgraded by to 7.0, finding no improvement in=20
>> the =7Foperation of the volume.
>>=20
>> Also, I tried initiating the scrub through the most recent static=20
>> build =7Fof the user-space utility (i.e. btrfs-progs), with no=20
>> improvement.
>>=20
>> I would like some suggestions for restoring the volume to health, to=20
>> =7Favoid the need to provision a new volume from scratch.
>=20
> "btrfs check" first, if no error, disable qgroup if you have frequent=20
> snapshot creation/deletion.
>=20
> Thanks,
> Qu
>=20
>>=20
>> Thank you.
>>=20
>=20


--=-x6wBgCb1QqRadaEG/tFB
Content-Type: text/plain
Content-Disposition: attachment; filename=brainchild_btrfs-check_log.txt
Content-Transfer-Encoding: base64

WzEvOF0gY2hlY2tpbmcgbG9nIHNraXBwZWQgKG5vbmUgd3JpdHRlbikKWzIvOF0gY2hlY2tpbmcg
cm9vdCBpdGVtcwpbMy84XSBjaGVja2luZyBleHRlbnRzCnN1cGVyIGJ5dGVzIHVzZWQgNzQzODky
OTgzODA4IG1pc21hdGNoZXMgYWN0dWFsIHVzZWQgNzQwNTU4ODU2MTkyCkVSUk9SOiBlcnJvcnMg
Zm91bmQgaW4gZXh0ZW50IGFsbG9jYXRpb24gdHJlZSBvciBjaHVuayBhbGxvY2F0aW9uCls0Lzhd
IGNoZWNraW5nIGZyZWUgc3BhY2UgdHJlZQpbNS84XSBjaGVja2luZyBmcyByb290cwpyb290IDY4
NTUgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNTg1NzAgaW5v
ZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNTk0ODYgaW5vZGUgMTY1
MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjAzMzMgaW5vZGUgMTY1MjM4NjMg
ZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjAzNjcgaW5vZGUgMTY1MjM4NjMgZXJyb3Jz
IDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjAzNzcgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwg
bmJ5dGVzIHdyb25nCnJvb3QgNjAzODMgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVz
IHdyb25nCnJvb3QgNjA0NzUgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25n
CnJvb3QgNjA3MTMgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3Qg
NjEzNTEgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjE0MjEg
aW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjE0MjMgaW5vZGUg
MTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjE0MjUgaW5vZGUgMTY1MjM4
NjMgZXJyb3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjE0MjcgaW5vZGUgMTY1MjM4NjMgZXJy
b3JzIDQwMCwgbmJ5dGVzIHdyb25nCnJvb3QgNjE0MjkgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQw
MCwgbmJ5dGVzIHdyb25nCnJvb3QgNjE0MzEgaW5vZGUgMTY1MjM4NjMgZXJyb3JzIDQwMCwgbmJ5
dGVzIHdyb25nCkVSUk9SOiBlcnJvcnMgZm91bmQgaW4gZnMgcm9vdHMKT3BlbmluZyBmaWxlc3lz
dGVtIHRvIGNoZWNrLi4uCkNoZWNraW5nIGZpbGVzeXN0ZW0gb24gL2Rldi9udm1lMG4xcDUKVVVJ
RDogYmJhYzg2ZTUtZWFiYS00NWJmLWJiYWEtYzI0OTRlMTE4MzFhCmZvdW5kIDc0MDU1ODY0NzI5
NiBieXRlcyB1c2VkLCBlcnJvcihzKSBmb3VuZAp0b3RhbCBjc3VtIGJ5dGVzOiA0NzM1OTYyMzYK
dG90YWwgdHJlZSBieXRlczogNjgzNDg0Nzc0NAp0b3RhbCBmcyB0cmVlIGJ5dGVzOiA1NjYwMzI3
OTM2CnRvdGFsIGV4dGVudCB0cmVlIGJ5dGVzOiA1Mjk4MjU3OTIKYnRyZWUgc3BhY2Ugd2FzdGUg
Ynl0ZXM6IDE1MTQ2ODU5MjAKZmlsZSBkYXRhIGJsb2NrcyBhbGxvY2F0ZWQ6IDExMDI3Mzc4OTI1
NTY4CiByZWZlcmVuY2VkIDg4NjcwNDAzNzg4OAo=

--=-x6wBgCb1QqRadaEG/tFB--

