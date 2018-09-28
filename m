Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2ACC43143
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 23:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0EC6206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 23:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="A12qm0++"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0EC6206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbeI2F5f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Sep 2018 01:57:35 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:36256
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726762AbeI2F5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Sep 2018 01:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA+3prGwRlJv5mielsz5zlteBjdpFhhUdLVgC59jLX8=;
 b=A12qm0++0w4O4vvLfdN9fkz3ex2ELHUoFKhczYGLCmGW9KWfrdnB7ygz1F7UcIgMKVCFnHTtFguPHtVdTkUEzyZvf3acq8ZaGkt28ZSCSJNEZcH7PYid7KjfLldJvAiuzqOs/WAnbx54CAFC/HYxy/NQrQpBWiX8a28zOBpoqMI=
Received: from [IPv6:2001:980:4a41:fb::12] (2001:980:4a41:fb::12) by
 DB6PR06MB3926.eurprd06.prod.outlook.com (2603:10a6:6:4e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.20; Fri, 28 Sep 2018 23:30:17 +0000
Subject: Re: DUP dev_extent might overlap something next to it
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com>
Openpgp: preference=signencrypt
Autocrypt: addr=hans.van.kranenburg@mendix.com; prefer-encrypt=mutual;
 keydata=
 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
Message-ID: <ef345860-6916-2c37-a7c1-b43ad5549df4@mendix.com>
Date:   Sat, 29 Sep 2018 01:30:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2001:980:4a41:fb::12]
X-ClientProxiedBy: HE1PR0802CA0017.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::27) To DB6PR06MB3926.eurprd06.prod.outlook.com
 (2603:10a6:6:4e::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc97bdd0-29a7-4f92-b407-08d6259a5985
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB6PR06MB3926;
X-Microsoft-Exchange-Diagnostics: 1;DB6PR06MB3926;3:uQ5pmc/a7l3RR/VntqE5iCILJ1cAcO2on/AW42PYrwvZymcjgDcWgcfmODjrZkxUKdyfARL9YY1H2FyVS3bCjK6o/tbYYRbtkFZBPoq/FxLRvEF3eg0UzXi64lOVF4raK5DfCtePPsLqvcRaZGpPL6qaQiG2Oww/3D5zYZxFvfFsnMVNcdVGfrrR2Qtv2LV3sPCSO8xgCRPBwdJcsyTv2rq4bRbFBSmhTbgN/3ZQPSCOC0AR8rhFBYoLAqkJyiU4;25:cEsFrNugywKHq+rhiaddfp+EPQUV9HF1nVvCbqvPG8khUD+VaI6DC5Oz/4xyX7udrhmeJQkHvV4sVE3aeQFvc5eJ5jq99mdBuKggKjwkz0aIMoRz4Ijo9OBe5IacqzcQgcYhuf1uGECSH2O3ZBlsYFiL5p8Q0Yhh9ZxZPyw8qWslOIfjVulElokn3xEyT58eF3MSphrtpRA03gVLiEqPW2iOqbLsmiCoyNgLpeHISUyDGAzxijrUUKN/67ZRwCD5qFFA8Pw2eXekT9Xj2cCdxV50yYyqpivsqecaKZiV41NJpC591LTSBU8SVZp0eH3xFZkwVC3KeyWVLdMxDP418w==;31:hTC7r6bf+c6NYOJnZdxmPiM0jzTcrQWCMZkkrJBktVeLAXk0K8HviYelUFKJgHCN4Oe7eMmAorCJA3mnXIbef73Xqr+Cwr5/HoUvAABYlwgufyxz7+aXuEzvBzm6QyzEgOVO7xy6F8akLzt+pm9tz7W/wrUHWf0AkQ6jt8HBjUNPRnpMBNemKdgRA1mVKrea1spmeHm0eBNeNnhsGW225eHNPEHKgL+MvVFv2swFNFw=
X-MS-TrafficTypeDiagnostic: DB6PR06MB3926:
X-Microsoft-Exchange-Diagnostics: 1;DB6PR06MB3926;20:YN4kH99hIE08NxG1KSFykj9EKkTxmMoIoW/uWZGWTtr7OagabAdNNaYVr1GM2GPF2O6raryf/coqUr3EEsJVlbisKrX7BlnPqN0Erk5alklklosaW92R5KO6v54XlQvVlyrVNqANuw3iNiXvywbYG3Uf0gJEvfFkTNRiRAxPxkVtEb9aEWDGRQXw3S4uVlTVuL3E8sEqtownBdEyIrREHqhu2kXmcQuUxHbMClmi2qNUXL1MXl9Pk3TX0KpDCdMkJjLdoH4d0b04Pa3mNPcWT7YEiKXPCuVgqMmNUsOTBkTQZk00DRuOPAJwJHyO9H7BmdJRgzJYHDUiM2AfH53ncYLIUaHn9yadDlONFMjJwFSmXtrcKfS+36SP+iA36qB2v3kdS4Zn4UlRipf3vGB9Hvr6hNn1pNaB2MmTI7vFG0UVb4ZOl8Ou6rqAF4xubo+FakhdLY84MU/pXmzmpM4aBkMMb5hu+H6Bm3ZEac/IgSCGLfsYP88wCtvGhEVZUv5PAqbPkZREfMRCOqqF5QDSVDMckhcbmR28ocHM30/42eulKI0d5pt6qyEcDr9l2LxpYVWaSXiagRz69L0sYSH2jx3lsPea71pchSh0PN+5QEk=;4:lBPTmAJyVLg+gw11Ssb8xZKTuUigDwirxr9mbaMnXAYrk73VWOHjPHLURmA1AxCeeaD8UVnqgga9AwfdJo/GzKI2z533M3scc3DM/w0wMDP10yB8OAcyHmVSQcIrB9V35ib6cMPoLh2h/Z4W9uQyopySgXYbgkGQSB4msZ1PTxKgxcit4KUMrkNbWbt3DL80FyzEkcyW5476+9gZ2wWpC8ilFNB0EXGhIuO/GLXe7tVGseqWNtlMcQs9Zlb1Exj1PiDqxTkh5ZjNitIBt1R2xQ==
X-Microsoft-Antispam-PRVS: <DB6PR06MB3926B645A14A83CFE5614CB3D4EC0@DB6PR06MB3926.eurprd06.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(10201501046)(3231355)(944501410)(52105095)(93006095)(93001095)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991041);SRVR:DB6PR06MB3926;BCL:0;PCL:0;RULEID:;SRVR:DB6PR06MB3926;
X-Forefront-PRVS: 0809C12563
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(376002)(39850400004)(396003)(199004)(189003)(53936002)(305945005)(97736004)(7736002)(65956001)(478600001)(386003)(2906002)(53546011)(50466002)(68736007)(2870700001)(72206003)(6346003)(25786009)(81156014)(8936002)(8676002)(81166006)(6246003)(47776003)(65806001)(6486002)(16526019)(186003)(229853002)(46003)(31686004)(36756003)(34290500001)(65826007)(86362001)(52116002)(105586002)(52396003)(23676004)(6116002)(58126008)(316002)(5660300001)(6666003)(64126003)(6916009)(446003)(11346002)(1706002)(52146003)(2616005)(2486003)(476003)(486006)(76176011)(31696002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR06MB3926;H:[IPv6:2001:980:4a41:fb::12];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtEQjZQUjA2TUIzOTI2OzIzOklUSkcyZlh2OE00NnVOZVlrVzZRTXNnY1ZD?=
 =?utf-8?B?dE9JVGhDcHFSVk9UMTJtdldsWlRSejhjZ0dwTm9UaFBVbkJXK3NPOVlqMFJu?=
 =?utf-8?B?RWgxSXlaN1ZoOW12cC9nUGxOaytvcy84Wi9jejY0OVFiY0YyVnl5ZzloNXRr?=
 =?utf-8?B?QzVkYzIwWDh3dzVBQ0gvcTdnaFJocW1VbTVMclpLenY4TlNXdUR0dmV4TWdH?=
 =?utf-8?B?RDVVaWt4c2lUVXlLOUd6Q1dwcndhOWQ1MkRiQmFSTW82Z3phYy9iU3ZxQ2Mv?=
 =?utf-8?B?SWJRVzM2VjE3TldZNjFGQU9kTm1pN0hwQkxPZHNZRVdzNEszZjNOMlJKMng4?=
 =?utf-8?B?eDYzazVicTlJSERrNWZxd29MSEptUUNmNjN4WjB6NE00RGR1eEZPQUt3TG9T?=
 =?utf-8?B?VkFEZFM0RlUyZk53TnJtL1EyQTlvVk8wSFMxODBEcWlrNmZmYlRDTWkvekls?=
 =?utf-8?B?NTg2dDBwSkZnM1d0Y1hBR3EwbmsrQVhmL1NqTEYyQ01FUXZ5VUxXT083QWVY?=
 =?utf-8?B?aXNmR3lPWTBtOThEZmc3WnVsNzBiNEk1ekNIZFRPcnFuRnp2b2Yxb2cxVXha?=
 =?utf-8?B?VW83bWZLamdkbkJQbTB6Yy82Y2ZrLzBZVjdsQ21aSVE5d2dUZGZ1b0NNWnNK?=
 =?utf-8?B?cXFlWGxzSzA4S2pRUEFla3RacEpzZlJaWUZnckRBeFFoSDVrLzBOWFdGSkJn?=
 =?utf-8?B?UFZvTnhoSkh6bUZ5KzhoNCs2THJ2QXZHelBlOG00Z0FVakFSQTZ5K0ZwU0U3?=
 =?utf-8?B?b0ZOWVhOR2svSFpBeWgzWm9EVUZYVHV3UzRtbzFlNWVqNUhlUzdhZHdSUWQy?=
 =?utf-8?B?L3BldXJFb0FCTi9OQ0RaR1RXYmlUenFMRlA1WEtwY3RwdjdPK2c1dUJwQnh2?=
 =?utf-8?B?NndiYUl2WXlhZDVlcnZpWmMwaForRmlZd3lkem9qOHFQb3pOWWhjUkZvclQ5?=
 =?utf-8?B?YzFSakFkcVlFRFJYNWV1L09jRTlPblVUeUpKcnQ4dU1ENUJsTFFhYVUzQ2c2?=
 =?utf-8?B?YzhUQ1F2RERFL2FXekZQL2FtTktwNkVhVllQSXJudEZueUwrQXh1UjVSL29s?=
 =?utf-8?B?K0wxWTg1SFY4RXF0MkU1K09QVEZYNE9CWGthV05CWFZ5WVhibWtCNWJYOEVV?=
 =?utf-8?B?eUlUb3NKVFpwdEZiRmIxQnF4VklENDhkdkpXc2VrV3lWK20xT2FuaFJUZmJx?=
 =?utf-8?B?SmNmZ1ZMRXhWWkZRMno1dEFid3pKcVMzZ3dDU3Q4d0c1RWlkVzlEa29wOTR5?=
 =?utf-8?B?a3VxaVY3QmRPSUN2bDBoTkVXc0VsQ3pnZkJESEZ6R0JVWmRyMFdmY1ZkZDBj?=
 =?utf-8?B?WEZxaG01ZW5CVTdjbEd0YmNZQlI3ZmN4SC9ROVl0RnZWWVY2Ry92Q1ArWEV5?=
 =?utf-8?B?V2NaT1JHZ25UNG9jZklNK0JXenRvK3JDYTBISDgxNWpsOFRVdllRanRwUlhs?=
 =?utf-8?B?OUw1TDRMb2NuZWpmcW02RStjWkxoQnQrWld3YkxMeVFMOG1SNkVWK1RjazBr?=
 =?utf-8?B?d0NIRHFJUHl6dkRKOUFBVkQwUmU5Q05DaGpuaXJ5eC9MUDVVRkVzRVJ6Zngw?=
 =?utf-8?B?dVdRd1dZc05IRnR4Sm9kRmNRZVluVnY1VzcxbHBJZnhyMGtxM2pKckt4RmZK?=
 =?utf-8?B?MTI4Nm56QUhLd25Pcnh0dXZvOEdZMytXeldBVUp5cmFNV2hZNEtXNTdScGFZ?=
 =?utf-8?B?OVdiQnU0N2RFbnZuZXlGbEZWVGdURHpVeHNKZ3laclp2VVZXMllYV1lqR2Fk?=
 =?utf-8?B?NFFQV2lrazFjN3RCT3RCZ2NEOVpoTVAzRUs4M2pENTVTVnZIbGVTQ1AzNncz?=
 =?utf-8?B?b0loNjc4RmhMMnlhRGlqR3ZNaTdNOExBcStuYW43SzdHQy9mUlNjNTlHN2lS?=
 =?utf-8?Q?1O+FRLUJjps=3D?=
X-Microsoft-Antispam-Message-Info: LQ3GMIoHe+Rp0eNWpuClTqv9FCZ1js35g4IOttz6SKgiyU2EPn2tOGgzh5DrWbdcAxo1mMLBMvd+7wDqKmHXfF03JD06MzUmtgyZXD63otTyC54Be6JozV3LMTThcGHOKtMov8xoAB2O+Zl/1S0ti4RURm5QEvvFmPJJKjg+T3lQD5if96e+cWaHixyNjhyTLqvKkiWAtDsJ7j893KhzD4HBEYEADvFqrJlKPtWmJSQ3CXaywaWyPV6UdT9feh2Vo3zYUCL1ykupVj+AZUsCDpe59fb3ZbpsSSmywnvnOPf2TltXJgsOYSa5PqJaCJSNZUFbtiiUXhy1glb011tBNT7mX+5KJDAUpI3oY1hq82k=
X-Microsoft-Exchange-Diagnostics: 1;DB6PR06MB3926;6:uxrsl0Kg7W5lNVmzEWIjhvlXWEHAo5w5j/ouoJlyHmP5p8GtIORTDSJsHWCCkBN/5xRgHWtbWnlO3k7HIlmp/rgKhJG5zPmEw9IXZMD1Pmua3ofZw/N8zSjy2hVxZBe/TNyqi3+iTtvunLAGvx1ABnFD2QDGOL628/Q4FTuD9P2mujlCu/AWPhy3X20i2JyeAPOYg8G+ouBonOyi6nt3O33DevkFNiObgqr1uxtfliNuMhK7iTGDroGEEs+ABN/XsrBe4NOw5A/N1BSHPpvZUw315t8YYB+4+pvXAky/bdvQAbpQWXnfWKnBUwVJlW40Zvi1BmgxKwQVuO+JZ8Krd2Imt6cVkjGJH1ZKzjIPMWAzAdibA0QEh4h6055UgmmQkjlAXdZqV5V+/VTRON70MSMcFsS807PjCoUbRgQDPZ3JjlTjgssAdBs9xgeos95qk7RvobWOnZxAoM71z9PAIQ==;5:EgN6hw/WX47Ti82iYF3xan+3r8QnAI18JradBUHdD6Bp5Y/tsGCRDB+39n1I1W5nf0yPUhGcw/l5aFvBKP2Kmwuu/EG78+7C0li6KNPBqtg7hvQA3+0LtQfZhNGPQOEmxrs/jtZZrHQjXLlshfD+b4r8KWTuYLO0ZgRZdgnfmn4=;7:tKeWdvIHy6F1CziTQ9Tgwrs0jfvAjVB2GSlRkw8iywAidUbnirrD+X2iU98HNp0+vmVVZ/KZQgA74S1tWLcpezRqGSotCtMPjeq375bPSJKWDpgnLNSkb0pNS3VwF7MbzF9fD1RmExuIMX+3OuY3EnGbVXZX6aTI16lJ9lraZqijyYa8grTkp9H3Sgo5AU0hWrNdf/tn1ut/jEfasrR22B6minOaYPkYgnGp1vFmRuvv0Iopq4blpkPmsO8AQpMs
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2018 23:30:17.3857 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc97bdd0-29a7-4f92-b407-08d6259a5985
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR06MB3926
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 09/25/2018 02:05 AM, Hans van Kranenburg wrote:
> (I'm using v4.19-rc5 code here.)
> 
> Imagine allocating a DATA|DUP chunk.
> 
> [blub, see previous message]

Steps to reproduce DUP chunk beyond end of device:

First create a 6302M block device and fill it up.

mkdir bork
cd bork
dd if=/dev/zero of=image bs=1 count=0 seek=6302M
mkfs.btrfs -d dup -m dup image
losetup -f image
mkdir mountpoint
mount -o space_cache=v2 /dev/loop0 mountpoint
cp -a /usr mountpoint

After a while, this starts throwing: No space left on device

Now we extend the size of the image to 7880MiB so that the next dup data
chunk allocation will exactly try to use the 1578MiB free raw disk space
to trigger the bug.

dd if=/dev/zero of=image bs=1 count=0 seek=7880M
losetup -c /dev/loop0
btrfs fi resize max mountpoint/

Now we trigger the new DUP data chunk allocation:

cp /vmlinuz mountpoint/

Now I have a dev extent starting at 7446986752 on devid 1, with length
838860800. This means it ends at 8285847552, which is 7902, exactly
22MiB beyond the size of the device.

The only nice thing about this is that df shows me I still have more
than 8 exabyte of space in this image file.

Label: none  uuid: e711eea6-5332-44cf-9704-998a7a939970
	Total devices 1 FS bytes used 2.81GiB
	devid    1 size 7.70GiB used 7.72GiB path /dev/loop0

I didn't try filling it up and see what happens yet. Also, this can
probably done with a DUP chunk, but it's a bit harder to quickly prove.
And making this happen in the middle of a block device instead of at the
end is also a bit harder.

-- 
Hans van Kranenburg
