Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35545 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbbJZOip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 10:38:45 -0400
Received: by pasz6 with SMTP id z6so190304141pas.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 07:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562E37F4.9080602@oracle.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 26 Oct 2015 15:38:25 +0100
Message-ID: <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply. What version did this go into? I'll try getting
a prebuilt backport of the kernel, building source could slow things
down considerably, but debs will not be available for the latest few
minor versions I guess. So if you can tell me a min version, I'll try
to find the latest deb newer than that, or I'll build if that's not
available.

On Mon, Oct 26, 2015 at 3:25 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On 10/26/2015 08:16 PM, cheater00 . wrote:
>>
>> Hi guys,
>> I am running into really bad performance. Here's my setup:
>>
>> WD Red 6 TB connected over USB2 to my core i7 laptop, running Ubuntu
>> 32-bit with kernel 4.0.4-040004-generic #201505171336.
>>
>> Single btrfs partition covering whole disk.
>>
>> Autodefrag is on.
>>
>> fstab line:
>> UUID=... /media/X btrfs rw,nosuid,nodev,autodefrag 0 0
>>
>> Sometimes when files are being modified or removed, I see
>> btrfs-transacti eat 100% cpu; during this time no io operations
>> succeed, that is, they're all stalled. You can't even ls on that fs.
>> This happens for several minutes then normal operation resumes. There
>> doesn't seem to be a rule to what will trigger this, other than
>> opening a single file and reading usually works quite well. (say,
>> watching a movie while all other programs are closed). But even moving
>> files off the disks triggers some sort of bug. Just now I am moving a
>> few files (just 30gb worth) onto another disk, and the bug triggers.
>> So btrfs-transacti was eating my cpu for over 5 minutes and according
>> to mv's output after this was done and cpu usage went back to normal
>> what I was waiting for was for a tiny png file to be removed. This is
>> pretty bad.
>>
>> I have tried defragmenting directories where files are being accessed
>> and moved. This hasn't helped.
>>
>> This happens whether the FS is near full or not. It currently is near
>> full but it wasn't before and it still did that. It still has about ~
>> 100GB free space now.
>>
>> The more things are happening the more often this bug gets triggered.
>> So if I have utorrent running and its temporary downloads directory is
>> there, its download speed graph will be a few spikes of running at
>> several MB/sec separated by durations of 0 download speed.
>>
>> Nothing seems to show up in dmesg or syslog.
>>
>> I have asked in #btrfs but the suggestions ended up not fixing the
>> issue (autodefrag, defrag dirs).
>>
>> Please advise what I should do with this issue.
>
>
> It might be related to delayed ref rework, the last time I saw this kind of
> hanging problem about btrfs-transaction eating cpu is that because btrfs
> doesn't merge delayed refs, it'd be best to try the lastest kernel and if
> the issue is not resolved, then we can work out a reproducer and provide
> debugging.
>
> Thanks,
>
> Liubo
