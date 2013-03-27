Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62538 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3C0Lez (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 07:34:55 -0400
Received: by mail-ea0-f179.google.com with SMTP id f15so3296035eak.10
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 04:34:54 -0700 (PDT)
Date: Wed, 27 Mar 2013 13:34:51 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        linuxram@linux.vnet.ibm.com, sekharan@us.ibm.com,
        mingming cao <mingming@oracle.com>
Subject: Re: [RFC] How to enable btrfs reserve block space from specific
 device?
Message-ID: <20130327113451.GA1979@zambezi.lan>
References: <CAEH94Lgbo_QLkWzqE5cOSC7WAV5HCKhBSKR6LUG2trePH7D=_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEH94Lgbo_QLkWzqE5cOSC7WAV5HCKhBSKR6LUG2trePH7D=_w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 09:45:59AM +0800, Zhi Yong Wu wrote:
> HI,
> 
>     When i work on btrfs hot relocation feature, i hit one question
> about block reservation. btrfs hot relocation need to reserve block
> space from specific devices such as SSD, but current btrfs reserving
> code doesn't differentiate if block space is reserved from SSD or HDD.
> In order to make btrfs support this, I thought that we can introduce
> one new block group or flag, but this will maybe make large impact on
> current existing other functions. For this, does any guy have some
> better idea? thanks.

Hi,

Sorry for the late reply.  I have a lot on my plate right now, so I
haven't looked at your WIP code.  However, based on my knowledge, I can
tell you that block reservation problem is completely orthogonal to the
way you choose to handle hot data storage.  A separate block group is
one way to do it, and probably the easiest one.  Block groups -> chunks
is a 1:1 mapping, so, for now, it might make sense to have one giant
block group spanning over the entire hot data device.  OTOH, IIRC the
original implementation from IBM just used the rotation flag to detect
"hot data" devices.  You have a lot of choices here, but, if you are
planning on implementing mirrored/striped "hot data" devices in future,
I'd definitely go with block groups, since that'll give you some of the
infrastructure for that for free.

Thanks,

		Ilya
