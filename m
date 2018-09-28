Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BC3C43143
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 23:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD77206B8
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 23:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="EjMTVcW5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BD77206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbeI2GCe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Sep 2018 02:02:34 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:52128
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726762AbeI2GCe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Sep 2018 02:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8cMJnI4jB4ouETyNJabgFRDOzAOMSRx115QhnxVAAY=;
 b=EjMTVcW530bOMT90QsXaIwhbokzdlzIA4jIAQGaFMWdg8CG+hsrQgSYw6adRiuGkIr2XJ0Ej/mTkHEaCq+vMbB5xMj1N/go1nOdhV5uDrLyNQMfn8L9m2AfWnTfo+EP20PmOpxmNjJ3BoljNvH4PGv8FGgvtaNbAW/d4FVUx+IE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
Received: from [IPv6:2001:980:4a41:fb::12] (2001:980:4a41:fb::12) by
 VI1PR06MB3936.eurprd06.prod.outlook.com (2603:10a6:802:62::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.22; Fri, 28 Sep 2018 23:36:25 +0000
Subject: Re: DUP dev_extent might overlap something next to it
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com>
 <ef345860-6916-2c37-a7c1-b43ad5549df4@mendix.com>
Openpgp: preference=signencrypt
Autocrypt: addr=hans.van.kranenburg@mendix.com; prefer-encrypt=mutual;
 keydata=
 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
Message-ID: <782f6000-30c0-0085-abd2-74ec5827c903@mendix.com>
Date:   Sat, 29 Sep 2018 01:36:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <ef345860-6916-2c37-a7c1-b43ad5549df4@mendix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2001:980:4a41:fb::12]
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To VI1PR06MB3936.eurprd06.prod.outlook.com
 (2603:10a6:802:62::13)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79698f46-961a-47ec-a5d4-08d6259b34a4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:VI1PR06MB3936;
