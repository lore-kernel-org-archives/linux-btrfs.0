Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3C40B6E0
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376103; cv=fail; b=ZSPZVagHGcqhIfmqTOa+C1UQANpgPE2XSg332znKdnjRRQTMhb6pal+CSzvUF0wWoL+4PbV7yP/shIPd1+NdGTrWhpObi6/TU+94kYMQILwbRRprbTdDOvd0qxJwsR6/FRIroRjl8Tdp/PC39+I7hiNVlAhrO8NTj1z1J/JVtQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376103; c=relaxed/simple;
	bh=gy2E+FWsxkYOxD3LAjGlg/hpYwrDh31LwrGq92FqnPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L3vN3vo5MD7GHisAxgH0n7rOMdDVEKFEsLMt3+7GnJueFHE0r7sr/Ij7VGxXwIiQOPo317eIQurc1Gg78oolZBYmAioGDibOoVNu3N81qCQ+KwhB7HuG3LJel0kVf7TgiA61tYZ1eUWCKTPDriibtnmy7pEm+cVF7ws1RBcN1CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LDsoAR1Y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=W7D1mIL/; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LDsoAR1Y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="W7D1mIL/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789376104; x=1820912104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gy2E+FWsxkYOxD3LAjGlg/hpYwrDh31LwrGq92FqnPQ=;
  b=LDsoAR1YpK6kgnUAQv+kIB0sNOQQGX2WSxLBw7pATLqvqTtm3qcuixuR
   QmSzz+fMrSkeM47ikMxj6kwtZrdEkE/U/GaxBr3g9DgXk+Xq9gqFem7uW
   flwAw+ienUGEupZeoMz+VQn42mts2IZ3Swp99tnU/t7gpC/6F7log1hNV
   gzjTpYmoJrgkx8nVoo3r0IeglAdlVtyhX2O6PWb4VuW2Bj+EBf+czBwj7
   tSfu4GoetOHA2arbIA/kW/PnyMzNQ9r4e1fUzWt1ZrJkhoi+RU6dJ8tEJ
   njUECgIjJ5Cfbxt4f2Xocm9JhM3NNAs4eCvUXKjvf+087LeQrPfpRwjr6
   w==;
X-CSE-ConnectionGUID: S3DqUVkzR4qnP2RPEDH3xw==
X-CSE-MsgGUID: VdHx2sWnT22IPixjC3KliA==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="156538428"
Received: from mail-southcentralusazon11013029.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 16:53:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkZ6EPrl2Q914mHRjlTtj8FTgg2FCa7ChyeYG4GqGyC4lz5/uwAIkHWJ2gZFSSeTYlNPlTXGXu/FljIKJ0a61e4cOoO0ukG8lFjV6NZaF4lEL4tI468crIXoZF4GtItJ0/trvCmk3gNEsTH2eXQN6v8uMuGOD56PlhWMozgjUECH99Jmr1z7yAil+YPSYzlrBNNi1PsD3RujF/YIDZYB6zs+DC8CInZyi6XtiNIJHB3MrJIuexLFeHKmTg5JbRvcbuLwyWe1MBrls6SywmD4Roh5s0K67/y8tmlSVzoZZr8ZViveAq2BdxTz48/Jcf40bqD/44NYiSAifUpOP/uqTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtwAvGJ9gn+YmEQNo7h2BKkc9KDPoeej+rnbzdcA8Ug=;
 b=Llyrvb3gJTOmA8z4HIRj2/HxCYIs89R04Skkebmq2wI21wB0OQwOjzcKpipccb7rull2skuQRnE36yrxPHetDC6PGGRI3OZyrBo6PYlITosfPBMoN+RX+fUv9JekCngqnU28T4NyvLN00og/xeYjOeVhhDG0+Tx5PWdYzRms985V4Fc6ahMASdHqbL4pwCqdOG5wJfYXOu/Q52ld7vWyKmseaRCHIo6c0wel5NK+CSvKydcTl5/iza6qCGY17kak+FRYxsF+y9oLoghVs56f5D3x5RFCRxFWrlaPhC+QqHe0hkmyWBPGHMhq7vq96obnoVGiDp22zbrfd/J0Liv2Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtwAvGJ9gn+YmEQNo7h2BKkc9KDPoeej+rnbzdcA8Ug=;
 b=W7D1mIL/t/T+yWB8tFdBreQfEyUqMxtLAG49RcPaBswb56SjgW/58mrm+OfjwTruxuKZ9KIZ0hs3ySfqa6qu9HoLwF3eC/oShkGtUotMqM0+8u4+mbJ+GBpdNeixUNpULV11jwaHcUap6+Mjz43PngX5f4HyDI3Ze+Eqt8slg6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9263.namprd04.prod.outlook.com (2603:10b6:610:223::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:53:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:53:40 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/4] btrfs: zoned: fix possible UAF in wait_eb_writebacks
