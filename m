Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085772;
	b=iwOT1EeMV++xvq+eocbOU2cjsGo0OQoCtrBhqcXcy1hNtwK7qesTqpPkqiXKOg3afSSW
	 JseeE3yrOCcXcxgfbU5fNlKr8GvOmee+o2wuIKuofdNPosK4lJD8j05WxS/b4MPtXpujT
	 5OUdHtFAgi0efiDWOIJIonjOPnTZpN6okgzUSm8KW9hWBojC3KrtOqOkJtFYdzfgMRsZn
	 /6pprYWHXj3DRIVib8vRzy39Bh8mafIfcxacUB6MQbfXJgH6ZMQWPlYvtXahUinK5iUjZ
	 dDdQNSGoeHOyGW3/NRnljNnXzNODGAvcikhzsWc9VKXFzJ/yvKp+hX0sMgUOfr+SJlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085772;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5wbryEhg2/rmg6hZki007vJ1mQWYbn6F3nzoRbYB1OM=;
	b=tFyfdOttT7ObDsLkPJqP3jJoqt28XTQq/71kGb/LsyxOaDEw0BPOjMG6AUnWZ3MQ3WUm
	 JQfCWqycRpkiSaUkYb+AeoOesi4uzBHFpzW6P9i3vuyQEeqk6ZMYQXEOvFoGwDfmYPMaN
	 Hzo1K87f1nInZklwS29bad4+I0gwFCHI84hzJb8TMkUXrBNtqh7f2ccrZrQHaFMmS9ecX
	 xgzzsxC4TXa+6hs2ww6EVsGoNhrDZOvWS91Zxw58d2JKv7ha0FFIIjA2eBe2/xDhnsMia
	 XrvvXHwxb+m8+c+G5T5MwfdkM5iB6dRbs8yVNbzkK9/ffNWOWMaBtWWSTSfTLUaZAgA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qMLY8CtX;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mK2zfcg1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154BC606A325
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 154BC606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qMLY8CtX;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=mK2zfcg1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085772; x=1824621772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ujR7vbLsydFDXC1e9DfWFaY2f2JyK8Zen9vNspOrZeI=;
  b=qMLY8CtXunjZEGdHzc0uLyEWfuzGOgoz4EI8ik2rQKsYG9kmBRmEUZd8
   +fidkspU1iAyqn+EbYmHQ1NR5I20SdtXgKqI44oetkAREgwQX4XODveof
   hXf+omVmQIzyUusc/2dMQcBEl48xQnMiD2hlNiu7rhUZU8TFb6qyDzhsm
   omEphTlaw+TfMVVADpqnNRKFe5EFv9dwnp//S1I40HXPKQ4GKD0uYbsWh
   pAwrtyqUAGI09qfALl/46VRLvjBSXv1zjRBOEhAOjVxKOOKAKs5cUn75f
   pj4hnsROV/tuOjgKQrd5eIyVhQj1CYTQ2vVWjW16uLoYTTRTHYgBSsfK9
   w==;
X-CSE-ConnectionGUID: nIsURS0kQvSSH81O4s+8Ag==
X-CSE-MsgGUID: GhRFfj0eScmHSBtd1vVRnQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092289"
Received: from mail-southcentralusazon11013000.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+f8r426aH5X6ng/kcv3DmWKU6OEM96zEcblax/88bWs/JSGmEsLF94SoChGiLnXDFA/ZjttpyVpPEUskHBhtwUEFu/qjBklapQy2Tr8G/qxVGoE81PmRJ8BnO1S4Azf9RZmDZ7wyYDpaYrJygIRxIuQYYVu4Tz37UWN/IGeam13CYSXjfmwNFrqCZ0GxCWTdLhzkbUCKJYut+cXajQOI1xBoo8i1OpYmlqDi5jL5b9j4vj+xykwnKspXzDbl3V7W9PHGSsxBCmlLyvnIqnLly8sjV3VRm8dTGmcoHHgWM+wH0C6KEWBVdPyga+JLb6Cs5JVOgJVR3/9/pJlVw3hgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wbryEhg2/rmg6hZki007vJ1mQWYbn6F3nzoRbYB1OM=;
 b=tNW0EKbskrxyrHirKp18N5ggpGOZWoAzcgwQlsjTXEGS40y4Xb0CXLmZ3PR08Lx3UXfvD4CI+ILpAOr4FYPMobQ0UOH08GYyhY3kLYaO4WSJYk1+9RfASdIt9Kxt3AUSa77+g7rhF2MPGCXDuMIrYTYCxmVki3RMI+LShJfjpDUZf9KW9gQWXlYUSbF4QjSKjhHkate4KuCIw1qaVi29MRZkOR+2i6LySrE+GVEq/3Nmx5ku14uzJItKF2s6GsR7CkSmE2/na/42KXFfcf8QUGwY3F/QU+/AMymwikYyJLwWhRYEeeqUgnTX7k6XUnvXSDfIpcf7k3PUtTossr4LiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wbryEhg2/rmg6hZki007vJ1mQWYbn6F3nzoRbYB1OM=;
 b=mK2zfcg1nnOfV7WyOv29zXwRnYeeH2Ff9J9iM5fVwWvyiMrKhVZEF+VS60cSMRQXMDYvbBl24sRauBMmY66wbUIwptgzJF4MHmi3A+mWASGVf/1OBYw6sNzqF+zEbHGz61tltbAhQXcUPpG6KVOZRaFa8FOwg3K623ryblhL49k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:50 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 03/25] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Tue, 27 Oct 2026 08:22:09 +0100
