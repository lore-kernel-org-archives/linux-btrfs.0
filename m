Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.44.105
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795761078;
	b=f+QBxgowOWIw4CMrp2MmmAiP4PEj3RfrfKq7DR1Jme6SpwPsqmV+Z8wvVoJFdhKtTyR3
	 L8Ukg1WESNJMToq114u1zegWnlMbaHNtb8UCBJyCKao5lxFuSO5ldGuvr1Y3n1g4cWaAx
	 O7voinHUO73pXs9xE4T3fZkB9EqxHG/+XLg/QDNjRYLsFEC/0P/l4CiibhIPy/0GoSUfh
	 N4PcPFQGGjHPok1gLcYjEDwmoMGc9igQq2X7oVUiLxzCSUK4EsK2zwoVbtYhYk9OFuLdY
	 QSQ/Z1ZRjH/ua4jrSoQ+kgUFL5r3RiEnbn0EWBVztoRoM5gZH7eAQXFST/16z0wEYBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761078;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-traffictypediagnostic:x-ms-publictraffictype:client-request-id:
	 request-id:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=YtYrxB4zH3z814oTM+kxhHUOfGgZKnCX04mEQjtFKXg=;
	b=5tghJQ9f3pSI8YfGgZLgadEB2gMM7F4we7mO13ztz4l9s8uS38maYN4RDg6Tcyodfqkr
	 crEJFmHsl8Q4yBI6qAtk1ooROOakvbYzfNXC5Z6+nCIB5dkasaJX/sRYEr0jiJgu9lPyr
	 fmhsXMCtT9Ja9VsR28x6N1iISucOQ8A/O8ursBPvCP2CSfqb2D5pncNDiitkGn1dCm2+X
	 evwH37zkzLbFFUTFxfu2rySIbfyCkQddAWaO/FUxBQYcWCKFpUGWC8U2iU2gdk86EO2Bf
	 8mIWUWQxNkQHm9x0dBM4RH2kY9tVrpy1hP9rUhRoJHtH/duLz8xWfFbc3ARIxt9pboQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b="DaG5uz/i";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.44.105
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023105.outbound.protection.outlook.com [40.107.44.105])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F4606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 06:31:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A98F4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=DaG5uz/i
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kz3TOlfKridweNJmOrAIpi6SugRAJJG6EZDhzml+dNJUpjM7BfY8qZXOH5qUkH1geLMHjLlb22kV4aeaIvy8TDmda+gUcixlx/TAzrbAA3dEg9BbM7NjGjkcxTgayr/phTudsjhXrpcrjQjEW5OykiKnz2z+DUrVv1UpxCNr9QVxwURsLIY+fNqmiRkTShQu/6HchYmAF8UU1NjiS5dHXL/zKszkcliNe3q6XkwSdetYYm1cwHqt4mEBYOgS6ic+/Nc4FcN7/mKJN8k06dMiEiRkzl1xPZVJDYNQJ1wn8aNrc0L6otFZBTrSGBJTncCmAuqIpylH6k81Q+DN96HzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=YtYrxB4zH3z814oTM+kxhHUOfGgZKnCX04mEQjtFKXg=;
 b=wDIxe0rBKv4IdvfyWg2kMnjeCGRnNjbKQSJ73TqCW4xi7MpjwAyBM9SfUYSoSef1EvBWrTqIbazaJBMq1KyASPqsFEHVm+aMW7KN5izVI5axHZMIv7EfFq2QvDJClFBjIG8iPJtsZmgqR3kYynO2c4DCrvCfqFdd2fZmi2ryUXCOW7yTvHpOq6oe+ZI0IjEF6O5WdBg/CxXAiA2G9Fl3K8V2e499LnFjeeYx/7+AoXk5ha8fXRvNDNpJcTAiDGPuOYNIdguHoxc9akBKWA0ykoIMzDGTGfcqZ7Qr0IKSkF5oh7ApIk+xj2/9cHtev4EqHceF8gii5CDlyfUPi+T5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtYrxB4zH3z814oTM+kxhHUOfGgZKnCX04mEQjtFKXg=;
 b=DaG5uz/i/A7QySpO7GBzKkiaGkb3zODrEZyXEpCi3bgjVRquli0d9FPoR5nHj++pO6ABB+wGJMLgs1misCw9yk9JnFfZkPDzMVZE4jt6csN78Vs9ljXEZ6HYez51XM7RxdehNFf8t0fEcf9W84BJswWVgnrKhDrhdnH/7jJkgPc=
