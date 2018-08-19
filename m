Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f52.google.com ([209.85.167.52]:44162 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbeHSNgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Aug 2018 09:36:49 -0400
Received: by mail-lf1-f52.google.com with SMTP id g6-v6so8815429lfb.11
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Aug 2018 03:25:49 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: =?utf-8?Q?Re:_lazytime_mount_option=E2=80=94no_support_in_Btrfs?=
From: Andrei Borzenkov <arvidjaar@gmail.com>
In-Reply-To: <2641568.fxl50hTsRH@merkaba>
Date: Sun, 19 Aug 2018 13:25:46 +0300
Cc: waxhead@dirtcellar.net, Adam Hunt <voxadam@gmail.com>,
        linux-btrfs@vger.kernel.org
Message-Id: <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
References: <ompef3$sim$1@blaine.gmane.org> <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net> <2641568.fxl50hTsRH@merkaba>
To: Martin Steigerwald <martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Отправлено с iPhone

> 19 авг. 2018 г., в 11:37, Martin Steigerwald <martin@lichtvoll.de> написал(а):
> 
> waxhead - 18.08.18, 22:45:
>> Adam Hunt wrote:
>>> Back in 2014 Ted Tso introduced the lazytime mount option for ext4
>>> and shortly thereafter a more generic VFS implementation which was
>>> then merged into mainline. His early patches included support for
>>> Btrfs but those changes were removed prior to the feature being
>>> merged. His> 
>>> changelog includes the following note about the removal:
>>>   - Per Christoph's suggestion, drop support for btrfs and xfs for
>>>   now,
>>> 
>>>     issues with how btrfs and xfs handle dirty inode tracking.  We
>>>     can add btrfs and xfs support back later or at the end of this
>>>     series if we want to revisit this decision.
>>> 
>>> My reading of the current mainline shows that Btrfs still lacks any
>>> support for lazytime. Has any thought been given to adding support
>>> for lazytime to Btrfs?
> […]
>> Is there any new regarding this?
> 
> I´d like to know whether there is any news about this as well.
> 
> If I understand it correctly this could even help BTRFS performance a 
> lot cause it is COW´ing metadata.
> 

I do not see how btrfs can support it exactly due to cow. Modified atime means checksum no more matches so you must update all related metadata. At which point you have kind of shadow in-memory metadata trees. And if this metadata is not written out, then some other metadata that refers to them becomes invalid.

I suspect any file system that keeps checksums of metadata will run into the same issue.
