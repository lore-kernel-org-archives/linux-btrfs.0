Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f51.google.com ([209.85.208.51]:45730 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbeHKIT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 04:19:56 -0400
Received: by mail-ed1-f51.google.com with SMTP id s16-v6so5739601edq.12
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 22:46:55 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <f66b8ff3-d7ec-31ad-e9ca-e09c9eb76474@gmail.com>
 <20180810073340.GB5473@polanet.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <a9e96e78-c066-b8f4-2bae-514e26ec306d@gmail.com>
Date: Sat, 11 Aug 2018 08:46:52 +0300
MIME-Version: 1.0
In-Reply-To: <20180810073340.GB5473@polanet.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.08.2018 10:33, Tomasz Pala пишет:
> On Fri, Aug 10, 2018 at 07:03:18 +0300, Andrei Borzenkov wrote:
> 
>>> So - the limit set on any user
>>
>> Does btrfs support per-user quota at all? I am aware only of per-subvolume quotas.
> 
> Well, this is a kind of deceptive word usage in "post-truth" times.
> 
> In this case both "user" and "quota" are not valid...
> - by "user" I ment general word, not unix-user account; such user might
>   possess some container running full-blown guest OS,
> - by "quota" btrfs means - I guess, dataset-quotas?
> 
> 
> In fact: https://btrfs.wiki.kernel.org/index.php/Quota_support
> "Quota support in BTRFS is implemented at a subvolume level by the use of quota groups or qgroup"
> 
> - what the hell is "quota group" and how it differs from qgroup? According to btrfs-quota(8):
> 
> "The quota groups (qgroups) are managed by the subcommand btrfs qgroup(8)"
> 
> - they are the same... just completely different from traditional "quotas".
> 
> 
> My suggestion would be to completely remove the standalone "quota" word
> from btrfs documentation - there is no "quota", just "subvolume quota"
> or "qgroup" supported.
> 

Well, qgroup allows you to limit amount of data that can be stored in
subvolume (or under quota group in general), so it behaves like
traditional quota to me.
