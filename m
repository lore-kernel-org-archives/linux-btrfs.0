Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD13B389A;
	Fri,  3 Jul 2026 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079468; cv=fail; b=eqBdPG5xeHDVmiYJwEw35kmfdEtAqP7wuC84GQKVQtkjv+ywD7zEUbcXzw4RJxgVyFytydI99dAgevpYodO/EPqczic/86rgy+QNYUa2ZFoHUtECtuttbdtSueastw57nJ2KDN2HZaucnlpWdO4l8RvdcOtskn/8fbvqMAWe+RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079468; c=relaxed/simple;
	bh=R/9eku7g7dlm/ZK+i+YxwEdDH3gwdPM8Ju5HXFKj8Uw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sAZVPnxxTuoVtjMwmgkzg6iCVr68Ug8cmIQGVOHiDKBy5woId4ju92/BUZk0mjXWgnWzh8YFILX53w0FaZStGeeqf9aEZv8LimjhxiJHX3flZGencQFRbgZYiuj8q72oT+FEKchk9b9j0EFnYikPvExwTr0ZJXJF7mMPktQKoKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TNkjThac; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tUuOrVdR; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TNkjThac";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tUuOrVdR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783079469; x=1814615469;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R/9eku7g7dlm/ZK+i+YxwEdDH3gwdPM8Ju5HXFKj8Uw=;
  b=TNkjThacv7+kZ3XPYaI0ZKwVpJIc3Ov9w5YiWYoDm+iNWk8D0gtcjPrU
   AxoRLofaWkUKkTViWUDRR3ujNnJ2foLB70yqPyzcndDLGSeJUU2LTGAyp
   ch/Z5zhR7F81xgklq4P2MGIcbqHb4Tn2SRbLffajeZptIsvS6rc+IL79t
   S+68Ar/5G5veCvmKPQThHpVFSa1RhILHZX7bRU9ZdEKeuTbA0foc90uez
   lgEoBgKYexhbRjtwEUrH6rLCcD2G7CVM8UK9/LYLFUI5UKaE2+/oD7UCd
   G/j97bz89Oqknq87rtk7t4FDo3tXWYrbt6WYpCJ367nr4wGJCP/v/iWvp
   A==;
