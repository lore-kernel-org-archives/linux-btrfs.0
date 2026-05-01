Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D900E38758F
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 10:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631123; cv=none; b=c9VKmwyVUcYDvFrTSioq3uHXvdyTAL5/XQj3NkHenKB/4z18ePZWU5TyaTzrp8g6EebXCzOSAApKB/oHRexuAltL/KGdUHV5is1ce8APmzMLnMjK5FkbcKjAnRS17FAultHCJiPcvBQD9keZjyh+zwm+Yl0ag5JybYASeFTf+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631123; c=relaxed/simple;
	bh=tIAT1dRXVuVYcnrraE5XW/JAeG2/b/WFEb61V8+RRu0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RL7rXoGpdkmpY9qkx2QHFo5q5BudKstPkdPfbICIQ75AlOlwT+7Dun8a27JauP2fsc6UONW3T3m5N1yPwY5Nr+0cIA2+KFNZENXOzkq99Jj/9CL/4/acPOYoJB9mWwyQrjZFjyiibTnhR0Diqj7PhT0XMJHHknUtjgzZQBdoTns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca; spf=pass smtp.mailfrom=maxchernoff.ca; dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b=7m2l54/r; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b="7m2l54/r"
Message-ID: <ff07ef238645e8fe6404308e83373d004af1dde0.camel@maxchernoff.ca>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxchernoff.ca;
	s=key1; t=1777631119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCvyDnuUSRVjdyPGbpmgNLlBneTb9EHqp19fK8KPQ5E=;
	b=7m2l54/rkqu8BRijSb5iCIDYowYqIdTTD69zyZ1sH7N9MTff1TOa9D+W65FsIv3sg3ySTm
	JwwSzosMZtm8rvzbn+eGaYbsm3sB6zsjMpeVCr2D0gx6xrNK2HY1TfniUIMqq9vM0oYQN+
	xKhq4f8H3yh03uo6fo18YzM0TzvvE7E1qSHb6Q3ee0mp5IKOYb2mdyu5Y6LVho0Ey6HBnb
	6FhCdsXoIlQtd3uVVj/Ql6lirUhL3ye5lZheJIcGJRNSLVzdBfuNieIJgNlpdh0UkYEy9Q
	LJPBKUaUJ3NCxz5UAnxf36fDRuvcRHBZRgA7+Xnd0KQVDcsbbExPv+8npVlYQw==
Subject: Re: Enabling qgroups causes 2+ minute hangs
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Max Chernoff <git@maxchernoff.ca>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs
	 <linux-btrfs@vger.kernel.org>
Date: Fri, 01 May 2026 04:25:04 -0600
In-Reply-To: <d248a319-d2ff-4520-8ad5-8967e8cce43d@gmx.com>
References: <22a4a11e1933a7b07cee7d6896098a5b251cb755.camel@maxchernoff.ca>
	 <d248a319-d2ff-4520-8ad5-8967e8cce43d@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT

Hi Qu,

On Fri, 2026-05-01 at 19:36 +0930, Qu Wenruo wrote:
> =E5=9C=A8 2026/5/1 19:10, Max Chernoff =E5=86=99=E9=81=93:
> > Yesterday, I accidentally enabled qgroups on my root filesystem, and I
> > started experiencing severe system hangs. When I disabled the quotas
> > again, the problem went away completely.
> >
> > I'm currently using "btrfs-progs v6.19.1" with "Linux
> > 6.19.14-200.fc43.x86_64" on Fedora 43 x86_64. I have "/boot/" and "/" i=
n
> > the same btrfs filesystem, which is on 2 NVMe disks with RAID0 data and
> > RAID1 metadata. I have a swap partition on both disks, and I'm not usin=
g
> > a swap file. When I booted into the "initrd" for my rescue kernel
> > ("6.15.8-200.fc42.x86_64"), I saw the exact same issue. My filesystem
> > has 309 snapshots and 17 subvolumes;
>
> This is the problem, btrfs qgroup performance is directly bounded to the
> number of shared extents.
>
> If you have over 50 snapshots, it's going to be ugly, if you have 300,
> it's going to be hell.
>
> And it has no good way to resolve, the qgroup rescan (triggered by the
> enabling) normally should not block normal operations, but for such
> heavily snapshotted systems, even doing qgroup accounting for a single
> extent can take a very long time.
> As such backref walk will need to iterate through all the subvolumes
> that own that extent, in your case it can be 309 subvolumes.
>
> This long time of accounting just one extent will block the transaction
> for a long time.
>
> There are a lot of optimizations merged, but nothing can resolve the
> root problem.

That makes a lot of sense to me, thanks.

> >      WARNING: qgroups enabled on a filesystem with lots of snapshots, e=
xpect poor performance
>
>  From btrfs-quota(8):
>
>       When quotas are activated, they affect all extent processing, which
>       takes a performance  hit.  Activation  of qgroups is not
>       recommended unless the user intends to actually use them.
>
> >
> > to dmesg to make it easier to debug?
>
> Normally it's not that a huge problem as the normal amount of snapshots
> are only around one or two dozens.
>
> Furthermore, if you only have subvolumes but no snapshot, and no shared
> extent (aka, no dedup), then the qgroup performance impact should be
> very tiny.
>
> But unfortunately that's not the case for you.
>
> Even with that dmesg warning, if your system is already hanging, I'm not
> sure if the end user will even be able to see that message.

The system does eventually recover after 10 minutes or so, so I would
see the warning _eventually_. But yeah, for the message to be useful, it
requires the combination of lots of snapshots + qgroups enabled
unknowingly + a user who reads dmesg---all of these apply to me, but
probably not to very many other people :).

> I can try to add a check inside "btrfs qgroup enable" command, which
> will checks how many snapshots, if that's beyond 10, give a warning with
> timeout before enabling traditional qgroups.

That won't help me in this specific case, since another program enabled
it via an ioctl:

    https://github.com/systemd/systemd/issues/41903

    https://github.com/systemd/systemd/blob/v260.1/src/shared/btrfs-util.c#=
L584-L609

Thanks,
-- Max
