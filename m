Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:33906 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752839AbeFLEhR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Jun 2018 00:37:17 -0400
Received: by mail-wr0-f173.google.com with SMTP id a12-v6so22524528wro.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jun 2018 21:37:16 -0700 (PDT)
Subject: Re: Corrupted node, damaged slots data
From: =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
To: linux-btrfs@vger.kernel.org
References: <CAC5rCSjVpjGr--x7NgSfmeBOc5+PRcgU4Zj5YSHXAHw_vDCQwQ@mail.gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4af2c3a3-d3d0-5844-1fba-6bb6c5e4f8be@metaliza.cz>
Date: Tue, 12 Jun 2018 06:37:13 +0200
MIME-Version: 1.0
In-Reply-To: <CAC5rCSjVpjGr--x7NgSfmeBOc5+PRcgU4Zj5YSHXAHw_vDCQwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

maybe I should note that when I have tried to dump the whole tree using 
btrfs-progs ver. 4.12 (as a part of distribution Kubuntu 17.10) then it 
have dumped the tree (I have that dump saved in a ~2 GiB file) with just 
only "a few" errors on stderr (I remember about 2-4 lines with some 
things like "blocks x-y aren't mapped" and maybe some other errors - 
unfortunately I haven't saved them into a file:-( ) ...

... but when I have tried to do the same thing (because of the error 
messages) with btrfs-progs 4.15.1 it gives me only: "ERROR: unable to 
open /dev/sda4".

But I am still able to do: btrfs inspect-internal dump-tree -b 
75150311424 /dev/sda4
(it dumps the respective block without errors).

With regards
TM

--

   Tomáš Metelka
   Business & IT Analyst

   Tel: +420 728 627 252
   Email: tomas.metelka@metaliza.cz
   

On 6.5.2018 02:44, Tomáš Metelka wrote:
> Hi all,
>
> I have a following problem:
> FS sudenly became RO, after reboot FS became non-mountable with the
> following error:
>
> [  +0.006976] BTRFS critical (device sda4): corrupt node: root=1
> block=75150311424 slot=245, invalid NULL node pointer
> [  +0.000007] BTRFS error (device sda4): failed to read block groups: -5
> [  +0.038021] BTRFS error (device sda4): open_ctree failed
>
> I've tried:
> btrfs check /dev/sda4
>
> but:
> ERROR: cannot open file system
>
> I've also tried:
> btrfs inspect-internal dump-tree -b 75150311424
>
> Result:
> btrfs-progs v4.15.1
> node 75150311424 level 1 items 249 free 244 generation 2488741 owner 2
> fs uuid be557007-42c9-4079-be16-568997e94cd9
> chunk uuid dbe69c7e-2d50-4001-af31-148c5475b48b
>      key (13276114944 EXTENT_ITEM 4096) block 74355359744 (4538291) gen 2392964
>      key (13279277056 EXTENT_ITEM 4096) block 775307264 (47321) gen 2484930
>      key (13286531072 EXTENT_ITEM 4096) block 74792714240 (4564985) gen 2392814
> ...
> (slots 244-248)
>      key (14811271168 EXTENT_ITEM 135168) block 656310272 (40058) gen 2488049
>      key (1505328190277054464 UNKNOWN.4 366981796979539968) block 0 (0) gen 0
>      key (0 UNKNOWN.0 1419267647995904) block 6468220747776 (394788864)
> gen 7786775707648
>      key (12884901888 EXTENT_ITEM 24576) block 816693248 (49847) gen 2484931
>      key (14902849536 EXTENT_ITEM 131072) block 75150327808 (4586812) gen 2488741
>
>
> Is there a way to repair slots 245-247 from some other data (located elsewhere)?
>
> Thanx
> TM
>
> --
>
>    Tomáš Metelka
>    Business & IT Analyst
>
>    Tel: +420 728 627 252
>    Email: tomas.metelka@metaliza.cz

