Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794590051;
	b=MTcqoaBPvVwEGILoxIzDhuQ2hJziZjnx6ADQWCO2LdeADMfSmzHmH78MyaWnxDbzXS3o
	 pDZ3ZXIKltjCL0Jj632TrnQqSKvc0tJjPJohBa+CoAk6KSTfrPDBGbGH8Tecs1MErjrk0
	 alh2GsJArh1aJXgrTt0Xov+JK8mran+yn6d3JNX05sHGc/MQrAjYqHzGfkiKSZ2x4aydA
	 VowmxIo9IicHI3zNZGKyQiXrmGz2LaAuR/Bl5QElcI3WpIw92KY2oaNH6CKxvB4BBSK6L
	 mu0UuOC+wBEvE06DXSd8aFyjczjYkZYfl2u12clT9fxO/PX+/aEI5eu7Igpqb50joqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EDl6SU19DWKtguSYQVTGJzhilPbV/qTAsI0Db4vrrcU=;
	b=raadtBwY+48xmF8wQD3yz7v6g2cpADSscRc/Hyip2gttxXS2vjwsyFSfMQX27KeyI0UH
	 keQMWvwEXtZWB2n45cBo0A8UuY905qeatobGIrGT/15rp8vAeWRHasMMFe3kbKYOFw85G
	 I3Axa1s/hBcWZGCLu55/eRYeqilON6PNsfbphuxhlQk0+BPiRqRkyq4ycxo51qhaY//7A
	 DIfyxdcGGvciH02xYNej+i15VHDy5bvRuPTF5XOB0YW1Z58/EjYZbNB5eKG7WPReSqoOS
	 m2xvkJguKgEnCZ60C1lVCHEQ/cpkvNDCaBHCL5TKWdfl19I0RAqkRMd72JNrfvagyyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gILRGEv5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83607606B353
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83607606B353
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gILRGEv5
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ad0102edd4so16507651fa.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 09:14:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794590050; cv=none;
        d=google.com; s=arc-20260327;
        b=KVMx3ZQgYyf39B1kiaGvqUDHPUpK4NEEvdHlPcvOzQBfDmfQBH9d8WZ1nT7QXcOCKP
         TyisBzPuFzkGmUoG+TMW7jzePBwevxFkJVqNbGiSyXZ3sMEa1uOgHU32ReIq9z2OSYIx
         tfMzIlg+xQxpDdWfh/zOJaPbbeoG+4mKm62r6QNhzmeFul1FwrGxWsZXaktebuhfxQHD
         vUokxCH0E6vI/80NCYl3coWoIKm82/3+svkkFJU6c31DFIyHq7Z+lVOuGQUl3BEN5Dxu
         61YEh9VQ0eOFn95CRCGe9rgaVuvG12Q6CHgwTwsrs3dg4yQcQxbCAGTsSh5ABxkI7X+R
         F5bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EDl6SU19DWKtguSYQVTGJzhilPbV/qTAsI0Db4vrrcU=;
        fh=+EQDHMSARrpZaEUij8rObCe+3HrU6fsLDLKQRC3kSPg=;
        b=sXvlTde1D6HdR628p8VF7EtgztoDtjCvwPQZodghxgUyo+K/CRzGCt3qu3FEIgTfl5
         GcmKSmrQWKL+nUqWnpBZomTF/2hL6vk9tNz2TWvkThFFzqFwRocMoWiyBXrs28/jsBdM
         MvgB158jIos/wqCUkpDl4a8AU1oxdUMakGuM46PjxIXAE/AU9XqHZz8k8swgTu/lHO3Q
         BumShwD8+0OREnakGbck7XV2SK+M0M/lcrKIESfjtKjilSYnYZIWf+vKcWb5ZYwIF1bq
         uofA3KhKgVUCGu3El5pwoGpqGtQxTdE4KJjl54K6pALd15DOgm6/TbLzL3A239OZqRs8
         rHIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794590050; x=1795194850; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EDl6SU19DWKtguSYQVTGJzhilPbV/qTAsI0Db4vrrcU=;
        b=gILRGEv5E6fbSbD79ittthWdLk45HBd+xnGkncMWIDXkAFRF84WwxJ1OSi3lC6ls2u
         IxfT7rv+T5Rhy7NLaDNAbZ+AkcHykIAZnP2WQi4vyXWC52RG/8rZYeoFOyn4tvLMe54R
         09WtqyH+oeXRc1xOJRohBpqMTrxMQ68c0JX4Lc6NsyR4AKF/jreF48DwfML/sQk1ZQuq
         XcKsUzekygLU6+lpSR7e6327VUNkV6sQJX+8oOJCfTPb+DVzW8ZzxbupEsWI2DfVODWZ
         7EZi8oVySk9jXvcXgUPg7CzbS5Zscf3eL1px/Dk2kVpfcvocpYC9jTHOuNiNlYWp6czm
         vxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590050; x=1795194850;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EDl6SU19DWKtguSYQVTGJzhilPbV/qTAsI0Db4vrrcU=;
        b=WY1sjJe2mkGXcQDkMoGjynxl3UD/J8SQe7EbK9tML1A4U+npoptP4ST2T3Rlgegk3n
         EcLk8pRsb3c8E9O7jtLGIoulkdpoLOZKGY+LclVMgsiX3oDtnpdAnC8Lv7xwR6EggEEy
         1hqhlKXXl5QSh/r5GMM0mY226MnxZZc6LPqOJCVJcq6B36+mO9LvSfkhIhnLxsm9Fkr6
         PXDNu0nciLBqgSUxSEBtUDAxniyXOz1rqGiIGYJ1ouVI7EJm7T0InguuMtgp4XtHKQ6V
         zBS73IS2L2ip3nyHUdJOiQDN+quAUvNiD8ru5pbFmnNsRBvMqwTqiIQ4QGjlMXOCiHAl
         yzgA==
