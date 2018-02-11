Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:38857 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbeBKHI2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Feb 2018 02:08:28 -0500
Received: by mail-lf0-f44.google.com with SMTP id g72so16487596lfg.5
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Feb 2018 23:08:27 -0800 (PST)
Subject: Re: IO Error (.snapshots is not a btrfs subvolume)
To: Nick Gilmour <nickeforos@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAH-droxO-K9RM9uCLie=6bg3cgC5uqo_wcscc0BmB9HyKM5gQQ@mail.gmail.com>
 <CAJCQCtTqJQkLmsowxun7YuRsy4MkN9A4iO5LVwp3tO_6G=LqNQ@mail.gmail.com>
 <ea8e5fd1-25f4-0f26-14eb-8aeb9de2fb86@gmail.com>
 <CAH-drozv-pgkrreOduoDUvS8ct0_BjHEwLBvQ9be3atnRpfZTw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <2bc46917-7504-2c05-834d-a88db438382d@gmail.com>
Date: Sun, 11 Feb 2018 10:08:24 +0300
MIME-Version: 1.0
In-Reply-To: <CAH-drozv-pgkrreOduoDUvS8ct0_BjHEwLBvQ9be3atnRpfZTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

08.02.2018 18:43, Nick Gilmour пишет:
> On Thu, Feb 8, 2018 at 5:32 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> 08.02.2018 06:03, Chris Murphy пишет:
>>> On Wed, Feb 7, 2018 at 6:26 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
>>>> Hi all,
>>>>
>>>> I have successfully restored a snapshot of root but now when I try to
>>
...
> 
>> How exactly was it done?
> 1. # mount /dev/sde6 /mnt
> 2. # cd /mnt
> 3. # mv @ @_old
> 4. # btrfs subvol snapshot /mnt/@_old/.snapshots/1594/snapshot /mnt/@
> 

That's wrong for openSUSE. When you have installation with snapshots
enabled, @ is dummy subvolume that never holds actual content.

>> No, you should create subvolume @/.snapshots and mount it as /.snapshots
>> (and have it in /etc/fstab). Snapshots should always be available in
>> running system under fixed path and this only possible when it is
>> mounted, otherwise after rollback /.snapshots will be lost just like it
>> happened now.
> 
> When I run this command I get an error:
> # btrfs subvolume create @/.snapshots
> ERROR: cannot access '@': No such file or directory
> 

You have to give it path on mounted btrfs filesystem of course.

> but when I'm doing this:
> # btrfs subvolume create /.snapshots
> Create subvolume '//.snapshots'
> it works
> 
> and this is what I see in the subvolumes list:
> ID 3541 gen 175955 parent 3540 top level 3540 path .snapshots
> 

Without actual command that shows where you look it does not provide
much useful information.

> and then I can create a snapshot with snapper:
> # snapper -c root create --description "test"
> 
> but snapper starts numbering from 1 again which I don't really like. I
> would like to keep the previous snapshots and continue the numbering
> after the last restored snapshot (1594).
> 

openSUSE offers native support for reverting to previous root snapshot
while keeping all existing snapper snapshots. May be you should look at
it instead of reinventing the wheel?
