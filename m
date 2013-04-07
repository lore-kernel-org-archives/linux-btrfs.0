Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38092 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161269Ab3DGCLF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 22:11:05 -0400
Received: by mail-ob0-f176.google.com with SMTP id er7so4687400obc.7
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Apr 2013 19:11:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=am8-swZ7-uBr4KQmHYHvwAfpKBwrudFu_LqgUEARWYE3A@mail.gmail.com>
References: <CANu+oN1szXCzLDqeT8UMCz660dO47dDTa8PTL1KFUoG6z-u_rQ@mail.gmail.com>
	<CANu+oN1q-r2ti+uZs2_2Mg4_4J8gdNdtLedPAC3u5WZa=+jjFA@mail.gmail.com>
	<CAFWF=am8-swZ7-uBr4KQmHYHvwAfpKBwrudFu_LqgUEARWYE3A@mail.gmail.com>
Date: Sun, 7 Apr 2013 07:41:04 +0530
Message-ID: <CANu+oN3bfDfkzZ32y=fPu6s=xJOaPJc_F2we517kBNqXvd2o7A@mail.gmail.com>
Subject: Re: [BUG] btrfs.fsck failing to fix corrupted block
From: Shripad Ratnaparkhi <shripad.ratnaparkhi@gmail.com>
To: Harald Glatt <mail@hachre.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yup, that is exactly the case.
I got to know about no support of fsck.btrfs at boot up, so symlinked
btrfsck and built the initrd.
I will try to re-build without btrfsck now and try.

Thanks for you quick reply and solution, Herald.

thanks,
~shripadr

On Sun, Apr 7, 2013 at 7:32 AM, Harald Glatt <mail@hachre.de> wrote:
> On Sun, Apr 7, 2013 at 3:56 AM, Shripad Ratnaparkhi
> <shripad.ratnaparkhi@gmail.com> wrote:
>> [Replying to my own email]
>>
>> Found a patch which seems to be discusses the fix in a patch provided here:
>> https://patchwork.kernel.org/patch/1946561/
>>
>> Still now sure whether that is already there in v0.20-rc1 or
>> applicable to fix my issue.
>>
>> thanks,
>> ~shripadr
>>
>> PS: BCC'ing the patch provider.
>>
>> On Sun, Apr 7, 2013 at 7:16 AM, Shripad Ratnaparkhi
>> <shripad.ratnaparkhi@gmail.com> wrote:
>>> Hi there,
>>> I am newbie and recently started using btrfs. Now facing a weird problem.
>>>
>>> FWIW, I am on archlinux, kenel v3.8.0, having Btrfs v0.20-rc1.
>>> After an abnormal reboot, getting these errors while boot:
>>>
>>> systemd.fsck[289]: checking extents
>>> systemd.fsck[289]: checking fs roots
>>> systemd.fsck[289]: checking root refs
>>> systemd.fsck[289]: found 23728128 bytes used err is 0
>>> systemd.fsck[289]: total csum bytes: 23092
>>> systemd.fsck[289]: total tree bytes: 81920
>>> systemd.fsck[289]: total fs tree bytes: 24576
>>> systemd.fsck[289]: btree space waste bytes: 38038
>>> systemd.fsck[289]: file data blocks allocated: 23646208
>>> systemd.fsck[289]: referenced 23646208
>>> systemd.fsck[289]: Btrfs v0.20-rc1
>>> [   OK   ]  Started File System Check on /dev/sda1.
>>>                Mounting /boot...
>>> systemd.fsck[289]: checking extents
>>> [   OK   ] Mounted /boot.
>>> [   OK   ] Reached target Sound Card.
>>> systemd.fsck[289]: checking fs roots
>>> systemd.fsck[289]: checking root refs
>>> systemd.fsck[289]: extent buffer leak: start 206893056 len 4096
>>> systemd.fsck[289]: *** Error in `fsck.btrfs`: corrupted double-linked
>>> list: 0x0000000002081d80 ***
>>>
>>> and its not proceeding and stuck here.
>>> I have the rescue disk handy, but not sure how can I fix this issue.
>>> Any help please.
>>>
>>> thanks,
>>>
>>> --
>>> ~shripadr
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> The version that you can get from btrfs doesn't say a whole lot sadly.
> You can build the newest tools from git and try with the btrfsck
> there.
>
> Now this might not be entirely correct, but as far as I know the
> btrfsck tool isn't ready to be used in the traditional fsck capacity
> (automatically at bootup, etc). They don't symlink the tool on arch
> and per default arch builds it's initrd without a fsck for btrfs
> available. If you manually symlinked the tool to get rid of that error
> message during initrd creation I'd suggestion removing that symlink
> again and rebuilding your initrd without a btrfsck in place. As far as
> I know the best and most reliable way at the moment to confirm or
> repair errors is by btrfs scrub. Once you removed the startup fsck it
> might boot normally. You can then start a scrub with 'btrfs scrub
> start /' and see its status and progress via 'btrfs scrub status /'.
> If the scrub reports no errors, or finds some but repairs them, that
> is (as far as I know) a more reliable message than whatever btrfsck
> thinks.
