Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762FB26CE05
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 01:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777339302; cv=none; b=YbvnPtRIiM8CmSxE/Drek6vKFI+sitV2SYBUZOIwrKmKZ91XqVlHyOrmrg+SUhrhJ4FbrOj5/kKakjEh9C5Y1zfk2leC1YimPntSrg5m1Bm4ievWqRQgjtSlxMonmZg8Hn2qpWn5SM8CgRq0FHfcj4H7V7fCzIMhxnPXY/0NWX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777339302; c=relaxed/simple;
	bh=C8X75XM95QHoOT96e2COmzacaO2ubumgiXM9F2++BKg=;
	h=From:To:Cc:Subject:References:In-Reply-To:Message-ID:Date:
	 Content-Type:MIME-Version; b=TGEe2GKpD3qfS3aDageQm7lUVwGx1IH8AbKVsL2cMG/ZpD5bWybXR9fkX33WCzqFGqa0WDnQo08I1BNqbqJQoHBtq1JE6cekWp+rrmRxHg+QyPAUnfcLrCcHBYjy0OfAmC1jdPoVfB+kK9KiNGxC1PrGasqB1+OeBRRB0MdQNEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=xEIHsm16; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="xEIHsm16"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g4N1k14D4z9tf7
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 03:21:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777339290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C8X75XM95QHoOT96e2COmzacaO2ubumgiXM9F2++BKg=;
	b=xEIHsm16OJA9f/b6/22n0VA5dhDcLevRKSGdWBZ/eXD5IBKqZLuhrScFuqPPdKTXGqhXoa
	97+Y1VvZkdcRgqcpgc50XiYRVKsJPNx128k8IdmdUuLBSjKX+z7Ho+foE27VP5lNdST6hB
	Qgnin44ZSsLvANW85/eiJFzBORWx2ZhaKx/SWohNWtvaEIAjY3hCRMeS9jvOttYvrB9SvK
	6vk4Vpuq+bhWgRWl4S6miF4hNs4c30Dop8VMmPyJxjjHk1LQokCG6/abgCICv9ASFjwW+0
	m+TWfWgsf4XEyRmgbb04ZzKyX/gKj3I1FEZq43nI5jKQMFXlHk1Mxi5jEv4h+A==
From: brainchild <brainchild@mailbox.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: 
Subject: Re: Strange behavior with scrub, quotas, and snapshots
References: <b86d2b52-5536-447d-9a63-be7f67effffb@suse.com>
In-Reply-To: <b86d2b52-5536-447d-9a63-be7f67effffb@suse.com>
Message-ID: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
Date: Tue, 28 Apr 2026 01:21:28 +0000
Content-Type: text/plain; charset=utf-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 63pmqia4iggtk5fgu38jwz71uzanaa4q
X-MBO-RS-ID: 4fcab5c67719ce92d7f

I have not tried scrubbing without the swap file being in use.
 
I could try, but as the file is only 32Gb, I would be very surprised if it made any difference.
 
