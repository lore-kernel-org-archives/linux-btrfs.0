Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BA13E5ED7
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781696188; cv=pass; b=a7Vz14d4EzMTPWF+bqeoUYwT4xy2N5BoZgNueAubdFQYeekQzf9OcmtT21VidNiYunh7Mcn8Qz8BFGjIxhCkMiV+bEp4/yOnJXYB849Zx+wYrf6d2nG9bcPHppVkADN74Whno/n2loEKwwWM1IbyLae8Q49BH5dWYEmyWLm4S2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781696188; c=relaxed/simple;
	bh=ff9cLkSNny/BY8EBh6w3a0YKNwlQGcuVDSLiF0ulRmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJs7FwYE3Dr/8285qY7WwAwM3SuX7dasBJ1cHPEKNVL6l2jVFRk2qGtyDO6g0NK3N4aRxqSE3A+HacoNKpxOyXeAp8EhuEHRI/6yqgd1tGgytsF37mpDishX3qPEBRLeJrXraXHOefC0USMI7G13PHu3XD+OcRmWB5Rgj+0MqbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnkRYPYZ; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnkRYPYZ"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-138501f8c04so3054963c88.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 04:36:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781696186; cv=none;
        d=google.com; s=arc-20240605;
        b=OgoDxMVrtTrZuvVBC3ve3brJaE/Zyu+a2NCOsFsu2h80fE86boBUKcxBCWXX5znhnh
         NI+MrBJQwtKxV9Mcp7xtgu20ahNOeyF3gGPgPHqC5Ei9vnTRXaJfdh0bv6olCCxRFZ7I
         YoZaS1CQRV9j1NtxM5E3cUKycePP8EN8pBPC9jf19gQqr7wRHjFo6XmtvvzTo7B8SpZ8
         4QkprhyEhUAKmOriRRkT+CNIqutbzkdRcmdl/XJwduL/JHQWzx+yrOdapX1OzUidJMdB
         IBO8B0mkPWIxn+pnXPw1oJTPyj4h/tb1P8Ba0SkvTY50VbNjIa3uJhemrGaWa2wIMLtn
         nUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ff9cLkSNny/BY8EBh6w3a0YKNwlQGcuVDSLiF0ulRmA=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=ZE4Vrbw6Qo4qkM1vyPtysh2OjCu1t9TCzjXMkX6UGoG6+KkCbFRgNIMX7a6BNXmVl0
         kNLduKAgbRsGe6tFawLlOiGMgPIxcSwy2iTnO9a8uMc5DUfobUlGFp/0fO5b91iI2ZLS
         H/Q8ZHXxD9cYQNQOlBnlFH43a0RR/00few8zRU1/doPcE+WjYwdgU0RrdAnpV8bs4z4K
         ROICpq/pupJz+63hWOLuXafSo+RkvREe018oObaueoE5m3N7NhpSF7IJu74KipE9c0Pd
         wuxat8j0/LGF62sUfmaKFqmNjATXtM8y0o3SpmjGrC+b1OsZ6tqMmp0Xb8COn5evIxTJ
         QIuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781696186; x=1782300986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ff9cLkSNny/BY8EBh6w3a0YKNwlQGcuVDSLiF0ulRmA=;
        b=OnkRYPYZ15masbyVHxC3il8SQj2waWXXMG5+GLKvzfiddbMij9j+X94DRfimHEBRMq
         C1fb8oRdrLRj4+MJN8bpXcdfAe8OTu2WeD5wbnKyoi7A9UWy+IfobTrT+RU6/9jq94wE
         7HJGYDs6rSH/786aAgOmO949tHrzhr3RLPKqOWREOmdqn81De3vidus6OmdVBqFKKTFI
         KR+cNlE76vwJiaXKoLhAPb858tsfkEAn0xc55cWCX+eB5xKUDbgV64UE9vfXoYU8SR53
         +nCxkZ5Qbs+VNVMI5elUKMfJ3b7gjvZccHYNgJW1x8Gzo5N8OEoSj8q5d2vD+rn0QtTD
         yCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781696186; x=1782300986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ff9cLkSNny/BY8EBh6w3a0YKNwlQGcuVDSLiF0ulRmA=;
        b=e7PjkovDBiA30dl0cZbfWqg3PqLQB0mEA4DoQg9Ju2k6gJFr7XYdhRp67/KOzblL9+
         i15HeXZ8XfPtpQ3w/Dj2PJn9cXyZAoa7Zm32Lk/2MEwYOnk1aCGDW4arIafSA3WEIJTj
         jnbMhPCKKIF0hGRo7mxkba2vdpwB53YMhQYIYQ6CTZY3W89FaG3BqV7OitF7+BiROk6F
         fUwxh5elwivW1J2oRGGtF2x3pae43gKdSXAiLhHw9F27CwUDin55ez3B76+bhz/gx4G+
         K7VCEMFLT2jST2+LSAw89BKjA6ZSSWLT9ygJ0ddXjIuZImJ+nkeTfbpPYwLcU8w/pTDq
         9cjw==
X-Gm-Message-State: AOJu0YyM7s9bKinzofu0awggOXbZsmX5lIDjdtsRApz9nxekGcVvnhfn
	gqmnpQzf8ZjxS2ljhDwRXHTSvAiSPpDpOvUnbDSh4FHaiF37edZVsCbHMaRSmtZdkfybqS6tN3f
	xr4L8XjFKRzO7iMOBkKT/TVxQKKIB7Itweg==
