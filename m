Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34836 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbbIQPmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 11:42:47 -0400
Received: by vkao3 with SMTP id o3so13270767vka.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 08:42:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FAD9CC.5060206@oracle.com>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
Date: Thu, 17 Sep 2015 09:42:46 -0600
Message-ID: <CAJCQCtScT-tTGapGX1vdgQ7f5hgPrYkBWkOiepxKj8t7zWT27g@mail.gmail.com>
Subject: Re: RAID1 storage server won't boot with one disk missing
From: Chris Murphy <lists@colorremedies.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: "erpo41@gmail.com" <erpo41@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2015 at 9:18 AM, Anand Jain <anand.jain@oracle.com> wrote:
>
>  as of now it would/should start normally only when there is an entry -o
> degraded
>
>  it looks like -o degraded is going to be a very obvious feature,
>  I have plans of making it a default feature, and provide -o
>  nodegraded feature instead. Thanks for comments if any.


If degraded mounts happen by default, what happens when dev 1 goes
missing temporarily and dev 2 is mounted degraded,rw and then dev 1
reappears? Is there an automatic way to a.) catch up dev 1 with dev 2?
and then b.) automatically make the array no longer degraded?

I think it's a problem to have automatic degraded mounts when there's
no monitoring or notification system of problems. We can get silent
degraded mounts by default with no notification at all there's a
problem with a Btrfs volume.

So off hand my comment is that I think other work is needed before
degraded mounts is default behavior.



-- 
Chris Murphy
