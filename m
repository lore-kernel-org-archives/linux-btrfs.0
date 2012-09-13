Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2IMXpU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 19:45:20 -0400
Received: by pbbrr13 with SMTP id rr13so4743867pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 16:45:20 -0700 (PDT)
Message-ID: <5052700D.4020003@gmail.com>
Date: Fri, 14 Sep 2012 07:45:17 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ssd alignment and btrfs sector size
References: <CACHiF8Bg+od7tyq_5QeXAN1uo+Gs+D_Mnof00RPJZRoP2RC6ZA@mail.gmail.com> <20120913130011.GE12994@localhost.localdomain>
In-Reply-To: <20120913130011.GE12994@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/13/2012 09:00 PM, Josef Bacik wrote:
> On Thu, Sep 13, 2012 at 12:02:04AM -0600, ching lu wrote:
>> I am trying to test btrfs on my ssd, i am studying about btrfs and alignment.
>>
>> I have read this old mail:
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16177.html
>>
>> According to the thread, 3 parameters should be tuned
>>
>> 1. leafsize
>> 2. nodesize
>> 3. sectorsize
>>
>> The first two parameters are easy to understand, but how does
>> "sectorsize" affect the alignment?
>>
>> If the erase block size of my SSD is 16k, and i set
>> leafsize=nodesize=16k, leave the sectorsize=4k (default), will it
>> causes misalignment?
> So frist leafsize/nodesize will always be the same, so if you set one to 16k
> mkfs will autmatically set the other to 16k, it's just way back when we had
> grand plans of having different sizes for both.
>
> Secondly your erase block size is 16k?  What kind of drive are you using?  But
> yeah 4k sectorsize will result in misaligned writes to the data area, but your
> metadata will be aligned.  Hopefully the raid5/6 code will be out soon and we'll
> be able to do > page size sectorsize and you'll be able to set
> leafsize==sectorsize.  Btw most normal SSDs have waaaay larger erase blocks, on
> the order of several MB, so it's not the worst thing to write to the middle of
> erase blocks, everybody does it anyway.  Thanks,
>
> Josef
>

16k is just a assumption only, thanks for your help anyway.