Date: Mon, 14 Sep 2026 10:52:46 +0200
Message-ID: <20260914085248.347198-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0314.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9263:EE_
X-MS-Office365-Filtering-Correlation-Id: 5729aaec-561b-4e06-8560-08df123dac8f
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|19092799006|10070799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 YEBcRA5t9mgbeVKYbRkhwt56V7y8HYvNvAm619VX4gZMGuqbrdoK/ZmIGbVMNhMZY0CqBRwih1dNU0kbzgf/FOLuNyxN57nAQJH0Atd7DSnBvAMp7bu/F5SUazNzRxLZWZhbHR7u/WWGj4OSbJqThFbWcx3E9WIzgO4bT704zh6Nxz2k0jqNMdDKVil8OpVa0CefsivI1QqTVwH28gI0o6oz/QTJzjeD6n0b3Mv1GEnlvLIG/0UHUWssJo53VljldYsY0ucrAolMsSRhit7MsRQVevE/neLAR0rifBJAn6WTxiHK8mGBXQAX71Wxyyl/CSV00tjUOJFKEzhTcZr4Z2L/rRbAsZ4nO0x+Wih5fw1rulGzfSRHFNyh9HG13xOq0cNxeiQbBgLlgeCKlgKP5ebmKnRb2/osYKPhBzInM9IuKLIHabux1suR6mEo5/kbonfSnmkZjyS8RVN8ISX6Gb+ef+w7FF67ixk0C9by14p+nuyFU8A18s76zl06zvDNHff6hzlLIRnCZ4mrheIj4ypb33oNlwPNiqRofNpa9QnwuFUamlhWZjdeKxqJYUjgr1DVwiQB0cUKmpMyB8liXaEcU8ZEbUgLwfaKLkvo1vi3wwyrrfK/Xwmm08/S/pnCuNeTNQ0ljLPcF/umWnauhg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Hw0EHJEcj6g6lALtpcJTaZ9RtfDLCXSaL4T9H1BUc7YkfFuODf3O+V04Gpk1?=
 =?us-ascii?Q?amBm0k1QmrpqkVKFEn3WDaNosT/Pc5QV+5yCfs0bW5QITeacbTr3ck8u50/u?=
 =?us-ascii?Q?/sDq9tQqwXeSoLMJD0dw6Gen8S/X0mL405TzLKO9RXL/Parbi9npZQAAENzC?=
 =?us-ascii?Q?GYy+tY5F4nAXzXsn1jJprC/paN52+7nr8GIwIcQpcsVVpgYA84pUGtm94B8M?=
 =?us-ascii?Q?+8NsHEmwfQFOk9N4f8PDqT7EPJ2CFTL7hDAQrxusLvBvDMES6iJ5yhKtq+cf?=
 =?us-ascii?Q?S7VveTJ2vFrx9cRY5QCdqdvz/fV1W6dIAS63CP7AlYJNu3TNTljb864DxHt9?=
 =?us-ascii?Q?PvO0kFLa+qMnzHvd14C9G0QmDoHkllE0JQISxzPJB8JMe6kRIFdzJ2Rzpg1C?=
 =?us-ascii?Q?GMLBLcyG1YHNFpJhcAAFFrenLmw/J8tSxT/Knj5y5phiJCRs9/DlhXTT9PXg?=
 =?us-ascii?Q?JedD1qcQ41s6A8836SOqQ+I9le/+iAcaM1yj/EbV7OVBZKf2bBtxaS0Y6uu0?=
 =?us-ascii?Q?aih6m3llL2sBZ3APjd3UmZXVAZaQNKoOxwaVr+gUlxfYsW1oQY2NJFqRyGuh?=
 =?us-ascii?Q?IwDqh1bWJKG5KnDC/bnW0tLQ9eV1uVESTaOTltVYDi9ofvlBG478PbGWvnF8?=
 =?us-ascii?Q?6bb4w5Tu9o2ZDSfgBQv0wj72YaNd5YqJvqJVdvyD0X7XK/9ox5hQFb9DpSaw?=
 =?us-ascii?Q?YiJJJBRjx+XojXCOOg4gEzRjwf8Js7sEIDl43Qx0opZ4mVIF6km0BNB574s5?=
 =?us-ascii?Q?Cq5ck3pRoZ4UTPX3Tg2aIVfnTVQXpK5P6HadF5fSD5t/fNvaZK8lbtyu8ugA?=
 =?us-ascii?Q?wiau9GpHgmGGGf/NJiE7XcpXTY2m9kS98e1qmh4X0HrttWO3PAk+8ShMBgAw?=
 =?us-ascii?Q?dOtLY3aBQAWwfpeyN2VmNWE08r02v2r4kh2sbfqBc21c6TB/TdKkh5vCxnYV?=
 =?us-ascii?Q?9srzouZ3f49+3IN93B9zmTT6Mnm7g2i6Ab0vC6O4CeOIafgWD7XS27LtGBcK?=
 =?us-ascii?Q?MEQu2dJ+tCmGbLrU1RTC5dqSrYtBF4WSHCIr1371VGg1qNiDAsMOgkkLbBq/?=
 =?us-ascii?Q?QPVx9XnKShibHGdDDcb6zsYp8BICfOAOr+68gOQaX1tHIeYPZiPgcQTElvve?=
 =?us-ascii?Q?Sx0R0zF6WNaxl39P59L0mrec7sBApqQjFuFcQ4G5K7fOFRgfEnnzovR+0Jb4?=
 =?us-ascii?Q?/8uS67eWBvEu0Es1Db3Lm6arUXFJPyf/cZ8gSjssS2ULgRAPoQsJXgYaKAxQ?=
 =?us-ascii?Q?6MbwBsrIN4MDj+zuvj/e/JRqMYBH/bw2fboAEZL2vhywX72sGzwkHU1UzfO/?=
 =?us-ascii?Q?LymFDEhwHgyAy5fM0XdxYlnUVR8ykYaA5U7WIJHP9s0S553eBR4z/NTBdOjI?=
 =?us-ascii?Q?BaE5xxwYJsU+K15gMzKXRihONyFGyh8LsEgmFXgLh7FkXuQaxfdOmN5yakxh?=
 =?us-ascii?Q?tiBXeDOknDNe+w1qQvJ/ZefWq5KG+5bskuZ0mQB/wdDIO9sltnkvwmUDML/m?=
 =?us-ascii?Q?kKenemF3dNjfXrIX04ionvssZ3D8SYm/uqkGnDFQSYvWsWou4fRTrb6nsXlX?=
 =?us-ascii?Q?CzYRR/WA2Jxs4T2qRZHGZKyJ7ilIzBtbJMvLDlQld47Zs/0IZmUtOhBeAZyu?=
 =?us-ascii?Q?K4XkASt28ky3uzyW8zpRy5cBUK66R+NUzkAAzWcSAQzIzthxZ5AjsZytN150?=
 =?us-ascii?Q?YS8jJGmejwFjLyiMSBDmgLX22g29vAIcj8QoWnwzx9IYBufJOmEwFoo20SLn?=
 =?us-ascii?Q?roOYkLcDLycDkLvDtpjTMm+VW5b/IO9YrY8iLsEKmi3ho/lxB33rHxOjNbWS?=