Received: from TY8P153MB2376.APCP153.PROD.OUTLOOK.COM (2603:1096:405:3b1::22)
 by SETP153MB2173.APCP153.PROD.OUTLOOK.COM with HTTP via P2P; Fri, 27 Nov 2026
 06:31:10 +0000
Received: from TY8P153MB2376.APCP153.PROD.OUTLOOK.COM
 ([fe80::cef6:d8f6:6528:90c2]) by TY8P153MB2376.APCP153.PROD.OUTLOOK.COM
 ([fe80::cef6:d8f6:6528:90c2%4]) with mapi id 15.21.0688.001; Fri, 27 Nov 2026
 06:31:09 +0000
From: Tianyu Chen <chentianyu@microsoft.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.com>, "mason@kernel.org" <mason@kernel.org>,
	Ruize Tang <ruizetang@microsoft.com>
Subject: [BUG] btrfs: RENAME_EXCHANGE with a snapshot's subvolume placeholder
 aborts the transaction
Thread-Topic: [BUG] btrfs: RENAME_EXCHANGE with a snapshot's subvolume
 placeholder aborts the transaction
Thread-Index: AQHdfjjGkQMvPYI5i020xgxflxV6VQ==
Date: Fri, 27 Nov 2026 06:31:09 +0000
Message-ID:
 <TY8P153MB237624AA8DAAC5323DE20B46DF412@TY8P153MB2376.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-27T06:31:09.420Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: TY8P153MB2376:EE_|SETP153MB2173:EE_
