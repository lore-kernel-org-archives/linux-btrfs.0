Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744E2C6787D
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 00:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97DDA2087D
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 00:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="ZYWAcxSb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97DDA2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbeJHHM6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 03:12:58 -0400
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:49229
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725925AbeJHHM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 03:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21Elm/UFMEYETE76zmpljLl1BqtZwuEU8GErHi4aUWk=;
 b=ZYWAcxSbMyILqYnJ0u0edOAqy+hVNiHSkn2MSEgJ4imYZogh+WuVA0ehFB6rueIalLCxG7iMB2LoamQawZnuW7vsDg3PjrQCpDtd7G/0VC0UJ31hk0mgwi84NGmZAeR8diGwRaHmaapYvYG4xzywF+dcX3rUjJ6jAndShwFdmwk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
Received: from [IPv6:2001:980:4a41:fb::12] (2001:980:4a41:fb::12) by
 HE1PR06MB3930.eurprd06.prod.outlook.com (2603:10a6:7:9c::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.23; Mon, 8 Oct 2018 00:03:47 +0000
Subject: Re: python-btrfs v10 preview... detailed usage reporting and a
 tutorial
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
 <20180923231935.go2uksc4g3jpdf6o@angband.pl>
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Openpgp: preference=signencrypt
Autocrypt: addr=hans.van.kranenburg@mendix.com; prefer-encrypt=mutual;
 keydata=
 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
Message-ID: <132155bb-17c5-0027-60d2-d077f309dcfc@mendix.com>
Date:   Mon, 8 Oct 2018 02:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20180923231935.go2uksc4g3jpdf6o@angband.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2001:980:4a41:fb::12]
X-ClientProxiedBy: CWLP265CA0068.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:401:12::32) To HE1PR06MB3930.eurprd06.prod.outlook.com
 (2603:10a6:7:9c::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20e7d619-df1f-43e0-6784-08d62cb18561
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:HE1PR06MB3930;
X-Microsoft-Exchange-Diagnostics: 1;HE1PR06MB3930;3:PeQ7Ds1VqiQxvhWP+Q+L/KhmS9QJ0ukGT0ZUOIkLvpw9oFoYxxFJQH1C9tYDNGAhk9tntJjGbDZLXoPPw1nf/utCwKaesmY+d2bYHLUu404eW6hUEwdkePV9+t9j6jecyNTg6SciDBUyM4C9XcZwle2RXgKsPTWsw1OfCr0M8hcXpPGY626/UtFuugyPGObxn/oktllsxCrApID4JDjvuzibqs0ZUpbZ1GH+XSSo6QOEEyy0KuXf9Lmu5POL3f1f;25:fFU2MsL4WEcnAmUaQ3BFyeRveEC2Cp/XmBkXnFWg0UpQnkcrfwbdXyv/7F1SRFFIIgu/jcwKhkpE3efAZbKtfGbaIpTRmL3kMt4sTyPtl9FS4QHf2ld/xXn/amZBOu6cMsI+C1nFLpnWX1S4LlwBYX1ktp4yjW5ivyAk88Tcd9oBPgb0EpTkSc9bD/QyuPqRKGLXR2z9qQczHpg0Jf9QsKlZ7C9T8tkljDyBcW76RduRbtBRMWthwNdas4gwF7YRklmlGKjRzsJpu4BYKBSVvy6QzUiaQXtpI9Y18DY+eeuZS1OLfohbak1nIGobqC/jDevjJXZXmNVBgkMDHuaaQg==;31:iId9Q4OOHT059ryDUkUaop7J6j3d8Cod9eiv8znaxbCXvwwdxu3iDFF/AJ5FbxfdJeoYN7suDrhGTHnL6bfDlvjzz+UkxLlc2VlY2qWKEX1jFvdFhKxetXh0DBkV49RjmZQpdWZg8OPIbYHVrEFKH4rYzANTp0fGIdbrrMbphrxbJwQJVeAlH040jvuT3OjmiH+8kToBpgydVqKwYWOEp/hDyBBizV+Z/aJ/JSu1a8Y=
X-MS-TrafficTypeDiagnostic: HE1PR06MB3930:
X-Microsoft-Exchange-Diagnostics: 1;HE1PR06MB3930;20:S8Nk3Rzrd57i4YE1Z22kZ8TkxjutyHYP7AA3331kn25pAsiYfgFqR+zvzFUNnH3j0MWa9pMGreTELxygF47t4tQovF641ovhbDqHtEPwUZiLacxeZrWfPHwsfQ4ckafDlDQWET1djRYlb4c9/nUIEUacwoWNQxTpYTTfdLjqYOJ77qBJaTkgzb2D13zYh0liU0LVkIynjJADouQM+PStiCNPmKlvoKO+1L4zjFGBf5cwSntWwko1dxIil02IldwJ1gs9elo0eI/6mBEKS0dIxIoJuUPHmE7hfOEYRHqPGXQOiox88ovUji3xeKx9VXPtR7KT11DiXVXPXJxqCbXkQFJun3/ibz4kVRFskksj1JgpYLuVbky/RmpvMdM1EDsFKAlOxHNXr4yu8TaYJknqPUesBTlwcfcU0qE5cjGH2dBBVZ1/cl01ZAkktsUe3j9ObjRZ4d4Ivx8UvIAXNWbKY14WEPfHkM452TTXSwPMqUT2HM5vq3Qblgfm75Vfcim7lcku59fatnLLWwqvYUe4+akZHe64VyzF3ilcXyX5mJWnvzfgTqz2PmhdPBY18fxLrTcBh806yYotvQmyUuN9pwi5VuFRSlSFN0MxPNe266M=
X-Microsoft-Antispam-PRVS: <HE1PR06MB39302F635CB458DAB589F285D4E60@HE1PR06MB3930.eurprd06.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:(211171220733660)(166708455590820)(17755550239193);
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231355)(944501410)(52105095)(10201501046)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991055);SRVR:HE1PR06MB3930;BCL:0;PCL:0;RULEID:;SRVR:HE1PR06MB3930;
X-Microsoft-Exchange-Diagnostics: 1;HE1PR06MB3930;4:SarpvHWUf4vWMYAXyramThLczNyb8Ojk2rRadUKu+Nsj2xT1sIoX7REtNGwDUgWzSSmJGHXF117FtSXvJ1LGpflkKWZQ3QDLDM3BP68YirbBJgPskZwjeufLjmWiFoXIs5xBuS3OC8Cybp+kWwlKoN62z8R7OsXWgN+G98H7vw34nJywK/vBnYiPJL+r17oTo/Vr49W9JqX9QtfV/rRoGK2xX//N3NSDJi2hdx2AeGwk0m0A37//igL+6SSODATGtgLN1uClk/hIdPzXyF1hSqjnb7SQRdCJVQ5f5b3Y3glw25r/7fwmpXU/8GLIXpE0DYaYN8o34i3CyAq+NaG+q853h4O+7+1JUYAsXa/vbJCCkIA7jjVnk10Sd80Vnuw+
X-Forefront-PRVS: 081904387B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39840400004)(376002)(346002)(366004)(199004)(189003)(23676004)(52396003)(2486003)(65826007)(53546011)(52146003)(76176011)(386003)(6916009)(52116002)(7736002)(305945005)(5660300001)(6666003)(2870700001)(316002)(58126008)(229853002)(2906002)(68736007)(1706002)(50466002)(36756003)(97736004)(105586002)(64126003)(106356001)(31686004)(86362001)(2616005)(6116002)(8936002)(25786009)(14444005)(11346002)(31696002)(4326008)(446003)(476003)(486006)(46003)(6246003)(16526019)(966005)(8676002)(478600001)(72206003)(186003)(6306002)(47776003)(53936002)(65956001)(6486002)(65806001)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR06MB3930;H:[IPv6:2001:980:4a41:fb::12];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtIRTFQUjA2TUIzOTMwOzIzOktWcjlZRkhlZHRZdHV6KzFhMWtxejlxNHlK?=
 =?utf-8?B?enY2K3hVZlNPUGFHc0Mrd0lydmh2Ukk1a08vM0pnRWlLalZYNzRpRERaOUt3?=
 =?utf-8?B?ZlNoUmNVV0x4YVJZc2R2d2NkbUJWaU9HcWtldXU0cWlYcGk3a200NmNQblgz?=
 =?utf-8?B?TzJLNmUzRlJrRS9Kdnl5QUpZK2JqZVVzRjNEOXVPR28yTTdQalF5SUp5eTlB?=
 =?utf-8?B?ZERMUU10emk0ajM1NklLUU85Slhjdk5oRTBBOTRJbHVhYVkyWVBDTzZNR1ZN?=
 =?utf-8?B?RFBoMDRKMTdHdlZRRkRQWFdRR3BWMTNPRUdTNGVKNGxXa1IvbHJOMEJqRytR?=
 =?utf-8?B?cUExWDVZa0RLS2xpQWJhaGtZNjhyNzdPRE05S0E0MXY2VjBRckc5R1MrUk5V?=
 =?utf-8?B?OEkwQTlxa2JOci9ta3ZqRjljdy9aMXBkbGpZMndad01NbHFVWXlmaE96Y1Y2?=
 =?utf-8?B?bzQ2QWh3NFNhQnVlRnBVaVFsbVRlUXBnMTBibE9IaHpWM0hZZXNWNmY2T2l4?=
 =?utf-8?B?TmpoeHlTR1YyV0N1d09JNWk4OGxsaHlod3MvMlpYMEdTbk4yTkxpQ09CUUtG?=
 =?utf-8?B?RXVGR0s0TjFZRHRZZmZUQWxtVjJtU2RTNnd4RzkreVQ2ZlRwdGxKRjVlTmtz?=
 =?utf-8?B?aHBVR050SWE3RFZLL3BvZ0oySUhwNHJnY3BIeDJIeGxsM2lITms0clFkYzNs?=
 =?utf-8?B?NXR3OUo0Tm1May9BZjJaT0VWZlQyclVBcjFET3hRcnltYSs5bElOT2FYcThU?=
 =?utf-8?B?YTNIc1M5VFFMWDBmdlN4SWVzNXZLTi80QkVBSjhLTFFjTmlVZzBDVUMzYXhM?=
 =?utf-8?B?c1NmQ2tUUUtoK3pDU1FnQSt1WHAxM1pnRUVjSnJYSXFpYkNBUWd6ZHY1THE3?=
 =?utf-8?B?ZDhORjVRTDY0cHl0U0UzekFGcUJKeFdPMDhvcUVEVVFmMVMwai9UckxrMWVG?=
 =?utf-8?B?QjZoYUVQSzd6aHBESUpyc3FDemlBaWZhUElOWWV6bjA2OE1DV1VVZk93NlFE?=
 =?utf-8?B?Ry9wT3REZnVEdmlHUk53OC9IbXNPNjRCQjRJcnh5OWdkMitJT0VseHBmU2Vi?=
 =?utf-8?B?Z1NtUTFVcGovUDVYUmE5b0MrbHhISmd0YjM4VWYwUEIrQzQ0eHd4NFE2Ym4r?=
 =?utf-8?B?R2NPODVXYzR4V1hiQVJOeTFjeFovVUFYVHkzb2xpajBTdVVvUnpySGZtakdW?=
 =?utf-8?B?YlRINFp0emF5WHM2UCtJRFhibVluVDA1c1N1cnl5QU5FMWVsOFVhV0MvTTFz?=
 =?utf-8?B?MitQVVlsYy9LZFZENHplbnZiMGF2b2FIMWlDS1ZzNWJtb3JhU0twRjc4VGx1?=
 =?utf-8?B?bFFGRjdFczdNZkZCS25nSTRsb0JsM2trUjlIV082b3VtK1BIZXl4NUVWMkt0?=
 =?utf-8?B?YjdUZ0JOV2JTYzNZRUdGZit6MVFqeStVd0p3a1IrNitHZmlzNkZFcFQzTkRB?=
 =?utf-8?B?c2ZBeVdvWm1nb21QWmlOMzNRbGlWWnhydmhGSndHU0JSVmtSNHg0d1ViU096?=
 =?utf-8?B?eWU4alE1K1NHSm14UndwQ2pVWVgxdE5sVEZaYzZvNDVPNDV2M1RDVmJ3b0lB?=
 =?utf-8?B?VmxxWkV5aHJtckNYa3lDNTg1cWUvTkxtQ0NlOXVianpSUUs4VWl5dzlTRWp0?=
 =?utf-8?B?Qk40ZzVVaUwzcXZXdUNaUGFqR1hOTzAya1Y1bEE5cEtkT2hqdVpRQU5rc3BX?=
 =?utf-8?B?bEZ5YnNzcnlieGVZK3ZzY1pnVFFmcm15b1A3RVlWZENPL1FCV1g4K1F0UUoz?=
 =?utf-8?B?eEZJZnpHdWxZaUxkelJwZVNvUzdybk1mTmtybmoydUxBc0NGQTBKVTRXM2ti?=
 =?utf-8?B?N25JS0YrQWhEZm1BeVJOQVEyVmRzZHlYWDc4bi8wUnorVTVLQ21qZExRSGNR?=
 =?utf-8?Q?kq2fQNAffYFUNjdptBihVaPxUJG0/FJl?=
