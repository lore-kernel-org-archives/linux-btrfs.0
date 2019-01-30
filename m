Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A435FC169C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 01:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C3C621473
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 01:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CC6Pbz1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfA3Blc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 20:41:32 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:45723 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfA3Blc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 20:41:32 -0500
Received: by mail-pf1-f178.google.com with SMTP id g62so10593042pfd.12
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 17:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8rjIJwakH+T4vvqNAn0HE6YOgUCqkGfyzmK585IKX3A=;
        b=CC6Pbz1A/KlzSxaeWiW92TYQQxqMtnd9wpJg/fWveBtrmR27Xp41fUoYB2eVxTErdQ
         KZvGENmpLDybzspro9m6uBxSkDL7qGb3HKMdDqILSIfDLsaEawePDHxYHn8Ubv9EzNzG
         TwxurRTiic5EZwO85fk9suO/B703W8uOhZgzu7Z7/EyMBBEEx9UPRoYmSUxMfw3jyc1A
         rUiXQejur54KUUHUK+IyBNCBpNNSK3QDLfWxjove3kyELU/0mdrtzNpkWLpOAcBiXD79
         EBCc5VXcsvS0Cpa+/sn4Dc0JmB94hm7sLtg78Db3NY3VSZi9Q3BuYkdkO8vfK/m5rFZq
         15Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8rjIJwakH+T4vvqNAn0HE6YOgUCqkGfyzmK585IKX3A=;
        b=Z5t2JRb7ZCp3EZzmT0DTPeYrj5GN5vJyw/Pjn4YPB077uehw84sQJuoFIhbHiXp1dR
         hhUMCnORAPlgNNSLKvehuVBHGHu9iwo4WNUyItnWNJfqSDxGvpMxJmXO0pHBqPClXIDh
         W9TsOyu11exTqnt0PjVVAlqw7Wnwvs28gQ4XpkYaD5z6zhwbaP+X5gUYsG38Enlzmooh
         R+T11T615b2soB+hqCoaQrcM7sVn5jVS+yG32NWEPDGJ7wIyZIVsr9zbs/KDPaQvYuXw
         ylLJeiuze7OiS1OEQ4oLtAuK1YpVQCAiZR6ZNJbYdr+DSslc/7IAfpTf8iaVgfZypOzx
         ROQA==
X-Gm-Message-State: AHQUAuZvN7UOcfjABtnlFpNSl8PVu1OuBNIMUGuneyjbfU3cBGuoIJD0
        Bfrt8BVN/mr8b5ZuHxL+PNg=
X-Google-Smtp-Source: AHgI3IY97kDW5gz2Or2aP7fKMc2DWbd6H1wp2EkrLZ4Axzq3sgen8iNNvj/SY2hIC3N+x/6ardt6Cw==
X-Received: by 2002:a62:22c9:: with SMTP id p70mr41743pfj.114.1548812491500;
        Tue, 29 Jan 2019 17:41:31 -0800 (PST)
Received: from [192.168.178.53] (14-201-16-168.static.tpgi.com.au. [14.201.16.168])
        by smtp.gmail.com with ESMTPSA id b10sm54967pfj.183.2019.01.29.17.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 17:41:31 -0800 (PST)
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     kreijack@inwind.it, Chris Murphy <lists@colorremedies.com>,
        Remi Gauvin <remi@georgianit.com>
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
 <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
 <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
 <80f46e68-4cda-3a22-385b-0ab0a47b079a@libero.it>
From:   DanglingPointer <danglingpointerexception@gmail.com>
Message-ID: <d3de555c-3e44-533d-5ae2-88a5abaf0401@gmail.com>
Date:   Wed, 30 Jan 2019 12:41:27 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <80f46e68-4cda-3a22-385b-0ab0a47b079a@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-AU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Going back to my original email, would the BTRFS wiki admins consider a 
better more reflective update of the RAID56 status page?

It still states "multiple serious data-loss bugs" which as Qu Wenruo has 
already clarified is not the case.  The only "bug" left is the write 
hole edge-case problem.


On 30/1/19 6:47 am, Goffredo Baroncelli wrote:
> On 29/01/2019 20.02, Chris Murphy wrote:
>> On Mon, Jan 28, 2019 at 3:52 PM Remi Gauvin <remi@georgianit.com> wrote:
>>> On 2019-01-28 5:07 p.m., DanglingPointer wrote:
>>>
>>>>  From Qu's statement and perspective, there's no difference to other
>>>> non-BTRFS software RAID56's out there that are marked as stable (except
>>>> ZFS).
>>>> Also there are no "multiple serious data-loss bugs".
>>>> Please do consider my proposal as it will decrease the amount of
>>>> incorrect paranoia that exists in the community.
>>>> As long as the Wiki properly mentions the current state with the options
>>>> for mitigation; like backup power and perhaps RAID1 for metadata or
>>>> anything else you believe as appropriate.
>>> Should implement some way to automatically scrub on unclean shutdown.
>>> BTRFS is the only (to my knowlege) Raid implementation that will not
>>> automatically detect an unclean shutdown and fix the affected parity
>>> blocks, (either by some form of write journal/write intent map, or full
>>> resync.)
>> There's no dirty bit set on mount, and thus no dirty bit to unset on
>> clean mount, from which to infer a dirty unmount if it's present at
>> the next mount.
> It would be sufficient to use the log, which BTRFS already has. During each transaction, when an area is touched by a rwm cycle, it has to tracked in the log.
> In case of unclean shutdown, it is already implemented a way to replay the log. So it would be sufficient to track a scrub of these area as "log replay".
>
> Of course I am talking as not a BTRFS developers, so the reality could be more complex: e.g. I don't know how it would be easy to raise a scrub process on per area basis.
>
> BR
> G.Baroncelli
>
>
>