x-ms-publictraffictype: Email
client-request-id: 8e7061eb-aef1-47a2-b48f-78b0a451703b
request-id: 7f67faf6-ddcb-4a62-cda0-08df4c500660
x-ms-office365-filtering-correlation-id: 7f67faf6-ddcb-4a62-cda0-08df4c500660
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|11063799006|261009223027099003|18002099003|7146999003|38070700021|10067099003|261022105027099003|56012099006|261102123227099003|261022075727099003|261028144727099003|261026140227099003|261022113327099003|261026121527099003|261021121427099003|261021123027099003|261022115727099003;
x-microsoft-antispam-message-info:
 rCJB0+fRajahMq3z9P8B+ahIUPvfoirJ0JCs3MQAPk8/xq9FUHUlgO7iWW7dvZsuv7XkJ3mbBrCTog5p5GKCkQ68tSz5xmuUZj+gf2VjNcqAVzeYAhVnA0mYtAOiQCGpyu9CpgXDzKlJ1cfRLhHieOkv3uoQ3iuVDB7+sxo6xoE4vlBa8SGMzq2fwldcSYUlJ+NvWx5vpKcnS00K3Z34O2dp4S4oc9deWDqVW3aR2dpkLnIK/Qxi53S29pQUj3JJdlDRr2uXvOAUjgSsSUI8zkrCupomFRiBJAXQnxSsZpBM+566lovPOhgVf4Kz5LdxdiLJxLV2QN+eh0JZmWUvoO4wsipWQVtHTM/QVApi3/Jhb27kqYr6kns2mPfJr/Y/xOONv/klsl/07q+goGcwRWcV4jBDwnZzaS9PNhvDeIK4jz9FfFni4KkUfit4UPrt83BW+UcrL07fEXdEeiaEHlueu/36kzcnWX5ud/51P85YEcjK+a98pZK3LkXGP7HONn+fw0pH0L/eQKz/krDsdb2h/KawzJKrtroCMpEDdjd+feotFJE0fwgXRAHgE7Tc1krHWM4LFYn6V+vZuAvm//kwgFpIsjdaTUPOW4BkJIV4EgRJVNIC2XkQhHd9AixQcxBF61ch9X+df4nys6gF/oQQEGJfYMrCb0fW8inVJBGpqPp6KprMnOr+THyf3Zbpxw2HJHhu5aMH4V3dH6BU7wgt8lBDasmhCN6vQ6rTsRY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(11063799006)(261009223027099003)(18002099003)(7146999003)(38070700021)(10067099003)(261022105027099003)(56012099006)(261102123227099003)(261022075727099003)(261028144727099003)(261026140227099003)(261022113327099003)(261026121527099003)(261021121427099003)(261021123027099003)(261022115727099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?yLPEtIC5Sw4InDwFsxLti6Z3UCVB0w9RNrnEjm0UpW9XC7zJmUNLZI2TBe?=
 =?iso-8859-1?Q?QWzJ+J4hC1yvvaSnWg3vLu12RggTN7ZDglzF0cmSiUZ41W8vzZsLcl69cS?=
 =?iso-8859-1?Q?zwPlwfq3mCh6HXXAZSfAxPIqsj05OmRyenJ9NiueE5LxdiSXk4tVZSHxGM?=
 =?iso-8859-1?Q?o7zl5A8SP3tvuIJhkgC9KrSnL6wqzPuDrSTpI/Pb19nyRxTpdgJSCUVTZI?=
 =?iso-8859-1?Q?u9mBOn12AZHXTWQEJ2x7tk5ua7z3VC4jcWRgm5xr5+RV6ThuaixNLVXVRH?=
 =?iso-8859-1?Q?5VZk1fyL7c4U2UXGeA5Ae81QZErIqEz6thF0DqfJ0wVoIpPhem3W6S6sU2?=
 =?iso-8859-1?Q?6+Ym4rjjGQwmnxbdwLLLPYuIxyqAcc7sdw2tLWrKyk5LlPKhFxRwqSjRKj?=
 =?iso-8859-1?Q?IIYDFtRcyYjnxRy5gdn9yJqsmmp1NdNW+QY/9mMjF2Hq3BdpajwEx5fAQE?=
 =?iso-8859-1?Q?TUQINQiiWEsWyTHIOqRy/BJVwJMi7o9tXnO/CuYPuBl6Y0YienX6NN7JAq?=
 =?iso-8859-1?Q?7p1hKAQ6Jzm5yvobKFIiIltQmFM/b2IBvgnDdOAj0OCamz13NHuvcLStEQ?=
 =?iso-8859-1?Q?3qOLnZyiCYErN+8fN2/3wRu1j65duVrIznhzwHdjbM63EeFjXS5tz50Rsw?=
 =?iso-8859-1?Q?H3f8vajhMHExSeYLzA1lUhMVnlhX69F0f4ReNy6d3quxcPqTwhrsZehG1b?=
 =?iso-8859-1?Q?33gmn3dcgAS/vwv437tOLx03saWTPRpS5JQyPt78n85LtVq4Jvnwbqz1Gu?=
 =?iso-8859-1?Q?urbpJwlLxoPAXvwmyLW8k6KPJSH1HUFD23ahNqekH0/s/prW73sqsM74ex?=
 =?iso-8859-1?Q?v8/gUVOoZH9jdikwFk76hAPZ0oEMG7Zjx/aCA78M+SdRYedlc/KpBB/iRU?=
 =?iso-8859-1?Q?/l+yNXDbiIuF5XT0rW0LRP2RvRRPYif9KbvcGjsrby1QoXLrEVXxrh5XjO?=
 =?iso-8859-1?Q?dS2F/kNHYosqiJc+ymUnAUY6oJHuNJtFT+ZPOXVJuujiS/ZbtFbKKhtR5o?=
 =?iso-8859-1?Q?5JCUOVYuyB/Ja9KkYCgIv4Kbu0G9KJUv1T9CPRjMnKV2ykPoECgylpTub7?=
 =?iso-8859-1?Q?rFPHLeu6UgD5N6UTj5rgkFE+L6JJA2gqmptj3X2MW6fdoIC1b7R7K9bT+Y?=
 =?iso-8859-1?Q?diFZT9IGcT4mD/l201gLdTaqZrZ2TETW3++mrOOS/0Bp1opFyw4XU29N9b?=
 =?iso-8859-1?Q?46m0F1nPdMXdYHgpI3PtSwpyy/PurZZoYJy9PcKkLjG2COo1nxpU/lkM/Y?=
 =?iso-8859-1?Q?8PvSmTrrWqIRYDxC5ZtANkWnrWIHCqb/gEW4EXHZ5RLYW+hao8YyXPjXtK?=
 =?iso-8859-1?Q?PnTuu8qEHhsauyRPTEORBBmh1SMsdng0RaaO5h0MUEE6nZcwW77nOMshnd?=
 =?iso-8859-1?Q?SIrWxOMA5lTd/KjMqtcmySnfNbbQy/2EloyMtOcOK1sO8YckcZhqouOJrQ?=
 =?iso-8859-1?Q?OQ4vxSqBa2QcpIbJEnrGvsX5wmrHgFl8fYu6L0H1Gklg0nzKvPHH5DfDLh?=
 =?iso-8859-1?Q?UDuxmYlLXY9zp/GjmZmbiNsoItXOkPuWFB/vmISVyIlQSmXNfvr+jON2FW?=
 =?iso-8859-1?Q?+4pOZgQEgtsXYlLwMZSxbekwsdoR3fRNiD+lpIwt7PTFid/hfz0WxEt6GZ?=
 =?iso-8859-1?Q?DUJYylWm8ZG9Chd+r2MMKkS/eJpKcN6VtI8VLvndq8agPrr4VT8RvEBAPv?=
 =?iso-8859-1?Q?4PWpWKQ1fbpoSTkvTAFxMcvT7y3O8sI2h6vov601z6+gJhPyydoFL5PdhT?=
 =?iso-8859-1?Q?54OA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY8P153MB2376.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f67faf6-ddcb-4a62-cda0-08df4c500660
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2026 06:31:09.7399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zXbRkvf9mer/EYu+6NsXvxF6TNPWZ9ykI3FunTqrO2PInCv9bgefAABV/NSP8Gcm+T3Lu1LYIWh1mjeu5TMwb8uhoqVgNrPtmJsd+RbKFUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SETP153MB2173

