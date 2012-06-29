Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49617 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2F2OHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 10:07:24 -0400
Received: by pbbrp8 with SMTP id rp8so4562419pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 07:07:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120629134726.GK25572@carfax.org.uk>
References: <CAEH94LgsFojUrrMPCkzY+OMbq=SWCMpfvV_J0NzO7E58zXDXzQ@mail.gmail.com>
	<20120629134726.GK25572@carfax.org.uk>
Date: Fri, 29 Jun 2012 22:07:23 +0800
Message-ID: <CAEH94LhKNNQ-XROwhpvracuuKXUaeCM_g+KD=cZ7u6rre5=e7w@mail.gmail.com>
Subject: Re: Can give some help?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Zhi Yong Wu <zwu.kernel@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 9:47 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Jun 29, 2012 at 09:41:47PM +0800, Zhi Yong Wu wrote:
>> HI,
>>
>> Can anyone let me know where the funtions are declared or defined,
>> such as btrfs_header_nritems(), btrfs_header_level(), etc? thanks.
>
>   ctree.h, somewhere around or after line 1550. They're all accessor
> functions, defined by a set of macros. Look for the *_SETGET_* macros.
> The actual definitions of BTRFS_SETGET_FUNCS are in struct-funcs.h
Great, thanks.

>
>   Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>       --- Great oxymorons of the world, no. 1: Family Holiday ---



-- 
Regards,

Zhi Yong Wu