Message-ID: <20261027072232.419318-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: f61fa931-214f-4bdb-5c4e-08df33fb1b91
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|261026121527099003|5023799004|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	7BM8gpFnrBmMM2vcCjF8H8WhZKPS69V/MkwrbvlVlU6N5xxsjfhTNTreKFmPRkjPZ/8FsUZ7Ihz7ui2PeQr3mtnA9o2VVbt8QSdH6fvNy+NHNeHFbEZKALZx7PxwgxNq37ewRvQa2Rqy83iF7woXubJTE0k/Cs3swXGWUJCvO+z41/WItY0kZCD/GVja4LP+Mf3aC32/VJOn74kX6EUVGqozZb/NHhdzM+NAe+Dmh0MaL4xH+f03mXRTDyrzLf8YiTd9GAMdkNOPaazx63CjO/35u2Mcv3OeeR+HK1fmstzwJ8egxWirTLCRzdph+xm0oetq1t226U28C3sBwuhmbB8UIDmpQqMe5JSNUmGUTyLyEYsyjCvog8I9DZRQ9hdaFmk3RILnFzCom4C8swfmHjIavnE7wXqqDWax/czE9k6kf3I0eFPwqu3S74il1ZVuAYOTC/SHtLvZsH3zxWVr0DWf3URhKJMRcSDi+luykVxGtMoWtyhsQDLgkmKiR/dDfhNxD0fpSW8Y3FNa1QO0miAmkiKhWxKbZKr7/EJTZOzfKTd/Tv/TINQzGFHi3XXeD2xiA9JnZk1+2gn+ad+wpiKEwhtX++6IozTygE/TuMCLSdCmm1djQUbVQ+GMP0e/uVi0pcQBeX2xgypE1LRl16+Aw+6S/p/jIC5boUOs+Qc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(5023799004)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IN9G962Chh6Cuz4D++z7Dxxy/l1lyrrS8fde8AvodVtzXW/G2fhDG+peDpiB?=
 =?us-ascii?Q?u4HceRCTZKVBMChaUvik7qSNicU+IPdVPXoh7swa3/ke5Hnq4+OAPkSPTMX8?=
 =?us-ascii?Q?D1cFqjr6ap+EdWgPLNg1QjKAcKAOpKenP6O+025RuOwEn8O6/LYjZXfLbMQ2?=
 =?us-ascii?Q?mst45muhEgdnB8oxP0yIDRiDeVOX15v0FkMY6CSRlR/IfOHS+DzKD8eUJmSN?=
 =?us-ascii?Q?jkAo/D/3QddsJN/8Wuv+b8FpH6I6boN5Yri8B7+p1o8YwwaYZrF4DNhyAOTn?=
 =?us-ascii?Q?bn7oICuFULz5ShEbRNgOSDuQYddwb1fIQnBb05PT+keQIiu6VvTnOOpar3l1?=
 =?us-ascii?Q?1Th1QAoqC5pjIMbUs4lijH+KHVQ3M9iK0p0vT8Ba7hjdwEeozJ1rSGKi6Clz?=
 =?us-ascii?Q?RTWqFk3AqyxX3D+tmzVvXcuZviatRmX0rCPMJLIIva+soNL7aNGNmM0qWsXO?=
 =?us-ascii?Q?MyB24xLs/cibJaAoLORQRPZzRWEYkYFkulQxW3iv/bLiUClGvOHVDU8XhQqc?=
 =?us-ascii?Q?MTBzDa77q1/2c5wgUkdVksdZyZsEzkPRj4I6QllLjfoZia32SxUYigCLd/U0?=
 =?us-ascii?Q?36ipzEu+27oVF3SYUO0Qkiu0NAK1kiBJNa00m+ufW0pWGS6L8XXdwqOKEvYH?=
 =?us-ascii?Q?QGHXHAc49nSe6Q+6iaUgNxIBE2/0OHOw+Z27evqZ/PBAiXJWLAScItvckJ0u?=
 =?us-ascii?Q?Y4Tn3th+4yIGfdDri8HB4j7/wA9C9CjTaRdLtxemKCltYdlJbv2b2S8p1Cli?=
 =?us-ascii?Q?Ymte3DHt+oLXKebhGqQKidk9iT6o/v+SCwrlbJewIVgPmEltiGqyEcKE8SFq?=
 =?us-ascii?Q?hzk4F+7vLZcnEFHvIl53apqLRSPyI7V3ZYB5vMAZHeyt5VexQ3yEsHm3N7eo?=
 =?us-ascii?Q?LIpvDGtkyyYhPCa8rEk3JLETK/vjbYwXNX0sOdHy8CjcHxzIr3GqKwLWBOD5?=
 =?us-ascii?Q?X8SCADEgPcvo3vxnIxgkr3Nph8iiwg14rhx8rhrBvzYK+GyXPaIv3kSAC3ao?=
 =?us-ascii?Q?QsNcIre4XcmNbLLh4SYbNQ6MHJRrzFeGT6L6NzZ5Sf3n8cOxGRQN4U9QgIU6?=
 =?us-ascii?Q?I//SmGoJ6w9gqYAb9pLP9qTIBeGGSEKWNu4vmt3Dmhg8YMFQP7Ta9bRgWH1l?=
 =?us-ascii?Q?eVEtkKtv6I0J5jFeVWoXn8GfoGgDgRvoqGKd2/8ZJrCQURCkEHILBZuM8iKq?=
 =?us-ascii?Q?Jtisl8B/ARYOyV9shXAHm+PJnAiPEN2een4hgxIxrBY/FtKnIhFTEWhHAfyd?=
 =?us-ascii?Q?I3BCMZvKuc7KU/XTEP7IFbEQExfEs9IxpQrtlylFmWuUmE8iA90jUnE4RfZz?=
 =?us-ascii?Q?OmZR3iYSxpoPv3RIjCA5oFduADRUC5wEuDoHdTsZS0MfHRIBr9mxEtjcJMjm?=
 =?us-ascii?Q?1R6Mh6Mdt2aBQoZhBuJaA3e66RVAkaQmP7otbBCrUMLGsFk4TIr3pqKo66bx?=
 =?us-ascii?Q?/qltHiJOXqM5LCnT2TPTfK0K1vnbrPX03OfwzbbMX+CD4sv2RX7UFl4V4Pyk?=
 =?us-ascii?Q?l/G0hT+e6t6RmNFG8EdHjpaWRFVcPXV1RYcb77MPnVX+idGNAjpl1KA3yiT2?=
 =?us-ascii?Q?nI1c7T4dWO8aVICnoqcMQYI8cAZf7W2RtJkIzY+x7p+IhMXiORg8E6e6+Y3b?=
 =?us-ascii?Q?sM+0/x73R78Umxe3hiCwQ/jn6YGOF+Z6o6W5EyZcsPX6h/0+RYhjxahB054g?=
 =?us-ascii?Q?COdUSzze05VTCCLlW1d/O1w+VWLEy+OoGGsbBsHBsO+1aFG5cPX2kYYohx1k?=
 =?us-ascii?Q?Jx2hI7TRA8DLsNu2YibaWFb/63E/Y8qcEP9A7YwYnXEBHVtnS5Y1ERJ6wqo/?=