Dear BTRFS maintainer,=0A=
=0A=
I found a bug in Btrfs.=0A=
=0A=
Summary:=0A=
=0A=
renameat2(RENAME_EXCHANGE) between a file and the placeholder that a snapsh=
ot shows in place of a nested subvolume aborts the transaction with -ENOENT=
 and forces the filesystem read-only. No privileges are needed: any user wh=
o can create a subvolume and snapshot it can do this.=0A=
=0A=
The placeholder is not an ordinary empty directory. Its dir item points at =
the nested subvolume's root item, and no root ref links that subvolume to t=
he snapshot, so lookup returns an in-memory stub directory with inode numbe=
r 2 (BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) that has no inode item and no inode r=
ef.=0A=
=0A=
Reproduction (as attached):=0A=
=0A=
=A0 btrfs subvolume create sv=0A=
=A0 btrfs subvolume create sv/inner=0A=
=A0 touch sv/f=0A=
=A0 btrfs subvolume snapshot sv snap =A0 =A0# snap/inner is the placeholder=
=0A=
=A0 python3 -c 'import ctypes, os; libc =3D ctypes.CDLL(None, use_errno=3DT=
rue); ret =3D libc.renameat2(-100, b"snap/f", -100, b"snap/inner", 2); err =
=3D ctypes.get_errno(); print(f"ret=3D{ret}, errno=3D{err} ({os.strerror(er=
r)})")'=0A=
=0A=
renameat2() fails with ENOENT (ret=3D-1, errno=3D2), and the filesystem is =
read-only from then on. Kernel log from running these steps on a fresh 1G l=
oop image (mkfs.btrfs from btrfs-progs v6.6.3, default mkfs and mount optio=
ns; 6.17.0-1022-azure, Ubuntu; the W taint is from an earlier hit of the sa=
me bug):=0A=
=0A=
=A0 BTRFS critical (device loop8): failed to delete reference to inner, roo=
t 258 inode 2 parent 256=0A=
=A0 ------------[ cut here ]------------=0A=
=A0 BTRFS: Transaction aborted (error -2)=0A=
=A0 WARNING: CPU: 32 PID: 3839527 at fs/btrfs/inode.c:4291 __btrfs_unlink_i=
node+0x3bf/0x3e0 [btrfs]=0A=
=A0 CPU: 32 UID: 1000 PID: 3839527 Comm: python3 Tainted: G =A0 =A0 =A0 =A0=
W =A0 =A0 =A0 =A0 =A0 6.17.0-1022-azure #22-Ubuntu VOLUNTARY=0A=
=A0 Tainted: [W]=3DWARN=0A=
=A0 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, B=
IOS Hyper-V UEFI Release v4.1 04/22/2026=0A=
=A0 RIP: 0010:__btrfs_unlink_inode+0x3bf/0x3e0 [btrfs]=0A=
=A0 Call Trace:=0A=
=A0 =A0<TASK>=0A=
=A0 =A0btrfs_rename_exchange+0x744/0xe20 [btrfs]=0A=
=A0 =A0btrfs_rename2+0x59/0x70 [btrfs]=0A=
=A0 =A0vfs_rename+0x787/0xc20=0A=
=A0 =A0do_renameat2+0x425/0x620=0A=
=A0 =A0__x64_sys_renameat2+0x4c/0x60=0A=
=A0 =A0x64_sys_call+0x420/0x20d0=0A=
=A0 =A0do_syscall_64+0x7b/0xb40=0A=
=A0 =A0entry_SYSCALL_64_after_hwframe+0x76/0x7e=0A=
=A0 =A0</TASK>=0A=
=A0 BTRFS: error (device loop8 state A) in __btrfs_unlink_inode:4291: errno=
=3D-2 No such entry=0A=
=A0 BTRFS info (device loop8 state EA): forced readonly=0A=
=A0 BTRFS: error (device loop8 state EA) in btrfs_rename_exchange:8285: err=
no=3D-2 No such entry=0A=
=0A=
=0A=
Root Cause,=A0(using the names from the reproducer: f is the file and inner=
 is the placeholder):=0A=
