Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEA1C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 22:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57542176F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 22:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="ODHOL+66"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfBRW6L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 17:58:11 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21402 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfBRW6K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 17:58:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550530687; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=fjcW2V9SkADbnUQsDTVUWiYmd1xVj5A2JepeCna2zGBNfU/UosScFVInPgDlVAjSGSPMJUmJ/BHOY4kptNZns/4N+dWuAzcQQrp1g6+k1XDWOta4XqTLsIurCVsWt9cuTly288E88swQ2StdzNJ1NumRkhrorBcvqsihqz7TfH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550530687; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=rbOxfZduXKjQ8UfthSHW587G8eH8ODP8+bDqp0Qm1gI=; 
        b=C+8mstldc0w3dhRy2EJxhytGjhhxY2obz0+RZcFFVrxffVmd01knUHBrqNaczNCUCD7TvKfVQexm02ZNcP9dADb8m2F94MQXVLmz17/CZX99HGawipT6bI01xR+517yq4twWYw5+Lv+VYjTlNgNM27Qp6jv0P7/AnyJQ5PmmGMI=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550530687;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=2397; bh=rbOxfZduXKjQ8UfthSHW587G8eH8ODP8+bDqp0Qm1gI=;
        b=ODHOL+66enj7+qBWW+y17OcaTRJ0L5/fgBbyMAmE6u6ydJDr3VTpFozykkmbJzVl
        Hryqy4bPsF07sZCjWt5o0o5ndzwbjC2ou6+xUATVo6zdohEBOiawHbPJNC+H/yQDt/S
        Dl8UdMk1POFwiY0CSdGmOwBo0osdlYpMZW3E1Ok8=
Received: from [192.168.0.4] (c83-248-74-133.bredband.comhem.se [83.248.74.133]) by mx.zoho.eu
        with SMTPS id 1550530685421835.0053443267143; Mon, 18 Feb 2019 23:58:05 +0100 (CET)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
 <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org>
 <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org>
 <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org>
 <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org>
Date:   Mon, 18 Feb 2019 23:58:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Ok, but I don't want to keep old snapshots of the child volumes. Only=20
the latest and then diffing it in regards to the master. Would that be=20
possible?

On 2019-02-18 23:28, Chris Murphy wrote:
> On Mon, Feb 18, 2019 at 2:36 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>> The reason why I'm using reflinks instead of snapshots is because the
>> master subvolume is large and will contain hundreds of gigabytes worth
>> of data. Now if I change / remove, say 10 GB worth of data from the
>> master subvolume unrelated to the child subvolume I don't want those
>> gigabytes sent down the wire with btrfs send as they are unrelated. Also
>> I want to be able to after time, when required, add more data from the
>> master subvolume to the child. Thats why I can't split the master
>> subvolume into parts of related data.
> OK, is it your plan to have both master and child on the destination
> Btrfs? So you plan to do a 'btrfs send' without -p option to send the
> entire master subvolume (snapshot) to destination first? And then you
> want to create the child efficiently using a difference between master
> and child? Yes I think that might work but I haven't tried it. But of
> course, master must already be on the destination.
>
> btrfs sub create master
> ##populate the master
> btrfs sub create childofmaster
> cp --reflink master/bunchoffiles childofmaster/
> btrfs sub snap -r master master.20190218-initial
> btrfs sub snap -r childofmaster childofmaster.20190218-initial
> btrfs send master.20190218-initial | btrfs receive /destination/
> btrfs send -p master.20190218-initial childofmaster.20190218-initial |
> btrfs receive /destination/
>
> However your subsequent incremental send/receive has nothing to do
> with master anymore; you indicate above you don't intent to keep
> master up to date on the destination. Just child. In that case the
> incremental changes look like this:
>
> cp --reflink master/morefiles childofmaster/
> btrfs sub snap -r childofmaster childofmaster.20190218T1905
> btrfs send child -p childofmaster.20190218-initial
> childofmaster.20190218T1905 | btrfs receive /destination/
> cp --reflink master/yetmorefiles childofmaster/
> btrfs sub snap -r childofmaster childofmaster.20190219T1301
> btrfs send child  childofmaster.20190218T1905
> childofmaster.20190218T1905  | btrfs receive /destination/
>
>


