Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FAFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DEEE2177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sheepa.org header.i=admin@sheepa.org header.b="FbEaY3gU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfBRVg6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:36:58 -0500
Received: from sender-of-o52.zoho.eu ([185.20.209.248]:21407 "EHLO
        sender-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfBRVg6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 16:36:58 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550525814; cv=none; 
        d=zoho.eu; s=zohoarc; 
        b=NdhIzBEHrbR9YMQ93UVQH1f5NA5wIsNNxbrQWbQnLWHyBenu6Mp+i2beZHMqfwNB0GmNCWBn++hUhtH970mHH66uz56omspvcpAEAt6ke5yMhLH5rieXMu2atXwOL6WXx8ffkV/THm8VUfpM/T/SpEB5fTMU7qiKr8QaXEVXXLw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.eu; s=zohoarc; 
        t=1550525814; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=ZYnP6t1gjcCeseVwRZ7NMfUxj1c7T0FMJL0Lx/ywh14=; 
        b=L372aZ1vTXMJXNhMlF33sJIB3NHupI4PmdxcxxHeDqq4TKklD5ed73cXzIdtQXBxB1dDwN/EEpW46dpnPA2xsmbM3DEFEy5S7ntlPVwK6CFXgb7pAEHjIEcv31kZGguamVLqJ/bdTwY2UCY0K5NWyeJk56Jz32XkoBqcTE+zvPo=
ARC-Authentication-Results: i=1; mx.zoho.eu;
        dkim=pass  header.i=sheepa.org;
        spf=pass  smtp.mailfrom=admin@sheepa.org;
        dmarc=pass header.from=<admin@sheepa.org> header.from=<admin@sheepa.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1550525814;
        s=mail; d=sheepa.org; i=admin@sheepa.org;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        l=3325; bh=ZYnP6t1gjcCeseVwRZ7NMfUxj1c7T0FMJL0Lx/ywh14=;
        b=FbEaY3gUyT826C9waIOzR/cq66N23Y7iGNV1pFugSZnYcA3DBXUd/wfU5zHJT+Tb
        egoElDeX367IgIDF34O3M1cmttoKh1DvvHvrYQoxVZk19FJInjjMl8Ji+lpb/7bR8Z6
        88rZCLHzAdzufI+de28G8kXCjjTrTp5/xDlz8xPk=
Received: from [192.168.0.4] (c83-248-74-133.bredband.comhem.se [83.248.74.133]) by mx.zoho.eu
        with SMTPS id 15505258124691000.3424229898636; Mon, 18 Feb 2019 22:36:52 +0100 (CET)
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
From:   =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Message-ID: <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org>
Date:   Mon, 18 Feb 2019 22:36:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The reason why I'm using reflinks instead of snapshots is because the=20
master subvolume is large and will contain hundreds of gigabytes worth=20
of data. Now if I change / remove, say 10 GB worth of data from the=20
master subvolume unrelated to the child subvolume I don't want those=20
gigabytes sent down the wire with btrfs send as they are unrelated. Also=20
I want to be able to after time, when required, add more data from the=20
master subvolume to the child. Thats why I can't split the master=20
subvolume into parts of related data.

On 2019-02-18 22:22, Chris Murphy wrote:
> On Mon, Feb 18, 2019 at 12:58 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote=
:
>
>> Basically what I'm trying to achieve is having a "reference" / "master"
>> btrfs subvolume where i add / edit / remove files continuously. From
>> where i can cp --reflink=3Dalways some of those files to new "child"
>> subvolumes as needed. As long as the files are still in the master
>> subvolume I'll only send the diff of the data. The plan is to have this
>> master subvolume across multiple remote machines (synced with rsync or
>> perhaps btrfs send / receive) and being able to update / change it as
>> needed but always only sending the diffs of the child subvolumes. Maybe
>> this is a bit optimistic.
> I'm not sure what you get out of this method that depends on reflink
> rather than just making read only snapshots.
>
> Why don't you create subvolume A as the master, read-write. And once
> it's in the "master state" you want, just snapshot it:
>
> btrfs sub snap -r A A.20190218-master
>
> And now continue to make changes to A subvolume, and on whatever
> schedule you want:
>
> btrfs sub snap -r A A.20190218-1412
> btrfs sub snap -r A A.20190218-1850
> btrfs sub snap -r A A.20190219-0920
>
> And now you can "compare" the difference to master at anytime:
>
> btrfs send -p A.20190218-master A.20190218-1850 -f output (or pipe to rec=
eive)
>
> *shrug* I'm just not understanding what your use case gains out of
> doing a refink copy to another subvolume rather than just make a read
> only snapshot.
>
> Is it that subvolume A must accept changes, but itself cannot be the
> "master"? And you're selectively reflink copying files from A to B
> such that B is the only "master"? That's fine but then I'd say you
> don't need any A snapshots, you need B snapshots where:
>
> btrfs sub snap -r B B.20190218-master
> btrfs sub snap -r B B.20190219-0920
> btrfs send -p B.20190218-master B.20190219-0920 -f output (or pipe to rec=
eive)
>
> And so on...
>
> Anyway, my point isn't that you're doing it wrong. I'm jut not
> understanding the advantage of doing it the way you're doing it; and
> it should be clear by now that most people on the list aren't using
> 'btrfs send' to compute the difference between two otherwise unrelated
> subvolumes.
>
> Part of this *might* be because of how ZFS snapshots work, and Btrfs
> users maybe just adopted the same logic due in large part to more
> limitations on the ZFS implementation: snapshots are always read only,
> incremental send is only done between snapshots of the same dataset,
> datasets can't be deleted  until all snapshots are deleted, there are
> no reflinks, and no doubt some things I'm forgetting.
>
>