btrfs_rename_exchange() handles subvolume roots (inode 256) specially, but =
does not handle empty subvolume placeholders (inode 2). As a result, the pl=
aceholder follows the ordinary-inode code paths.=0A=
It first inserts an inode ref named "inner" for f's inode, then an inode re=
f named "f" for inode 2.=0A=
__btrfs_unlink_inode(old_dir, f's inode, "f") removes the original "f" entr=
y.=0A=
Next, __btrfs_unlink_inode(new_dir, inode 2, "inner") tries to remove an in=
ode ref named "inner" for inode 2. However, the only inode ref for inode 2 =
is the "f" ref inserted above. Consequently, btrfs_del_inode_ref() returns =
-ENOENT, aborting the transaction. This matches the kernel log: failed to d=
elete reference to inner ... inode 2.=0A=
If the placeholder is the source instead, the corresponding __btrfs_unlink_=
inode() call for the source should fail for the same reason, although I hav=
e not tested this case.=0A=
In contrast, btrfs_rename() explicitly handles empty subvolume placeholders=
: it returns -EPERM when one is used as the new parent, -ENOTEMPTY when one=
 is the source, and calls btrfs_unlink_subvol() when one is the target bein=
g replaced.=0A=
=0A=
btrfs_rename_exchange() has the same relevant implementation in mainline (9=
437ee8b6cf6) and btrfs for-next (14bf1d1d3641), so both appear to be affect=
ed. I have not built or tested mainline, nor have I bisected the issue.=0A=
=0A=
=0A=
Suggested fix. I used -ENOTEMPTY to match the error returned by btrfs_renam=
e() when the placeholder is the source.=0A=
=0A=
--- a/fs/btrfs/inode.c=0A=
+++ b/fs/btrfs/inode.c=0A=
@@ -8256,6 +8256,15 @@ static int btrfs_rename_exchange(struct=0A=
new_ino !=3D BTRFS_FIRST_FREE_OBJECTID))=0A=
return -EXDEV;=0A=
+ /*=0A=
+ * An empty subvolume placeholder (what a snapshot holds in place of a=0A=
+ * nested subvolume) has no inode item or inode ref to swap, so=0A=
+ * __btrfs_unlink_inode() would fail and abort the transaction.=0A=
+ /=0A=
+ if (old_ino =3D=3D BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||=0A=
+ new_ino =3D=3D BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)=0A=
+ return -ENOTEMPTY;=0A=
+=0A=
ret =3D fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fname)=
;=0A=
if (ret)=0A=
return ret;=0A=
=0A=
Best,=0A=
Tianyu=
