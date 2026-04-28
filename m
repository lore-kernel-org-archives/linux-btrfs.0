Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E291154425
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 02:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777343630; cv=none; b=QVyRdKCQf4Pw4PpfUzRAskFAOJ/JhN/PbyrvJT9BEUQYyaEgNUgBZgGhD7KCggvpjLDe5oy+T3qLNUKxmqyzshjPA4+GANKNDcbK6VZ2Z46WxZvEJ6lZkir20X6knjazpe28KXPL7Oc7g89sXsRuwGKWvk9b4fdqELL3fiBwo2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777343630; c=relaxed/simple;
	bh=N1HdjyrHJ9HwzNBZzA0vDtEMu5PkW4jFv8n0N07CaAc=;
	h=From:To:Cc:Subject:References:In-Reply-To:Message-ID:Date:
	 Content-Type:MIME-Version; b=LimCyqJlUuIbszqd9vijF7vAXV0/d5LVgmsF+1GKS6AWPwYozYJxlwxlwl85VZ1cIzhAi9SLyAHKnDkNO+ntLd6dGwRuFEKHBxivulPmw4PIzRvIZ/Sc9k8oJaMpTa5YQ8QqMAIh1ZKQdT5GN8AAjxemaTaghtODWOHaxQ7K26M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=yjda7wfY; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="yjda7wfY"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g4Pd526Z0z9t1g
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 04:33:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777343625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1HdjyrHJ9HwzNBZzA0vDtEMu5PkW4jFv8n0N07CaAc=;
	b=yjda7wfY0NTMSOrLS2caSnHB9uISBPFNL/VDCoKG4WPAzuZm0ml73eBOnnGwQCpFVY6EhZ
	X1iGgn8+U1ugAaMyC12wznb7NOrMc5NYJ6huJnwTBQkc8OYLd9lVJgAoWZwy0hPsxW+8Uf
	TsPY1Lyn+uCDxOlciQ69uriLEWGyVe4ADQklc/SYzpbqf+jH6zaxlpdenl4P+oqivHC4Pv
	XrQCEtlrDYJlOFsIvgr2E96Iw6J4s+JiT3YVRwgZJ08b4P08Mnce8HCa3KG68qNB+dOhxF
	IyKe0GDQaPxlQ84J8XpYx3qMRYSU4i/G23/P8/6UVF8vGLLgMaXYpz8jlQnvKw==
From: brainchild <brainchild@mailbox.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: 
Subject: Re: Strange behavior with scrub, quotas, and snapshots
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
In-Reply-To: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
Message-ID: <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
Date: Tue, 28 Apr 2026 02:33:44 +0000
Content-Type: text/plain; charset=utf-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: bk9ogcugu4hod3e7ruckohduc1nkbaji
X-MBO-RS-ID: 88316361dedbac8f9f6

With swap disabled, the scrub operation seems to reach completion, with no errors found.
 
However, the check operation still discovers the same errors.
 