X-Microsoft-Antispam-Message-Info: DGcfd1F+r9bQBMRgtFAokgXbyJflRVY2+5ApiBeZeBDrGRsykWfZj0DgrqYA5n+lZqAz1TlDEUfwewjTbMxty2z8c/GN5X+GGWrzA/bpOD161cWVmCcJeFykX1gIt+YzmgQkf1zbIIlIilNv7Ik+nBnVTVtAdfi2i8F2bBjB/gheV9YMgPChPl1xPUbfHLxn0S7OTkGl1qNR3d2rqiBGuxTmRkDfwfzpwq/TgptCibjOaWmMwooT61gM8C3hTyKV2q934jA/Y4gP2VFA3Bn1K7PhEwQY5OVkF+9CH4JFaycLPfRnVn0Tfl4QYTSmV2XS41RymYpZp5N+HcSBqLmUleg+/BCLfGOIo4ctpsrNo2Q=
X-Microsoft-Exchange-Diagnostics: 1;HE1PR06MB3930;6:G3d0AsRtAxWcjX9kbnVhWiG+KrDaR+MgyAOf5/MJ5psT7E+Uush2KuE4KMXdTfTzKoCu74tlFOYTvUi3Gojai53NTzF04H9g+GPSz2HSCkm7Kpg55l3ECxV3A+l05hwEDbpCVyV/y2fconuouMkQesfdQDVnnXNJ+9p+v+7yhOCpTmR0o+P0yI7UO2CWbvb/dlZMd4YPUFlNhQJVV90XSkvCA8NF7GJhIWil+sm2LR+NOk6UCGqR3f3XiwoA2QVVOHNt6iIGM3+Jg5E9Udbj+A3CSm0YZV7y9kWTyMqFScaWooNj/efXcRPttQWYUCW2Git2H+2cQ7XURosj+iJRfPYrTptvsjkVGir6I2a0brNREVmRZxE3qd9lb14Rll54L3SM9IZFjNAgEGxgIj7nv6DzeexI6CO4GQJF2eQ0vaLbO+xox0HimD8dC9tzE1W6Lur+Xl0EQkSbIukIacSxng==;5:OEKThEp/cwq0ZhYD9MotE6yY4CxJW5L6TJReI3O4JWDbdgbxDquM2SDZXK77rkkExhdnlyzpNssoPJucov2Ay1N+utV1QyitaUewETPfdqKhEGOUMIMqEYnkLeebWKj8M1Cxd5aqsIwYrBgXuUZu0Sn7+Xq7heiz6abuPHhoDm4=;7:2A9XBz4IHX+Nd+YdUJS8U85bN1f0PeK7Ukd9oAXh+cpIAwROLGXBT1st+umu/O0Xe9aHMDYxJe0u7q9KNtcMmCvTLq9MIWDtnxBYnC/ZSaaQvCPpzV75vISXPsjFbQxOJkj8PBnbxpuekHphRHUrLzdocZhiGMCkC88UP+JDwyuGA/XKbuu/dR5LLxy+9Q6bZuEjnYYHk914OPYsdhRRFCR6hcHTZuZdeybZxUFaPoKCv4gLPeylqWTCYeT5z2H/
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2018 00:03:47.5218 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e7d619-df1f-43e0-6784-08d62cb18561
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR06MB3930
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

