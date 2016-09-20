Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35749 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbcITHgo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 03:36:44 -0400
Received: by mail-io0-f173.google.com with SMTP id m186so11587403ioa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 00:36:43 -0700 (PDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com. [209.85.223.182])
        by smtp.gmail.com with ESMTPSA id u76sm9701795ita.15.2016.09.20.00.36.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2016 00:36:42 -0700 (PDT)
Received: by mail-io0-f182.google.com with SMTP id m79so11546465ioo.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 00:36:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJFSNy5eOdkn=YSA1-T7goOUNuX6ozUiGAM3tCTq7dvzsiJCug@mail.gmail.com>
References: <b369cabe-9269-800c-cce7-5f5c71147660@fb.com> <1473233938-21560-1-git-send-email-kernel@kyup.com>
 <20160919181315.GS16983@twin.jikos.cz> <2c9c27c6-5e2d-5035-de11-0cf021dfd9a1@fb.com>
 <CAJFSNy5eOdkn=YSA1-T7goOUNuX6ozUiGAM3tCTq7dvzsiJCug@mail.gmail.com>
From: Nikolay Borisov <kernel@kyup.com>
Date: Tue, 20 Sep 2016 10:36:42 +0300
Message-ID: <CAJFSNy7MRLvg6u7c-rbXBR-Mp3vFaW+bq7O+gbEY7q4YfO8uAw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix handling of -ENOENT from btrfs_uuid_iter_rem
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Resend due to gmail mobile interface defaulting to html layout]
>>
>> We know its returning -ENOENT, so it should in theory be enough to just
>> goto again_search_slot, assuming that we just raced with the deletion.
>
>
> I will apply this on the machine which are exhibitting problems and will
> report whether it rectified the situation. i bump the objectid wince this is
> what you suggested. i can also try without it.
>>
>>
>> -chris
