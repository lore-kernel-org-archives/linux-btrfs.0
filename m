Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBCC3EE1C3
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150361; cv=none; b=NpByizZX+JCO0ZsXmuODlFh+idf1B4n7EZ8pedXoF0mZhBdTcWkwa1VOYKlTERGB+8yw3uUwutAmuhXi+W6TwpTkNKQEJBVTmFDTI1wbLXn309ob/JyTbXAC1Q/58tIdK6nCqTR+NFw5zmtJasXVx9U73U8v/LK3LTlensbNMFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150361; c=relaxed/simple;
	bh=fj+U3WC+zFRN+Sde1Qtg4GYQ56U5+wmIMzfVSYXwZhw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Vi9hcV4gndQTPQf0LItE4XHEX22WRqak0GiRvaW1BvOxLO7aq9orD8HF/zIGhbaNd1A+IkzgdSdf+mCyxc6Jpbz7fQouQYSZk47imgizTrg0vlyTBaicKsS0evg8XWDd4M/e1k6Fgv3BJs6PlXMZDnd1ZtW80XPMXsmfcnvEdJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C4i822ZQ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C4i822ZQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Xsc44h+8f1WAn4yfJYFomsaZ7/wEDqlItgg5sr8JICk=; b=C4i822ZQXMgAw83F4GNeao//1e
	ECTHckbcn6B9XYoK1y/atX35LzuJZLO76JhmWyYYHEvl6xZLMq5yZz3mcnHVDKjipDfllEEAYx2YO
	Ijj0QY2TAifYCBTVE5jqp5dfU6QZk74awK438pfdSeYN8nv0+7y8g77c1WEj3U9dADvZviVzs6LuT
	4SY5QFbRhxsbw7yGWcVSQCsiDAuxi9oSG7EV6F/qpmN+rtGVAkAM4dJ2IrRoDysHubF3s7arpdWiE
	wQTPJy97TGaz6jl1kOqhtDeE1D/tTGPcN1K+1Q1djOcrOsqQK8au36LmajQOnBNl7yt2DlxK0EKYk
	NL+5xZ0A==;
Received: from [2a00:23ee:2960:424c:db4f:1faa:e62e:37c5] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x55jg-00000003sqK-2r12;
	Fri, 11 Sep 2026 18:12:28 +0000
Date: Fri, 11 Sep 2026 19:12:29 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Thiago Macieira <thiago.macieira@intel.com>,
 Dave Hansen <dave.hansen@intel.com>, Anand Suveer Jain <asj@kernel.org>
CC: sashal@kernel.org, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
User-Agent: K-9 Mail for Android
In-Reply-To: <qH1wH2-sQO2cdJ17lf_wvw@intel.com>
References: <cover.1772095546.git.asj@kernel.org> <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com> <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org> <qH1wH2-sQO2cdJ17lf_wvw@intel.com>
Message-ID: <68DEEB96-40BA-45B1-8C9F-BD45E19F72F8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 11 September 2026 17:07:29 BST, Thiago Macieira <thiago=2Emacieira@intel=
=2Ecom> wrote:
>On Friday, 11 September 2026 07:51:16 Pacific Daylight Time Anand Suveer =
Jain=20
>wrote:
>> I wish I had more clarity on how OpenConnect uses the FSID before I
>> comment=2E Do you know? Can you shed some light on this?
>
>It's openconnect's option --key-password-from-fsid=2E It uses the FSID en=
coded=20
>in hex format as the key's passphrase=2E
>
>To reproduce, take any key without a password and do:
>  openssl rsa -in unencrypted-key=2Epem -out encrypted-key=2Epem
>And paste your FSID as the password=2E
>
>This is not real security, we all agree=2E David W can probably remember =
better=20
>why this option exists, but I would suspect it was an IT mandate that a) =
the=20
>key not be left unencrypted on disk and b) be specific to a given machine=
,=20
>avoiding reuse by being copied to another=2E Ideally, we'd use TPM these =
days,=20
>but there are still a lot of systems without it where Linux runs, and=20
>especially a lot of legacy set ups=2E
>
>But very simply, it's the fact that the FSID has been used as a stable=20
>identifier and no longer is if the device in question is not itself stabl=
e=2E=20

Right=2E This was never "security" per se=2E=20

In the early days of OpenConnect we were required by Intel IT to match the=
 level of security of the Windows key store=2E Which basically meant that i=
t would not prevent an *attacker* but would prevent a genuine user who hasn=
't read (or chooses not to obey) the security policy and wants to copy cert=
ificates from one machine to another=2E=2E=2E for at least five minutes (do=
wnloading Jailbreak, in the Windows case, and re-encrying the key, in the L=
inux case)=2E

It's not high security but it *does* mean that a key file can't *trivially=
* be copied from machine to machine=2E Or recovered in useable form from a =
backup=2E

Encrypting it with the FSID of the file system it's stored on did a reason=
able job of what it was intended to achieve=2E And the FSID is supposed to =
be *stable* and not break on a kernel upgrade=2E (Isn't it part of the NHS =
FH too, or is that derived entirely differently?)

Of course, you *should* have moved on to using a TPM by now; I don't buy t=
he excuse that it isn't available=2E But still, the kernel shouldn't break =
userspace *even* if you deserve it for still using this hack in 2026=2E