On 09/24/2018 01:19 AM, Adam Borowski wrote:
> On Sun, Sep 23, 2018 at 11:54:12PM +0200, Hans van Kranenburg wrote:
>> Two examples have been added, which use the new code. I would appreciate
>> extra testing. Please try them and see if the reported numbers make sense:
>>
>> space_calculator.py
>> -------------------
>> Best to be initially described as a CLI version of the well-known
>> webbased btrfs space calculator by Hugo. ;] Throw a few disk sizes at
>> it, choose data and metadata profile and see how much space you would
>> get to store actual data.
>>
>> See commit message "Add example to calculate usable and wasted space"
>> for example output.
>>
>> show_usage.py
>> -------------
>> The contents of the old show_usage.py example that simply showed a list
>> of block groups are replaced with a detailed usage report of an existing
>> filesystem.
> 
> I wonder, perhaps at least some of the examples could be elevated to
> commands meant to be run by end-user?  Ie, installing them to /usr/bin/,
> dropping the extension?  They'd probably need less generic names, though.

Some of the examples are very useful, and I keep using them frequently.
That's actually also the reason that I for now just have copied the
examples/ to /usr/share/doc/python3-btrfs/examples for the Debian
package, so that they're easily available on all systems that I work on.

Currently the examples collection is serving a few purposes. It's my
poor mans testing framework, which covers all functionality of the lib.
It displays all the things that you can do. There's a rich git commit
message history on them, which I plan to transform into documentation
and tutorial stuff later.

