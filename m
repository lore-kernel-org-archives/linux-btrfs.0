Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EB8C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5965A20651
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfANN2t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:28:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:44266 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbfANN2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:28:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8687AE86;
        Mon, 14 Jan 2019 13:28:46 +0000 (UTC)
Subject: Re: btrfs hang on nfs?
To:     "Scott E. Blomquist" <sb@techsquare.com>
Cc:     Jojo <jojo@automatix.de>, linux-btrfs@vger.kernel.org
References: <23605.54017.819143.292441@techsquare.com>
 <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
 <23605.63394.330818.203495@techsquare.com>
 <23607.12444.740949.683554@techsquare.com>
 <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
 <23607.13250.659000.140295@techsquare.com>
 <23612.30105.728099.63687@techsquare.com>
 <89a8a3a1-07bc-6cdc-1278-b9649f2b477e@suse.com>
 <23612.35592.599043.773332@techsquare.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <9644378c-d06c-9747-4f15-7f1d0804f54e@suse.com>
Date:   Mon, 14 Jan 2019 15:28:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <23612.35592.599043.773332@techsquare.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 14.01.19 г. 15:13 ч., Scott E. Blomquist wrote:
> 
> Nikolay Borisov writes:
>  > 
>  > On 14.01.19 г. 13:42 ч., Scott E. Blomquist wrote:
>  > > 
>  <snip>
>  > > 
>  > > The file system hung again below is the sysrq output
>  > > 
>  > > Linux kanlabfs 4.19.13-custom #1 SMP Wed Jan 9 08:36:50 EST 2019 x86_64 x86_64 x86_64 GNU/Linux
>  > > 
>  > > btrfs-progs v4.19.1 
>  > > 
>  > > # btrfs fi df /export/
>  > > Data, single: total=79.61TiB, used=79.61TiB
>  > > System, single: total=36.00MiB, used=8.31MiB
>  > > Metadata, single: total=192.01GiB, used=190.19GiB
>  > > GlobalReserve, single: total=512.00MiB, used=0.00B
>  > 
>  > So this btrfs is hosted on your local machine but it is exported via
>  > NFS, correct?
> 
> Correct and via samba also
> 
>  > > 
>  > > #  btrfs fi show
>  > > Label: '/export'  uuid: 8f92c2e4-86fe-48cb-b2d3-bc36da765f02
>  > >         Total devices 3 FS bytes used 79.79TiB
>  > >         devid    1 size 47.30TiB used 43.58TiB path /dev/sda1
>  > >         devid    2 size 21.83TiB used 18.11TiB path /dev/sdb1
>  > >         devid    3 size 21.83TiB used 18.11TiB path /dev/sdc1
>  > 
>  > What kind of disks are those, presumably spinning rust due to their size
>  > but what model/make?
>  > 
> 
> 3 x raid 6 on a LSI MegaRAID SAS 9271-8i

Has your controller been updated to the latest firmware? In my
experience LSI Megaraid are rubbish controllers and in the past, in a
datacenter environment, we've had a batch of bad controllers which
resulted in controllers resets, causing all IO to die on 10s of machines.

There was a way to query the controller's built-in log for firmware
errors. I can't remember the exact command but googling suggests using:

MegaCli -AdpEventLog -GetEvents -f events.log -aALL && cat events.log

Can you run that and also attach it when a hang occurs?

> 
>  > > [Mon Jan 14 06:24:26 2019] sysrq: SysRq : Show Blocked State
>  > 
>  > <snip>
>  > 
>  > > [Mon Jan 14 06:24:26 2019] btrfs-transacti D    0  6808      2 0x80000000
>  > > [Mon Jan 14 06:24:26 2019] Call Trace:
>  > > [Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
>  > > [Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
>  > > [Mon Jan 14 06:24:26 2019]  btrfs_start_ordered_extent+0xca/0x100 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
>  > > [Mon Jan 14 06:24:26 2019]  btrfs_wait_ordered_range+0xbd/0x110 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  __btrfs_wait_cache_io+0x49/0x1a0 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  btrfs_write_dirty_block_groups+0xed/0x360 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  ? btrfs_run_delayed_refs+0x8b/0x1d0 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  commit_cowonly_roots+0x1ed/0x280 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  btrfs_commit_transaction+0x36e/0x8d0 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  ? start_transaction+0x9b/0x3f0 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  transaction_kthread+0x14d/0x180 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
>  > > [Mon Jan 14 06:24:26 2019]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
>  > > [Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
>  > > [Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
>  > 
>  > So the transaction is being committed as a result of that
>  > btrfs_start_ordered_extent, which flushes data to disk. Since you've
>  > compiled your kernel can you run the following command from the kernel's
>  > source:
>  > 
>  > ./scripts/faddr2line  vmlinux  btrfs_start_ordered_extent+0xca/0x100
>  > 
>  > 'vmlinux' should be the kernel executable with debug info that results
>  > from compiling the kernel. I want to figure out which line exactly
>  > btrfs_start_ordered_extent+0xca/0x100 resolves to.
> 
>  <snip>
> 
> I'll have to rebuild the kernel with debug symbols.  Do I have to be
> booted into the kernel for that command to be useful?

Well the running kernel needs to correspond to the vmlinux since
otherwise the offsets might not match. In any case try rebuilding the
kernel and running it to see if it's going to result in a sane output.

> 
> Cheers and Thanks,
> 
> sb. Scott Blomquist
> 
> 
> 
