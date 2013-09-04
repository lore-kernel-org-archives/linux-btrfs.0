Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46874 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab3IDO0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 10:26:39 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so382369pdj.8
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 07:26:39 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Btrfs prog
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <A3E04520-431C-4040-A0E8-33752343B110@colorremedies.com>
Date: Wed, 4 Sep 2013 22:26:34 +0800
Cc: Giuseppe Fierro <giuseppe@fierro.org>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Message-Id: <54476549-52EA-4375-8683-06A3CCE40393@gmail.com>
References: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com> <20130904133207.GC6389@carfax.org.uk> <CAN3gubnrbEWaiJf1VFATgAX+p9btGTDX916BLEmJZG5yt_HA-Q@mail.gmail.com> <A3E04520-431C-4040-A0E8-33752343B110@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


ÔÚ 2013-9-4£¬ÏÂÎç10:10£¬Chris Murphy <lists@colorremedies.com> Ð´µÀ£º

> 
> On Sep 4, 2013, at 3:51 PM, Giuseppe Fierro <giuseppe@fierro.org> wrote:
> 
>> Thanks,
>> as I can see I misunderstood the meaning of "btrfs filesystem df" I
>> was expecting that the 'df' has been to display free space remaining.
> 
> Check the archives, this is a long running issue that no one has particularly great answers for because what free space remains depends on future (unknown) usage of the file system. But I still think it's a worse problem to not report anything at all in btrfs fi df, considering the historical point of df is to show space available. And it's also not good that the regular df shows e.g. for raid1, twice the free space as the amount of data that can be saved to the volume.
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

