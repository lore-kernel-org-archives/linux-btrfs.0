Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:55176 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbeBWK0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 05:26:53 -0500
Received: by mail-wm0-f52.google.com with SMTP id z81so3695192wmb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 02:26:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180222235704.GK1469@twin.jikos.cz>
References: <bug-1547319-399363@bugzilla.redhat.com> <bug-1547319-399363-GV0megqgjZ@bugzilla.redhat.com>
 <CABB28CwoGbEGNiYdY_SmBJV+REWMWNxL7f8kjM5+S4t--w5-LQ@mail.gmail.com> <20180222235704.GK1469@twin.jikos.cz>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 23 Feb 2018 10:26:51 +0000
Message-ID: <CABB28CxEzxNnC=pT+UzT4kv9vfkO4gc+YzGNWeZdCMrW2T1Lug@mail.gmail.com>
Subject: Re: Fwd: [Bug 1547319] 4.16.0-0.rc1.git4.1.fc28.x86_64 #1 Not
 tainted: possible recursive locking detected
To: dsterba@suse.cz,
        =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 February 2018 at 23:57, David Sterba <dsterba@suse.cz> wrote:
[..]
>> https://bugzilla.redhat.com/show_bug.cgi?id=1547319
>>
>> Laura Abbott <labbott@redhat.com> changed:
>>
>>            What    |Removed                     |Added
>> ----------------------------------------------------------------------------
>>                  CC|                            |labbott@redhat.com
>>
>> --- Comment #1 from Laura Abbott <labbott@redhat.com> ---
>> This is btrfs which is pretty far down on our priority list. This is best
>> reported to the upstream btrfs devs.
>
> Quick and wrong conclusions, it's not a btrfs bug.
>
> The fix:
>
> https://patchwork.kernel.org/patch/10207013/
>
> but I don't see it merged in master branch.

Thank you for the reply :)
I'll keep my ticket opened until it will be merged.

kloczek
-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
