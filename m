Return-Path: <SRS0=hmSb=RG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB92CC43381
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Mar 2019 12:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B70120836
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Mar 2019 12:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="lf+DD2cY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfCCMOO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 Mar 2019 07:14:14 -0500
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:57812 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726054AbfCCMON (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2019 07:14:13 -0500
Received: from [10.155.21.225] (unknown [92.184.116.87])
        by box.speed47.net (Postfix) with ESMTPSA id 86358BD0
        for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2019 13:14:10 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=lesimple.fr; s=mail01;
        t=1551615250; bh=/Vm97uH5vEeEb2n2fxQ2mXVWW4uJEi+I+PE/dql3Ako=;
        h=From:To:Date:In-Reply-To:References:Subject;
        b=lf+DD2cYxb82JQ0/eSoAko6+81undGpbajNiuwSBeBUv53d2TCai5/6iDiNoarjAy
         ZnhOFmgqY1FJW02NsTkcxPry8sVQG+sd0Oac2Cw2XPiUssIhty5oWhJ57Adg05whvf
         6q4bKa8OEfHqVLUnUFNf19PUAG0hFipOJKkyILZc=
From:   =?UTF-8?B?U3TDqXBoYW5lIExlc2ltcGxl?= <stephane_btrfs@lesimple.fr>
To:     <linux-btrfs@vger.kernel.org>
Date:   Sun, 03 Mar 2019 13:14:08 +0100
Message-ID: <1694379c680.2787.faeb54a6cf393cf366ff7c8c6259040e@lesimple.fr>
In-Reply-To: <50cc3b27-e780-6c94-1602-2970b1a867eb@gmail.com>
References: <535a7ce9be6696815eb4413fd0f2ed17@lesimple.fr>
 <50cc3b27-e780-6c94-1602-2970b1a867eb@gmail.com>
User-Agent: AquaMail/1.18.2-1413 (build: 101800200)
Subject: Re: Announcing the btrfs-list tool
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Le 2 mars 2019 21:28:29 Andrei Borzenkov <arvidjaar@gmail.com> a écrit :

> 02.03.2019 22:06, Stéphane Lesimple пишет:
>> Hi!
>>
>> I've been using btrfs as my main NAS filesystem for a bunch of years
>> now, and I always found that managing dozens of subvolumes having dozens
>> of snapshots each was not really straightforward, especially when trying
>> to get an overview of "what's taking space on my filesystem". I was
>> missing the niceness of the "zfs list" command, which does that quite well.
>>
>> So I've started to write a wrapper around btrfs qgroup show and btrfs fi
>> df (then btrfs fi usage when it got out), to implement this broad
>> overview of my filesystem I was missing so much.
>> Adding some features along the way, I thought that after all it might
>> also be useful to others than me!
>>
>> As stdout is better than a thousand words, here's for example how it can
>> show you a complex hierarchy of intricated snapshots:
>>
>> root@nas:~# btrfs-list /mnt/a
>> NAME                                       TYPE     REFER      USED
>> MOUNTPOINT
>> 4582dacf                                     fs         -     0.00
>> (1002.88M free)
>>   [main]                               mainvol    16.00k    16.00k /mnt/a
>>   sub1                                  subvol    16.00k    16.00k
>>      sub1/.snap1                          snap    16.00k    16.00k
>>      sub1/.snap2                          snap    16.00k    16.00k
>>      sub1/subsub1                         snap    16.00k    16.00k
>>         sub1/subsub1/.snap3               snap    16.00k    16.00k
>>         sub1/subsub1/subsubsub1           snap    16.00k    16.00k
>>            sub1/subsub1/subsubsubsub1     snap    16.00k    16.00k
>
> btrfs does not have anything resembling USED in zfs, so I'm afraid this
> will be confusing to anyone coming from zfs. In zfs datasets are
> hierarchical (including snapshots) so USED on every level is exactly the
> amount of space that will become available in parent dataset if this one
> is destroyed. This does not matter much without quota (as all datasets
> share one common pool of free space) but becomes quite visible as soon
> as you restrict dataset space consumption. In btrfs every subvolume is
> independent; what you show as USED is exclusive space; deleting
> subvolume does not mean its exclusively consumed space will be now
> accounted as available in another subvolume.
>
> Showing hierarchical list with USED column creates false expectations;
> I'd rather call it EXCL to make its meaning clear.

You're right. I personally just use the quota feature to track the readonly 
snapshots that I use as backups, hence I have only the auto-generated 0/ 
level qgroups on my filesystem.

As USED could be confusing in more complex setups I've replaced this 
terminology by EXCL as you mentioned, and adjusted the help text 
accordingly. Thanks!


>
>
> That said, tool that lists qgroups with volume names is surely welcome.
>
>> Or how it can help you find big snapshots that you might want to get rid
>> of if you're running out of space:
>>
>> root@nas:~# btrfs-list --snap-min-used 4G --snap-only /tank
>> NAME                                                          TYPE
>> REFER      USED MOUNTPOINT
>>      backups/.snaps/skyline/20130213_231649_lastskyline    rosnap
>> 22.52G    19.58G
>>      backups/.snaps/box/20171231_221207_monthly.12         rosnap
>> 88.73G     4.96G
>>      backups/.snaps/box/20180130_221209_monthly.11         rosnap
>> 91.25G     4.90G
>>      backups/.snaps/box/20180307_154215_monthly.10         rosnap
>> 96.28G    10.72G
>>      backups/.snaps/box/20190120_193004_weekly.3           rosnap
>> 56.45G     4.25G
>>      backups/.snaps/nasroot/20180122_091325_monthly.12     rosnap
>> 34.65G    10.79G
>>      backups/.snaps/nasroot/20180221_092311_monthly.11     rosnap
>> 31.96G     4.98G
>>      backups/.snaps/nasroot/20180323_092734_monthly.10     rosnap
>> 33.69G     7.05G
>>      backups/.snaps/nasroot/20180820_205559_monthly.5      rosnap
>> 31.74G     5.37G
>>      .syncthing-bkp                                        rosnap
>> 40.48G     8.15G
>>
>> Want to give it a try? Here you are:
>> https://github.com/speed47/btrfs-list
>>
>> There are a couple snapshots there too, to give you a rough idea of how
>> it looks like (yes, it also has nice colors)
>>
>> Happy btrfs weekend!



