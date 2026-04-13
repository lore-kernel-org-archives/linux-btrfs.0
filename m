Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AEC318EE7
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 11:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776079592; cv=fail; b=iWEMZC6/SCI1047r0OKjhi1wd6S3KZbYJQyWmA76SMnbk8qeNPvyXqsnLjcKrjR39zCZmokznJ44x0mfe68pIfJL3FPFLTqht16TykY/f1cJfxcyqZNzM3UVJjW3WrOmabJmcwOlqKbKfObVsRUaGQOF4bbQXuOXMHJG/6A/dXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776079592; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jfAJyrXNWwJ5lspo3UhvQS1ASyIc0oCTx+rDHjdhHeDwmuhN0ZYtfPdB1NJwIPldhoZLWfyMvfXuCkokWaoPhdk8vgxFxw/CbUVwXDZgXJeD5uoEAxEMlEKxHo2dSH9ny4PY3nrJ1bJ03wDanj7eM1qRPu4yh3GXeqHg4rn8hOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cOBRJaBY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ov3dod1+; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cOBRJaBY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ov3dod1+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776079591; x=1807615591;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=cOBRJaBYcAYwHUNQ089LBxs8TdLGLEjqljG+jTzmFutrwxLiLm2AdqKy
   XGVTMo0Hi1QWP/80S7btN6MhTuRP6aRV9OEQd6GujprgjZhR9dAaR/j9y
   81M11S1A3NzsBGgjsfGHYetxtfPevwqR7XL4fzqSGugF7sCdxNYUKFY7A
   LbIyWM4Mwakdobq5k0LFdhQeiCDdeYjLyezvGsJQC4SYQuARTO8wijEqS
   cCu7hUS2fbcOt7ufleg6Ih46oHUOBuKfTwdmQfzYMHE3ReTaEoYuXdTIt
   BftmHSTpRgqf1r5gW9q2QuVqpLfFHFut45D6dZ9oBmcllTuN+udoW6/MN
   g==;