X-Gm-Gg: Acq92OHUCCYm3ot7U8wz6Ydt9Ds9YRJJbYzrsX+MY450s+1DvFu96EhK85R0wiO3vN4
	CtP3N3VVij/dWg9D8O8/jTgbU108BrF6ahCOuWwzkaHQduEe2/JXnEOuYZULfkcRAInkR7pa7eJ
	8QxveWsL+WwF7dtu+AxMFjU8wkkZwUxv5gAGAT8IqIPQ21f2bR98b9NVtufXSxb1FMxH+F1GXee
	gsjEvERYgOik4XTUbmTev0/kaS3KipAEYoPGY5mdriyT7/1YqBlnnf7rlXAb/eBC5cQlkK1
X-Received: by 2002:a05:7022:983:b0:138:3613:dbb with SMTP id
 a92af1059eb24-1398f6665d7mr1348146c88.5.1781696185661; Wed, 17 Jun 2026
 04:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALuM0_aMUsWM0xGOrda7-jizQmmzJ6+cU63FVm-epMwEeifiWA@mail.gmail.com>
 <310be885-8ec9-435b-9a67-26fa14aab611@suse.com>
In-Reply-To: <310be885-8ec9-435b-9a67-26fa14aab611@suse.com>
From: Amber <edoardomonterosso2010@gmail.com>
Date: Wed, 17 Jun 2026 11:36:13 +0000
X-Gm-Features: AVVi8Cceeb389oIws2S4YVN5JZCUWjUM6HM1DQ1lJ4RXSTaZbIEprAF6SEK2AEI
Message-ID: <CALuM0_aSy5KW569Zdu9sOtVejc92HvNDXG8f4_2f7y0Uf-TNQA@mail.gmail.com>
Subject: Re: Btrfs mount failure; log tree replay error and transid verify failed
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I managed to copy the files i care about into an external drive, thanks a l=
ot.
What do i do now? Is there any way to fix my system or do you advise a
clean install at this point?


On Tue, Jun 16, 2026 at 11:11=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/6/17 07:53, Amber =E5=86=99=E9=81=93:
> > Hi all,
> >
> > I am experiencing a severe Btrfs filesystem failure on an NVMe
> > partition (/dev/nvme0n1p3) that stops my system from booting. I am
> > running from a Fedora 40 Live USB to try and find a way to rescue my
> > data.
> >
> > I don't know much about filesystem internals, so I am attaching the
> > exact outputs of the commands I was told to run below.
> >
> > Output of 'uname -r':
> > 6.8.7-300.fc40.x86_64
> >
> > Output of 'btrfs --version':
> > btrfs-progs v6.8
> >
> > Output of 'sudo fdisk -l /dev/nvme0n1':
> > Disk /dev/nvme0n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
> > Disk model: TEAM TM8FP7001T
> > Units: sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disklabel type: gpt
> > Disk identifier: D2CC4AA6-D32A-4B69-A117-FA5431D953E2
> >
> > Device Start End Sectors Size Type
> > /dev/nvme0n1p1 2048 1230847 1228800 600M EFI System
> > /dev/nvme0n1p2 1230848 3327997 2097152 1G Linux filesystem
> > /dev/nvme0n1p3 3328000 2000408575 1997080576 952.3G Linux filesystem
> >
> > Important parts of 'smartctl -a /dev/nvme0n1':
> > SMART overall-health self-assessment test result: PASSED
> > Available Spare: 100%
> > Percentage Used: 1%
> > Unsafe Shutdowns: 80
> > Media and Data Integrity Errors: 0
> >
> > Initial boot crash log:
> > [ 4.027710] BTRFS critical (device nvme0n1p3 state EAO): log replay
> > failed in replay_one_extent:880 for root 256, stage 3, with error -5:
> > failed to lookup data extent for bytenr 13497643008 disk_num_bytes
> > 32768 inode 993755 root 256
> > [ 4.027727] BTRFS: error (device nvme0n1p3 state EAO) in
> > btrfs_recover_log_trees:7789: errno=3D-5 IO failure
>
> You definitely missed part of the dmesg, thus that's why we always ask
> for full dmesg.
>
> There must be some transid mismatch error message before that.
>
> >
> >
> > Errors from 'btrfs check':
> > Important parts of the initial check output:
> > [2/8] checking root items
> > parent transid verify failed on 323993370624 wanted 15274 found 14939
>
> Again, root tree corruption that caused the log replay bug.
>
> And it looks like some bad FUA/FLUSH behavior, some writes are lost thus
> you got older tree blocks.
>
> > [3/8] checking extents
> > owner ref check failed [323993370624 16384]
> > ERROR: errors found in extent allocation tree or chunk allocation
> > [4/8] checking free space tree
> > there is no free space entry for 13497565184-13500841984
> > [6/8] checking only csums items (without verifying data)
> > ERROR: errors found in csum tree
> >
> > Final totals from the check:
> > ERROR: transid errors in file system
> > found 69424640000 bytes used, error(s) found
> > total csum bytes: 66219348
> > total tree bytes: 935608320
> > total fs tree bytes: 782991360
> > total extent tree bytes: 71860224
> >
> >
> > I ran 'sudo btrfs check --repair /dev/nvme0n1p3' and hit 'y' when it
> > asked to clear the log tree.
> >
> > It said:
> > "Clear log tree successfully."
> >
> > But right after that, it hit the same error again:
> > [2/8] checking root items
> > parent transid verify failed on 323993370624 wanted 15274 found 14939
> >
> > Normal mounting still completely fails. Can anyone guide me on how to
> > save my system?
>
> Try "-o rescue=3Dall,ro" mount option, if it works, salvage your data.
>
> > Please CC me on replies, as I am not subscribed to the list.
> >
> > Thank you,
> > Amber
> >
>
