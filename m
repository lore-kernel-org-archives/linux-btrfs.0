Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020134.outbound.protection.outlook.com [52.101.150.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F65CDF1;
	Mon, 16 Mar 2026 10:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773658622; cv=fail; b=F2zSYtinQLfOgCdLWmoIpNI1MLRdoAJizdAbP418HtX6eClkDmfeCbvvaKMhPLEVx8YhQaSJY6wtuf7Kpn/bQcyBuwDoEvIPFAb64A5wqoP1D5JIsIwkqx5OQ461VuTLlSZq4HByquknymfgga5pOwt+XP10sDxLsVoR9XdRc0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773658622; c=relaxed/simple;
	bh=d5hNtX6DpWb48mk9GMOtWsv4+ZkGU1EDB5Jdxm07lYE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sILLaUfx3e5WIu/v48t/OCqlsAvzeRuFlnY2KBR1Hnkmru9tf//rgmzf90xKuqhnaG4SkDvMueyId1rgrS98e3xWLWFD3NiVWIFgVZbpVohnc5IVkAjcaaC7okEleX4PJVrSmL/PaOpQDPu6s4VVeyFgrqdOpSq+/9paHeISlJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=gejhQU0F reason="signature verification failed"; arc=fail smtp.client-ip=52.101.150.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="gejhQU0F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRn3KFGNkArWzTf7Wc7Mlx+cTJYE9jodL6pEwadEaTTXx4M38iFbQhTJewNYbi6D6r+X60/mPnrP+oFiYlLHfw7+rZ9m0jiX6fbNXxBwPL8KP6oT9uHNjwCVyAXVTinOMLv5DWzEmWvlfEqE8JAGBAQL8lh7TD3UmhqIJXfM/rx/fMGJQZd6hHROCxJuoyIRRiUDtUfUqqsY69sFioJLDhnbVipzi4cFT/xDxCVkWm8uI27L6yBjGFAu3ZrVvT+Mqob1bFFxhluIYEfjb85sUH7th2T/4s5DqWaQbaI0VNA60Xi8EGPz8XFqf9LuEXi7WjafKOHcckCwfi5JoGN43A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOCCwPojCpX/58d++EKWqx5C9P4/Vfd+2EOtU0u16BI=;
 b=uhs8reGj1DAnlggZf47xWcvhgpMg34lc7f8m0eausen5SYG2FnbEj/Vfj41ddwDODDIF3aRdmVuMxfQT5dRQc2D/+3dHr8mfHdurcWIe/26GkFqF08pQ4PZNERleXH+CAPdPrr7cyAd7d4hxlmUc5I9OaAWpFhUcJnObDPolmBLDVHit7qLfZPQ6GW/dqCEoeQeS2OMr+ch2zgKIjQLBbzYm8k10bIO5SfcmhvACmosXDge23cJ/xrxiflaYYk23cuAh/paNf2QOruS7ONM+2U2AzaBeKJfG1J8VbK88BOtbWm31Bn7D7y1Kaq7WMaMdD8VijeZZw9w+Xl2ey8Y2Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOCCwPojCpX/58d++EKWqx5C9P4/Vfd+2EOtU0u16BI=;
 b=gejhQU0F/9oJuNhgABSoUhY8RxSH0ihboG0ZoAWQWPOKTIoV/NlVEO3HSqbz4mSR9cuHMd4Nn0GTJH4FcMNamqHZJnrIL9fcGzzXO3zk85F0nGmSRl+qMFQbEdUWVwlPl8pi0xKCw7qtUUt6puBAWbiQsUM49BSBbIfGnmeb7XnLtNTk5z8di9GKaKCeKBpbShLgrSY0m/iryMnQHNhgKQ3kBVI+G3TwQRMCqq4JMPVSlu8x7ygMshd/rYIqo5Y+IIEmVmu/SGTQwAxobv6XWpHz02NkD56UC+EdToT0bvIKAyYRz5AuQI64p35ciqt8MHsCz3IQqabbJAHeKgtfuw==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY3PPFFCE4AABF2.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::4ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Mon, 16 Mar
 2026 10:56:56 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Mon, 16 Mar 2026
 10:56:56 +0000
From: Werner Kasselman <werner@verivus.ai>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "wqu@suse.com" <wqu@suse.com>, "dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Werner Kasselman <werner@verivus.ai>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] btrfs: fix subpage state mismatch in cow_fixup writeback path
Thread-Topic: [PATCH] btrfs: fix subpage state mismatch in cow_fixup writeback
 path
Thread-Index: AQHctTObRWzC431DjEmnyqvxv2SVgA==
Date: Mon, 16 Mar 2026 10:56:56 +0000
Message-ID: <20260316105654.710798-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY3PPFFCE4AABF2:EE_
x-ms-office365-filtering-correlation-id: a8344331-c519-41fc-8336-08de834abd86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|18002099003|56012099003;
x-microsoft-antispam-message-info:
 iwSKC6aPptz7W1w3VvmGLX818qRHR8pOOsab76Koi4+3Vjj9SXcNZ99S9dKtB1akSk1UYm5FCrAwht3nfVSgI+uKnDeMwU9GLLfOYRJ+bUYT44NZyR6umStGkBMq1jI2iaPDgPcgmlhJ6EiDxF6oiQDUuu5EarRwthPfzBThiUkaw8O2f57a/VUYZR7TqF4MNbrzSmJxwfSPCLno+NIgSlTozpln1ZIBaV5rTNXKhB5mBmedxPS5/uxViLoks8sacGXSuNdvQxDnkNQxEy+JzkZfD90e7rQ3olU5ZV+TCLIWBrdz289rJHfOZaT7ro1IvPBczCiP2JOT6HOo6j0BHxgI4V+heOTc0uEdnCl0M1Z7ZbJLw9LlyzlH2e2jw5W36MUuSgwhjZRWdDtHqEcrXYdw4D0cjgYfAu10XSfLxiskxfhjTAKlv+f8lRYVwvaNHR9getl/z+DA+NEvw1U75hrPtEej2iLP1HYXlYitl5/gA+TG5dos9ekVtvTMT4K7sNsqikHBwId+9AcW77pRSKVez6qQKNGZwCKK/USzuqz+LSn/6oYTECNXCWhknRXNTHctSR/P6vVMyp6F2QvfLt4uu7bfWbYZMnKaVWKY/i1SLRNEBawIzKMjMwZRkps1ABkxiidb4eZy/GTmrme/0KuOdEgHhN4WyC/i6yxBQvCpbpUcHv8odIW+1mm4tYiij10yzrwkQ/EBdfr0mfx4Sj6zcNXtX9CoBHi5dF4QllYgF8wMk55TkCEiJW1QaZ+xm1viYr5HCDbJWpHSAZCckS1JmH5LkSYs76HTftYD/PA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ZcxJlnV0/+Z/8ClfKo97hdSBUcYXIhTaB+ZxpxT8m8gQfjTm1wyu2GqV6g?=
 =?iso-8859-1?Q?Mer6khCxMevH3+1XUzrc/wVcl4/y5CxSbRrz+oHZ0lbfNz0kWMSndBc1hU?=
 =?iso-8859-1?Q?TziQWaY9pTIjDWq5YKgwSN4/o1Oo0SxAm5rFDoVY/2wWAQY59KkzB88FzL?=
 =?iso-8859-1?Q?BUK0rpOIUdvdeVqY11gvFNYCup4mZs1+uQA+8SllO3sjC3L7fPR105TxII?=
 =?iso-8859-1?Q?1p/+0NW6bGtgOKT3CMBm/rojHyouhFjxLwuS6aCP1eS4uDWfa/amI+GDzK?=
 =?iso-8859-1?Q?WUJGsgOAO/6kc0nj4GS7rjr5qulx+dbh5yrsS8ThIlbuq0as73XnkmM3+m?=
 =?iso-8859-1?Q?hN94VbvdKej30uQfUbrgygmpODEV2Yw1lYIt8ZCejPnOil4CrVWmmlfCTE?=
 =?iso-8859-1?Q?3qB5c0QjRNrxnmyW59rKvI6JpMauIynGGNRfF4hnISC3WKvrZadiXm8abZ?=
 =?iso-8859-1?Q?CZNqhlKuiPrvVJQffTzK+EAGWRmuQh1cTSuta05TlXMN3qx6paYgf+1gOh?=
 =?iso-8859-1?Q?BVs83c8Lz1jnzEiB8sYGl3A/vmyHib9ZdTTanEUlslHQb453ML4b7KK5FZ?=
 =?iso-8859-1?Q?3/yL9ab2Ck5EWy5CZ1ITVp0xZdWxcqi7f2e8jofwIB4Hsy7ZyBJLcU8VFh?=
 =?iso-8859-1?Q?Jt0LyVmtt61qiUiWS5GHc0yhXaUOAxjgWarc/neKV8dZJdv8MaV4Tg1QHS?=
 =?iso-8859-1?Q?I08wgi3JYXp7p5k9YlzoM0Py+EZeQGMPvv4qE3WYWk6z4Isyh622vzHc1E?=
 =?iso-8859-1?Q?pvxiObTuxVWxJk1mB0tV5cLN6HGbxH9JsX4/ny0xBFA1irqzh+nUqP4Yqa?=
 =?iso-8859-1?Q?vpr1XF8i1rmTZ2zXiBLz2I5KyOYb30qNt3+5RXCmj3QXZDbe/XuFnAsBAY?=
 =?iso-8859-1?Q?S8/jysth8iDzumbhxu4G71WlcnSjLTeSsATBZ4Wm9nNI2lnBbFlAYoJNIQ?=
 =?iso-8859-1?Q?wL58UtKbDWIWhzgtMXfE+rurt5O4KPyNYXLsAg4b4J0M66/j6iN9TcpByM?=
 =?iso-8859-1?Q?4WEB9beKa2KwiYuP/HRvukOhKnDvQXkD0/GZFfe805It+aFKwMAOzmjJyP?=
 =?iso-8859-1?Q?Zh80ZSgVsz2C5nOVah5PIdnf7CeXFAh5eh1Idi1AaV4+SJUGWimU3dv/qD?=
 =?iso-8859-1?Q?UtG1TZu6JMwqRGi5dImNrzIMsg/rMzsCqcJ5DQAXlobf0TtU05Wb242grZ?=
 =?iso-8859-1?Q?fd59i23VC+97HEclAcT76wwd8vMbn2ftQEtoWBqL9jj01cI4jF3uLKE0dZ?=
 =?iso-8859-1?Q?mp/RjCkNAvDZiF1A403rWUkX2rYXD/BkgEScwS/CebkRUiVwklbENe8k1D?=
 =?iso-8859-1?Q?psCVL1PbTLL053EME9pZhfTkak7wrKt5SRNZIWVFhh/zuidsaBA39aQ+tc?=
 =?iso-8859-1?Q?mJf3UY2WOxXCoVaL6ZZCH9JOEUkgtNiPGENu8skYOrk2Nh1FVYUyIpOCT1?=
 =?iso-8859-1?Q?KJLD+sAV0A/hn706x1ffVx/f+adICxPFwdcGU6zfRQzLvWlxhzzXscLGlb?=
 =?iso-8859-1?Q?JmxdveCtnqiA+RgBabnNV1r9zRWEG4IqoewJW7yHDj92EUQsRH4axeP8on?=
 =?iso-8859-1?Q?TXWmPfba8gXEN7KLRTiLUx6GRgD+DunfUsX6ESgO+s5tV3Ezd5OgLeFxvI?=
 =?iso-8859-1?Q?HRkbZKGley+hcMVo+4xzEAMC/62aMiOntKDGYPLVzhCQAUeIxKz7VRto1e?=
 =?iso-8859-1?Q?eEeZI5a0l+IYLodKeVONgohZXU0nZbu+36wqeaiiBymScFrHWAaMzlQKcG?=
 =?iso-8859-1?Q?Coj+ShPxSIMK/AiVOpV7dRlKreUsQ59fEEfePn5ZLmL/dYGPIX6EwzfQ8l?=
 =?iso-8859-1?Q?eoj0WqBjJQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a8344331-c519-41fc-8336-08de834abd86
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2026 10:56:56.3181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fx7OxXtSusinOcm9zeF79WfaXAyEwqjbPNztb6Nih6e3MKcrGErIjNYBmTYr6xtDQ2rJYFxpqS7+KKVkHIhZQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY3PPFFCE4AABF2

writepage_delalloc() marks all dirty sectors as locked via=0A=
btrfs_folio_set_lock(), setting bits in the subpage locked bitmap and=0A=
incrementing nr_locked.  These are cleaned up by=0A=
btrfs_folio_end_lock_bitmap() at the end of extent_writepage().=0A=
=0A=
However, when btrfs_writepage_cow_fixup() returns -EAGAIN inside=0A=
extent_writepage_io(), the code calls folio_unlock() directly and=0A=
returns 1, causing extent_writepage() to skip the bitmap cleanup:=0A=
=0A=
    ret =3D btrfs_writepage_cow_fixup(folio);=0A=
    if (ret =3D=3D -EAGAIN) {=0A=
        folio_redirty_for_writepage(bio_ctrl->wbc, folio);=0A=
        folio_unlock(folio);     // doesn't clear locked bitmap=0A=
        return 1;                // caller skips end_lock_bitmap()=0A=
    }=0A=
=0A=
This leaves the subpage locked bitmap out of sync with the folio lock=0A=
state: the folio is unlocked but its subpage locked bitmap still has=0A=
bits set and nr_locked is elevated.  When writeback retries the folio,=0A=
btrfs_folio_set_lock() hits the ASSERT at subpage.c:746 because the=0A=
bits are still set from the previous attempt.=0A=
=0A=
The cow_fixup path is largely a legacy path -- the GUP dirty-without-=0A=
informing-fs issue that triggered it has been fixed on the GUP side,=0A=
and experimental builds already catch this case with -EUCLEAN before=0A=
reaching the -EAGAIN return.  However the subpage state mismatch is=0A=
still a correctness issue for non-experimental builds under error=0A=
injection or memory pressure (kzalloc failure in=0A=
btrfs_writepage_cow_fixup()).=0A=
=0A=
Fix this by replacing folio_unlock() with btrfs_folio_end_lock_bitmap(),=0A=
which properly clears the locked bitmap bits before unlocking.  For=0A=
non-subpage or when nr_locked is 0 (e.g. called from=0A=
extent_write_locked_range()), btrfs_folio_end_lock_bitmap() falls=0A=
through to plain folio_unlock(), so existing behavior is preserved.=0A=
=0A=
Fixes: d034cdb4cc8a ("btrfs: lock subpage ranges in one go for writepage_de=
lalloc()")=0A=
CC: stable@vger.kernel.org=0A=
Signed-off-by: Werner Kasselman <werner@verivus.com>=0A=
---=0A=
 fs/btrfs/extent_io.c | 8 +++++++-=0A=
 1 file changed, 7 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c=0A=
index 5f97a3d2a8d7..c7b25e415498 100644=0A=
--- a/fs/btrfs/extent_io.c=0A=
+++ b/fs/btrfs/extent_io.c=0A=
@@ -1746,7 +1746,13 @@ static noinline_for_stack int extent_writepage_io(st=
ruct btrfs_inode *inode,=0A=
 	if (ret =3D=3D -EAGAIN) {=0A=
 		/* Fixup worker will requeue */=0A=
 		folio_redirty_for_writepage(bio_ctrl->wbc, folio);=0A=
-		folio_unlock(folio);=0A=
+		/*=0A=
+		 * For subpage case, writepage_delalloc() may have set locked=0A=
+		 * bitmap bits for this folio.  We need to clear them or=0A=
+		 * btrfs_folio_set_lock() will ASSERT when writeback retries.=0A=
+		 */=0A=
+		btrfs_folio_end_lock_bitmap(fs_info, folio,=0A=
+					    bio_ctrl->submit_bitmap);=0A=
 		return 1;=0A=
 	}=0A=
 	if (ret < 0) {=0A=
-- =0A=
2.43.0=0A=
=0A=