X-CSE-ConnectionGUID: 0Umf6lmuSZet2wXBLXX/Rw==
X-CSE-MsgGUID: N5SEWWD+S22Sf+0RNbotFg==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="144418389"
Received: from mail-eastus2azon11010010.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 19:26:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BA7JaAwNvRUILliYEbZcJmdHuCU9u0GdwfMtuo90q9guHYtA98gYMlxbDypzxAxOvOnZ2CiKGGuloIxi0wLuFzrYhCNJXFNEb+61mVcpoMxyE2Uqn1aLKd4lrOlspovw5oX22BvQcQm+FrpmyZ93+d4VvJn1SIpE5UjIj1sLho6rBmlN8tRmsCofa5GfzdvwJeck/XByGVkkea85OZ1L6glyWquHrO374aMcERR1acL9NwBc3E6jD/SHQwiNGWzMSltvxenzm5Vn2R0Z39bjCL0FBfhdCEI7HkR6qGRWCfrxtvN9/rrgqNBu6O3qxdAx1bZpFQhPT4h/j9eIwfPRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=PMR4cRBKnSI+ERGalQjOEl/e7lg7XnueMf0+Ji92tBJbZONH7HrGWEq9jCwbkVtmHvucQ+iJv0PoRz2BkhmPhVxNSMLouXvCW6tr8ETimELgrWJFrwMEYKap7lWV9+wscbgeQgqk6YCQ+Tvnj31UzNegf/u4NE1qPSCYzv+2Mvha8f8Tchw2/YLnDEBzAXiWyvcOLKyGvmLgSaSOENYFJzsYIL3Pu+LpF79hRcLmc04Dc4+nMacbdFc3AXBodkpWX0V56uwydOG4fSMolZJozOMo6hXdCIF3VG4+E7Q0dMez6v3PSdF1eqx3ilpjQWwKv4CCFHV66iQbXHAt+jFPsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=ov3dod1+ymlPMZJccWIEg1FeAYaisCPgD6vetrn8kBmYTHCsHG82MRmAibgTiA1fjq/UitHUxSj4Xkyss2C25QwQHBLP5KqQHoIWbZOEGmwA/bNYcMQJyL/0ZMyojkwuY97Vz95Pe2M3wQqrGEe4F48PPI4aCeSOmAEfZQEHFuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com (2603:10b6:a03:557::20)
 by CY1PR04MB9739.namprd04.prod.outlook.com (2603:10b6:930:108::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 11:26:19 +0000
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::cfc5:d779:604d:ece2]) by SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::cfc5:d779:604d:ece2%6]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 11:26:19 +0000
Message-ID: <3a0c1b94-4404-4726-aafe-809c425707fc@wdc.com>
Date: Mon, 13 Apr 2026 13:26:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: abort transaction in do_remap_reloc_trans() on
 failure
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 boris@bur.io
References: <20260408170349.130997-1-mark@harmstone.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260408170349.130997-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0199.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::7) To SJ2PR04MB8987.namprd04.prod.outlook.com
 (2603:10b6:a03:557::20)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR04MB8987:EE_|CY1PR04MB9739:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8ef20d-8370-4c28-ec36-08de994f7bb0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|19092799006|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pI0cel5KxHQlWaD8Cp0DKIxp9H6UFGIvB5B+FgrfKD+PJ8A3elmzjjMPgZBkRA0a2CFHNTWiSGZIEgYOMdKOb/20828mE/QWYOwL/dfkep3KLOWr770Y5GK2les0ifn54y4EQ261Dy3vQAO7vBWeT9WmTitg0BdiucdZGNF4MGSEcWJReIlMfxUQ8nDmrnyITESe5RgvQTFJ8+zg35dGVoOG5pjoSXmWiEjhMA+M3+9uHUo3Qm7Dab4Dz6p7KtGtzBZn14MC1mJpL9zjKOqIBZmPHGhw5gtoShuSzddImnKF9N9klceOLVTNQxv4KyAsCp0NkA5n3s2h3MxxI4AK2Dms58QmczXRKb8OoAwr1d10duBSYVqtBkPbvhQjXFCuw1hxJkObxf1hPAhx9GgxadYmYi4cYxN9/OB6I3evbNPGw9xfERSrV+q171ZL+xy0WrhEaFSe9H7RPUctuv53Rn19KxPjp4aPqggYMlOiN/GhuRmDj0Dj1lr0A/Mh6XCG6sv0JGJv0RaTaghOIq1+uZqoocbLTSkWPDnAKCUYgGk6YFlf1UUhvTeRpm3SbUCnP3F+ISd0WjkLKBr1OkzV2osiUqFJmMotz6EFaVPWZBljvI6tuV7WMUaJmtMGxMFRAFwoatWl789qXnQWO1DrcAGI8jpA6iB+JZsCaZvZ/HOY7CoB3r7WX82K4vzTUcPh8dDZmDYoycCcSxJJWhgRB9sXuqXuzAyHRP0GBTVcUgw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8987.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(19092799006)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uml2WXpINnNGZWovLzd2Nnlhb3NpdjhvcEl1WmYvaVVGZlhEQU1uZHRERi9y?=
 =?utf-8?B?bU5pMEdOWXZrQU10MUN4R1JzMXlXc3hsTXFxMVJUMnhDcFZEY05lR0pkKzVv?=
 =?utf-8?B?RFUyMFF6cXVYMEFVMytiWWZCcWxCbVFqYTNOQWpSZ1NrR2hUbk5zcU9oUlYy?=
 =?utf-8?B?RHI0eDZJeXJXa2JZNUhPa0JoalovTEdKVFNXVHFLRnFZZWU0Z2FzR3RvRHZy?=
 =?utf-8?B?dnY1UTBZc29hQURiaVlzOENJK3JxR2hBTXdWQVNTSlVSV2VxaE9UOTlqSkxL?=
 =?utf-8?B?UzhYL241Y005aE42V2VKWjA3aU83UlZJYTRMOHgwNEpLd3JTU3BHSVdydDRJ?=
 =?utf-8?B?T0NZbnE4b05sU3ZqQ0ZpcU5iNlNIOGx4QkdvN3BEL3prUUptV29qdkgyS2Vl?=
 =?utf-8?B?dmF6VXdjY3hZd1dxYll1VTFFTFRFbjRTNVpiMDlOODRtYWdGN25TTmdZTWY3?=
 =?utf-8?B?Ry9NVElTY3ZaZkFKWDF5emFPODl0QUJJaU9qYUdKL09LZWk5dXowWTE0Vll5?=
 =?utf-8?B?TXRlUkdvcmxTaUsrWXhLRjNRbW9jZHdqSnowcGcvZ2pCa0E0NWQ4K3VremJH?=
 =?utf-8?B?V2JaZjhmOTRLcmcwL2FYMTlaOUh6QllodS9QMEZ3NCt6MGJtUklWRUR2KzhY?=
 =?utf-8?B?WTRsdHJhaWoyZTIxRStIdjdrenJBVnI2NkxLZHRYQUdaS2xUSklXMGtCV3lF?=
 =?utf-8?B?WGZWOXQ5MGpNS3hvQkJpSTlwbE8ycEozU1JDZ2dmbUUyamxzK3hiMHhGSnJO?=
 =?utf-8?B?TEh0dDJxVC9CUzBjeXdhajgzTUFuVVhQMFBZUHRyMmFTaDlRUWh2cU9OUlQv?=
 =?utf-8?B?RGJYWGdEcjRhNUNhTk0zOURDT3F3MjRrd1Y1Vm5yV1BRZ3c1MFFyaXBRN0xD?=
 =?utf-8?B?N0wvZkZnUjJVVktnOTZyR2M3dDNSVnlkNFl6Zjhnd3llNUc0d1RxQVFrZ3Zl?=
 =?utf-8?B?OXllcHVHUzN1bEJ5NGEyZVY5RmthTDZhMmRkUm10ZkpYSElvUTRKWjI0QTdz?=
 =?utf-8?B?dXJYK280WGdyMkJTOERndDd4OFZiNWFZNTBjNGdpdTI2TkV3VXdiTUJ6L3Fi?=
 =?utf-8?B?aXp2c0R1MmN2dmNJRTVGMi93UXpPbWp5K2JVbVk5NlRydk9Eam1Bb0tPN29t?=
 =?utf-8?B?SEpCVzJJN0hkTTJsNlZwTEhRMnJFSGR4MzQ1SnpKZy9xVmhja01PbXdNbzls?=
 =?utf-8?B?dHlKOENwM01yWmJWSSszTXVwU1VOTk1qYUVNSzJQRjEvUU5MRjM1blJWOFFr?=
 =?utf-8?B?MDVWL0tvaEgrZjFtSDJwQjlDcU9zTEttclVXQmE3WStzSWNwK0pSRCtMWldq?=
 =?utf-8?B?QU5MeE13Mk55NFFvMFpFcUk4bnBqb1RLSy9PNTU0azVUd2hoQ21YbE5MbEZa?=
 =?utf-8?B?bVVqMDFGV2tmWGg5cmxQaFdsaXBkclJKZzN6anIzQkZCL2pJZml4NWVxSENy?=
 =?utf-8?B?eDJXQjZiMEl2L3FTZnBvbFlSS2ZGQ1dYTmFMMG15eC9rWE9Kc3Zob2E0NFpE?=
 =?utf-8?B?WllHeU5CZzkwUFcyM3pDdTRoUUkyNkpETWpNajlRSTRmcVdyMlNyanI1MWxF?=
 =?utf-8?B?d0xLWjR6VlkwZGNjalRLYXQ5L1lUYVRMaFlHQWd6Tll3cDlIUE5BaldGK3NE?=
 =?utf-8?B?Y2ZHeCswOFhYWHQyRkJxNTU0VTBzSSsvd3JnV3JzYW5hbVEyL21DRGcxM0pS?=
 =?utf-8?B?bUZvYktHK0c2Zk14YW9NSEUxMEtMaUZhMDFsNkRubmlWdTE0SkduS1pHQy81?=
 =?utf-8?B?V0RvOUdOSFJvd3d0VWtzOEJsUFdSS25PZXlmNlVmaVFsM3E5K3BnZVBxd05m?=
 =?utf-8?B?Ni9xbXlVN1oxZStXK2laOVVaNm5WY2pvWk51aFp1aExzMGFDNnkwb3ZDRGdL?=
 =?utf-8?B?bHBHM0k2TkVFaW1TcU5xZFpEZUsvV0pKWnBDOWJiZFpQVXQzSjBvMHE1Q0Q2?=
 =?utf-8?B?NGJ5S0E2eEVjT1Qvd0U0Y2t0WmpUeU5Db0xqT01GeUhpQWMwUGF0N2RoNExQ?=
 =?utf-8?B?R003ZUE3YkZicnBlMVNWdDdNeS9kSGZhWDFvOE10RjhGN3NIVkNFb3B5TGFQ?=
 =?utf-8?B?VGM3aHVFMElCYkU3aG9SQ3BRRjNMV2xpNElrakRIcmZteC9VL1RRekZMTjF6?=
 =?utf-8?B?enM3YW1qcHpLbExsbm5HdlgwdW5ET0J0eUw0WDN2K3pSS09wZGw1ZSs5R1hO?=
 =?utf-8?B?dERDbzZxMUdJRkhmcTJYNUFrb3dsbkxIbXJwRlAzdVBWN0l3bCtXTnhkQmxK?=
 =?utf-8?B?ZHR1NjJrNFlweTVTUElxZ0RsZUxaTkZxK1B3MkpiZjRFbnhvbE1BeU1qbnQ1?=
 =?utf-8?B?bFEwcnIyZjdlWlVWdWV1aWdwZDllUkJ3eHFjRmtubGlEd1V3cGJocGgvTFBB?=
 =?utf-8?Q?dSr88e7/4V/gB5+ghhK0AVqIkFFy23Y4Ng7ymardZQRo2?=
