Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A40D1A683B
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 00:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777335744; cv=none; b=li9PE+efIA9QNAUzpL0IVty2HO/2ss59NoyKZqjDnuk2K5Xj4Fz1u/HZ+OMIceX4SKHi5odru95P1eN10rL3PLMn6KVMu3WoH94wqqR8Auc8+Drf676uWBuVWEvwAU6+OUN1oV+LJlfNx11+jWolue78VW3awf9cvEcbbqaYFNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777335744; c=relaxed/simple;
	bh=Cb2yirAEoUH+FpMaFHH+tVP/BMt23XCIiCDrECw+scQ=;
	h=From:To:Cc:Subject:References:In-Reply-To:Message-ID:Date:
	 Content-Type:MIME-Version; b=MXyf9+mnEpNIKwkQq58CpXivdIGEkzcbaFh2eNu3LJLCFWoXC+tt8bNL3I6+2omONrt459wP+GcUsVwSFMryZwThBcrXtHXnC53gdTUd2mBlFCMd629oozBn6dQmH5Mi3TMmlkv1yJFKqjf46b7j50fy4YkYswVa93ywobArf+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=ioGEBOjN; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="ioGEBOjN"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4g4LjQ6PsLz9v7B
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 02:22:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777335738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hck6n65ixYokexSb6/FUJtSelphsYbznTSXntanInsg=;
	b=ioGEBOjNasWlM04l1XVDYaK8sh3LXHmP8Nqbit7/0BcV9sfF62SijkrUxOqatBnE3f/2TS
	3j6ab3EjIqKUYfm5YCRssVrn7wLVJZOdItX+b/fzYg1nI6YQUizl+R0SLw+S7byAoil2YG
	S8lQBM7JOyEk9+SGXOGPImsoHsHexgaRU8O3y0tkSOIJvqyJ/ebV0I4JG875irqWaIT1jU
	9lkuTaXhZ47zydYxMN+n+90abVA2Y1S0PaDbtxCLV9IwsKi2REfhr0j7MlDHX3MEE3yZLw
	PrJCynvNCJ8PgroZN2qmZJ8mBQlF0h0Ys9r3ulcbR6mLD6TbCLgSDRyjdJyI6Q==
From: brainchild <brainchild@mailbox.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: 
Subject: Re: Strange behavior with scrub, quotas, and snapshots
References: <0dfb1998-e951-4db7-be8a-987da3a8f471@suse.com>
In-Reply-To: <0dfb1998-e951-4db7-be8a-987da3a8f471@suse.com>
Message-ID: <20260428002217.Horde.5h6SZuQXFy8tGMhc9x7qKTM@nextcloud.brainspace.site>
Date: Tue, 28 Apr 2026 00:22:17 +0000
Content-Type: multipart/mixed; boundary="=_hSpJ5furEM-qHgwHk6ed3ha"
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: f4a6a67b3f0acbe8688
X-MBO-RS-META: sjy9syp9nuz11gid6nrh9zc41cbendfa

This message is in MIME format.

--=_hSpJ5furEM-qHgwHk6ed3ha
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Just as I was scanning for the name of the particular inode, the volume reverted to again insist on being without any free space.
 
I was able to extract the log for a new scrub, as requested (begun after the switch to being unable to create new files).
 
Thanks.
 
