Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0203133ADBF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 03:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528886; cv=none; b=TZYj1pU90ovxL/S3Ons925ONOU/tjOckgBXfGPk7OX90/FzDLKxPqXvpj6lsiYe2J0NVuFTwK+RHJbNfFopRJyC9yXqCXyUYSKm1l2XYEAL/JTysRF8Kjkp80yRIlpB8+vZlZLcynUK/BoByWHFfoXx5VZay9I0N+Vx44bgbsp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528886; c=relaxed/simple;
	bh=hWvhaJn4URrOd+ajB8jiRM2O8U6Zt7FrZwsdx5AZN5A=;
	h=Date:References:To:Mime-Version:Subject:Content-Type:In-Reply-To:
	 Message-Id:From; b=eJM2+hjQWjES36vwwkgXmjHDtWYtvenNiAE/9vhRCLV2ksUd3e8m5/MlnG1PBeCLXJql1+MleP+2WvxXTEAdVqoGq0XvPXgfsQMQh1aG6qQcgBNhmAbvrqwAPu7tYKQ8AKPSyL2fwjM2vTVA2nxuQjAg3zwRrQNiMbPuAVNzr3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=GrwrTZG7; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="GrwrTZG7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789528873;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CYIg1z7kZioVXf2T/bFT1pB1SW1iEoxavfh+6MyTxu4=;
 b=GrwrTZG7nFyL6ciJcARxMzx5fvvEdpNwHLLh4cRKrARH9NiWY2tFXlcGoW8borrdRqvrPv
 Ga2vMHQ7CCHbkM8dI+NRMaKBLbeHjX0PjYJ9p5JY4Y+oqk0XsbIt1ikyEDNFU68igr17hw
 QyF23gjIR3rtl8MJHqP+Zmw1d8Ec5BZe5KM8L3m786yZdjW3A8ZGeLfXUocIVseM8EHHUm
 +/MJC/RQ7YaoSBIhtZa2z21dkKLWQg8kLX1gW2SSWVok6xa6Gkg5hEWdbt3Oig4E+Da0Ec
 uZSWqmiDoMkTSDZpd1zz4iiESE/bZE9n5OstizJ8aa0j4sB3ocIQgH2DrwLCPQ==
Date: Wed, 16 Sep 2026 11:21:09 +0800
User-Agent: Mozilla Thunderbird
Received: from [192.168.8.64] ([183.34.164.60]) by smtp.larksuite.com with ESMTPS; Wed, 16 Sep 2026 03:21:12 +0000
References: <cover.1789524388.git.zhudongjiang@fygo.io> <6e1accfc2487250fdf5d5b1dc397434b5f854242.1789524388.git.zhudongjiang@fygo.io>
To: <linux-btrfs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aaa0b29+1a1cf7+vger.kernel.org+zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Subject: Re: [RFC PATCH 5/5] btrfs: qgroup: fix rescan handling during remount
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <6e1accfc2487250fdf5d5b1dc397434b5f854242.1789524388.git.zhudongjiang@fygo.io>
Message-Id: <7ea0c4b8-7555-4271-b9a6-72c464f875cd@fygo.io>
Content-Transfer-Encoding: quoted-printable
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>

=E5=9C=A8 2026/9/16 11:14, Dongjiang Zhu =E5=86=99=E9=81=93:
> There are two problems with qgroup rescan handling during remount.
>=20
> First, the rescan worker stops whenever BTRFS_FS_STATE_REMOUNTING is
> set. This is a transient state used for all remount operations,
> including read-write to read-write remounts. A read-write to read-write
> remount can therefore stop a rescan even though the filesystem remains
> writable, and there is no corresponding resume path. Check the actual
> read-only state instead, so the worker only stops when the filesystem is
> becoming read-only.
>=20
> Second, during a read-only to read-write remount,
> btrfs_qgroup_rescan_resume() is called from the pre-RW setup. At that
> point the filesystem is still read-only and the remount is still in
> progress, so the resumed worker can immediately stop again.
>=20
While testing this change, I found a separate issue in the qgroup rescan
wait handling.

The issue can be observed with the following sequence, provided the
rescan is still running when the filesystem is remounted read-only:

   btrfs quota rescan <mnt>
   mount -o remount,ro <mnt>
   mount -o remount,rw <mnt>
   btrfs quota rescan -w <mnt>

The worker calls complete_all() when it pauses for the read-only
remount. The read-only to read-write remount then queues the worker
again using the same completion. Since the completion remains in the
completed state, BTRFS_IOC_QUOTA_RESCAN_WAIT can return while the
resumed worker is still running and RESCAN remains set.

Simply adding reinit_completion() before queuing the worker does not
seem sufficient either, since waiters from the previous worker run
may not have finished returning from wait_for_completion().

I do not have a clean solution yet. One possibility might be to use a
waitqueue with qgroup_rescan_running and a worker sequence number, so
a waiter can distinguish successive worker runs. However, that seems
to introduce more state and complexity than I would like for this
issue, and I am not sure it is the right approach.

Does anyone have a simpler way to handle this?

I have left this out of the series to keep this patch focused on the
remount stop condition and resume timing. Posting it here for
visibility and discussion. If anyone would like to pick this up and
work on a fix, please feel free.

Thanks,
Dongjiang