So, yes, a bunch of the things are quite useful actually. The new
show_usage and space_calculator are examples of things that are possible
which start to ascend the small thingies on debugging level.

So what would be candidates to be promoted to 'official' utils?

0) Ah, btrfs-heatmap

Yeah, that's the thing it all started with. I started writing all of the
code to be able to debug why my filesystems were allocating raw disk
space all the time and not reusing the free already allocated space.
But, that one is already done.

https://github.com/knorrie/btrfs-heatmap/

1) Custom btrfs balance

If really needed (and luckily, the need for it is mostly removed after
solving the -o ssd issues) I always use balance_least_used.py instead of
regular btrfs balance. I think it totally makes sense to do the analysis
of what blockgroups to feed to balance in what order in user space.

I also used another custom script to feed block groups with highly
fragmented free space to balance to try repairing filesystems that had
been using the cluster data extent allocator. That's not in examples,
but when you combine show_free_space_fragmentation with parts of
balance_least_used, you get the idea.

The best example I can think of here is a program that uses the new
usage information to find out how to feed block groups to balance to
actually get a balanced filesystem with minimal amount of wasted raw
space, and then do exactly that in the quickest way possible while
providing interesting progress information, instead of just brute force
rewriting all of the data and having no idea what's actually happening.

2) Advanced usage reporting

