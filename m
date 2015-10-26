Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33139 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbbJZN4c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 09:56:32 -0400
Received: by pacfa8 with SMTP id fa8so10429680pac.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 06:56:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUjgdpzNn1U6LGuNPcGefVnVt-FRbNMN3e-bCm_QNxvnFg@mail.gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <CAC=t97AxEpbE0iWc4dq-8-5ZEe==bnwmufi8TfW7n6669YUkCw@mail.gmail.com>
 <CA+9GZUja+36PfVrS+DuzeJdrYfCMgQQoSzw0Dt3PPpGz2Qywgg@mail.gmail.com>
 <CAC=t97DNfiBqA+evAH+wPt21VOdfEn7SF71FCBVZfjpphtTvmg@mail.gmail.com> <CA+9GZUjgdpzNn1U6LGuNPcGefVnVt-FRbNMN3e-bCm_QNxvnFg@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 26 Oct 2015 14:56:12 +0100
Message-ID: <CA+9GZUgN1Av6mDt3MXGJ8CD8uLayO=T6biTzUd0m9vm4VCVVMw@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fwiw, I did this:

sudo btrfs qgroup show /media/X
ERROR: can't perform the search - No such file or directory
ERROR: can't list qgroups: No such file or directory

I assume this means no qgroups present, which means no quotas present.
Please correct me if I'm wrong.
So yes, the issue must lie elsewhere.

On Mon, Oct 26, 2015 at 2:46 PM, cheater00 . <cheater00@gmail.com> wrote:
> I don't remember doing that, but just to exclude everything, how do I check?
>
> On Mon, Oct 26, 2015 at 2:45 PM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>> AFAIK quotas aren't a mount option, but if you never enabled them and
>> created the qgroups by hand that's your answer and the issue must be
>> something else.
>>
>> On Mon, Oct 26, 2015 at 8:36 AM, cheater00 . <cheater00@gmail.com> wrote:
>>> There are no quotas. I haven't enabled them. I believe the fstab says
>>> that - could they be enabled in another way? How do I check for sure?
>>> The man page doesn't say how to check the status:
>>> https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-quota
>>>
>>> On Mon, Oct 26, 2015 at 2:32 PM, Donald Pearson
>>> <donaldwhpearson@gmail.com> wrote:
>>>> Accidentally didn't reply to the list the 1st time.
>>>>
>>>> I see the same issue when I have quotas enabled.  If you have quotas
>>>> on, see if turning them off helps.
>>>>
>>>> On Mon, Oct 26, 2015 at 7:16 AM, cheater00 . <cheater00@gmail.com> wrote:
>>>>> Hi guys,
>>>>> I am running into really bad performance. Here's my setup:
>>>>>
>>>>> WD Red 6 TB connected over USB2 to my core i7 laptop, running Ubuntu
>>>>> 32-bit with kernel 4.0.4-040004-generic #201505171336.
>>>>>
>>>>> Single btrfs partition covering whole disk.
>>>>>
>>>>> Autodefrag is on.
>>>>>
>>>>> fstab line:
>>>>> UUID=... /media/X btrfs rw,nosuid,nodev,autodefrag 0 0
>>>>>
>>>>> Sometimes when files are being modified or removed, I see
>>>>> btrfs-transacti eat 100% cpu; during this time no io operations
>>>>> succeed, that is, they're all stalled. You can't even ls on that fs.
>>>>> This happens for several minutes then normal operation resumes. There
>>>>> doesn't seem to be a rule to what will trigger this, other than
>>>>> opening a single file and reading usually works quite well. (say,
>>>>> watching a movie while all other programs are closed). But even moving
>>>>> files off the disks triggers some sort of bug. Just now I am moving a
>>>>> few files (just 30gb worth) onto another disk, and the bug triggers.
>>>>> So btrfs-transacti was eating my cpu for over 5 minutes and according
>>>>> to mv's output after this was done and cpu usage went back to normal
>>>>> what I was waiting for was for a tiny png file to be removed. This is
>>>>> pretty bad.
>>>>>
>>>>> I have tried defragmenting directories where files are being accessed
>>>>> and moved. This hasn't helped.
>>>>>
>>>>> This happens whether the FS is near full or not. It currently is near
>>>>> full but it wasn't before and it still did that. It still has about ~
>>>>> 100GB free space now.
>>>>>
>>>>> The more things are happening the more often this bug gets triggered.
>>>>> So if I have utorrent running and its temporary downloads directory is
>>>>> there, its download speed graph will be a few spikes of running at
>>>>> several MB/sec separated by durations of 0 download speed.
>>>>>
>>>>> Nothing seems to show up in dmesg or syslog.
>>>>>
>>>>> I have asked in #btrfs but the suggestions ended up not fixing the
>>>>> issue (autodefrag, defrag dirs).
>>>>>
>>>>> Please advise what I should do with this issue.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