X-MS-Exchange-AntiSpam-MessageData-1: 7eoicn/ek6UnH6UMui9fHyvFxZDfUGRcS+s=
X-Exchange-RoutingPolicyChecked:
	bqs8IVgj46nordjckGs6H5Gd3V8KhnOl7oA7T8+PSsrh0MRXru1usEabrd56/2Xkqyh6bX1Ej3ctVx/8Kq/JFkdm5XApEj55fUr+Bc2nmMkJJ3E0gDfNEYWBEc5Z8E6vLlVeC28unsD3AD1gRYiHXUeb8Cv+cL47ItxZr7CRyVJOkRAtqvFx3GnOS8ToGK05udoCYlFKhQJZi53G3N06YigAS4mwNoq6y8v4rholRyX8vdb6yuM0y5gKtqbDAuu/RXL8h+VuZmOA4cYPuX/FEQ+Ly4xZknez1z9wOHQXoJ0Hj05YULgx4EE6JNEePtiOlKhGEVzx+5zata5aXqRxVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v4TZLT70/CYTNVamQgw1n5WXHAurSqXlxXFQI3L1kyy6r8xjeEaZqcsjumD2CTrxXpSLdOhF+bg9lnDx4jwSerg53U1WPs0y1a697H7LDG7SOTUX6fkXiK3695kSIpkxgykBzKF+pjLPmiA90wiJDKfdtGznO+BIu1wDsf3ntc2uASCymRDEFBeCqT8ysQHE2qH3l8Ekrf0tEV0KwN0xt9wHVMYSmc4prBLd3u0fGFepIOQ23AFkw74KHJQLjw9qtSTC8TipgmQA1FfM41Mm3Bn1snAmOIO3r6e1RfXfoQRFdTHIs9upY2YSzntYspfe5xJZD218ZxYErOOV4Rym6piIGqeRc44dkh0W9HqWJc/5Bzfcvrwvaw4z2WnJZd9Jr0G4ZzTY6SlGPQEbE4Vw67tVFvHZPrfhtC98DajQIYzIXfPKwPOJQ0RejeDWDhXyXausiPircZlBKwVGaynr8IpH+PFjvv9NFHI7mwHh7JPvvPE+k6qUlK6wxuasgAUY7MRmbIc5misLV/CNGCzd+YXx3APDHUJH6SuZiS10KsdkNfowcHPOoM5qqGRwwieYBnboAvnW9Nwrx0RP5mAIXjDGKickKuR9y16bfcqJf6BbmwoiwaPXpQ+w0kbN0GSL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f61fa931-214f-4bdb-5c4e-08df33fb1b91
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:50.2885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlcQMsHO5gITFO8c4XbkuPV2ZNpZgTnTOs3dv6Q5lZQBfuB+h3FM6xxfVkJ5kMnNEx5Cp0+4unmzhnSIev8BhIAR32tB9MGMb5M1u038mQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Freeing a dirty tree block needs to know whether its block group is
append only. Count metadata block groups with and without sequential
zones, so the block group lookup is only needed if both kinds exist.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/zoned.c       | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 027830a53f7d..b29070b51b92 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
@@ -1204,6 +1204,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase_cached(&block_group->cache_node,
 			&fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
+	btrfs_zoned_account_meta_bg(block_group, -1);
 
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ff630630490..8b49581eeffa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4170,13 +4169,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..1597bd4512d6 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -919,6 +919,8 @@ struct btrfs_fs_info {
 	u64 max_zone_append_size;
 
 	struct mutex zoned_meta_io_lock;
+	atomic_t zoned_seq_meta_bgs;
+	atomic_t zoned_conv_meta_bgs;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 6991912701e5..02c15b2da344 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2007,6 +2007,7 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (!ret) {
+		btrfs_zoned_account_meta_bg(cache, 1);
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
 			spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2288,6 +2289,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2315,6 +2319,29 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	if (!atomic_read(&fs_info->zoned_conv_meta_bgs))
+		return true;
+	if (!atomic_read(&fs_info->zoned_seq_meta_bgs))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2581,7 +2608,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..3a2ca8bd68e5 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -215,6 +216,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -432,4 +439,31 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
+static inline void btrfs_zoned_account_meta_bg(struct btrfs_block_group *bg, int delta)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	if (!btrfs_is_zoned(fs_info) || (bg->flags & BTRFS_BLOCK_GROUP_DATA))
+		return;
+
+	if (test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags))
+		atomic_add(delta, &fs_info->zoned_seq_meta_bgs);
+	else
+		atomic_add(delta, &fs_info->zoned_conv_meta_bgs);
+}
+
 #endif
-- 
2.56.0