Something like the new show_usage, but hey, when using python with some
batteries included, I guess we can relatively easily do a nice html or
pdf output with pie and bar charts which provide the user with
information about the filesystem. Just having users run that when
they're asking for help on IRC and share the result would be nice. :o)

3) The space calculator

Yup, obviously.

4) Maybe show_orphan_cleaner_progress

I use that one now and then to get a live view on mass-removal of
subvolumes (backup snapshot expiry), but it's very close to a debug
tool. Or maybe I'm already spoiled and used to it now, and I don't
realize any more how frustrating it must be to see disk IO and cpu go
all places and have no idea about what btrfs is doing.

5) So much more...

So... the examples are just basic test coverage. There is so much more
that can be done.

And yes, to be able to write a small thingie that uses the lib, you
already have to know a lot about btrfs. -> That's why I started writing
the tutorial.

And yes, when promoting things like the new show_usage example to
programs that are easily available, users will probably start parsing
the output of them with sed and awk which is a total abomination and the
absolute opposite of the purpose of the library. So be it. Let it go. :D
"The code never bothered me any way".

The interesting question that remains is where the result should go.

btrfs-heatmap is a thing of its own now, but it's a bit of the "show
case" example using the lib, with its own collection of documentation
and even possibility to script it again.

Shipping the 'binaries' in the python3-btrfs package wouldn't be the
right thing, so where should they go? apt-get install btrfs-moar-utils-yolo?

Or should btrfs-progs start to use this to accelerate improvement for
providing a richer collection of useful progs for things that are not on
essential level (like, you won't need them inside initramfs, so they can
use python)?

-- 
Hans van Kranenburg
