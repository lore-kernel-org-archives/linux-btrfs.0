Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34812 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbbDGODG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 10:03:06 -0400
Received: by lboc7 with SMTP id c7so43264499lbo.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 07:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201504071358.29442.russell@coker.com.au>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
	<201504071358.29442.russell@coker.com.au>
Date: Tue, 7 Apr 2015 16:03:04 +0200
Message-ID: <CAK1hC9uUdBhS92RdVsxvbGY4L5bEXq7-5nNa6m-=XVkC-CLoUQ@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 3:58 PM, Russell Coker <russell@coker.com.au> wrote:
> On Tue, 7 Apr 2015 10:58:28 AM arnaud gaboury wrote:
>> After more reading, it seems to me creating a top root subvolume is
>> the right thing to do:
>> # btrfs subvolume create root
>> # btrfs subvolume create root/var
>> # btrfs subvolume create root/home
>>
>> Am I right?
>
> A filesystem is designed to support arbitrary names for files, directories, and
> in the case of BTRFS subvolumes.
>
> You might ask whether /var/log is a good place for log files, it's generally
> regarded that "yes" is the correct answer to that question, but it's not a
> question for filesystem developers.
>
> I like to have / in the root subvolume so all subvolumes are available by
> default.  I have /var etc in the same subvolume so I can make an atomic
> snapshot of all such data.  It's not the one true answer, but it works for me
> and will work for other people.
>
> The main thing is to have all data that needs to be atomically snapshotted on
> the same subvolume.

Would you mind give the return of # btrfs subvolume list and $ cat /etc/fstab ?
It would help me. TY

>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/



-- 

google.com/+arnaudgabourygabx
