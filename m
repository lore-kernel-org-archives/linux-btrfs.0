Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDFE3B4EB6;
	Fri,  3 Jul 2026 09:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072264; cv=fail; b=MUlrLmQqRAr01LdExnel7Hm126q9OkJu5BhOCAJ6TOusYqw7FC8NXq0rz0ptqL6X4/R5WzTVCrP57UlTPatLXX4vEIBRD9/C6CdqpwKzH+M3YlchkWx6h/WvqxpOASgPwn2bFxoXkfya+YwwBQ0vrFolDwC8N7B0tIkTEwStEwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072264; c=relaxed/simple;
	bh=kEitlebE373zGxrEulFENJQ6bp5gqE/C+9sAucvat0s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IqWC2c4A+Fmg8m1ovW+52N5HNHQVTmVcSBVM7Zh1HUR1JwGtvzUelKFpKl5S5j11jPxUAQrcdqgxMHVZrkHc3ZDNiVTiinNJTYHYP7BuQxWhfou5hfBjwTY35XRZrPsFcnu/JVFlqTpkHEGI31kgcSpDlRQcLA7yzGa0YCs+4k8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mpscK0bz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rZD6W3P6; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mpscK0bz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rZD6W3P6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783072257; x=1814608257;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kEitlebE373zGxrEulFENJQ6bp5gqE/C+9sAucvat0s=;
  b=mpscK0bzfg7r8oKcSht3KZwKrrJscwjiSkRP6QlvvjOrwGK34SPCuWMc
   OXnYz0WNXHCbNA6r1TKQAK3VJ6nfZyFpKVGRRn67bF5tEr9cZ/AELrwCH
   HsX1HmYQUoM7VulC654GR4MCLW9gNCBNudRvD5cTLF/Q5Vxz9CtHsegtM
   c/eoc+A9Pl1Wn4w9tn2k9YEBwNaol1ILcifyk+rGIHDu3KxHw2PbtFZ/d
   KFw1G7oyFfKCXqW2+qn8AZ3V6HF2Syog9j6vRvK147oLHoXkQC2fJFghi
   9SdifkPz6XOh6L5y/SqWQc3ujh+S6v5Rjk5xYgDxeobWY1ZLhp4JuW3Cy
   g==;
X-CSE-ConnectionGUID: AU0Xf9XlRHeuTFewW9Sv5Q==
X-CSE-MsgGUID: FdyUG2YUT8qHYGjt3bFL+A==
X-IronPort-AV: E=Sophos;i="6.25,145,1779120000"; 
   d="scan'208";a="146159017"