X-Microsoft-Exchange-Diagnostics: 1;VI1PR06MB3936;3:4XGEihUdt8DYcSpRCkJSUuDXFaKnYlJb01SoPbe2fCWwALUsnKpvpeS6rLvbEImo3i0K5JNbabRCCy3q2chh/4CfUZr1vxOvCcVmbsKNvVI+PH0s/xf9xpv0Qb8GtO0e4ZTA572+9uK48BnYetyO/3zENQUkOzyR0oMw3FtSfk4Oiso4FjNN3xbbbJ8qHRS0ez6Xcmrzl0clzsflgwOkoxJ+RnKRLZlzbGVmtBMuzobdkCjjWAruvKXbLeW5wlB+;25:xZE+NNyI8k8C6C/I0tlB1YgV049UwkXgg9ZH5cHbXZH8+JxK+IlzrHFka8TAErK1KNCwaSOcwBTostBEjwh/s+Vsc/E9kUahCecEJ/iiiUq5y05g4X9DnfGSt3EkMI3vv7FRyWyNw9ju38sIwIjjJA6wUhuMLkEzeT9fX4mr9ymGSjLVgFyRC9MZ81UBNZXbqQxxYF1w7mgQ8d4/oSBMoCdpEtcM6p3V1aKrKDTXlbTBf+6a2b0yrysxPRZ9LStQf+xF4XkFsQ/ROAc1FxmWptNayaeIpxAFyLdUdEnAQshT2Vgtq0gH5aW1OdI8rb6/Y2dg7Y0WDQNm624oIWZ3tA==;31:WOptixic0cSK52G7Yh/mzwnyxGEZt651A/QOLkPrSjEko+kzy4aPpTRGVLpdV2xHGmj4ElxfX/FDuEScU6/Q5Mpg6MbEN51DSu4kGIxRDNDP9RD8P/7gMf1xgBh/pVFyk6lhAbXCom3/LgOXDZVMzrpbkt9YfF4VVMTEFgeloIhceSi8IJrUTFevQvt2s+PT21dktb714O29C97XMZny6tJsBGRGv1EcsGRpbOIBak0=
X-MS-TrafficTypeDiagnostic: VI1PR06MB3936:
X-Microsoft-Exchange-Diagnostics: 1;VI1PR06MB3936;20:pEo1qRwtd9buqrJCVD/gUwwRzvSaVpma5e6osPheciGewlhKP8Vx6StrvnM2Bwu6oNuKs06HWsYgTAv38tb9AjPlx7HEsbo9oQQUwWBoGDhV1H9Zn6ftUcKRVsTrJLjP5oTESRcAVcFDo3QnrKcCr49br5KeQyOYSavqAZEJkmO96QK0tPRcKnI0ecnq30smJhyA+zuMrZE1Qv9w/e8g+ol36nSwdlMswKV4Rq0TJmG4OJeRLQ9XEgz5hvwO5lN7Cd95VxjKVUfkZrv0H4A8QxJ1KI3slCy/JwO9SZb1SFku51duT4dm0BwrYToNEwCmbyvs8wuITVnFbOo4uDSa7PPhHCeoFoVlnNyOn5rux+dEq+7l9O80k+mXFMHuDJoIlwUj+G5bYvRkhI317vCK7PlCXDwqBhvg5ZDpghJxALdeJd19zGqXePD8vSSG9n8M7qYa/cDIntoHNM8szE7w8mKpDvhPyMSYdwmHCo04eoduYUzZHFDcYePaAY+4jDm8PdkgKM1d+Oze2FSuF3KSyiopRjPU1TtWdWuj1cijqAuvAxFszUWn2yQAr4WJbWII8ZW4HzRlwys+PAgXGQeFS2r4OFQZbdxd/2i5dF/PK28=;4:gZnS9in156wHaf+I+ubgaKqCBAurvTfLoTtOK3QlUgXC+brrS8TVyuSd4Wah/ZroYkpGYqI3gBZpCWuyl97oFQd6TRvO/6ZtjRkxMjZCvIV7WclBhKUychfaLEJczIEgN3Iwye6jIJh43ORqcKpAEg282EO3P8aN/U1Y8hOmOf9IxqtxRMdq6KLQTEyofec6t7xp+1mYPw72TueG4e3bBu7wAjpjl+BiXqrSkKC8mHuMQ2T6AAsXT4r/V20XM/qj5wruk0vrnCMIBY33ycNknQ==
X-Microsoft-Antispam-PRVS: <VI1PR06MB393646750B3FD5C7C3A3FE1CD4EC0@VI1PR06MB3936.eurprd06.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(201708071742011)(7699051);SRVR:VI1PR06MB3936;BCL:0;PCL:0;RULEID:;SRVR:VI1PR06MB3936;
X-Forefront-PRVS: 0809C12563
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(53546011)(386003)(5660300001)(52116002)(2486003)(65956001)(65806001)(52396003)(31686004)(2906002)(106356001)(316002)(58126008)(8676002)(446003)(2616005)(476003)(46003)(76176011)(36756003)(6486002)(7736002)(486006)(230700001)(6666003)(16526019)(186003)(11346002)(305945005)(25786009)(81166006)(65826007)(23676004)(558084003)(8936002)(478600001)(47776003)(52146003)(105586002)(6916009)(81156014)(68736007)(50466002)(229853002)(64126003)(6246003)(72206003)(31696002)(97736004)(53936002)(1706002)(6116002)(86362001)(34290500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR06MB3936;H:[IPv6:2001:980:4a41:fb::12];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtWSTFQUjA2TUIzOTM2OzIzOm9TeUNxY0RlYm1MT3prVHc4T1FHQ1NrWG9F?=
 =?utf-8?B?dHBwV3JkaU1VYjhCWktTMnpkUHZDcUd6ZDdxOWJoaXZtWEp2aW1UNnpqTkJR?=
 =?utf-8?B?RVhVQkN2clF4M1VlOUNaaXlzWTJadzhIZGN3aGxDTEhmazZzZnp4ZmNJdmFG?=
 =?utf-8?B?RU9sSnZScTNobFhmTzYyM042d05XVXZpNlYyRlBjeWhIN1VIaCtuSE4rVWhI?=
 =?utf-8?B?Ukk4UzNIYkpZNXFYZVlEMmk2RWRWR29ybUpQZWRSUGhVVno1UGZqMUZoSWZq?=
 =?utf-8?B?L2FwYXgrKzdhQlVHeWxTaG5ldDhoWlQ0b1VhOWxlYm5ROFlDZEF3RmVmc0Mx?=
 =?utf-8?B?VmxrRVBjRThnZDVTbXVFN3dyRnZCOHcrL3B3Um5vajVOcjFlWFhxS0VRVkUw?=
 =?utf-8?B?cUhvcWNoSkZEKzFxS0hKQ3BCamhNS0hxQ2k4b0dEMGxYSWVmVEQ5QXhncGJH?=
 =?utf-8?B?SC9zQmpscmlMR25TdlcwQnNxNUFWSjhaek94QmU1Y2tlWU5HaXk5blpOaFJQ?=
 =?utf-8?B?NjJaLzdZUHZpZnA1MEFsbnBpcitTc3J4WGVlcHZUWFVPNWNEeEU1Zk8wZGpH?=
 =?utf-8?B?NmR0ckV2NE1nUVJoc01Xd3k5TzJ6UklJWEwvNTN1WnV2WkgycTlmeDg5M3dw?=
 =?utf-8?B?NmZQM2ZPTkV6WlB0WjRZT3E5RWhsZy8vaHZKVUZORkxnNTRjTTVBRGcxZ29F?=
 =?utf-8?B?WmJMYUozQ0h3eGVYMGdHbS9hOGFtaVBBZlRhS3Y4Q2VEQ0ZZdlZnSVJVM1A0?=
 =?utf-8?B?V0x2ODhaVVFVTXhYM1hpM0tDYzgyR1hkWmRNWk9hUmMrdzk0RkZhYTFxT1hQ?=
 =?utf-8?B?MVVMMDBNdlhoTnhXNS8xR2t6VEtPRldVRWYxdkJqNnR0VVd4cUFlUm80VVlK?=
 =?utf-8?B?UDVtZXNkQjJ5aGYxZ2toc0FCQUhON2NONGU4YjNGNzZNNnUzNEtneTRzbEp6?=
 =?utf-8?B?d1QxZXNHMUFVWEhYeDQ0V0xkZjNyV2NSVFpnWVUzTGhuM3lhUXkraC8wS0gz?=
 =?utf-8?B?YlVKMnRFY09EUXR5c0ZsYVBjcnU2U0hROWpXMmZSUG4zaExoaVI2VXhsVDQw?=
 =?utf-8?B?Uzd4ckFDMWpweWt0TkdpSVY2NjZ5U01nM2ZpVHoxZ0JsSElSS3c5MHZhSmh3?=
 =?utf-8?B?SW5HcGxkY3hZME5uY014Vnp1cUM0TFBsWnZtQWtSZXBFQkZ2ODloUHRGcGNP?=
 =?utf-8?B?WEZycUxXd1FTUVNsSXl4UkI3OEdhbjVUT2RLNzl6MDFJNGl6ZUhkNDdDVGoy?=
 =?utf-8?B?TFRlQWx5NEJRbk1qMlVBenRSRldYQmxkSVJnbHV6eGd6QzIwMlpyaWxieVkw?=
 =?utf-8?B?L2dvT0o4K0o3enc2UXdReWdhWmYzeGlkQWVrcFA5ZUErUEdrckVQYkt4dFQ2?=
 =?utf-8?B?TDk3NDJ3NThQL1ZWRDZDLzR0RS9zRTFoTjFyOGQwYzF2OGFidDNRRDN5N21G?=
 =?utf-8?B?N0VOeDhaVlZUSVVId0NOeHpJb09wT0pFbHR5NThJdEJwY0FlSXExb3hpZFNp?=
 =?utf-8?B?ekxsUFhWYktjczVCd2JjTnM3VUxjSi9HcCtreGgvNTB0ODdCUzUyOENTelNG?=
 =?utf-8?B?ZTZXUkJjNUNYOEswRzRUZGk2cXU1bmRtcTU5OGFabzZzMCtKWEVnL3RkMjBm?=
 =?utf-8?B?emEwZWRvMXpiK2VIKy91WHVkc1ljdVQwOHlpSlIrNXJQdndzc1JmbmxKb0dC?=
 =?utf-8?B?T1BseEdFMzA3NGFIeWVZMm9GM3o4aE1CSGhoVjZWODJMdXA0NHZwZitpMlFI?=
 =?utf-8?B?TzhwU1YxUWY5NVhIby91VkRuM1pZencyTkhuaG1RUjI3VzkzMDk5RkNRYW5y?=
 =?utf-8?B?Y05QeDdqLzVGUmdzZG90Y3U2U1h4MWhOaUhKa2FVazA0UmxiZTFHWTNqVTN2?=
 =?utf-8?Q?2hDvem6K2oM=3D?=
X-Microsoft-Antispam-Message-Info: nNAYdO2moziwwFwaDTiFtlPjg5lsyVBpXOlGat9Q70d9PjzWCqR+F+oVKvkERi61oiBimiLQ5RtJUVqsFrVk3lBOLBhhR6MF561NPXXJRCpEWzk19fVqH5Bi63CYvd9Lyir+3/kTx7NV0nNHc9yR4kTR83OX9YPRKRtRHDWyV1uDf0J+W8/tyux4Me96kb2A25tE9lJOBGSE8QTn7GeBClczwkkNUbPbIh4dLaw26/EZd1c41lNLzstCMetCLY4SQg+hZ1QLuIeB0OKtxh6LQUPwVdK/q/cldoyfqYnfoi2pWLg0ECGKy3KjIQHX4klXnpgcjrIH0aNnr0KII7XuZvFJi0q4EaD9yteU2VB8AxU=
X-Microsoft-Exchange-Diagnostics: 1;VI1PR06MB3936;6:Xz1HowigMydAWuxcMlf7rkPuxOKqpO8oD8+5BsD4D+VRr/T+67SJ0iIFMD1MYkpb+T7bs2e6kExb8QTgNaQ92hK8mKAmD5rpYMGa/IwDuUnnjxOP8giJe7mbFYBgUTvqmAcwo6GXKkY/QUSz7Hzg2E24EB8J+DUsjj0i3WSxb/4Trw8oLBltA4t48BNApW6/4ndnkPYOHiipyPrDI85bOtS9WaebDWzC/xcg0EhrHjMR3W69WNqh47YkYvMYvWiKNjUWtURx3Ny6r5dGwM/bXk2j1DZyaJOk+ZvowSV3Qcy6juGNvfofYx28gXVojTyodmZabquZYaEICv4umpO4V41hd81ZrrV58y3e5EvZxEmGYUGgkhjF1+O2SgzL9TzoRznizgLfi2hbSNEVKe7v8y4uSpP9sftEJZKPWMoG99mIA1TjgHkNlIBqox7tTP/YkvNRIpo1WGTv8gQzCZky1Q==;5:7fpsrx+mTN3/vywyWfMXKeN9yS32z9atzHeXgrKoe4+C3Xm78x79o5OLElLnAW3TPa7SfxUL0SloVPDaw0kJ0gGxDJaUbJL2EcDqrbXwMZ12XycmrrWEKfsNdlPyxEVWZDkilg0kOL+QyGqqGhoh/BBhJS+0yQYJ+cljJhYef9I=;7:mUl3Hy8LSEBukr6WzJuFfnGZCDcvJcY1yFuv3Fr1C0p4W3voxrMKOFtBK5vPekhr5TffbO5MV4dCwaBEclqKQcWuYfDsMobJw4ZkSHaukiRW4RMDGaHwpsEYjh4o2zFA5crMzS7HceCkSOp7aMQWh8peMRXNB9TnsXMZP6P1KRUGQIvR5AMZT/q9AcqdrulL99q/Q/nTGThxJ88XbUy6ZW8Zowr6FcgcfHUsoKp94WDxK7Zrf/5VmULlG1o0z/61
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2018 23:36:25.1156 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79698f46-961a-47ec-a5d4-08d6259b34a4
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB3936
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 09/29/2018 01:30 AM, Hans van Kranenburg wrote:
> [...]
> 
> I didn't try filling it up and see what happens yet. Also, this can
> probably done with a DUP chunk, but it's a bit harder to quickly prove.

DUP metadata chunk       ^^^^^^


-- 
Hans van Kranenburg
