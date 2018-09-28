Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53483C004D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 23:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5D5206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 23:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="HcGjiFE6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB5D5206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbeI2Fai (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Sep 2018 01:30:38 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:52642
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727022AbeI2Fah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Sep 2018 01:30:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bmaQYE0ZhuV41GkFSVYlkDQrXTyvTWHfhe5HlIUbLw=;
 b=HcGjiFE6VKFHN6htkJoKIVV/G2+Jx3JGpFNcWHRumDQSscOVrDQMd8o4BOvnOauV29usdIjFYtX/Ja6Nzy3/eRHu8aftgAaPOUsF6FjNfRUGtbv4m6e0eVQ7SEk1UkIJcldUq0IHKplXxZiVZJ8iIFIOkvu6pgnBeU1rNQ6vt+M=
Received: from [IPv6:2001:980:4a41:fb::12] (2001:980:4a41:fb::12) by
 DB6PR06MB3926.eurprd06.prod.outlook.com (2603:10a6:6:4e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.20; Fri, 28 Sep 2018 23:04:33 +0000
Subject: Re: python-btrfs v10 preview... detailed usage reporting and a
 tutorial
To:     Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
 <f50f64a5-eec5-da34-d07b-0a76d108f044@suse.com>
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Openpgp: preference=signencrypt
Autocrypt: addr=hans.van.kranenburg@mendix.com; prefer-encrypt=mutual;
 keydata=
 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
Message-ID: <65be6c24-b02f-c6fd-5932-780e42fb0fd6@mendix.com>
Date:   Sat, 29 Sep 2018 01:04:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f50f64a5-eec5-da34-d07b-0a76d108f044@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2001:980:4a41:fb::12]
X-ClientProxiedBy: VI1PR02CA0078.eurprd02.prod.outlook.com
 (2603:10a6:802:14::49) To DB6PR06MB3926.eurprd06.prod.outlook.com
 (2603:10a6:6:4e::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07785960-6027-433d-ba38-08d62596c147
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB6PR06MB3926;
X-Microsoft-Exchange-Diagnostics: 1;DB6PR06MB3926;3:ixtnuY4RT0xtPYfkikJo0x4pUqGNY6r2Gxm3KTc2KA+qVNCgNT3n8NOJ76ZMaAx0NsG253pba71TEJDyg15DyG7N27dzCdLTOPpWOF5dG3fE+zmDqoVHQza2fq16IQJbMNOZmzfHYQ2iK2EZYHfA3GWC/APlMEBEcmtTvJIUp2EYKwaa2oszsxpq+c37EijviodkWyZNC/Rj1mIk3KMBXEoxksJMmAf4DfiqDYoPA0sONakzEdh2xR92qXvyil8M;25:ZMqbUSy20pvTyPSM9N4wJpTKDcFqIleai2l2oeq31/3A8r62icetZkaCIE188MeHeVT5VFV/vIpcNNep/jo3ppvgtPGyjRhWddJrxzrdbRpCNcBHWIvsFDK6GWaUljsKtlyVk3WchxG+BQZzU2+T9xKCHGLeHX4sp4GMnLipsW/MJzlxKn1Z/264qhiYOVwAy3ZIX5XN9izbs1OQoEurm8MSCNikanJRZ7Bh56tiTqomTjJspfHW8xEjzFGg3XNHXR/uR7zq4NFJu+Z4ixx3g8/zim0JZ8PFpnkf/d2YHNpnuEw3gmmFiJJS3MJ2u4tf/3Vbb+vWS/bY5edAahJBBA==;31:Mm8zSHTmXYaIppgufITTsC9aV/XPFk1Lb3E0YM1SeZ9YyYcS2ULVgj5iKg+Gwhw+vBrp/XPSi7vnaHcd1r0/ji9/RMnfuFLZcZeLu4QAF246S6YzkXi3mmu2+KQUUW8p+uqa309UIvaR3GNNv6Efm3lBfX8Yb/rwVn+5Q+tPmzuki8ax5BzxPCUTQhkZHMD4yRymUHFYKEwAbjvaCbgnVn6KNPRWluAoNogOLq5MAT0=
X-MS-TrafficTypeDiagnostic: DB6PR06MB3926:
X-Microsoft-Exchange-Diagnostics: 1;DB6PR06MB3926;20:JpXekD14CYtiHQ+n1S06vL6/I50izOgj4HzmLoRDjSUj2PtDG+WhkzrxjnXM8uyJsiNFeHx3eGS4I4Ux7jMyhZgoP4ZBfIcWkHcb4CLMKXAeOOQgpjDDELPGoK5ht4BHQ1I3Kkr77AszUF87+zRBxtR4630AUORYV8tAOrsOAaaaiKd1QRmZh0ixaoLOxek2WTCUk2gNIAr4G7Ut2BqHtZh20rUQOkpRTXoJUX+rMwQ0Dv3HWAHneGZpDOQSfrqD0n4m6WB5DCrZqh9JtuKpTsnVnCZnx3f6aLEMt+Bj8dWcT4yLGgr0KFkA+UxA1Gc3P1abVwUZqjxTXJJbKZaXnou6fuBTYREws+BVx77Zd8B7ani1UnZQZa1Z201o8nV7jAnqM6QIqsJkWBKsjiMoJgyV+F6Gq7WNoSizhs4QuGIDVRt8Jxu708ygozzk9E+1IXL9Qdnj/AwiIcniRI++AxpR3HTzqYzHmp4UwotORTP57gzUV4G0OLa2xIwRm20oZ4SVpuoF8vzt7hBPHJd3nAlMroMuBiCnQVtu+dreHWPxhfUKROfeoopnw8uGb8X2ky8ZTSUVVBaTnPLoKjbH4S0tAqKjJ6n1Xza3bzdBK9c=;4:brf3HxfijsKjJVo0GHVNJqgsXe55fFjWcTXl1qfFttxHJLRtoIZTGgMgwvfPmGy4K9H3LZ2TykewM9pebKvHmHQkC92tbBRZGYYxtZFmh71qzKNmumIBjPczV2we9LTYOUlfbqEeOMPCd03R5FZXXnLDuIQq6CB2dkJZCyx1K6nYJ4Vace08RZRX7aH1H0oSm7VdENDoQjYcP9XiEgbJ7/sUNfrgUv/KhvxtTXX/0Y7ZsWB+lxCmiohUyVPqgu4x8fXIbqrSWGkZTbtQWGbqj/KYLwaGTKVmF0G3D7OACy28T0URQ+9SBbOTOiPN25Ms
X-Microsoft-Antispam-PRVS: <DB6PR06MB3926E36EC33CC0EA22F64C0CD4EC0@DB6PR06MB3926.eurprd06.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:(211171220733660);
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:DB6PR06MB3926;BCL:0;PCL:0;RULEID:;SRVR:DB6PR06MB3926;
X-Forefront-PRVS: 0809C12563
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(39850400004)(136003)(376002)(366004)(346002)(199004)(189003)(65826007)(34290500001)(36756003)(105586002)(52396003)(86362001)(52116002)(31686004)(46003)(52146003)(2616005)(2486003)(1706002)(11346002)(76176011)(31696002)(106356001)(476003)(486006)(316002)(58126008)(23676004)(6116002)(110136005)(5660300001)(446003)(64126003)(68736007)(50466002)(2870700001)(53546011)(386003)(2906002)(72206003)(65956001)(305945005)(97736004)(53936002)(478600001)(7736002)(229853002)(186003)(16526019)(8936002)(8676002)(81166006)(6346003)(81156014)(25786009)(47776003)(6486002)(65806001)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR06MB3926;H:[IPv6:2001:980:4a41:fb::12];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtEQjZQUjA2TUIzOTI2OzIzOm8rN3JSbEFLSHdvVkVvVmtMLy9zcXNxRWUw?=
 =?utf-8?B?M21nWHBmSzZqMFlOZHZONE9tbnpTUUFDVUpDYU9VTG45cndmdS9uR1V3TVkw?=
 =?utf-8?B?dURSL0hmMjBWQVNObG52S011NHRRK1Fhb2lDaDdSa0pXQkpmN01OdkMwSEVp?=
 =?utf-8?B?cFRKVmV2RDE3ZDA2Q2tDdXFPeWxoOWxYVC95YkRPSHlhRjdTSVlwNVNkdEM0?=
 =?utf-8?B?enpIdmRybUZvbkNHZnRxRkRzNDlieTlTSVdQR0VwQnhQNkdIVDlzcnE1Q2Q1?=
 =?utf-8?B?b2hRTldJZ01tQmxBQk5Ka1V1My81VWpMTXFNN2lXVU5vRzRmek5HSXgydjVM?=
 =?utf-8?B?RTZoN0xIMXNlZWN0NGU3eTJraHlmMjBSMUF4bHBXaFBoVTRqRVRrVHZ4bGRS?=
 =?utf-8?B?dC9hN0xwdWhPcEV0Zkw3NjkyTGRCU0xZNmxYOU45QnZsbmR0YWMwRFQ1cGlW?=
 =?utf-8?B?Vm1rNnNoRXRCQjNLMVVxaWE5ME5XVCtZRkRxc3hhbWFtNlZCM1JHV0dPNHl0?=
 =?utf-8?B?dmc2bDIrRFRhM0NZYXBxTEc2VXRuR2lEQ0ZWVjZpN1NYSzJOUWpZUHltMzI2?=
 =?utf-8?B?bGQxVXVEUGZ2Ry80NWRRZGVzdW56TGFYSWVUQXZlVlNvNm1EbjZQRDZrREdH?=
 =?utf-8?B?cFVhbGh2Q2NUVS9zUWxOeG5NWGdYQlNlQk5WcE0xdFFiNFdabTRtRWpheEM2?=
 =?utf-8?B?TkNqN0FTelQ2TEhkS3NEQldqSHhHSG1Xckt6aWtyN1FaRThNclRSUTZ5TzBZ?=
 =?utf-8?B?VFNEc0Uvd0Q0eXpyVGt0QWRhT3k4NG1wUndzYzFXVGpJbGNCL2w5S1Z2c3Uv?=
 =?utf-8?B?VXlVUlUyR1VPNHM4TDRWVHJ0SUFndHBIa29KVXpSbm4yUGZsV1dTZTJhV0ph?=
 =?utf-8?B?NU9qZjA0d09VRlRtOGNPZFcyS3ByczZyVUZtWWRuM3N2WWtNT2tSc0NSSkxv?=
 =?utf-8?B?QnM4ZlFUbWxYbHlGZHcxcnBsQm5VaGV6eldzQ28yOHBqOHp4OTk3SUUzZzM3?=
 =?utf-8?B?V1BLRDFab3ZCOUtkcm1MQkJGUElzLzJVSkZHc0JPRkRzRnhHR0VMdGY4S3Bt?=
 =?utf-8?B?TkRhak9DcEVraWpkbVR1QmNhUU1SZ2ZXUlI4K2NZYUpJUnRRTWJ3d3pkVXVU?=
 =?utf-8?B?SUp5cjNMMUNiUi9OMzV3a0xVZFJFL01wbUc0UitCSStzbVEya0xnQzdEKzlz?=
 =?utf-8?B?TkhxVlowOWdYMlROVWs0K25hM01TMklDTnVza1VEeUJYekhxSUJlTUcrWVZj?=
 =?utf-8?B?ajBHYjBVcDFIYjRlbVZ6d3lxNHlUamZkblNjTVZLanZGbWFjOCtzRzErejFD?=
 =?utf-8?B?N0NEamYvTHV3ckYvNlVQYjVvUWdGaWg1WnN2U1J5SzRPMlk5UUp0T1ZWRi9B?=
 =?utf-8?B?dzAwYXB2Z0FHdU1JNEp2cEY4NktUaVA0WnJkUkpvdlNUUGNySkp4SU5MTG0y?=
 =?utf-8?B?TzBQdFlMdTQ2SjhtUE83Y05sTjQxaC9HTUc3UU12cGRGcUd6Q0VPYjh0cWZK?=
 =?utf-8?B?eG5CcW5ERGpXNDRZQ2NhNjdpOTJvQkt4My9JZWlFWlVkcnNDL0EvbWNCVFBS?=
 =?utf-8?B?YzIzZUl0bVhjdTVtdHZVaURnN0RvNjNrQ2VNLzNVYkZQZ21aT0s3TFBSaUNw?=
 =?utf-8?B?SDZoSzhaY0oxRkZVcmtvc014UHZyNGExa3FVRjJ1RUhjK1BDUU1wb2UyU3J2?=
 =?utf-8?B?QnEzTUtWTm8ybWV1SW9ybFpkT1R2c2xpTHFPWVM5c0NobHZYd3VVVm50cDFa?=
 =?utf-8?B?UUt2djRmZitEUUVMMkR0YTVWbkVRVEhTVk9UQnNGSTg5ODRrQnhtTEtNT1BB?=
 =?utf-8?B?Mm9CNm0xSEpQYU9keFMvc0Y5bzdwejFaNUJZYU9MazBLRnc9PQ==?=
X-Microsoft-Antispam-Message-Info: RcDNLsXzdFAqd///9Z+bRc0pzbBpaxBsl0zWDcuTfPdwbatBpsKNJ9nrbGuX0NGtoK/LYddGUuJ8QxjDA1YusFkCTrlSl5SCqgeIjbErJoQwHzSwu4MPs2w/OYMnLWM7GvQs/Oq3kJ4GtnvGc+iOtJTeOrbF37zN48O3yXqLH1OVkR23pzxPxMKsVsIpUQPRqJggEKs8aknETDLKeSGpBaUYdaySByH3MzX4JFEm+gYbdROFF16Z1CWel056uuLDxo+55IGB2DdJazxdezwdr5PpmkskrePyfiGQuiEn7WLNoUvfxu/Eeg6mTYlmbuZhL9lEa5n2fb1nf6ff+nnivnlaPrEQuQ/f4fuwgknkcPA=
X-Microsoft-Exchange-Diagnostics: 1;DB6PR06MB3926;6:eJ/vLSNlQoa9Z0yU6yfik9/8QabEmp3TjmQ8VUy2WOOLeGWdZxcjBRhNzgkbcYC//NBcxfCUoTz/hAqggMb44lDEj8T2MNNGM9YKH8Tdyyebbi3zmMBHmqG/ArKpFNhloQBn53YRPzJLfM99il0owm6aaaykDboDjkxC1ALmhvf+uI+SmWVekAX0YbajUBvPlyMo9xZB3gmMFtOpao6xdZO06Ie1THWcHYHv5/DB4TXEoxjMXDfQNUNtvSIE6fafAvxScucgng2/ImC1SgBFQ0gmU0xixjU0mseDA1IIeff/0VgkG91Rq6emNnC/Xk/XkYGiRxf9SwcFh9fSrdbTFLugToQo8iBTj1HJ9t5ND1WxvHrBnuigXYOWsJ1yep60Qh/+UEL5A6hwcTmg9JILA7HI9wF+dqGLZjXxhDT6Ik+CAzgBuW10cmwi/j6+ywplYajxh7EhJraWln0fFCQaMA==;5:BbcS7n+OPdLalIjHNJOIefIGtFRIFEQg13oh2CdN5G0INqQjXHP6Wwyn+ZP6CHKcCIDvjWc6rXbcbUUIKSFEzR6H4uwNA23Swx+WW3clEy04eMV9E7CEotmJn3sR7WjfDtg9Fa/I1SOqwOF6+KmAdlcwJ25iX2Ua9s5kCST45zM=;7:EA/0FZLiJDAyKunCYK4lEHW+m7z0+Rg/V+Xzprtg/r+6zadxiBZ4/xetvOoL4We3neZWqDT6HcDgUIQL/g3n0/T7mozCQeciOA0BHIlyS/6rP9fJjhG8bGmjSFSN+VDU4be06PZJVMvuSHqN6RCdmKM8pfKEGpSEDgbvXLWhQxdPVgckyz7d3ze/GEOdtHqmZJetOJ1hzkTOEy7sOchsQN0bGpNKe5ZtCBIyzQmrN/HH3UMbwSksLDhR1KdW+luJ
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2018 23:04:33.4447 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07785960-6027-433d-ba38-08d62596c147
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR06MB3926
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 09/24/2018 10:08 AM, Nikolay Borisov wrote:
>>
>> The bugs are all related to repeated kernel code all over the place
>> containing a lot of if statements dealing with different kind of
>> allocation profiles and their exceptions. What I ended up doing is
>> making a few helper functions instead, see the commit "Add volumes.py,
>> handling device / chunk logic". It would probably be nice to do the same
>> in the kernel code, which would also solve the mentioned bugs and
>> prevent new similar ones from happening.
> 
> Would you care to report each bug separately so they can be triaged and
> fixed?

In case of the RAID10 5GiB thing I think I was mixing up things. When
doing mkfs you end up with a RAID10 chunk of 5GiB (dunno why, didn't
research), when mounting and pointing balance at it, I get a 10GiB for
it back, so that's ok.

For the DUP thing, I sent an explanation ("DUP dev_extent might overlap
something next to it"), which doesn't seem to attract much attention
yet. I'm preparing a pile of patches to volumes.[ch] to fix this, clean
up things that I ran into and make the logic a bit less convoluted.

-- 
Hans van Kranenburg