"Qu Wenruo" wqu@suse.com – April 27, 2026 9:16 PM
> 在 2026/4/28 09:52, brainchild 写道:
> > Just as I was scanning for the name of the particular inode, the volume reverted to again insist on being without any free space.
> > 
> > I was able to extract the log for a new scrub, as requested (begun after the switch to being unable to create new files).
> 
> Only 10GiB of data is scrubbed, meanwhile your data should be 600GiB+.
> 
> You mentioned that there is a swap file, how large is that file, and 
> have you tried to disable the swap file before scrubbing?
> 
> Thanks,
> Qu
> 
> > 
> > Thanks.
> > 
> > "Qu Wenruo" wqu@suse.com – April 27, 2026 6:58 PM
> >> 在 2026/4/28 08:17, brainchild@mailbox.org 写道:
> >>> Currently, scrub operations are not completing properly, so I certainly
> >>> think it is important to try to repair the volume.
> >>> 
> >>> Which error do you expect is related to the particular problem,
> >>> concerning scrub?
> >> 
> >> Can you provide the full "btrfs scrub start -BR" output?
> >> 
> >>> 
> >>> Is there any evidence that data may have been lost,
> >> 
> >> Not yet.
> >> 
> >>> or concern that
> >>> 'fix-device-size' could cause further loss?
> >> 
> >> That should be mostly safe, but if you're concerned about it, please
> >> update to a newer version of btrfs-progs.
> >> 
> >> Ubuntu is pretty bad at backporting fixes for btrfs-progs.
> >> 
> >>> Should the operation be done
> >>> while the device is mounted, or only while not mounted?
> >> 
> >> Must be unmounted for btrfs check and btrfs rescue.
> >> 
> >> Thanks,
> >> Qu
> >> 
> >>> 
> >>> Thanks.
> >>> 
> >>> On Tue, Apr 28 2026 at 07:40:31 AM +09:30:00, Qu Wenruo <wqu@suse.com>
> >>> wrote:
> >>>>
> >>>>
> >>>> 在 2026/4/28 06:02, brainchild@mailbox.org 写道:
> >>>>> I have the run the check command, which reported a variety of errors.
> >>>>> The output is attached.
> >>>>>
> >>>>> Are any recommendations available to attempt restoring the volume?
> >>>>
> >>>> The super block bytes mismatch is a minor one, which shouldn't affect
> >>>> normal operations.
> >>>>
> >>>> But still you can use "btrfs rescue fix-device-size" to fix the problem.
> >>>>
> >>>>
> >>>> The nbytes wrong can be minor too, but it's affecting all snapshots
> >>>> containing the inode 16523863.
> >>>>
> >>>> You can either fix it by copying the inode to another location (can be
> >>>> inside the same btrfs), remove the original file, mv back the new copy.
> >>>> This will need to be done for every snapshot.
> >>>>
> >>>> Or you can try "btrfs check --repair", which will do an in-place fix,
> >>>> but will still break the shared blocks of every snapshot.
> >>>>
> >>>> Overall, I'd strongly recommend to remove all unused snapshots first
> >>>> before doing either fix.
> >>>>
> >>>>>
> >>>>> Thanks.
> >>>>>
> >>>>> On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo
> >>>>> <quwenruo.btrfs@gmx.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>> 在 2026/4/27 09:22, brainchild@mailbox.org 写道:
> >>>>>>> Hello.
> >>>>>>>
> >>>>>>> I am struggling with a poorly behaved BTRFS volume.
> >>>>>>>
> >>>>>> [...]
> >>>>>>> ---
> >>>>>>>
> >>>>>>> No errors are reported in the kernel log, only warnings about
> >>>>>>> skipping the swap file during scrub.
> >>>>>>
> >>>>>> If you assume the fs has some corruption, none of the above is
> >>>>>> really useful.
> >>>>>> A full "btrfs check" is strongly recommended.
> >>>>>>
> >>>>>>>
> >>>>>>> Second, within the logs generated for Timeshift, a concerning
> >>>>>>> pattern recurs, as in the attached example. Further, during the
> >>>>>>> periods in which are generated logs such as the one attached,
> >>>>>>> the entire system lags considerably. It is clear that the
> >>>>>>> volume is not healthy.
> >>>>>>
> >>>>>> The lag is mostly caused by qgroup.
> >>>>>> You have a lot of snapshots (shown by the super large snapshot id),
> >>>>>> every time a large snapshot/subvolume is deleted, btrfs will try
> >>>>>> to disable qgroup to avoid such lag, but if whatever script/tool
> >>>>>> decides to rescan qgroup when the snapshot/subvolume deleting is
> >>>>>> still under going, the lag will be re-introduced.
> >>>>>>
> >>>>>>>
> >>>>>>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the
> >>>>>>> problem emerged. I upgraded by to 7.0, finding no improvement
> >>>>>>> in the operation of the volume.
> >>>>>>>
> >>>>>>> Also, I tried initiating the scrub through the most recent static
> >>>>>>> build of the user-space utility (i.e. btrfs-progs), with no
> >>>>>>> improvement.
> >>>>>>>
> >>>>>>> I would like some suggestions for restoring the volume to health,
> >>>>>>> to avoid the need to provision a new volume from scratch.
> >>>>>>
> >>>>>> "btrfs check" first, if no error, disable qgroup if you have
> >>>>>> frequent snapshot creation/deletion.
> >>>>
> >>>> So your fsck is mostly fine, the lag part is highly possible to be
> >>>> caused by qgroup.
> >>>>
> >>>> If you do not need it, just disable it for good.
> >>>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Qu
> >>>>>>
> >>>>>>>
> >>>>>>> Thank you.
> >>>>>>>
> >>>>>>
> >>>>>
> >>>>
> >>> 
> >>>
> >> 
> >>
> 
>
