Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6593DC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 06:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EAD32082F
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 06:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="a9KMjnED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfC2G4H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 02:56:07 -0400
Received: from mout.gmx.net ([212.227.15.18]:45407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbfC2G4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 02:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553842554;
        bh=NwY2D8lMhkiadAi3ZwatiMCIgqAt49jsYHiLGzI5ZzY=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=a9KMjnEDTufbbHpFwEvBu62gD9e7qrW5DmJrDHmInAdSjczVy+azRz4pKEKw4R2uh
         y8hq4tvEBA3xgO7sN6yVQ6Lol0D+8bpSUidY3J4DAdG3HDd5UKCoWuSf8tM4Ui2MdT
         UIkleVi6mRjCrN3Hb9eGccTLwFWjj5JUOh6pf/xQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MbgKD-1hPvEi11YD-00IyXS; Fri, 29
 Mar 2019 07:55:54 +0100
Subject: Re: [PATCH v4 00/15] FITRIM improvement
To:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
 <20190328231818.GS29086@twin.jikos.cz>
 <ee1bed9e-3330-d4cb-3545-19f191431415@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <430654e4-3193-3471-902e-4759365b9001@gmx.com>
Date:   Fri, 29 Mar 2019 14:55:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <ee1bed9e-3330-d4cb-3545-19f191431415@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nGCWf4pZvZn49mq4733nKmIj8HQNnK6752nlAFFPuIyqG1NqoZl
 wTvZc0Lgl27A43bBzJHGeZBKUkFbB77TCNUDv1vmVvmbleh2/740Ibpo4IDqR9go3pusI4F
 P6Yl1pRoUsfSfLc7F8W3viP1bATAb5EAs1WGtbrVXuYBT2C0VL36a0YNBlBuzmsh2+XVaQG
 Jt/rvSd1H7niL9xT08qeA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QX5K2U1uUjY=:RF4eoFVKPd1oBWKvaZR10E
 7TIsfUCfv0wWG5qc2uJkydIUGIUX8Lsw9aBThpf1x9TZ26MmiBIWioFqo8IpOwLHxY864AHuo
 XSc4YpCoQ3+XeqXZpnXeDV7ILOhAEKUDfvuWTfTP1E79EXAfB1Jqig0cXKvys41Nx8LXzId0G
 yWc0TinqkDcxXVbEHoNFv6sBi22CcsTq1AMrWJBJWW4ZfuRDcGYYnNRAjtcnzbLw9ZGO+FSZS
 EaKLio1tzmKnmjmy0gVZdfFOLnXkb+4YvAKf7hjpguRuPhqTVk98ecw7vv2kAG6O3IuEwyhdC
 YRydeOzTKY9LGMrpQ4rdy/RJSoFGu7yM7yyLX0IGBVE+msjuKVmqv1t1CTQlSCmy3WnNETSAD
 JiJhF+f9jdlAoQBfaszGNRKbzhFJ6uM24uDMr5nkx1686xmmcPh42aVOg/xNcjwoFb2W0UwFX
 ccvoQGdORRe7MDjJyBunIs47cEURtJQy6HYo8G35rIq95EYelI9s4PjwizM2Jt7hH/gcUbfmT
 sqctcRTrVQ9ryR7gVU6GvgLjs268Z1nGeCdEuXARR0MG4SyfBQwOdjcXarWYR0fV76Je9vPxI
 czK618FhuTyIwLWJ7YgAOBBw/SArIUqE7BKyqcOyUzEPRLhAsqveUXWvlt1VFwr4IvdtaoG3D
 +/SNhYPrG4zhFovZAv6s9OjHiy7OTPkIf0+XSqX0idphQtzbAp8ACRCnpEV1pGfhy+5vQVVCL
 dsFIkpgT4CXX/5s5UCjGxVD23H8MEINXsdxSIztvDxqlLNEUSfX8RKaYxX/NDBatsF9qxUy/X
 asMwQhmXyMMAuvdhCQ36QdPqjl+kTAq0Ttj8bh1HaKVL9wqWg2I0kNrvJyv8y8iMgeV5WmmEE
 W6c4gnjdBgtDVLQG2gkKyWTP6oSVxPldNb1lCUQTZt+owAjBzCgdgz7D68sB1qxbiNca/+0wr
 zJ1q9XeFAcQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/29 =E4=B8=8B=E5=8D=882:20, Nikolay Borisov wrote:
>
>
> On 29.03.19 =D0=B3. 1:18 =D1=87., David Sterba wrote:
>> On Wed, Mar 27, 2019 at 02:24:03PM +0200, Nikolay Borisov wrote:
>>> Here is the (hopefully final) v4 of the fitrim patches. Main changes s=
ince v3:
>>
>> Nope, tests don't like it. It's v4 applied from mails on top of misc-ne=
xt.
>>
>> generic/475             [20:36:10][11571.724402] run fstests generic/47=
5 at 2019-03-28 20:36:10
> <snip>
>
>> [11576.260681] BTRFS error (device dm-0): error reading free space cach=
e
>> [11576.260832] BUG: unable to handle kernel paging request at fffffffff=
ffffffb
>> [11576.262301] BTRFS warning (device dm-0): failed to load free space c=
ache for block group 1104150528, rebuilding it now
>> [11576.265687] #PF error: [normal kernel read fault]
>> [11576.265690] PGD 2b016067 P4D 2b016067 PUD 2b018067 PMD 0
>> [11576.265696] Oops: 0000 [#1] PREEMPT SMP
>> [11576.265700] CPU: 0 PID: 25594 Comm: fsstress Not tainted 5.1.0-rc2-d=
efault+ #531
>> [11576.265702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS rel-1.12.0-0-ga698c89-prebuilt.qemu.org 04/01/2014
>> [11576.265753] RIP: 0010:btrfs_lookup_dentry+0x4ce/0x5d0 [btrfs]
>> [11576.265756] Code: 4c 63 f8 85 c0 0f 88 90 fb ff ff 80 7d ae 01 0f 85=
 8c fc ff ff 48 8b 7b 28 45 31 c0 31 c9 4c 89 f2 48 8d 75 a6 e8 e2 f0 ff f=
f <0f> b7 38 49 89 c7 e8 c7 01 e9 d2 3a 45 98 0f 84 5d fb ff ff 41
>> [11576.271036] BTRFS: error (device dm-0) in __btrfs_free_extent:7103: =
errno=3D-5 IO failure
>> [11576.271144] RSP: 0018:ffffa82cc3fe7db8 EFLAGS: 00010292
>> [11576.271149] RAX: fffffffffffffffb RBX: ffff94f41ea66218 RCX: 0000001=
603c56600
>> [11576.273851] BTRFS info (device dm-0): forced readonly
>> [11576.274694] RDX: 0000000000000011 RSI: ffff94f41ea63ed8 RDI: fffffff=
f930dacb4
>> [11576.274696] RBP: ffffa82cc3fe7e40 R08: 0000000000000001 R09: fffffff=
ffffffffb
>> [11576.274698] R10: 0000000000000000 R11: ffff94f46f36a910 R12: ffff94f=
414e94500
>> [11576.275912] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:300=
1: errno=3D-5 IO failure
>> [11576.278115] R13: ffff94f474880000 R14: ffff94f403833000 R15: ffff94f=
4563eaa10
>> [11576.278117] FS:  00007ff34f4f4b80(0000) GS:ffff94f47d400000(0000) kn=
lGS:0000000000000000
>> [11576.278121] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [11576.278123] CR2: fffffffffffffffb CR3: 000000001f60c000 CR4: 0000000=
0000006f0
>> [11576.299608] Call Trace:
>> [11576.300463]  btrfs_lookup+0xe/0x30 [btrfs]
>> [11576.301666]  __lookup_hash+0x6b/0x90
>> [11576.302748]  filename_create+0xa9/0x180
>> [11576.303865]  do_mkdirat+0x53/0xf0
>> [11576.304844]  do_syscall_64+0x54/0x180
>> [11576.305924]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [11576.307131] RIP: 0033:0x7ff34f5e5307
>> [11576.307952] Code: 1f 40 00 48 8b 05 91 eb 0c 00 64 c7 00 5f 00 00 00=
 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 53 00 00 00 0f 0=
5 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 eb 0c 00 f7 d8 64 89 01
>
> My Code doesn't touch the lookup path, furthermore it doesn't touch the
> extent freeing logic, could this be something unrelated? How reliable it
> is to repro with/without this patchset?

OK, it's my inode mode checker patchset triggering all these.

It's btrfs_inode_type() call causing all the problems.

I'll investigate how this happens.

Thanks,
Qu

>
>> [11576.311502] RSP: 002b:00007fff14fd0a98 EFLAGS: 00000206 ORIG_RAX: 00=
00000000000053
>> [11576.313415] RAX: ffffffffffffffda RBX: 0000000000000014 RCX: 00007ff=
34f5e5307
>> [11576.314809] RDX: 0000000000000000 RSI: 00000000000001ff RDI: 0000000=
0004153d0
>> [11576.316224] RBP: 00007fff14fd0bf0 R08: fefefefefefefeff R09: fefefef=
efeff3263
>> [11576.318087] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000=
0000001ff
>> [11576.319955] R13: 0000000000405390 R14: 0000000000000000 R15: 0000000=
000000000
>> [11576.321746] Modules linked in: dm_thin_pool dm_persistent_data dm_bi=
o_prison dm_snapshot dm_bufio btrfs libcrc32c xor zstd_decompress zstd_com=
press xxhash raid6_pq dm_flakey dm_mod loop [last unloaded: scsi_d
>> [11576.325773] CR2: fffffffffffffffb
>> [11576.326498] ---[ end trace fe71251c3619f317 ]---
>> [11576.327514] RIP: 0010:btrfs_lookup_dentry+0x4ce/0x5d0 [btrfs]
>> [11576.328841] Code: 4c 63 f8 85 c0 0f 88 90 fb ff ff 80 7d ae 01 0f 85=
 8c fc ff ff 48 8b 7b 28 45 31 c0 31 c9 4c 89 f2 48 8d 75 a6 e8 e2 f0 ff f=
f <0f> b7 38 49 89 c7 e8 c7 01 e9 d2 3a 45 98 0f 84 5d fb ff ff 41
>> [11576.332993] RSP: 0018:ffffa82cc3fe7db8 EFLAGS: 00010292
>> [11576.334430] RAX: fffffffffffffffb RBX: ffff94f41ea66218 RCX: 0000001=
603c56600
>> [11576.336263] RDX: 0000000000000011 RSI: ffff94f41ea63ed8 RDI: fffffff=
f930dacb4
>> [11576.338080] RBP: ffffa82cc3fe7e40 R08: 0000000000000001 R09: fffffff=
ffffffffb
>> [11576.339907] R10: 0000000000000000 R11: ffff94f46f36a910 R12: ffff94f=
414e94500
>> [11576.341535] R13: ffff94f474880000 R14: ffff94f403833000 R15: ffff94f=
4563eaa10
>> [11576.342561] FS:  00007ff34f4f4b80(0000) GS:ffff94f47d400000(0000) kn=
lGS:0000000000000000
>> [11576.343689] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [11576.345041] CR2: fffffffffffffffb CR3: 000000001f60c000 CR4: 0000000=
0000006f0
>> [11576.346593] BUG: sleeping function called from invalid context at in=
clude/linux/cgroup-defs.h:721
>> [11576.348556] in_atomic(): 0, irqs_disabled(): 1, pid: 25594, name: fs=
stress
>> [11576.350006] INFO: lockdep is turned off.
>> [11576.350894] irq event stamp: 0
>> [11576.351608] hardirqs last  enabled at (0): [<0000000000000000>]     =
      (null)
>> [11576.353254] hardirqs last disabled at (0): [<ffffffff9305cc77>] copy=
_process.part.72+0x847/0x1df0
>> [11576.355056] softirqs last  enabled at (0): [<ffffffff9305cc77>] copy=
_process.part.72+0x847/0x1df0
>> [11576.356705] softirqs last disabled at (0): [<0000000000000000>]     =
      (null)
>> [11576.357848] CPU: 0 PID: 25594 Comm: fsstress Tainted: G      D      =
     5.1.0-rc2-default+ #531
>> [11576.359000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS rel-1.12.0-0-ga698c89-prebuilt.qemu.org 04/01/2014
>> [11576.360913] Call Trace:
>> [11576.361480]  dump_stack+0x67/0x90
>> [11576.362231]  ___might_sleep.cold.85+0x9f/0xb1
>> [11576.363300]  exit_signals+0x30/0x130
>> [11576.364220]  do_exit+0xac/0xc10
>> [11576.365042]  ? do_mkdirat+0x53/0xf0
>> [11576.365937]  rewind_stack_do_exit+0x17/0x20
>> [failed, exit status 1] [20:36:15]- output mismatch (see /tmp/fstests/r=
esults//generic/475.out.bad)
>>