X-Forwarded-Encrypted: i=1; AL+hErHkW7FuPnp5/EpG/8pD/O2Aaa7Hgf1AVRgXwEJuCM/vz5i//Pn98mm8CHhYDlzuCP5BHY4b+aKVCUIGSg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Rmj1Q/2SkwzLJ8QkkeG9tXrXZINyEqQ4bxY41Ad7BJK7mJH2H
	2SlwiDnvUjlL/mdrD+JorrE4FMSdCuHFnAN7vV++AYaUnOxAFCB34dc0YWehA8xz7AgSD8ztEa3
	F7chLadEjlAG78sI4qg0c9qIo82aUv4c=
X-Gm-Gg: AYBFou1yeRSkjucWsraghvChS4Cm5Q7Q4oZ04knKdGb4NHJvNJrMRqhVcFpnNdXoO9B
	yQYUy6F3EbK4ZYFoD1Qz/8aoYpen5afHox2GrqD0YRk9me8r0CrQRSnWNvq+4QosF2R6eIhf4Ee
	p57Coj64HhCnXrSh9w4MDr/ydwTq3ViCJz872HZKae64v75GdvD8Z5aICAFiZExkLWxRdyXnvKy
	YR/hc0mpLrf84BLJD+VBFufrILrufUnSIpE3l2qJEA7InCBV7coqTR2RrgWEZRRFNqzidmBjDuJ
	XSPgqzl+EUs2pIVx5AGT7NmDXi49Hv5XnM7GzpilxjCxtQGozUs6fnIWkTiQLxPGhrbN58j1xf0
	JvAgyxmjd+qObfZl0DxulZh5aHRPMWY1L2K7VjsN+oXRCDhm794wlf4HsBNsuNY6LKupiNynRaS
	zRm+h0yY8mL7PycBFS7jwEXnCffLLdbhKG2ChgUY7DeyOc3un8gnvtnxA8PifxkWUOXcNhHyXzF
	rzfZjpGMLEugFRDx6aT0avQgEKLcalv6CWTo5skuyVFynse/t6Fryr+Be8BXYvdk34i62GfHP8w
X-Received: by 2002:a05:651c:90a:b0:3ac:d131:66c6 with SMTP id
 38308e7fff4ca-3ae2b51ee13mr10506021fa.18.1794590049373; Fri, 13 Nov 2026
 09:14:09 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com> <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com>