The output of `rescue fix-device-size' is "No device size related problem found".
 
After, check still reports the same errors, including the super mismatch.
 
"brainchild" brainchild@mailbox.org – April 28, 2026 1:21 AM
> I have not tried scrubbing without the swap file being in use.
>  
> I could try, but as the file is only 32Gb, I would be very surprised if it made any difference.
>  
> "Qu Wenruo" wqu@suse.com – April 27, 2026 9:16 PM
> > 在 2026/4/28 09:52, brainchild 写道:
> > > Just as I was scanning for the name of the particular inode, the volume reverted to again insist on being without any free space.
> > > 
> > > I was able to extract the log for a new scrub, as requested (begun after the switch to being unable to create new files).
> > 
> > Only 10GiB of data is scrubbed, meanwhile your data should be 600GiB+.
> > 
> > You mentioned that there is a swap file, how large is that file, and 
> > have you tried to disable the swap file before scrubbing?
> > 
> > Thanks,
> > Qu
> > 
> > > 
> > > Thanks.
> > > 
> > > "Qu Wenruo" wqu@suse.com – April 27, 2026 6:58 PM
> > >> 在 2026/4/28 08:17, brainchild@mailbox.org 写道:
> > >>> Currently, scrub operations are not completing properly, so I certainly
> > >>> think it is important to try to repair the volume.
> > >>> 
> > >>> Which error do you expect is related to the particular problem,
> > >>> concerning scrub?
> > >> 
> > >> Can you provide the full "btrfs scrub start -BR" output?
> > >> 
> > >>> 
> > >>> Is there any evidence that data may have been lost,
> > >> 
> > >> Not yet.
> > >> 
> > >>> or concern that
> > >>> 'fix-device-size' could cause further loss?
> > >> 
> > >> That should be mostly safe, but if you're concerned about it, please
> > >> update to a newer version of btrfs-progs.
> > >> 
> > >> Ubuntu is pretty bad at backporting fixes for btrfs-progs.
> > >> 
> > >>> Should the operation be done
> > >>> while the device is mounted, or only while not mounted?
> > >> 
> > >> Must be unmounted for btrfs check and btrfs rescue.
> > >> 
> > >> Thanks,
> > >> Qu
> > >> 
> > >>> 
> > >>> Thanks.
> > >>> 
> > >>> On Tue, Apr 28 2026 at 07:40:31 AM +09:30:00, Qu Wenruo <wqu@suse.com>
> > >>> wrote:
> > >>>>
> > >>>>
> > >>>> 在 2026/4/28 06:02, brainchild@mailbox.org 写道:
> > >>>>> I have the run the check command, which reported a variety of errors.
> > >>>>> The output is attached.
> > >>>>>
> > >>>>> Are any recommendations available to attempt restoring the volume?
> > >>>>
> > >>>> The super block bytes mismatch is a minor one, which shouldn't affect
> > >>>> normal operations.
> > >>>>
> > >>>> But still you can use "btrfs rescue fix-device-size" to fix the problem.
> > >>>>
> > >>>>
> > >>>> The nbytes wrong can be minor too, but it's affecting all snapshots
> > >>>> containing the inode 16523863.
> > >>>>
> > >>>> You can either fix it by copying the inode to another location (can be
> > >>>> inside the same btrfs), remove the original file, mv back the new copy.
> > >>>> This will need to be done for every snapshot.
> > >>>>
> > >>>> Or you can try "btrfs check --repair", which will do an in-place fix,
> > >>>> but will still break the shared blocks of every snapshot.
> > >>>>
> > >>>> Overall, I'd strongly recommend to remove all unused snapshots first
> > >>>> before doing either fix.
> > >>>>
> > >>>>>
> > >>>>> Thanks.
> > >>>>>
> > >>>>> On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo
> > >>>>> <quwenruo.btrfs@gmx.com> wrote:
> > >>>>>>
> > >>>>>>
> > >>>>>> 在 2026/4/27 09:22, brainchild@mailbox.org 写道:
> > >>>>>>> Hello.
> > >>>>>>>
> > >>>>>>> I am struggling with a poorly behaved BTRFS volume.
> > >>>>>>>
> > >>>>>> [...]
> > >>>>>>> ---
> > >>>>>>>
> > >>>>>>> No errors are reported in the kernel log, only warnings about
> > >>>>>>> skipping the swap file during scrub.
> > >>>>>>
> > >>>>>> If you assume the fs has some corruption, none of the above is
> > >>>>>> really useful.
> > >>>>>> A full "btrfs check" is strongly recommended.
> > >>>>>>
> > >>>>>>>
> > >>>>>>> Second, within the logs generated for Timeshift, a concerning
> > >>>>>>> pattern recurs, as in the attached example. Further, during the
> > >>>>>>> periods in which are generated logs such as the one attached,
> > >>>>>>> the entire system lags considerably. It is clear that the
> > >>>>>>> volume is not healthy.
> > >>>>>>
> > >>>>>> The lag is mostly caused by qgroup.
> > >>>>>> You have a lot of snapshots (shown by the super large snapshot id),
> > >>>>>> every time a large snapshot/subvolume is deleted, btrfs will try
> > >>>>>> to disable qgroup to avoid such lag, but if whatever script/tool
> > >>>>>> decides to rescan qgroup when the snapshot/subvolume deleting is
> > >>>>>> still under going, the lag will be re-introduced.
> > >>>>>>
> > >>>>>>>
> > >>>>>>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the
> > >>>>>>> problem emerged. I upgraded by to 7.0, finding no improvement
> > >>>>>>> in the operation of the volume.
> > >>>>>>>
> > >>>>>>> Also, I tried initiating the scrub through the most recent static
> > >>>>>>> build of the user-space utility (i.e. btrfs-progs), with no
> > >>>>>>> improvement.
> > >>>>>>>
> > >>>>>>> I would like some suggestions for restoring the volume to health,
> > >>>>>>> to avoid the need to provision a new volume from scratch.
> > >>>>>>
> > >>>>>> "btrfs check" first, if no error, disable qgroup if you have
> > >>>>>> frequent snapshot creation/deletion.
> > >>>>
> > >>>> So your fsck is mostly fine, the lag part is highly possible to be
> > >>>> caused by qgroup.
> > >>>>
> > >>>> If you do not need it, just disable it for good.
> > >>>>
> > >>>> Thanks,
> > >>>> Qu
> > >>>>
> > >>>>>>
> > >>>>>> Thanks,
> > >>>>>> Qu
> > >>>>>>
> > >>>>>>>
> > >>>>>>> Thank you.
> > >>>>>>>
> > >>>>>>
> > >>>>>
> > >>>>
> > >>> 
> > >>>
> > >> 
> > >>
> > 
> >
> 
>