Received: from mail-westus2azon11010017.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jul 2026 17:50:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMM0DcBZBeDoiojljaOKPd8tkR/qf54QooF2xJW+EYxOEkK7wJqWjWmcNBunOqwlbTzds53P24rYPS+5CuX/djAxUJQIdDsxVh8sLGn2lpSrFf2uMC5qUGyrXnz/Mj7NrQz3xBVN5URDW5jpBdQM601Ge5YayaZwRRKnVTvBHFECV140MbmUE0gWjBKyMFoIeJTX5ftIQzHOn6FmrFWTxk1zMJ8NpzqNu1+gX+RgShhKTRB15jiSZjWJyjw42U/pMqd3qoaAxcGDpYLiKYsTCYLrqd3+qskpU8vE5GQewBoZjQ/HbmSdwSljXBhe2GmSCCugNhpUC60z9njBFfcK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBOiSribIrkbXt1aInqvC8g3aA3RhA8zAuSos2gvsH4=;
 b=DhyfBPs/RiiptjDJ5udl07GBGY3vvkcKYW46C4tFy68jnlY214BujNVE1Ke5MZFpV2kEeK7bOf7NvOAY8BMpDe3X48in3gOzTLqBv5PWXfX7Ce9v70IfxzGugkkVUlOv2ttF/QicxQIPNMSgNSiWY1GpDuRpc+Rpj0Af6nX4Y2dDtdAwqr08bPEoqRtBBWe/sAXbE+iqTivFJiXo+eX4/DL0FPJxRNU3KnMI85NMVEX4iUZTrDgChQbnRou92VvZu9mELqwEp6ky+3z7+gkfw2czjE4aeDifrbADTfqGh1r5eIbhG090ea53fMevIJK91yQlGq3sEEJqholId2VbIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBOiSribIrkbXt1aInqvC8g3aA3RhA8zAuSos2gvsH4=;
 b=rZD6W3P64NWCgL7EEvCMgGzuv0IzCLdEBhtVt8RnyrmPHeiZwAGXly+BlUP/MOhTin4T1JrpdOOL/XnKOAtDGprZzMxnP3BkpH1c8JXjoe3JeXowKjWlzvjwe6Z3U3lS54vQ+YRlbee+nL01Vt4OIWtuDZCx+dsVxiK5WsNLVng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7338.namprd04.prod.outlook.com (2603:10b6:806:ea::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 09:50:49 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 09:50:49 +0000
Message-ID: <b0d5ea81-37bd-44c3-b69c-ce7d47d02cdc@wdc.com>
Date: Fri, 3 Jul 2026 11:50:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: reset active_meta_bg on zone finish
To: =?UTF-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20260703084559.136605-1-johannes.thumshirn@wdc.com>
 <87y0fs772r.fsf@>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <87y0fs772r.fsf@>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0191.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: d7126e80-3623-49ad-eade-08ded8e89043
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|23010399003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DTqHMUax+FB59oLQSv9nbzoeRdor1ZwmqVRPpHPvexXa90QtrvD6z6cBriIw1C6bEEhVLdkXRQEoyNLHjKvSxsPYHkPZ/mFBm6WoRAYk2wTt6CkKhzsD4yJwXzQwsG3agFx5qnhwKK5IfwVjylsDUTvpFtXqp+Fu0WXTetrx2nGalrX5REaLmnxBa7cs7tWyVNRqCLLxHKhTDs3wwqqgh3/kWd7AILjrVt/KLCm9YDCo5vYlC8/xmLuThTjdduMN2L8bkIYC+N56zQbZ26pgrKwnE12JjNmlwqXY2unXbn56eSQs+21Y3keYa84d1IkKhYO5TcYmlEcia966wdWO7H3ApXlfcP6cENOu9IYW8eIpxAVyyMPwf9r/bo/eybRIf6ZgyKQV7/Z6wf1YJ4hm3SabOgEap+cUKkOdlSsOiVDKAr4kruSw7O6q5H/gqzPo6C6vzYjzdYgLGTSGR6f+BWsszoYWqa/+hARBGLHNKn7hl7wSXQY1+DMoymqQFZiETFR3PhnwzHd4dGN/chtxF/53crmY9C8EewcA4jOxejOZP0QtigbMYU1DU0/Ld5QK32boi1H6n31W0PpsGXjfccRzHahl3VnvICK/SeNRknKYFCcxL5ZS+9Ijk+6AgoUXg8wXs1fUelHC58iCUir69k9r3ScuNNjVlMpqiE4obXU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(23010399003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWI5QXhIWmNaVHN1cS9vSGloSTduK3FNVmphRmhmcTdSL01uNlpMSjVLaGxk?=
 =?utf-8?B?dDc3d2JzZXgvYTkyeGxrakhGR2d3eEVWaFJ0U2tqQUNjNFNTbkpxMTdxZ1Yw?=
 =?utf-8?B?SVNaTHJCNjBwWDYzL1RPbG9pOGc3b3RSN3djRkI3K3FTNGJyQy9OOEJKRVBk?=
 =?utf-8?B?NU9uWnlzZVM3MFh6SDR5VVNrWGlxd1hpNkNScm1tZnphU280Z1lPc0UwU2JC?=
 =?utf-8?B?ZnVrVm9ma0hZejU2aFYzM3ZYN00xeWQ0VWdYUERjS0lhdVN1Y2R0eFBjcmZJ?=
 =?utf-8?B?WksxZlp4YUY1T2d1bjFnbU4rZVFIb0FaRGNSOXZLTGZYMGVZejE3cUZyOVNs?=
 =?utf-8?B?aTZuZ09PTzVleHAzZFRFVGg3ajVhZ21rZngwaWFRVmlqVTVVT3Zka1U4U2N2?=
 =?utf-8?B?b3pWSzFKNWZwbmlHVmZxTFNUS3VrV1E5em4zUHdNeFF2YXVDL3VHNGk4aUZn?=
 =?utf-8?B?eUxicnlaZEVsbEZCeTNLdXpRVldzRVR2QnB4MTQ5N1lNSGVDYU96SzJRclVz?=
 =?utf-8?B?eHcyanozYXMzOHhCM1BrV2hLSHovYWtIWHFIUTJQTjlWQXg0THhFbENXQzRK?=
 =?utf-8?B?RDJCbUNPTTVOM3A1TTBIWUZDTjVtM1pzRnFxUWtVMlQ5bStpcEJEMjhMdW5E?=
 =?utf-8?B?dktlUEtLbDRVM3RlL2FIbHFsYmNRZU5zVUI3enpSZnhvaFVGS0krK3NIK0Ni?=
 =?utf-8?B?U2NRTllHZStlUVRnUTNuZTZaZ1dlQW9LbmJnVGsxdzJ6Q1ZyNW8zZXB4MGtU?=
 =?utf-8?B?MzkydkZza016WWMrWXpVSlZ4WHlHR1UwU0hMV0NrQkJOcys1VkFFSEJ1MDY4?=
 =?utf-8?B?a2QxcjlzRW9aeFpwNVJaUm51V3ZoL3g0VmlrN2hPc1JYSklaanRTM1B4aENm?=
 =?utf-8?B?VjJUZmxxLzkrcW82RzVxQWkxNkY1SWJhNDZ3VW1EdGFUWnBxZjRjTElFbVpv?=
 =?utf-8?B?NlJEdnBJbERqZnBxMmpPZk9HMnJFdldzWDBaL3N5MmdON2NDN2x2T3VQYVJZ?=
 =?utf-8?B?Rlh0dTNpbGxWb21jblBPelFNSTcxZER4R1RyalVIdEJXM0pYM3JTK0lhTmhB?=
 =?utf-8?B?Z1FBZUQ2ZDdBbHVjRDZsdXNueVZxR0JqaVBGaEVSaUluYUdHT2JUeHdibFYx?=
 =?utf-8?B?Y3pTRWJxb0VKU1FOOTJoUDFyZktnQTlzV083SERxaGFqdzR4eXBLQXp0Rmh1?=
 =?utf-8?B?amc4QVdsajZqRjFLZUh4SGFsOTV4RWhucTNyc2tEL1p5cUZFN096czloSHFx?=
 =?utf-8?B?Tkw5OXdXVnBKaFFmN0lIRElPSUdtNVJ5Wk1XU0tDOWU5Ylc1UDZrb2lWTklm?=
 =?utf-8?B?Y09kaDhhbU1Sdjd4MUt3V2VwclkxK3M1NmgrKytPOGQ0NlF5UWY0SHpGOEhL?=
 =?utf-8?B?Nlh3eGxqcEVUaXU3NUVQK3NqSlhuaFRPTGZiRitSNDM2a1RFald2c2l0bHVm?=
 =?utf-8?B?SDBDekZseTRUSXpMVHBoMjFxaEhtS0FRTTdFY3lpUlFNaUswZGxhUTRGb1p4?=
 =?utf-8?B?T1N4V3NkTDl2VlNJcU5yOWVPRDYyV3puSTNMMlZSYUpISHJjVEc5K0NraXY4?=
 =?utf-8?B?Y1hKQ202bEMwVnlOY2dkTnlkSFN6c09oVEYydTdhbitrQ3paMmFtNkZSMlYw?=
 =?utf-8?B?azdUNWxIbFVMUDVLKzV6alZsUS9tS3JwaEQ3R1VuQTdUb0xaYjhNd1l5b1Vs?=
 =?utf-8?B?R3VuSVgxajFVZjk5MThwZW9YdnAvY3cyTkVsODNsUUx6NjNMc2ZsdmdrQ3NX?=
 =?utf-8?B?YkorNG1mdmk5MjY1TlV2VDFQL3A2blJIR3hNOVhBaWpFVk5vT0ZzT3M1anRT?=
 =?utf-8?B?TlMxVTNHYi91MkMvaFNGMStYb3dWQ1dGU09uWHpmV0cxbnZFOVN3bFFJSnVm?=
 =?utf-8?B?NW9ZK2pmVHNMdiswV1M3MW5CN05HdlFCbFV3dHR6SDh2M29XazdkODJtenJJ?=
 =?utf-8?B?L21sS0RLOUc3MzRFVEt3NWNrb0p5UjJKRzBocldjU2NYR2tqeGVxN2dHNGRm?=
 =?utf-8?B?WlRVNWFUTXh5eFNjZFFXb0lOS2hBU1k4SncwMlEySTRXK1FxK1lNUjcrMlRM?=
 =?utf-8?B?OEw4bkNjV0dTZGo2aEVOSEtHWEVSaXpQVEg4dGNIKzJGRGlheXh5MWFGTG13?=
 =?utf-8?B?MXh4Z0NsM2k1ZnIvdlRHc0EwNUlrNWQwZFViQkRWWmZ4b1JreTQ2Q2FrZ1BW?=
 =?utf-8?B?aTJGRGJlSnhVcjNNN3JOYTFGYldTR05oLzVzaFhmU1NqbUVOR0ZqMzdmdWJX?=
 =?utf-8?B?a3BaR0R5UUVhMUxrYzNXMmR6bmNWcHNWQjlZUytiTUJpay9qYlJrUUVpWE1z?=
 =?utf-8?B?TS9QWE1BbnV3NEtDNHNoWHg2UFhGeWdxZVZNVGZLZUExbUJCTmtNTWZTd3dl?=
 =?utf-8?Q?lJ6VHyTSxPrKon10=3D?=
X-Exchange-RoutingPolicyChecked:
	asG17C4KmIyt9PoeZYk+8wDFLme/DUR0c5seCeXdfDCNZ/JPhqFvuxVCaSFv3b7ep71vCIIMWYtwMW4YCDYpuq7/arjUoAzX4sffaNjU1rTxS29xdW4TYnNptYFcqc4zyAkgVDjuHM4GXnKzBqFdb0+dNnMpjL3DLxwljjRW5WtY8nzV97r3Asw+iS2QJI+heknexxCoNEKnWrSDDoqqJSQB+E16rgpl1AVkeJshkws1APDwwi2vND1QiCG39UEo6V/pJEukQo5S+QftXdjUMAT3XboGhczPCHgHzjVulVcEdxlqwqLwhHhQSvC6ZTfyLnwOzRFNEa63PsPqsl+NwQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zowNAbC0yATQZNOIOixJz+i/TzVBUMN3aL4pTBDovS71riOfxgsng/09LZ4a/Mryd16y9weWiNVHZBE4DW/rOwc0nDeKl2UUJn3dXAh8qfDST8RnGO0Aiexaad2IygkXrPe+xJcqF6BqIzb2iuQ/M1/HEwiqtkX8UA/rjgz7j8cVf+bOGl3SyQPWYmcfcW26r7LW5KsFdWF36M5tc9xB5x/V9GRp02HCoEXFcd5NHPSZ2O0Ut61A0EQSxrJoY8l6ZwqFah5LTjAUeiP3+2EAX5dBokjUAwD6pViVWNjljFbghoSFuf3qgWiJeuWpxtf83RNFllZIrhRP1pK+8AQ+PMtPcxZBsov/9lup10oAkzAhyxRguh93rUiFEBYT6gMcg2EP2upPoh9w+1d0gsRdyAMlOI7jc/YcnY98YWPqucYWVyi2ZIPu5h8pBoQIGu9Cw2lm7FPWgITbedKPn18KGsgYjsn/fMLIK11XED0zJ9vu7brxVrTawR6AJVrFOwlYc7Ndw3AO1uzdAs3eVlcFI4XwrJJsfHmascFi6zn8AfMR8iMnneZ4BnoohErKTGDEqSi8zd1KAUPAV33vMDkJ/alzAbpf2lcqWfCPMAh5prK69u016VyqYtQtXh+jXm5z
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7126e80-3623-49ad-eade-08ded8e89043
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 09:50:49.8319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzUBSrEM8HEUhKs0xJEOKndvMZYDcX+TX09R3YRS1AQKNo0rDzQlAddpGWgsJWg1a//9GtCURgQUXAIDnGD03NwuZHAKxk1ePypXTEr75CA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7338

On 7/3/26 11:31 AM, Miquel Sabaté Solà wrote:
> Hi,
>
> If you don't mind, a couple of questions from a newcomer that is trying
> to grok this part of the code :)
>
> Johannes Thumshirn @ 2026-07-03 10:45 +02:
>
>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE and removes the
>> block group from zone_active_bgs, but only the path in
>> check_bg_is_active() resets fs_info->active_meta_bg / active_system_bg.
>> Any other finish path leaves active_meta_bg / active_system_bg pointing
>> at an inactive, fully written block group.
>>
>> Reset the corresponding active_{meta,system}_bg pointer in do_zone_finish()
>> so it can never go stale.
>>
>> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>   fs/btrfs/zoned.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 44a13ed6b8b2..c8c850de1702 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -2539,6 +2539,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
>>   	const bool is_metadata = (block_group->flags &
>>   			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
>>   	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>> +	struct btrfs_block_group **active_bg = NULL;
>>   	int ret = 0;
>>   	int i;
>>
>> @@ -2636,6 +2637,20 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
>>   	/* For active_bg_list */
>>   	btrfs_put_block_group(block_group);
>>
>> +	if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
>> +		active_bg = &fs_info->active_system_bg;
>> +	else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA)
>> +		active_bg = &fs_info->active_meta_bg;
>> +
>> +	if (active_bg) {
>> +		btrfs_zoned_meta_io_lock(fs_info);
> If you need to lock/unlock in order call btrfs_put_block_group() and
> then reset *active_bg, couldn't the previous if statement be written
> like so?
>
> if (active_bg && (*active_bg == block_group)) {
>
> This would then only lock/unlock just in the case we really want to
> touch this 'block_group', no?


Yes it could be simplified, but I'm thinking what it would buy us. For 
sure we would not take the lock when finishing a DATA block-group here. 
Note the lock is not protecting a data structure but is for serializing 
metadata writes, so we do a QD=1 write to the drive for METADATA/SYSTEM 
block-groups as we cannot use REQ_OP_ZONE_APPEND on these.


>> +		if (*active_bg == block_group) {
>> +			btrfs_put_block_group(block_group);
> Also, hasn't 'block_group' already been put before your patch? Won't
> this try to double-free this pointer? Or it is about decreasing the
> reference twice for this block group?
The put before is for the reference on the active_bgs_list, so we should 
still have a reference left.
