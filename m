Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013008.outbound.protection.outlook.com [40.93.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8278F486BB4
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912803; cv=fail; b=hXbyx3bRp4GqoDIQ/SIOhV4he33Y7EhC+EUXHlXGKbLWFvogu72T5kRl0cUQwRP24ikdM1KkXKK6pIfdR0aqiGm9AV98l9xyCh8apt71NC9CL2mmOuWPNzWP3sEL+Zc7t9bgTste7dtlAGtGMcHUDXeffq/LO8L5G2jZDhl85dU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912803; c=relaxed/simple;
	bh=ysxCdLDOFLmwLtJfIw45saRU9kLkaMpc5OhEQZTEdjw=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mr0n2fczTaGfX5VX9vuu9Llq/lQYqWncrcLAqqqzhjpr5Vob6sZ3AbLoxkgG6qok/XamNKNueEhrVQt7R6nhGxAN8GE6CmihJTiMwXTNgnV+be72PiDH+UMA2Yxroh2GDVEx9FVLCmdV4YCFAb21JIYDZCP8D/Kou1tTDcEhLT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=eaton.com; spf=pass smtp.mailfrom=eaton.com; dkim=pass (2048-bit key) header.d=eaton.com header.i=@eaton.com header.b=WHpQOBwL; arc=fail smtp.client-ip=40.93.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=eaton.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eaton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=eaton.com header.i=@eaton.com header.b="WHpQOBwL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cp1U1cgsKEPxRaiTwcbsW0iFURBEAVUy1N4BIb93JnTy3Mb8on7UTlqJczo0UlyF86rNXcgLpTu6mE6V4m4vzFc9qtGdxkc8910cbWozMU7HsqLbY/R3kPFPuDgX2gK77deCA5NTEYdSgKuHnFD582Hl7eN1J/adqA50ZmO+BDAG0Pcq68P8sHnVeRWbQPO65JBRQku4PJve9TTyMXK0V07tHif7VoQE4ePZc8LG8gbPA9dkzQYShlLx/D80xp45ITilcdIx9sOyifOHomN6hOrJZeYt7vWX88nU5iKJ9J56nM75WPaKt9UctXCvHec4sCfJ7PmjMG7n+dWn5EV2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysxCdLDOFLmwLtJfIw45saRU9kLkaMpc5OhEQZTEdjw=;
 b=SclVmcBChC7bhd6xRp+yxFuU7IDw40lCd0cVQRsQ5H8dwRG8W4FhYzmeKi0NAGbjVlzXWohXQ6mASQD//NRaZ5X7Xcaj3XvUaT/mB7Gf8yw8nN9AKwoSrZQjpyzaYQVG305X2R/Uz8g9CenQ+32a+ov4bvWo+1C/Vtfia3i4M2rFqzlH7SfmJ4Q6bllqkpdnI3aU9KGLSBXkKJVZ2CPAD62VJtlAcfn0hjqNO0AkGQejIGcBa7VG6kBCLpp1OV78mJfduU2L0vQJixpJ3U7VubS2eCTBlq3l5J4bARGtCODF/Du2wmejZ9e7cU4BcVgtPvjsgPEMbZVdervNUoBQNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysxCdLDOFLmwLtJfIw45saRU9kLkaMpc5OhEQZTEdjw=;
 b=WHpQOBwL75QyNJxhDikbu/YbRx5+FV83piP8ATCZ5iLe2JTJUVU2T5cxsCYmkZdFnFPfKiu8EfSLPCOR9QDEpkoUIausBAKMbaAvyEs7TKQbgYLWXvCbPKau4IV6Hw8GBWSC6Nijb/hOkXo8CqSF817VbPu+0KyU264J2EynxMy6bm8TUVXrODD9mtlfSFWRJ8PqnNMx+306GfewAVX4CCJMrXVoRJz+pvHl+aRB4l1kRMjxmHlGQvHPi5DeCvwKrrMAqlXgtNvIHmzm9Bb05YPNbXFYYnAhK8jou0FMNAiC83I1rxnh09RM2Y/DpPUYRO8VNBodH9Vp1so0MpxVaw==
Received: from SJ0PR17MB4288.namprd17.prod.outlook.com (2603:10b6:a03:290::11)
 by MW4PR17MB4387.namprd17.prod.outlook.com (2603:10b6:303:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 17:33:19 +0000
Received: from SJ0PR17MB4288.namprd17.prod.outlook.com
 ([fe80::3940:81a0:dc78:7646]) by SJ0PR17MB4288.namprd17.prod.outlook.com
 ([fe80::3940:81a0:dc78:7646%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 17:33:18 +0000
From: "Naulls, Peter" <PeterNaulls@eaton.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Btrfs PREEMPT_RT transaction-waiter livelock: experimental mitigation
 in kernel 6.6.78
Thread-Topic: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
Thread-Index: AQHdV/zYoCdqLEUpiUCMf474Lb+SQbb7wAqbgAABf6s=
Date: Tue, 13 Oct 2026 17:33:18 +0000
Message-ID:
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
References:
 <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
In-Reply-To:
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_ff418558-72e5-4d8e-958f-cfe0e73e210d_Enabled=True;MSIP_Label_ff418558-72e5-4d8e-958f-cfe0e73e210d_SiteId=d6525c95-b906-431a-b926-e9b51ba43cc4;MSIP_Label_ff418558-72e5-4d8e-958f-cfe0e73e210d_SetDate=2026-10-13T17:33:18.181Z;MSIP_Label_ff418558-72e5-4d8e-958f-cfe0e73e210d_Name=Internal
 (IP2);MSIP_Label_ff418558-72e5-4d8e-958f-cfe0e73e210d_ContentBits=1;MSIP_Label_ff418558-72e5-4d8e-958f-cfe0e73e210d_Method=Standard;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eaton.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR17MB4288:EE_|MW4PR17MB4387:EE_
x-ms-office365-filtering-correlation-id: fdc87332-fbe7-43e4-5b45-08df29501235
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|6133799003|10067099003|22082099003|18002099003|11063799006|4143699003|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 Ci6joQN7ftbNuSli/CeEfVkv66Y0CeAWNxl+9wFo9z1J2mKy0+Xid6frW9E4Xkgsi7BDjxBt4IjSeQcdXXQTdX4c6dzeK1/Z8DaHwNiKsAkBRJ3REgybjDTA9H+DCPcmv2U912tywxlM+rd4q5/g1s7O+nTh7v7DgAFS9LPTbR/vi3TIgMTxhzL4bAeBR4yEI+3bjHMfDKb1w6Sigg8EbJjZRW/yq725jzatpC3AxYoiQNm91kvDDNcsDUR64aqsb8edcT16mczRIKE7AOXzpX2HU8acM6zFlbB/fsDVT2s4Vah8YpCjYdpn+OtYbbeswsYB5gBqZIkKrGDpFYvEo1sdpIUf+UlSeAY8lGUvh7IUu+apzT7z9FlAJ0R/5hTtSeF85nqcAdc/IMzqr5WtyPTfFxI+SFRAdD2vCD6cTzpO0B/YyeYML5fBlJNxTeCUfO3Qaom0pjJXaioWygBLMnxVwUR02PuqudNJ+iaZOx70Zy66e3mF9+IBhbz33YFiSvtj6Fx0TIMa/unapVQTctUgyObNpLZOSuy90J+jnrp6MLgVnJgtSbdpxLEaRtPTPHtXOkbxIirF1LuIX/HTQUC/nuo7LXvkix73UixiMP/9DS6K7Xv+aotQ6+SgRTsToXO168rUf92/hwSUNgbNbdz/EGgQPqeeHFdx3eiTu7A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR17MB4288.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?56MNAAehbfCJRS8RTXg4TOoVaBoARZG1jwiC6qEe7bfGU0M2LkGe/TabhU?=
 =?iso-8859-1?Q?R8aha4trNT0fxsBDMMYSetVv/bCr/WHt+HdDMQEC7jbkbX8HnViKS6RvfK?=
 =?iso-8859-1?Q?1SBIaZvIKA0Sw2iIWg6I8ZXBBF3R7IUEjoUg11H2vgOI3k5fLmpoNy3iMX?=
 =?iso-8859-1?Q?oUv3NUjqiabq7QbfPJ0N6/P5ha+tElcJ2m7BHw8tbyDuQK4nhXPEuPlC9R?=
 =?iso-8859-1?Q?C/ce8xjM0A9YGFlqQG9yPRhvyYCJC38wxT152JKhwxJsno4V7BVXrxpkLx?=
 =?iso-8859-1?Q?Rrx+tbzxQWznI2cF2ctSmcN+A9pmLxr83Ia3N6srPRbEOd/2zI+BkBXfOG?=
 =?iso-8859-1?Q?wXLpcareRlUy5xdribT5Ed2XPAa+FTEDT1yf8H8sBm2Pe3ZeElt7Soy+e4?=
 =?iso-8859-1?Q?9nxXS/86h6atlDIdKsGg4eKfTIM/dwbEm4jLvE0yUkQFBcZgOsoC9ZDNEX?=
 =?iso-8859-1?Q?f/D7AT0kB6MK01f2h7jLmFrwgheiw+8ortojC4MyarzfN6ny/bi7w+dJsn?=
 =?iso-8859-1?Q?zXKXBxTDU2HYrDKrud/2qXGtUmZ06aTnjXQFyvIYC2tSoDCcuVh5v8r9Dj?=
 =?iso-8859-1?Q?/uLX6SKkQsh8tCs3LpB97Gi3ULeP4NdjJE8ht4wkmERcu8sj3J3nG/4BS1?=
 =?iso-8859-1?Q?ml9eGYKrZOgY41/Rinqj7WzlVl6gzmayaL5Fdu8qThEXd0118EEwVgXzsP?=
 =?iso-8859-1?Q?sEO01ZqEr1PFQmhbKIMFlM8Pes29ujv+3o6vODZjlWWoqW/5qMRybKCajI?=
 =?iso-8859-1?Q?JU8Aep+LIAfRTKJICcc9DBCuKLHRo4e+IKCluT7rdlefqv7DjVp8HwvfW6?=
 =?iso-8859-1?Q?m6YVlnG7ahALH7KaAiVuULT5yTS3FcOtexmj2wJI3zRJwX9IKkkwCKPbsI?=
 =?iso-8859-1?Q?vs9JzUVGwTyHgwUp7EkPb3S9CwV4iprXOALktTGgf0z/Bm8xoDiJatL0K7?=
 =?iso-8859-1?Q?rxkXR9Mj+RMnwDXtXocSXbgHtnH8zSev+Pmu0Wp8kUZkmiGZ5NTnUsOuK2?=
 =?iso-8859-1?Q?N7wLmfZeHtPrwPHmEKta84wO2yJ7b6SlnL+EM4zhhOb3l9HNtsHxY+CbP1?=
 =?iso-8859-1?Q?RKBiFOpBkx/6sR4ydkjf6X2RjKQpcU4KlIw5aO64qW3v1AY8ivbCUUvE5M?=
 =?iso-8859-1?Q?3kB5dY38Xmsjfsb09qVjXh7Ur/V4pYS9YKCQs/+BxQb/oInnBqH7TxraHe?=
 =?iso-8859-1?Q?0VndoFH9Z1PjhAdDamQM4lpa+8eVMMFHWFf3erNt35tHVutQE8jDLbCewA?=
 =?iso-8859-1?Q?ZaPmHCcQ3pe7kSX1scPcDZJMEqd+dY6kCstfrq090DjGA8pe+xkhzqriue?=
 =?iso-8859-1?Q?Aws8NULeo7BLYps2PuGha9G+eQSEPazIj4Tg2Wf6NNmpHslJYZ5Iq7jKhc?=
 =?iso-8859-1?Q?Mb9PqcAmYPPnP1nLnDw9HPLqt5n1pZgRv1As2W0K8C2s8sVwAk4nfBptWl?=
 =?iso-8859-1?Q?4pU+vBb6aMTtGS1KTS6vhGnzhYT2L98BunPE2g9/IE4vWdGoSdwzE2qRw9?=
 =?iso-8859-1?Q?GnSmg3MOE8TO5pJFVAYe12VM1Q3TCsktFyHw4pU/U2M5g3btf7qQxGXPU6?=
 =?iso-8859-1?Q?SdMXwCuLKPw5ou31rMe4IM3s0sXvQyV1feP5dT7Q6YLmjdgaBZbe4hWYYy?=
 =?iso-8859-1?Q?gnfqh5Mm3Fi+gkOI1yMyTV7f7XKFbvzcblJV+NjQUIYUBvykgtuE19kQnv?=
 =?iso-8859-1?Q?S9owzRn9rfQkZCD0Ctmrj8giE/d/UJJcCf8P6aKRYvhEFtfP1XM3/u2buV?=
 =?iso-8859-1?Q?rGFWs+PD5bxVx2Vp5rRNFcqttyLG1Qlpv1wsTMg9urY5P8?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: eaton.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR17MB4288.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc87332-fbe7-43e4-5b45-08df29501235
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 17:33:18.8920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0i6gewpagfRyNzK48NBkCsDyzmR+K0Tn3NITcIPt6DmXMsXTWXWVC7Tu2PQscVLTYaR679xGgQOcLdh3xtZ2Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR17MB4387

=A0=0A=
Originally posted to RT mailing list, see post and replies there:=0A=
=0A=
https://lore.kernel.org/linux-rt-users/PH0PR17MB4277167A37B20340B231443FBB9=
22@PH0PR17MB4277.namprd17.prod.outlook.com/T/#u=0A=
=0A=
________________________________________=0A=
From: Naulls, Peter <PeterNaulls@eaton.com>=0A=
Sent: Friday, October 9, 2026 11:34 AM=0A=
To: linux-rt-users@vger.kernel.org <linux-rt-users@vger.kernel.org>=0A=
Subject: Btrfs PREEMPT_RT transaction-waiter livelock: experimental mitigat=
ion in kernel 6.6.78=0A=
=A0=0A=
Long term kernel hacker, but very infrequent contributor.=A0=0A=
=0A=
We are using the RT kernel patch on x86 under kernel 6.6.78-rt51. Specifica=
lly, this is the kernel from meta-intel in Yocto Scarthgap in the intel-ker=
nel-rt recipe.=A0=0A=
=0A=
It appears under some high load conditions, and especially triggered by cal=
ls to sync(), there is a live lock condition in the btrfs code. I used copi=
lot for this analysis, with apologies due here where relevant. I'm familiar=
 with kernel code, and I'm well aware how complex filesystem interactions c=
an be.=A0=0A=
=0A=
Here is the lock we observe:=0A=
=0A=
=0A=
sync (PID 52371)=0A=
=A0 btrfs_commit_transaction+0xc48=0A=
=A0 =A0 [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]=0A=
=A0 btrfs_sync_fs=0A=
=A0 sync_fs_one_sb=0A=
=A0 ksys_sync=0A=
=0A=
ordered-I/O completion workers=0A=
=A0 join_transaction+0x2b=0A=
=A0 =A0 [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]=0A=
=A0 start_transaction=0A=
=A0 btrfs_join_transaction=0A=
=A0 btrfs_finish_one_ordered=0A=
=A0 btrfs_work_helper=0A=
=0A=
journal/fsync callers=0A=
=A0 wait_current_trans+0x33=0A=
=A0 =A0 [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]=0A=
=A0 start_transaction=0A=
=A0 btrfs_start_transaction=0A=
=A0 btrfs_sync_file=0A=
=A0 vfs_fsync_range=0A=
=A0 fsync=0A=
=0A=
btrfs-transaction thread=0A=
=A0 transaction_kthread+0x76=0A=
=A0 =A0 [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]=0A=
=A0 kthread=0A=
=0A=
=0A=
The processes are then not killable, indicting a kernel thread problem.=A0=
=0A=
=0A=
This was largely found because our userspace code calls sync() excessively =
(being separately addressed), although that's not the proximate cause. We e=
nded up writing shell script which writes blocks of data to a brtfs partiti=
on over several threads and also calls sync and were able to repeat it with=
in 10s of seconds. It is not repeatable in the non-RT kernel.=0A=
=0A=
To add:=0A=
=0A=
I have been extensively through the later kernels in 6.6, and later series =
and have not found any direct fixe or references for this. I've also been t=
hrough the latest RT changes and btrfs mailing lists/changes (and this post=
 might be served better there) and cannot find any direct reference to this=
. The only close match is:=0A=
=0A=
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=
=3D99da896614d17e8a84aeb2b2d464ac046cc8633d=0A=
=0A=
This is in related code. I put this patch into our 6.6.78 kernel and it did=
 not resolve the problem.=A0=0A=
=0A=
With that in mind, I had copilot (again, apologies) have an attempt. It cam=
e up with this:=0A=
=0A=
# Experimental mitigation for a suspected PREEMPT_RT Btrfs transaction-wait=
er=0A=
# livelock. wait_for_commit() can reselect a completed transaction that rem=
ains=0A=
# on trans_list after its waiters are woken. Skip completed entries while s=
till=0A=
# waiting for older incomplete transactions. This is a diagnostic hypothesi=
s,=0A=
# not a confirmed fix for the observed lockup.=0A=
# Review notes: the scan is O(n) under trans_lock. Completion state is publ=
ished=0A=
# locklessly elsewhere; READ_ONCE provides a single load, not acquire order=
ing.=0A=
# A multi-hour run did not reproduce the issue, but the lock owner and root=
 cause=0A=
# remain unknown.=0A=
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c=0A=
index e15e1855fa0a..0f05fabe451c 100644=0A=
--- a/fs/btrfs/transaction.c=0A=
+++ b/fs/btrfs/transaction.c=0A=
@@ -865,6 +865,7 @@ static noinline void wait_for_commit(struct btrfs_trans=
action *commit,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const enum btrfs_trans_state min_state)=
=0A=
=A0{=0A=
=A0=A0=A0=A0=A0=A0=A0 struct btrfs_fs_info *fs_info =3D commit->fs_info;=0A=
+=A0=A0=A0=A0=A0=A0 struct btrfs_transaction *next;=0A=
=A0=A0=A0=A0=A0=A0=A0 u64 transid =3D commit->transid;=0A=
=A0=A0=A0=A0=A0=A0=A0 bool put =3D false;=0A=
=0A=
@@ -893,10 +894,16 @@ static noinline void wait_for_commit(struct btrfs_tra=
nsaction *commit,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_lock(&fs_info->trans_loc=
k);=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 commit =3D list_first_entry_or_=
null(&fs_info->trans_list,=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st=
ruct btrfs_transaction,=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 li=
st);=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!commit || commit->transid =
> transid) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 commit =3D NULL;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 list_for_each_entry(next, &fs_i=
nfo->trans_list, list) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (nex=
t->transid > transid)=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 break;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (REA=
D_ONCE(next->state) =3D=3D TRANS_STATE_COMPLETED)=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 continue;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 commit =
=3D next;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=
=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!commit) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_=
unlock(&fs_info->trans_lock);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break=
;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
=0A=
Note the O(N) time here. To that end, this is very unlikely to be the corre=
ct fix, but I hope it highlights the core problem. I ran this patch for sev=
eral hours with no apparent problem (versus seconds of a lockup in previous=
 testing).=0A=
=0A=
If there's a later kernel patch I've missed, or something else I ought to b=
e looking at or test or need more info, please let me know.=0A=
