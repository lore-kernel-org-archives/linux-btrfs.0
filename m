Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53736 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2IYODk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 10:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120925101429.GR14582@twin.jikos.cz>
References: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
	<1348538536-29838-3-git-send-email-zwu.kernel@gmail.com>
	<20120925101429.GR14582@twin.jikos.cz>
Date: Tue, 25 Sep 2012 22:03:38 +0800
Message-ID: <CAEH94Ljvso=7jtBg+gYw3UiKwL=x8EGEXjjSXMGAT6BePAdUug@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs-progs: Fix up memory leakage
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbacik@fusionio.com,
        linuxram@linux.vnet.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 6:14 PM, David Sterba <dave@jikos.cz> wrote:
> On Tue, Sep 25, 2012 at 10:02:16AM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Some code pathes forget to free memory on exit.
>
> Same as with the fd's, kernel will free all memory for us at exit().
hi, can you let me know the pointer to exit() said by you?

>
> If there's lots of memory allocated, it may be even faster to leave the
> unallocation process to kernel as it will do it in one go, while the
> application would unnecessarily free it chunk by chunk.
got it, thanks.
>
> david



-- 
Regards,

Zhi Yong Wu