X-MS-Exchange-AntiSpam-MessageData-1: 6k7YDEherwgE4hu1NLiGwXR+LeeiIP3aRZA=
X-Exchange-RoutingPolicyChecked:
	xH067AvSCdGf/6UDrQ5A+eEEVIetiIvQqMH4K+7W6gcMo5RwSQfUAGWAG0dW/7TkVgHRYStXyDy4Xu+RMr/lRkNFbR7FqgS3tFkl47/04oan1hachzWaA1DKzsCqa19F9dLU1AKv8QTxLlv5BmRwu0Cp90DkM9bGvqzHzzwsEyN1CMDbUgwMiVqFEDurWQINA+tYvmGt0ExopU0XYz+rc8Ip/7rqKJPvQPEPGZjYWqe9dgyDNPpJKo9RepWdjlfMq7q1LMJOOdyNAS479LV9zZmnIp/HP9a3xfLoo/bnpKYnTWSlxCwetKbw6go4OvA2qRvyKiT8a1p1Z1yo/EYuVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ofeJMCrIhbINrqdbjSI/kEZQ81xSCWGgs5IL/BitKprQluyqgvrEfpBTkIC1YukQWL/ripY6SSDje7wou/Xp21LUTKyaXL0dI5PC6plGZRav8P75Wj1orZ2rxa8kUNMDIugfaj9qx7+QP/5lt2dPjs0Dr8kEwrBr/mjhYwvukFkx7gM1jFu8+zp8SuDVMoHfJHuRuoVm6IfKxuxkmlTDpLXG4RcftHWCrHWOoErxBBeB4QLRPvkm8U1F9PecO/mZb1BnrlT0EYG51XmS0xbgVwj0yJb9lBlMCC/ngI+9YNXfUQ3wFx0p3alh3jrASSooNdCv3Pbzn2FdgbTJfniSyNxCKbiYt4Z/44Fzhk9dUKaD/WziF7QnoGwbCDJhpBaLGQ+pEwxXwDZLxbr42Cz/+U+fmp+MOUXs259Hv65kD5Kw2e977xKJa9hutgHJpbJN/4Ipo5VJmEZ5og0v9O4uSfWS75dgsOe3t1ed1QbPQZXWj/LuL+AFPnyF/9wHDCwpnniQagKllfZS3P+AAlNAzCHTwhqwGq2k8Eg3ki4vS2Nso2Pic1u3q6SvUU0N6X7icJHKIFAoigds5w1a77XjbJfcftVTNhPGKr3MBBh9y89pM3WJhs6P2K9pm8RnyqVG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5729aaec-561b-4e06-8560-08df123dac8f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:53:40.7941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImfBadAEr9QITIP6wFggfPWvl3lwnYPm4u17Aq/I6KTW+R79trKEH04ke5CJfKRUveFHFaj/g0LTIEYcIzQ0TzX62sFAjbhpdipAeY7MAGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9263

wait_eb_writebacks() iterates the fs_info->buffer_tree xarray and waits
for the writeback of these extent-buffers. Waiting for writeback needs
to be done without the rcu_read_lock() held (because it can sleep) and
thus the loop drops the rcu_read_lock() before calling into
wait_on_extent_buffer_writeback(). But extent_buffers are freed through
RCU, so if btrfs_release_extent_buffer_rcu() is scheduled while we're
still waiting on the writeback, the extent_buffer will be freed causing
a use-after-free.

Similar to what is done in find_extent_buffer_nolock(), get a reference
to the extent_buffer before calling into
wait_on_extent_buffer_writeback() so a sucessfull writeback does not
free the extent_buffer while we still have a reference to it.

Fixes: 2dd7e7bc0282 ("btrfs: zoned: wait for extent buffer IOs before finishing a zone")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 12391063304b..c09e32904caf 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2511,8 +2511,11 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 			continue;
 		if (eb->start >= end)
 			break;
+		if (!refcount_inc_not_zero(&eb->refs))
+			continue;
 		rcu_read_unlock();
 		wait_on_extent_buffer_writeback(eb);
+		free_extent_buffer(eb);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.55.0

