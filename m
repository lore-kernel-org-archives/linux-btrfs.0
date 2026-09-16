Received: from outbound.st.icloud.com (st-2003b-snip4-11.eps.apple.com [57.103.77.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F23385D94
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 05:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.77.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789535581; cv=none; b=uL8novFxAW0y9FExIiBCUwwi67rWQffW4Dk40P2aahdX8gsTr2SSsPjLleh0B6zQbJp5wE8oRQ6/ORSCu7Wt4lIPR/0wtcxc2M+iZbSG9EvVElLAAq3Dx9xrXB1VtDKrl/orxRobk1xGdBCPmuFqZX/2JTp5j026a0HEBo8/l3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789535581; c=relaxed/simple;
	bh=vorASBaWuMZ812UZt0imZKnC0/rK4ft5COyrjUoHl3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPE4bkOsSZZvBJluSv70YENIrYDQt4GouEflmp9KDS0Zlg9DrtDNycQKGqBfdJQ5X/NrlvdbqFqM5/XHxuhok5hdFjVBAylvkyjQXoXcrZazgk0VMaJjyVFezpc9Gm3MgtY8J8LeHwh1GBQqeHHzwVv/8vaiwyxWskcQSjfGrxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=EfgKpsUM; arc=none smtp.client-ip=57.103.77.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="EfgKpsUM"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-11 (Postfix) with ESMTPS id 41EB6180021D;
	Wed, 16 Sep 2026 05:12:56 +0000 (UTC)
X-ICL-RepId: 01a0a8a1-e079-7e79-9d19-db160eeb5ce2
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ1NHVwGRQpFF0oBVBcOVk1dGV0EUgdyFFwOHQFeBVgRVBkdDlgGEhZdRVcIQUVeGVcSUgBWRVEfVFhBDgpfEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWVhVPVl8EWQFTHVhWUAJaS18ZXUUPXwdZBEAASQVdAloARAlWBlUCWQRIFEkeCVYFWxVVOFcIQUVeGVcSUgBWRVEfVEYTGU4bV01aDUAZWAZtFFYVUgRZ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789535578; x=1792127578; bh=MTo5ibviQCqS1GHLnnbIZDk7ZkDlZGTC9ASsZ1Wi50U=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=EfgKpsUMNZH/eD8rrFeDJLJeNdYlHnwrr9zeei90M40L5J3rqja/SR18hkNtE7qsfzTQ3SRqLxrTZ2WrpUkzjSVvndN3f4ynjSqNKDkXgVkrc75BvlVcYq46KqjdKqKyBSFf8FTwRNqTC+Jhw+Hr9mObbboDAyLVki7ojy2gULZ7Pf2BLp7q+PCM21oxIut/+rR/VdAFzDRdpA+YiEnfPyHQwcMKV3Jj3pccg0j4Jyz1MkQF6NLtC14TDDvdTiuxoLUl3Q408t7cAErtX9z3g5SaQCtulsFGLZXp5V3cxQo+/zPCqvxm343dtIqZ/ALSB9dpOIf6fg69Eh7sC/Jt5A==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-11 (Postfix) with ESMTPSA id D82521800097;
	Wed, 16 Sep 2026 05:12:54 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: Re: [PATCH 1/2] btrfs: test qgroup limit handling on fsverity rollback
Date: Wed, 16 Sep 2026 08:12:40 +0300
Message-ID: <20260916051240.585268-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <afd05402-fdc9-47bf-87a0-df37a513b853@suse.com>
References: <20260915053815.307674-1-daniel@dev.linjama.com> <afd05402-fdc9-47bf-87a0-df37a513b853@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 48a7klcHXEtrm-dVs_ADqCVP5LSEIxke
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA2NCBTYWx0ZWRfX1lzTSjCPWYIV
 UtUWi4MMdOOjcY+goNpkH5bE2/8HAPJ16E0G/5hdIV2fsQzNKRdyARqb57f7jiULHe37mWlUJKj
 522qTmFx/oOWNVeyZc2xEwjscBqLct7oX/PqmYq7syKNAQVdR1qirsbkeo68zlKrrzaLXS1jHy/
 h48HQwcKSvKo3lv5hf9EEpdqxVwLj6/4Qi2ppBkL1hXNHr91so91GNLOl7kr7bdfz3GA0chjBBL
 IVC12vAuxCR9FE7gvmVTeE/D84omBiX/F1HtnTX1PdwmQ/TF9KB7rS4OgxlIBjgA03B/TKxzhtM
 g1ouNjC9PebJ43FwRXQASnqAVUGYbl/PS2UVBSHKtzCc55ud2Zt9NYoobOaaLI=
X-Authority-Info-Out: v=2.4 cv=M+1A6iws c=1 sm=1 tr=0 ts=6aaa2558
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yb1XOp_2IUZ1KS_rwy4A:9
X-Proofpoint-GUID: 48a7klcHXEtrm-dVs_ADqCVP5LSEIxke
X-JNJ: AAAAAAABGxo6eXIVdgrwsnNe7xxI/8rjXI5BW0d5SeGp65QFIrwSDnMugmCd+GS9ddwqPvwZHtMry+pFeOZwTmm0xoMBL4BxNXYMEKYCZXxAUZiE+m5W63lnftKOrVwKOKo1PeTJC+oLaalLDOXPnJl5CT+WxxmwdX55xxgIIK8fMwVRaJY4n9r8FVRv+aPQ/ApqK2HsFS3N2jV3WruTmveztf+HHDqo9CVmG76KzZCRo9XNMAeJX1XTcYbrkv9U4qvHxYECaO9IlXygT2+R7tdh3aez6RKV0G6HZMh42P/Gl0vczpg0tmt8gA8EMzd1OAmz6Xzc8i3gfwrof+rT8IWUnwKLcpiA5ciXQvaGAc7WCsKA4t5lFqYEfp9cnPUAUB9sYLCKfMsqmWBgoapytb0xBk3i20SR45LzB+QY206ukEGpj+APTvAnz83d9eXr/+PJ/XtduHLhbh+eUlgLWY3h+HdopXISCBtnPR8+UqR4ldtVeURGrjr1B3oNslcMz/Ms0T19at78M3tBmSwgAr80OAWz57X6LQO+1/Bzua633Zj8dUW33VD9oqQt+NR3rgDTttOkd1viUJvwq/R01yBZBZCyj2vzesIwtF9XQo2l7VdaMgt/tap1vZIcL+k5NXsLQJp4KDxTA4cUDk5c2CxcGxlcW0edrPkoiId6FD9QloOatavm/t7/iTL9XSP9zfPYyDyiCioJT8qAiRfWV9Ju2lPpvzdVohEusjIez7DY5YbSunLuA6gjKsQibZiEKfzdchZiOtYpGQNoaRaENDuGmbotoXZXoI7i6C9abgSZPxJaFjfY2sa1wUfoyofhipUt/bC+cSjwcRDrcIQ7XYLbrl33n0mX38gg3Vyp4ganRXZ5rgsETKZJZsBbczJ9stxyKYLumGJ+fErLfaXLVGrFTUczPG6nokoiG7h5B2rUez5aVM0vAQwsGZFcj6SIWFEDI3Z0fnOYPLUr0aL86dL24VJ6gmh
 P5PvIVezy+tMcngjkEJcCpGebYWlFtN9E/aH9jJqQt2qIn8LgY183sDTr0AUBiM5s4+OOqhtX19eAeBWcFAM+AhT8oX1jJ8G03M13uXRxXOi4wMOZs1uy4WQZB0z0TLW0KWRaPuZB0Zo7slTA9yM45Q7baKTBFoziYXII4PktF4MjcSzOmGl/Upp1uAFAbPP1dbyrhRpp8zXgYElJf9eO3Ykdvz5lVKqK4G68VW6if7p5kmfGdPwU/A==

On 2026/9/15 15:20, Qu Wenruo wrote:
>> +_require_btrfs_command quota
>
> _require_btrfs_command quota rescan -w

Will do in v2.

>> +    _qgroup_rescan $SCRATCH_MNT >> $seqres.full 2>&1
>
> Use "-w" option, or the rescan may not finish in time before the workload.

_qgroup_rescan already runs "btrfs quota rescan -w", so the test waits
for the rescan. I'll keep the helper.

>> +    while dd if=/dev/zero of=$subv/filler.$i bs=1M count=4 status=none 2>/dev/null; do
> [...]
> You can just do a 40MiB write (which should fail halfway), sync, retry
> the write until the write failed to write any bytes.

Will do in v2, with xfs_io instead of dd as the other tests do. A single
write turned out to be enough: after it fails with -EDQUOT and a sync,
nothing more fits, so there is no retry loop.

Thanks,
Daniel
