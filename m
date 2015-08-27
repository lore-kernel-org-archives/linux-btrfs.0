Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35425 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbbH0Rnv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 13:43:51 -0400
Received: by vkfi73 with SMTP id i73so12906164vkf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 10:43:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQzTt14UDKKK996U-CRznvzL8JxnkkRWC=WfxmqDCbsOQ@mail.gmail.com>
References: <CAGAq4WGf475k4oN6+MHrOfnKNdeLsHQE1WfKQAkwPxOH3=9-cw@mail.gmail.com>
	<CAJCQCtTxrBXxi3UQVXqPbXeRQobsvdZq9rsnyVioKQ0nNCZNsw@mail.gmail.com>
	<CAGAq4WFEown9JQxj0qi46zuBun2eUQFKtRSOsgLC03Uv6r1UPw@mail.gmail.com>
	<CAJCQCtQQmz3+Cs0KXL+-18UTP1tUG3_4BEpU0qAevi=Os4bYSw@mail.gmail.com>
	<CAGAq4WF1-aeLHzz25WjqnrP9wrfjERFy+MqdTK5nbqfg6c5xcA@mail.gmail.com>
	<CAJCQCtR_83dzDtALR=joqdBqWAB4mG8vK0p_t3wgiwKgKz22ew@mail.gmail.com>
	<CAGAq4WEaoB3ZDM0Er-AEohVsguWjmSrm8xSmtfROpQ-p8iVV+Q@mail.gmail.com>
	<CAJCQCtQzTt14UDKKK996U-CRznvzL8JxnkkRWC=WfxmqDCbsOQ@mail.gmail.com>
Date: Thu, 27 Aug 2015 11:43:50 -0600
Message-ID: <CAJCQCtQ8YXR4mkFFnrDcfiHB4qi2B2uNT2AtqNQQ6noS_rP95A@mail.gmail.com>
Subject: Re: Meta data full on a Readynas
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Mike Aubury <mike@aubit.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 11:41 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Aug 27, 2015 at 11:33 AM, Mike Aubury <mike@aubit.com> wrote:
>> #  btrfs dev scan
>> Scanning for Btrfs filesystems
>>
>> (back to # prompt)
>>
>>
>> # mount -o ro,degraded /data
>>
>>
>> Seems to work, /data is mounted
>>
>> # btrfs fi show
>> Label: '0e36d290:data'  uuid: e75a9856-d9e5-4d02-92e6-a217056c69b7
>>         Total devices 4 FS bytes used 6.09TiB
>>         devid    1 size 2.71TiB used 2.71TiB path /dev/md127
>>         devid    2 size 1.82TiB used 1.82TiB path /dev/md126
>>         devid    3 size 1.82TiB used 1.82TiB path /dev/md125
>>         *** Some devices missing
>>
>>
>> Where next ?

Well now at least you can suck the data off the volume...

If you can't figure out why the loop back mount device continues to be
missing, you might as well just take advantage of the fact you've got
it ro mounted and get everything off the volume in preparation to wipe
it and start over.



-- 
Chris Murphy