X-CSE-ConnectionGUID: HctNK57UTga01zTpNDN3JA==
X-CSE-MsgGUID: V2t1RyQHRieEaKZ2xI80Xg==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="146164524"
Received: from mail-centralusazon11011043.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.43])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 19:51:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lVfGw1dFlOdPGCVkg2MXja0Sc6WzPXFG7ILgkzeNOwM2B6jUayvqY7DaBQYDHy60Q9rlWRrhOzsRmolWoHltrt374EuobX1c1oblAxkFgOpzuUCX+aM9A4AsVe9I1GQ8BagX3vKXAbzrWuOthUpiWAol/43wQpFAI+BlfXXH4jx5mdOj72aQ8IICrtlZvTc0Z582SKUR2FuUmTFg6a7V3Q6GqA2yqB0/h3tHr1CRuypPCjjhMQIHLOB7ergA5mT54nnKmt+da/ETbAsuF9ExgA2Vg9+l1T+W4rRXb2OMLWFk6bnCpYGuO6eE8LYuejx1mE277JSzRZ0z6q3oH3qiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/9eku7g7dlm/ZK+i+YxwEdDH3gwdPM8Ju5HXFKj8Uw=;
 b=LhA1xyznE/vobjGNk5iF+DUIARs/Z8qJ1ogSP1EyK7+jS6Zi6SXjjABGa5xAqe1//wTkED8ekaZKbC3Rci0LzZJdzwBZXOJc1zFN9i0oDMxPb+E1eXTe3h6LtDGXO8jMMpX4Bs4JD4FOpx2R8qy4Uo9jA7s5pXdHAWH01ei3yfEFKJbP/80v5GK7Trtj+B0UpbH2bdVX5W9CIPL1SCylnP6dHwXqCYzW34HOSyjMQ6ajsLsY/YkAEmK+Cfk9xDW+AOzF0YE06fb6IG40L8K2P0PNwOpCxhAD9xOgM5p21sc9HQGY8ssgfiuma8EP37p2WQDB/sKkYuFXN89BqE48RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/9eku7g7dlm/ZK+i+YxwEdDH3gwdPM8Ju5HXFKj8Uw=;
 b=tUuOrVdR/dOmfCWW96nTNOIvRq5MGliC3XjHjmGOX/2H60rRX1qYsyZlODFVQjarU9qyM4SPwhPv5ElYfafl9IFmGUCkuD/jv4ZBIOLrDIjbq1aMdjYEwbJ0f6eDKXeDA5Tf+nHzxXk6sQte3QptsfcJzrsWZ0lHbCQlkQ7MAzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH7PR04MB9545.namprd04.prod.outlook.com (2603:10b6:610:24d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 11:51:04 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 11:51:04 +0000
Message-ID: <6cedc123-0e9c-4c00-bb79-190f0a9e34a7@wdc.com>
Date: Fri, 3 Jul 2026 13:51:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
To: =?UTF-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
 <b0d5ea81-37bd-44c3-b69c-ce7d47d02cdc@wdc.com> <87pl14711a.fsf@>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <87pl14711a.fsf@>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH7PR04MB9545:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cdf0c96-b2a8-4b3c-dc3d-08ded8f95c83
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|19092799006|376014|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lyh2WndA7rPWp1liws5BC141xNcwopxy4DZPwQAl+924Ir+YnfqvtGhyEBwUUlKYw7WedY72HhmR5JFuJFWMWUd7SqCepAMfFAFTYolTXQ3xNebQpp7ogS8vBkbJqebKR82WxrBCLnr24K7PFmT/uMcjkEvLKU4Wyd6fzQwGg4L73WcoEdq8jU1Zn4Agqmm18bDJq8q0ceJyIBkwccYpQE6KfcbTz2lW16gv0f4issysWOADO+btvtKAJBfmBSghwBfDo0NhY48Z8s/3LGkaxxCPpf1nCVXdntzHc3llYgM5hIj5/kxK4qX7CZJK9cvoGxrpio/kb03VWtkqc97xs2s6AOUbhs2VUnYbbhHc2rirgZjsu+41UtGz5SEFFED9vJTPWzSWH+nQ6KFug6UOgITwcBMvyCqbRqIkzMjUKsJPICpEG14pILRZia6/SjRNvy9fx83Sz8ziuXfTv8AXbPQHVOlgHvbTf2Fwjs7XK1y++WngEzdlbz3lHq8onYPmZvdiXnlfdiyZQSwTyLyhrSVb4u8tTuPUxdZVqC5MYBVs1A5o+69iTJxP0ZzTln04mFJQoyomskS3kUTp++Bazxsz6GE1YEspIkaEGVExPkxwWTAyRkoMNa6qozpO8ejgUKx7N5NLszCFmGIF4vI9oIqcHtwjNuS34mmaaLpsKR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(19092799006)(376014)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2QzeHRjdW93cmdRL25qV1hCbi9FMmxQdFpQQ1FPdlc4NDluWEZkLzcxT3Zr?=
 =?utf-8?B?cjh5QjNnNnphUTNXVzNUVXB4anEybzE4ek5qM2ZkRVA5UGpYYkNMSHllUWEz?=
 =?utf-8?B?TmdvdmUwZm92dVVLYWtlTGw4cUh3TyswQ3I2MWwrSTFOL3ZPbDRhd29KcUVB?=
 =?utf-8?B?eVowTUhQR0Zjd1NGSUVxajdVVVFzWGozbXNiK2FzTFhrSUpJZlJYRHcvM25Y?=
 =?utf-8?B?ZTdnWHVhTVdqYVk0UHFMYk9CTkZhZUNKc010cU9UMkZ3NFRzVjI1ZlJqZ3FK?=
 =?utf-8?B?dXlrTmIzS0p0cFIrbHNHTkNMaHVsMmdmd01oWW5QbEM2Y1cybGRLbmRjWUZM?=
 =?utf-8?B?YmxQYnh4QlYrNmx0VWI0YkhISmdYTHZ4TTRpTnk3bk1NTVEyR2dwUkJTZ3B1?=
 =?utf-8?B?MkU0cWRuMWUybExjM2NCMlg1VVV1ZXJhUlF5czFxb1NydnRsSjZpaHhsV0VL?=
 =?utf-8?B?d1IyZENBRkc4Q243QUdaZUN5QmpzcHR1WGFaOGVEYi9Reko3YUVsNHhQQzVP?=
 =?utf-8?B?b1p6aU45S3ZIUis0Q0FXeU1ZbHEraWFRSnQ3cGl4dlRzdzRwUUJKVEF1bTkr?=
 =?utf-8?B?eXNxalNGUkNGTjZtck1lNGhmbXNIWkxydnF0ZmNJeUhrYW9MNUNaM2p1cUVC?=
 =?utf-8?B?K3pnZlh3UlJvamRvZW1xRFpVa2lsZWwwMFU1aEt5aXd0RDdmU2VSY3ZhM0FN?=
 =?utf-8?B?OHdEZnNYSHBoeWM0QWQyMkJOazJiQTZkRXNSTEtIZUNZMHlaOHBHM2tJcmcv?=
 =?utf-8?B?aTJzRVpDRjFVN29yQzhCRngwVTJ5MHNMNkZ2OHcrRVYwWFdrR29oM0Q0UmxP?=
 =?utf-8?B?R3JRYm4yTFVDMUVaYi9kdi9RT2NoWTE4elIzUzB1cWw2TFdGazZKR1JrQWFE?=
 =?utf-8?B?LzVBRVUwaFFlVk41MjRURFpDSlNQTmhTVytvdE5TUlFBenNVbll5VkcrUUVE?=
 =?utf-8?B?NjlzVGhjNk5HbTBROGxjOGs1TUJ1TUEwUVVoRS9sVUZ4UU9EeGJ4ZHVDNUVi?=
 =?utf-8?B?Yk8wRk5jeG8yTVE0QTRkMC95TWdOeHo2dU02SlQ5VHNramRBZUVCa3dpZm9G?=
 =?utf-8?B?cmJ1RTIzamwwdXJvWjBJNGR0YWJZL2JsbGRZbGVoREw0cWJvZmY2ZnFyVzlW?=
 =?utf-8?B?eCtlaTVGQll6RVJsZUlzS1JyTlcwVVY2cC9RdEZwMHYwcWN4R0NrSkFiTW9P?=
 =?utf-8?B?QmlBcHdnbUxjcHZFdVMwTnBoUTJTRzJGUzNrWVI3S0hJTjZTaTF0MEV5aTlW?=
 =?utf-8?B?OVBWNVBnMEM4UHNWRGNIVWJScVFhVGdHc3N3aXVrVkZtaUZrTlAvcGthWE9z?=
 =?utf-8?B?Q0VGb1c2Y2lCS0wrRUMvU3lpWlV5Q0JuckNQZDFHVEZwbnh1QnRYMTdEdXhs?=
 =?utf-8?B?c0E3Q25rR0NyUndzSUJmOENPUzZpTWVPZXZYWU8yaGZQQ3A4TTkwbUtmSVdh?=
 =?utf-8?B?dXZKeFZkNGFjSkJNOEkwcVdGaWJiaElzWXRJQ3pQemhlVjVYRTgwdFRhRys3?=
 =?utf-8?B?YzdLSlBRZ0lFZmU1WlBydU9BMFNBdU1NUjNBRTNNMitDdTdtdS93SnoybUN3?=
 =?utf-8?B?Mm01eFU3RTg1TkwrTDVGS2c0NG1mcnFDTWZmbHNQVFZwbEVkcGZ2UmtTYUdh?=
 =?utf-8?B?SnV1SURnemZXUitubUJQNzlNT2dyemdyRGZ1eDBObGZNWTcrZFJrNUl3cy9C?=
 =?utf-8?B?elFnTHNtSUVobmZOSlBOdXloVThMcXlXZU1Jeitzc0RhVVZkKzI2OEJwMlhh?=
 =?utf-8?B?ZXUzMzFaeFJUVFpUMXZCQTdmdGI0aEtOVWEvU1E0Ulp4TVBQbnE1SDlOdEh1?=
 =?utf-8?B?Skt5RE1UNS9yK1QxQVRmbmdMMmVNV0VlOXZPdVdpWnRYenlrS2J6SHVtNllW?=
 =?utf-8?B?SjBNUEFPV1QvWWxnNTNSeWdpY1JVWWJTaHZ5cVdpcmo2N05hTkZxeCthWGth?=
 =?utf-8?B?cThxakh3d2MyY1NuL1JHRWI1OUxPVUlaaklFa3NvSldsa09oWmVCQUd3Wjd1?=
 =?utf-8?B?QjJwUFIyTFhSeGRrN3NHQklBeDdxalI0V1ZnUUQ4OVZRVmI4endPQlBCNFFz?=
 =?utf-8?B?T04wYU9VcXoycTFZNW5XSnVKTDVTdXlZcVluaHhDR0I5c2FhcmMwNkIwZm9S?=
 =?utf-8?B?QWVaRnBQcEYxUkh5aldCSXFHTm15V2VKZWJsN05GamJ0QU14ZkxVYTB4OWlG?=
 =?utf-8?B?Ri9VckdDMVdXZnp5cUgvSGdWcjRNN0tDMGtMNE4vU3BRNlJjRUNMbENkdncx?=
 =?utf-8?B?QU5NOVFOU2hKZFplZmZWNkNYL1ZMbHNnZW5SSU1KWncyYVNmSkZaaS9ObmNS?=
 =?utf-8?B?eVlqZWdJb1RJN3FnTmZZeEgxemkwQ01mRWFLemlBMlg0RW9KYnpGZ09MV3hy?=
 =?utf-8?Q?yRPe7IisOSwNZa+s=3D?=
X-Exchange-RoutingPolicyChecked:
	lrRJanq3NfziPPq3d1hKI2CrWIW0ZzG/SSw1JSvnf4PYiy6/U/L1/g7qfjRfYD2zuDVEfCwzbpfCmZDOb9LDmzgMnx09h/uMQPiPDIoR3Tq0ajaFsoF/Z1GQcRkHlsjoupHf/A0EwRaWiNG3gr0gywPbcCesVzUvujcfk2Xb2Bq2aS6H16Bc8Amsh7Pl54d8IrtIwZwFxja2NXitmkLsn764k8RY4XkIfxGZ5XJn4OrPhcunZaYt3xgBNqoAAqz7ON1WH8si9hl2IKp54QcM62OTCsG2OVrNoZKp1Ut0qJTpGndymfLvIsrBdkRY8YCTb5VNFME+FdgJS8rHntWchA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z5iSQp9X9q8TMm6liAEvfb7AfXGSQupgLJLqnIy+8QSO5xL+pTC05EOuvMRkdLdTK9uEQeeul0HoQrPbF59kcCPs8KnOY2MdFTERaHbdgyjLVK+lDLT9OcDnagm2IJciYMl2afJ+EeBmV8PJ/hS0SJGtkbMSllGrEQ9yl6qJfAxsEEncLPg9MHXGk5eju0+lmakRfcaYd8xZT3EkhZ9r0NzHiuTyOtIogy90l16iCFKY6ipklwdqtQ5h8fogtsds9zj3LYBwGrA2kg+Hzegz3sH1MM64aRpyzCMmPK5thrOY/zmdvfcK+PTS0UeDQKqTnUK03tizqptyUbUfo48FL727jKIktkyCswdcXjSEDhkyaU8EHm+c74uTG4upqtiOBsNicxf+qOw8FiioZoQMtmCueTa+nunYJW49QYtbt/6bhewgAWL4F0FVq6n9K4nI+u11W4D7L84n58PE8LiR19bb2xGSsp3M1ntnrN2+qLZ8LBpO4IR0ap0JF2v92ohKUa8z31YFDNXrYDmce4Q9Ikvb3kLRhCgm4r/zmWQHgbCYebEkqPxgGmS2By63ltHX8C4Ro/wb0EYGkTGDzZK+YkGOL2vna6qHwJxKj4TSJ93Z/tk96zl+ACzkmYLhS4gh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdf0c96-b2a8-4b3c-dc3d-08ded8f95c83
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 11:51:04.4530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCmGjp6oQGUXqwvvtP7NzXAaqjXJqyJCjBkWH4PjB68oViDIvw9QGsOerfM2y1DBsQit8EcgqxmelH/GD5Q7ln2Rutm7GgdvjmxMgq57aG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR04MB9545

On 7/3/26 1:41 PM, Miquel Sabaté Solà wrote:
> Points raised by Sashiko aside, thanks for the clarifications, much
> appreciated.

No problem, you're welcome.