In-Reply-To: <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Fri, 13 Nov 2026 18:13:57 +0100
X-Gm-Features: AclHuK9OrVb40pp0JADGkmq6dCvUk42Dsa7YJfGi24RM-jDsY3aABU_BUIAX6ds
Message-ID: <CAD=K2o8W085XSBeTYXjvaTRxgnx6y0_fVrNRH18-At=EUtWOUg@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: =?UTF-8?Q?Martin_=C5=A0koda?= <mar.skoda@gmail.com>
Cc: johannes.thumshirn@wdc.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	naohiro.aota@wdc.com, zhudongjiang@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

results of the larger write test with Dongjiang's
zoned-fixes-testing branch (7.4.0-rc1-zhu+, untainted):

- ~2.3 TB written via rsync in ~3 hours (~200 MB/s), fs now
  holds 6.7 TB total (the first abort back in October happened
  at ~4.3 TB written)
- no btrfs messages at all during the run
- closed zones: still 5 after the run (124 before the first
  mount with this branch, 128 on the broken fs)
- clean unmount, no "unable to release extent buffer" warnings
- btrfs check --readonly: no error found
- mounted again, stays rw

So for me the series fixes both the broken on-disk state and the
problem itself. If it helps, feel free to add:

Tested-by: Jochen Philipp <a2jphilipp@gmail.com>

Johannes, I'm happy to test your patches as well once they're
out.

Thanks,
Jochen

Am Fr., 13. Nov. 2026 um 17:16 Uhr schrieb Martin =C5=A0koda <mar.skoda@gma=
il.com>:
>
> Hello,
>
> I would like to report another case of Btrfs zoned filesystem failures
> on a Western Digital host-managed SMR drive. My symptoms appear very
> similar to those being discussed in this thread.
>
> *System configuration:*
>
>   *
>
>     Distribution: Ubuntu Server 26.04 LTS
>
>   *
>
>     Affected drive: WDC WSH722870ALE604, 27 TB, host-managed SMR
>
>   *
>
>     Filesystem: Btrfs zoned, single-device filesystem
>
>   *
>
>     Zone size: 256 MiB
>
>   *
>
>     Kernel versions tested: Ubuntu 7.0.0-34-generic and 7.0.0-42-generic
>
> *Observed failures:*
>
> On kernel 7.0.0-42, writing large media files repeatedly produced:
>
> |BTRFS error (device sdg): cow_file_range failed ...: -28 BTRFS error
> (device sdg): failed to run delalloc range ...: -28|
>
> These errors occurred despite several TiB of free space being reported.
>
> On kernel 7.0.0-34, I also observed a transaction abort on November 7, 20=
26:
>
> |BTRFS error (device sdg): error while writing out transaction: -11
> BTRFS warning (device sdg): Skipping commit of aborted transaction.
> BTRFS: Transaction aborted (error -11) BTRFS: error (device sdg state A)
> in cleanup_transaction:2060: errno=3D-11 unknown BTRFS info (device sdg
> state EA): forced readonly|
>
> At that time, Btrfs filesystem usage reported:
>
> |Device size: 24.56 TiB Device unallocated: 10.65 TiB Device zone
> unusable: 251.31 GiB Free (estimated): 10.86 TiB|
>
> All Btrfs device error counters were zero, including write, read, flush,
> corruption and generation errors.
>
> Both dynamic and periodic reclaim were disabled, and the reclaim
> counters were zero.
>
> The issue has occurred repeatedly. The filesystem becomes read-only
> after the transaction failure, and normal write operations cannot continu=
e.
>
> I have currently disabled writes to this drive through mergerfs to avoid
> further data loss. The filesystem contains important data without a
> complete backup, so I cannot safely test experimental kernels or perform
> destructive recovery procedures.
>
> Could you confirm whether these symptoms match the active-zone
> reservation/accounting issue addressed by this patch series? If so, is
> there a recommended stable kernel or an Ubuntu backport that includes
> the necessary fixes?
>
> I can provide additional kernel logs, filesystem statistics and
> read-only diagnostic information if useful. I would also be interested
> to know which fixes are planned for stable kernels and whether a
> backport to Ubuntu's 7.0 kernel series is possible.
>
> Thank you for your work on Btrfs zoned support.
>
> Martin =C5=A0koda
>
