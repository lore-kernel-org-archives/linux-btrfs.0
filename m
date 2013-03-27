Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58165 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3C0Nuj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 09:50:39 -0400
Received: by mail-qa0-f43.google.com with SMTP id l8so900735qaq.9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 06:50:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130327113451.GA1979@zambezi.lan>
References: <CAEH94Lgbo_QLkWzqE5cOSC7WAV5HCKhBSKR6LUG2trePH7D=_w@mail.gmail.com>
	<20130327113451.GA1979@zambezi.lan>
Date: Wed, 27 Mar 2013 21:50:38 +0800
Message-ID: <CAEH94LjFJ4men7E3yi+JabRnTAiwhEsrxyfjTw6fWA+VADaztw@mail.gmail.com>
Subject: Re: [RFC] How to enable btrfs reserve block space from specific device?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        linuxram@linux.vnet.ibm.com, sekharan@us.ibm.com,
        mingming cao <mingming@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 7:34 PM, Ilya Dryomov <idryomov@gmail.com> wrote:
> On Wed, Mar 27, 2013 at 09:45:59AM +0800, Zhi Yong Wu wrote:
>> HI,
>>
>>     When i work on btrfs hot relocation feature, i hit one question
>> about block reservation. btrfs hot relocation need to reserve block
>> space from specific devices such as SSD, but current btrfs reserving
>> code doesn't differentiate if block space is reserved from SSD or HDD.
>> In order to make btrfs support this, I thought that we can introduce
>> one new block group or flag, but this will maybe make large impact on
>> current existing other functions. For this, does any guy have some
>> better idea? thanks.
>
> Hi,
>
> Sorry for the late reply.  I have a lot on my plate right now, so I
No matter, thanks for you reply. it is definitely very helpful to me, thanks.
> haven't looked at your WIP code.  However, based on my knowledge, I can
> tell you that block reservation problem is completely orthogonal to the
> way you choose to handle hot data storage.  A separate block group is
> one way to do it, and probably the easiest one.  Block groups -> chunks
> is a 1:1 mapping, so, for now, it might make sense to have one giant
Yes, bg:chunks is 1:1 mapping.
> block group spanning over the entire hot data device.  OTOH, IIRC the
If so,when hot relocation is enabled, will the other btrfs functions
reserve block space only from HDD? In this case, will SSD seem to be
only used as one cache?
> original implementation from IBM just used the rotation flag to detect
yes, it determine if one device is SSD by one flag in request queue of
that device.
> "hot data" devices.  You have a lot of choices here, but, if you are
> planning on implementing mirrored/striped "hot data" devices in future,
This is maybe next item, i will put it and meta relocation support in
my TODO list.
> I'd definitely go with block groups, since that'll give you some of the
> infrastructure for that for free.
>
> Thanks,
>
>                 Ilya



-- 
Regards,

Zhi Yong Wu