X-MS-Exchange-AntiSpam-MessageData-1: zy2wmDTVXq1Tg5bYc3bOjCykpw9sxApoZxE=
X-Exchange-RoutingPolicyChecked:
	qzawdcjeHCclVofAfIbyfm4crz9FaqFJxPVjrJoiW2oYVJ5+Ob9E6jwIcLOlenEGm1gqDH8uYIX8MTNX2zGsG3vo7jrBTnQhDhXBwbHrsTIPHbOtL+xeRFItn6e3LMarSYzmckYDmhhJdFXxJnqBwyGCopmwGFrJ3hcFw+foRZHA4dJTFy0edITl5TayFIJCPV5e19tJS+5yWliIUqeSCkMVYN88xQ8iIcWjsFKfl2JlGvkl9/2eQP3OzbEKcksVK/zjeg3tgOOC0RxysyjUgnRK9uQv3AZcKfm0NT4QevpX1i5X+u1l6iQ6eCHLQwSwOQa6PjS/+BPby4yONTkcNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+cRlcLj+RB669IP9LHgNN4Gjc6BoL8+S9baHh1qFhBwVKz0qeKeG+kD4qLUOEGS0SAxt3FmAi/u3vwjJEI/mjOyXfUoCeh2tCeBaODnIASHVVmeXn78TjYccwaYSKRYipCXP6lkrS15nrwvmg/E/CaYmtB1I5mt0TnZBNaNN+35WTO2hB7K/2XJS71iHuGit3MCyIfUZNZdTi0RNqpEvHyNLHDtJ+9jWYNfqGO4wsYxuQPDwt+he7Lc1Xc+YbDGXv50YtQlCfBJv//78S3OUQUfhlKGZA8wjcir8/928/5GM/y0m+khLebzRBPL9r5t5SktEZUM2UoX/ma5qcZhJZJBqGYBNLcxBB4aSHv8x8p3dZ/B3aew4ES3naHkaKJuM4Zp+Im/zK7OTMmbmxXEh/lWYJJ5xC5dXBqhCN832d4C5qoi0ikWttEOpd+cjWe1B5G8T/fIkB8oph4n2Cpo/xqm5ljH38l0sH5aeI7BlekmCeF9vlv35MQSFQpFgYfmywE6nkdHxvldELR4DDCCamgcCDeJjtzv+0c8s8dgcaBHpk+wVZTaQtyLf29gdcP/VBuCfFJnx5zJCb+MMxrTBzcn0WvuT2V3HFlMIAnGEBTNVBxSw58p8TkKIepwOkTJ/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8ef20d-8370-4c28-ec36-08de994f7bb0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR04MB8987.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 11:26:19.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgimZBPp7fKbIs01quBsCoepdkaRUEJSRab1e8+/vIROeG2H1SixFViy8c2V7knzuYw0KND7yVzcZtypDVpjdiUrtRxwqON7l9deeUsT8tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR04MB9739

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

