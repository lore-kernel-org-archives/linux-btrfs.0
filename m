Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013036.outbound.protection.outlook.com [52.101.72.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19633B6348;
	Sun, 20 Sep 2026 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789871423; cv=fail; b=PWcE+eC1hlUpQNporzqS3fB39Tk+H0/nGFPzCFkIohkhWxJSepK3MgEPg6bAGgs5javriXFPh8qfLzzD0eRWXHIjsaq/2V1JYKQuKXe97/50qbKklgR9BwGaBZaEJByDQFmfPv/Mzn5mRxbBEdzsl4yv3VoDaDsEOfeEhTBlx4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789871423; c=relaxed/simple;
	bh=HKQa5MMEulD2dMHxOqknNetL+sfWYX9coJEF77tX5Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NWZV2okBqbwOA3/LQWcgoAB/t/+vB8NyKU4YMhWvYVchAcDXwrYspJAFVv2ZTpZnV5mhpqTPgnGiY5syl4EWv/L9eQ8K4wBo7gyk3olsv824JC8S+zhbqB8g+t6JagKv7ZxRUigfrSkam4gxpXBsNCHoZd6A3NuVd9zmyPnlHyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=JPKJRMCR; arc=fail smtp.client-ip=52.101.72.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="JPKJRMCR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3Pt2o7LSUH3bENZV9bYkrYTySOpSqELYqLIaLGUda990OZ6AOG5vKSj6Gt8RzkZKoyLCMRq/tChzSz/42WsJNF6HGvJF9jtiYGPTVnuN65lh0nXb/czt89BHWaKcSdl2CZfDCcdl/ChX2dU53cPUtgqi5uHLcY0JgQQ87ZpWncWc/uvwqh4RO0m6Hkv4MwagX7UGdSvM55Zhg77arcVkLtNbSiEJcwPCnckbEeG42dq3Vj1kLmm3Lu6FIlcia5bnqCQk7tyz05vRy8+xuOA89UsbtkMClPjH6s9CNqPKjzdbt4R20H5MbUZ4laTTk5lD0ck2jm3WA/xrYo8iB32rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D59p5e4WdihMWABW3DrU3EQUkPFSp7E4vvi8/zEfA/Y=;
 b=iGl3WrI/QptRuBBN2etl7UhsAVUA0/yI96sLSHfURYt6IUVmUfBbE1+F21qJKAM01JlzuzCfl7c7KI3qKnQ7n5ghx0Crds9/t+0Kns43+agat1BvEv1cXDoSzsNje9YW9Qq2QS/vkJwULSLp2iKhOzH0OoLpwhYqZol0QvtWPekVZneFsJ+o+0JH6NlqfrIWN6ZzBSjkB7O3eecO3WyE05prr3WbA0GVFSlJ3UOTPqaOl3CHKXNSsH7OVQcerRwWrYa7LFOU/d2Ugmz/G8oC8fNwv2utFHQZ6dVq2oFWJtO9kbHoCyoRk1bpgE/9VVkdCCWbnWlWvXe7GJk1HArrbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D59p5e4WdihMWABW3DrU3EQUkPFSp7E4vvi8/zEfA/Y=;
 b=JPKJRMCRT7+EcviD5l//OGzZsGAA3NBU8CRO2NIDqn9DGCcCEz2RxoU6FiAfTpBiiQNf5BBthhGLSdloMPs4JoGz2ICLmuGjevXFn8vfX1sDCWIUgxvkXo5/avTnvIADm3XLxNFYJPvEQpMdrEKBo22EmibQkO0Q0gym8IPiWKAVl3OU99tufwqXbK/GnldISqxmhcZ4uEagfbt27/8k3Sy2HXdkK5qUsHbLCG1P2BR5ZMbjklBzxR7hMpoeMB8/PrBSRMBKOOGD5CeYxp+NO5OHM0vsZdQAe5D9CbGp0bSxioQAEmY198on85EHhqLbVh9MyfwduhfLcQUPoAFD1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by PAXPR04MB9596.eurprd04.prod.outlook.com (2603:10a6:102:23e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Sun, 20 Sep
 2026 02:30:01 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.014; Sun, 20 Sep 2026
 02:30:01 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use assign_bit() where applicable
Date: Sun, 20 Sep 2026 10:27:29 +0800
Message-ID: <20260920022730.3145797-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:295::14) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|PAXPR04MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: f6932c0a-9954-43c6-f9c2-08df16bf11c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|19092799006|366016|18002099003|56012099006|11063799006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	GBsvHLuyne3zUYVTh3nsgmltLzXzR0M0wiyrXk8JQkYFXuwagEHGI+5BUrzq7xTziRrEuUc4ouuOrL16TLnCQitAMHxjJLOe080+XsIM/yeJrCLt8GbTwhmfstUDtwQoAchRZZjw5db2SiCNSD0QNnyK5cUXXIDEr2MpsK3HTo49RKXj9F1/rsK225ERZv9eKrGmExl5mmQliUEt6gOD7Nl4ud8iRvLU0QO2307qNginQGi0/g4uDvhjirROhWy6NznA9YyrIFr+uEuwiSWVQ3QGVJa3km8fE23yQTAHR2k3aL0CjQXOkhuxdn02cUOwdXVju7FunhXkuHKWs7fWMgUeHTHQ4LQlnkzXssXjglR2n5anqDlHd0YDAWP2H7SqCFLLynbxGjIvltUhvA/4FAkWPUkiOqYJ3HrOevoaIA7q/dFu8xEbYTG47BcRAxrSjjL8uzOHsdwGYnIxpFB2xWP0nK1eSaDQAiIMfUZm6CrH6naSToEQRB7QTpei/21JfXLvX/iZUPmVsHcHTaezCSbH1TKxOuc8Gr+r3rFrhCen8vWpztOovvgVMAbqrX/NofkLrzvOPvFTwjTiymyjI5OPEiRi0dnZQQgdNiKt2DmIDYi7N88x/AawUOZke0rzSKe4Wb/nqAJfyPy6WueEWnh2N/a/OXbSJ3iBHnBWZbY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(19092799006)(366016)(18002099003)(56012099006)(11063799006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ao76b/AdpDXVJPkyP4I31bRFBsSqvSagKFWSkH9sLPmhHE/rViFabkh0bTYK?=
 =?us-ascii?Q?SgnSQyz7WGq59uHeGPKvtzgB/elwZtLij1p8KVA2us4N5BKPaEwP9/7g18aa?=
 =?us-ascii?Q?K3dbKOl59UHBsf+1kZtnENQFieZ8OcRjS6uZDr5TM68qjfo6X3GI3Qfj5IXg?=
 =?us-ascii?Q?NdjGc+yrhMeJYqzH8C/HTHAW+i2C1TV6gUzgZdHC1pNYVtfrtwLdI2IXIATt?=
 =?us-ascii?Q?L7QdKTODR/nuBZIsQMNnS0X1r2FjBPUoKZ3trvNVFQzhFha2A/XxEm6sRO+U?=
 =?us-ascii?Q?V8MGLIcp9Mqtqajv0LCU63eDVq3bOJZDxqvQeZ9AK3O33lvHtiTRSfmE3N52?=
 =?us-ascii?Q?Jsw7285otpodJMBDCBB7mmFjHWjC8jXDIKovHmeB//cgd+zupuSX/bhHN1gH?=
 =?us-ascii?Q?xGRDkkOlSzPiqSg8j9QIyv/MFcEOOCmfcxZxLHI+K4mWGiW8wNJlFbUhi/Q+?=
 =?us-ascii?Q?DliDHBMfcVgom7pCkpHvw09jlt19kZDUbWfGjgUwLem+SowoF3mfoRvgp124?=
 =?us-ascii?Q?PAtUFrIhfnKqtuEOtZJxMooxizX+pgB/QVJOhNVAh/8rRe43tFvWWNwRoISO?=
 =?us-ascii?Q?vlqdbZ//EruRWqivvPFpI0XaPWFL+6whPkt5azPaUA28ZeMxHJEeoSy6YqAp?=
 =?us-ascii?Q?MQovD1BVjIjhF4uym0Uw3TWOTLxsec+piEQZRKk6SiRju+b30Ek+TYskTwLz?=
 =?us-ascii?Q?L0YxRmBjn95kWG+A8Wu3JL2oqSWtuuqmzaRa70wM8S4SzFFZOPwq6Hcq8cM0?=
 =?us-ascii?Q?XNuS1k2pa+R6Euf2cXFIwEf366E37j2n5M9nYxYge0TuQiaaj4lfMQDOR0CD?=
 =?us-ascii?Q?br0Npd4gvVhiRtIgDMDOD+O7FAiqGEodT4xrBpNIt3BdTLE//0PYQPu+sYe+?=
 =?us-ascii?Q?wuOYCfFTapIGtPyruA8fHFLnndQPdopdEcfKBjHFYBmHIlkQSaP8ARI96meK?=
 =?us-ascii?Q?YO8VFqQKjp5daw0Jhz832sIeRVevg/AsbAOTf2G8rUqmIs3QXRCL4UZXZDtS?=
 =?us-ascii?Q?MnTj35OwYWaMjjcLrDgadyr1lUONKIrQRuqoFUbVVnt1FGvYQNc8cfL/3dum?=
 =?us-ascii?Q?PMINRk440rrT4eSHdHkhgJaPjBCH52pdJAGrhQt8CdJqMO+/VjH6ZDza2SA0?=
 =?us-ascii?Q?PaZNoI7cFwz0DBOBQD1S8pi9E7WaDY3FpGfJ9h9/Qrh45DZiw9W+LdpRJh3U?=
 =?us-ascii?Q?h5T0bp2ZdBMQvdULgi9iSZYCzIbsrLSH5STGtRwAkXx8GrniAyEKzp7K4U2s?=
 =?us-ascii?Q?/StzUoz9q5SboWrLx5v1CxsMtlWHzYk2r5G/WLwPnVp/pjVmOAOS9n+8HYiW?=
 =?us-ascii?Q?itxPXA3i6Qt9eN7rbmOoxzxgg7dwUDC3cCgy3oow3H4iG3s9yeiDxi+Nj0Rd?=
 =?us-ascii?Q?CCyefYeb0Ghh/IVoemmh6m5cu8av9wFbqvwdWpruAoA1J+xqoG3F/xQkYREW?=
 =?us-ascii?Q?b6N30HoHDkzyC8QxKAoHoq71VJFlJwbvlwLqmmkb3p5IAyWvynHN6IUYQ8YV?=
 =?us-ascii?Q?OPvwTcm5jvWT2WShogmJlAQ4mK4xYPCC16HVD0U220qurTU+nMlNrEGfJJ9v?=
 =?us-ascii?Q?x2YRBxAnj7XaUuHdEAfOcrBKSvE2lrT+hHlkV1/5z6A5CIa3WRZKz59xfAp/?=
 =?us-ascii?Q?zztPhqvydme+kS8m3gW7nLHWH4etDCNojun3SM2/tikuH+/Gv8dGxqFKpX3r?=
 =?us-ascii?Q?otMO+LysFaLvWrgVcvKaYqXUUi86empu5mhwTchv0/qeUQ6mfkgc7oLguWPU?=
 =?us-ascii?Q?yCvIeizdg8wKCmr44UaCDVkCVdfEvmUEFNhujDFQnG8OZkfXhVr/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6932c0a-9954-43c6-f9c2-08df16bf11c5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 02:30:00.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkLeCs4YS5yJhwGxpu9dZjjdCU5cv6Pg6k/sFJBWnpjSD8EoqJEZo401QGc2WKOgIeimCSh0rC8I8kAOW6QBmaBPvbfBBGyTa7EP5daHhkuJX/NuicZl7JlBt8AsMNjq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9596

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit and their
non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    // clear_bit -> set_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

    // __set_bit -> __clear_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __set_bit(bit, addr);
    -else
    -        __clear_bit(bit, addr);
    +__assign_bit(bit, addr, cond);

    // __clear_bit -> __set_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __clear_bit(bit, addr);
    -else
    -        __set_bit(bit, addr);
    +__assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 fs/btrfs/qgroup.c  | 6 ++----
 fs/btrfs/sysfs.c   | 5 +----
 fs/btrfs/volumes.c | 6 ++----
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05e35eb126dc..bf06962d49f3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3177,10 +3177,8 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 						 "qgroup limit item update error %d", ret);
 		spin_lock(&fs_info->qgroup_lock);
 	}
-	if (btrfs_qgroup_enabled(fs_info))
-		set_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
-	else
-		clear_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags);
+	assign_bit(BTRFS_QGROUP_STATUS_BIT_ON, &fs_info->qgroup_flags,
+		   btrfs_qgroup_enabled(fs_info));
 	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = update_qgroup_status_item(trans);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c5bb1c7eac6a..3ac1fa608d3b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1117,10 +1117,7 @@ static ssize_t quota_override_store(struct kobject *kobj,
 	if (knob > 1)
 		return -EINVAL;
 
-	if (knob)
-		set_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags);
-	else
-		clear_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags);
+	assign_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags, knob);
 
 	return len;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ddabadc9188..31d790fea8d8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -698,10 +698,8 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 		fs_devices->seeding = true;
 	} else {
-		if (bdev_read_only(file_bdev(bdev_file)))
-			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-		else
-			set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
+		assign_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state,
+			   !bdev_read_only(file_bdev(bdev_file)));
 	}
 
 	if (bdev_rot(file_bdev(bdev_file)))
-- 
2.51.0