"Qu Wenruo" wqu@suse.com – April 27, 2026 6:58 PM
> 在 2026/4/28 08:17, brainchild@mailbox.org 写道:
> > Currently, scrub operations are not completing properly, so I certainly 
> > think it is important to try to repair the volume.
> > 
> > Which error do you expect is related to the particular problem, 
> > concerning scrub?
> 
> Can you provide the full "btrfs scrub start -BR" output?
> 
> > 
> > Is there any evidence that data may have been lost,
> 
> Not yet.
> 
> > or concern that 
> > 'fix-device-size' could cause further loss?
> 
> That should be mostly safe, but if you're concerned about it, please 
> update to a newer version of btrfs-progs.
> 
> Ubuntu is pretty bad at backporting fixes for btrfs-progs.
> 
> > Should the operation be done 
> > while the device is mounted, or only while not mounted?
> 
> Must be unmounted for btrfs check and btrfs rescue.
> 
> Thanks,
> Qu
> 
> > 
> > Thanks.
> > 
> > On Tue, Apr 28 2026 at 07:40:31 AM +09:30:00, Qu Wenruo <wqu@suse.com> 
> > wrote:
> >>
> >>
> >> 在 2026/4/28 06:02, brainchild@mailbox.org 写道:
> >>> I have the run the check command, which reported a variety of errors. 
> >>> The output is attached.
> >>>
> >>> Are any recommendations available to attempt restoring the volume?
> >>
> >> The super block bytes mismatch is a minor one, which shouldn't affect 
> >> normal operations.
> >>
> >> But still you can use "btrfs rescue fix-device-size" to fix the problem.
> >>
> >>
> >> The nbytes wrong can be minor too, but it's affecting all snapshots 
> >> containing the inode 16523863.
> >>
> >> You can either fix it by copying the inode to another location (can be 
> >> inside the same btrfs), remove the original file, mv back the new copy.
> >> This will need to be done for every snapshot.
> >>
> >> Or you can try "btrfs check --repair", which will do an in-place fix, 
> >> but will still break the shared blocks of every snapshot.
> >>
> >> Overall, I'd strongly recommend to remove all unused snapshots first 
> >> before doing either fix.
> >>
> >>>
> >>> Thanks.
> >>>
> >>> On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo 
> >>> <quwenruo.btrfs@gmx.com> wrote:
> >>>>
> >>>>
> >>>> 在 2026/4/27 09:22, brainchild@mailbox.org 写道:
> >>>>> Hello.
> >>>>>
> >>>>> I am struggling with a poorly behaved BTRFS volume.
> >>>>>
> >>>> [...]
> >>>>> ---
> >>>>>
> >>>>> No errors are reported in the kernel log, only warnings about 
> >>>>> skipping the swap file during scrub.
> >>>>
> >>>> If you assume the fs has some corruption, none of the above is 
> >>>> really useful.
> >>>> A full "btrfs check" is strongly recommended.
> >>>>
> >>>>>
> >>>>> Second, within the logs generated for Timeshift, a concerning 
> >>>>> pattern recurs, as in the attached example. Further, during the 
> >>>>> periods in which are generated logs such as the one attached, 
> >>>>> the entire system lags considerably. It is clear that the 
> >>>>> volume is not healthy.
> >>>>
> >>>> The lag is mostly caused by qgroup.
> >>>> You have a lot of snapshots (shown by the super large snapshot id), 
> >>>> every time a large snapshot/subvolume is deleted, btrfs will try 
> >>>> to disable qgroup to avoid such lag, but if whatever script/tool 
> >>>> decides to rescan qgroup when the snapshot/subvolume deleting is 
> >>>> still under going, the lag will be re-introduced.
> >>>>
> >>>>>
> >>>>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the 
> >>>>> problem emerged. I upgraded by to 7.0, finding no improvement 
> >>>>> in the operation of the volume.
> >>>>>
> >>>>> Also, I tried initiating the scrub through the most recent static 
> >>>>> build of the user-space utility (i.e. btrfs-progs), with no 
> >>>>> improvement.
> >>>>>
> >>>>> I would like some suggestions for restoring the volume to health, 
> >>>>> to avoid the need to provision a new volume from scratch.
> >>>>
> >>>> "btrfs check" first, if no error, disable qgroup if you have 
> >>>> frequent snapshot creation/deletion.
> >>
> >> So your fsck is mostly fine, the lag part is highly possible to be 
> >> caused by qgroup.
> >>
> >> If you do not need it, just disable it for good.
> >>
> >> Thanks,
> >> Qu
> >>
> >>>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>>
> >>>>> Thank you.
> >>>>>
> >>>>
> >>>
> >>
> > 
> >
> 
>
--=_hSpJ5furEM-qHgwHk6ed3ha
Content-Type: text/plain; name=brainchild_scub_log.txt
Content-Disposition: attachment; filename=brainchild_scub_log.txt

WARNING: failed to open the progress status socket at /var/lib/btrfs/scrub.progress.bbac86e5-eaba-45bf-bbaa-c2494e11831a: No space left on device. Progress cannot be queried
WARNING: failed to write the progress status file: No space left on device. Status recording disabled
Starting scrub on devid 1
scrub done for bbac86e5-eaba-45bf-bbaa-c2494e11831a
Scrub started:    Mon Apr 27 19:25:47 2026
Status:           finished
Duration:         0:03:34
	data_extents_scrubbed: 174742
	tree_extents_scrubbed: 1117169
	data_bytes_scrubbed: 11444801536
	tree_bytes_scrubbed: 18303696896
	read_errors: 0
	csum_errors: 0
	verify_errors: 0
	no_csum: 1621176
	csum_discards: 0
	super_errors: 0
	malloc_errors: 0
	uncorrectable_errors: 0
	unverified_errors: 0
	corrected_errors: 0
	last_physical: 844727582720

--=_hSpJ5furEM-qHgwHk6ed3ha--

