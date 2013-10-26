Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62999 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3JZWu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 18:50:58 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so3451360eek.18
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 15:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEezp7tgtNUmN6BfSEY9+Jc6D6WtZds=GRQ7NK9ScM7OzVod8w@mail.gmail.com>
References: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
	<C5E10710-8D46-44D4-AC38-FB66B9938BB1@colorremedies.com>
	<CAEezp7uaoZow7vjArHq4E+aD9nxTwEFwvd5VrjUUuNcn4-B1cQ@mail.gmail.com>
	<9E910E84-766B-44BB-9EA5-D848016A79D6@colorremedies.com>
	<CAEezp7tgtNUmN6BfSEY9+Jc6D6WtZds=GRQ7NK9ScM7OzVod8w@mail.gmail.com>
Date: Sun, 27 Oct 2013 00:50:57 +0200
Message-ID: <CAEezp7uXbWZn+bGDSd-qd_2SJx60m31HrenhwOQh8TokOtP-Hg@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 27, 2013 at 12:22 AM, Igor M <igork20@gmail.com> wrote:
> On Sun, Oct 27, 2013 at 12:17 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> On Oct 26, 2013, at 3:53 PM, Igor M <igork20@gmail.com> wrote:
>>
>>>
>>> I even added enospc_debug mount option, still no messages.
>>
>> If it were kernel enospc, you should have messages in dmesg.
>>
>> What version of btrfs progs when making the btrfs volume?
>>
>>>
>>> cp: failed to extend ‘/usr/local/mysql/data/gbdata/parts_0016.MYD’: No
>>> space left on device
>>
>> Reboot with kernel parameter ignore_loglevel and retry the copy, and see if you now have anything in dmesg at the time of the copy.
>>
>>
>
> Some more info. This files are MySQL database files. Tables contains
> only text so they compress well.
> But, if I copy some uncompressable file, for example some video than
> everything is ok, no error message, copy is successfull.
> I also tried mounting without compression (without compress-force=lzo)
> and in this case no error is reported.
> So it seems it's something with compression ?
>
> I'll try rebooting with ignore_loglevel parameter.
>
>>>
>>> It's the same error if I try to copy for ex. with midnight commander.
>>
>> I have the same kernel version, the same mount options, and use the same cp -a on a 5.3GB file and cannot reproduce your results.
>>
>>
>> Chris Murphy

Still no messages. Parameter seems to be active as
/sys/module/printk/parameters/ignore_loglevel is Y, but there are no
messages in log files or dmesg. Maybe I need to turn on some kernel
debugging option and recompile kernel ?
Also I should mention that cca 230G+ data was copied before this error
started to occur.
