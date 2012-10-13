Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62990 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2JMW4V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 18:56:21 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so3808743pad.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 15:56:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5079AA18.6010103@zastrow4u.de>
References: <k0ub0m$pvp$1@ger.gmane.org>
	<k1cc36$tj$1@ger.gmane.org>
	<5039BF90.7070509@oracle.com>
	<5079AA18.6010103@zastrow4u.de>
Date: Sat, 13 Oct 2012 16:56:21 -0600
Message-ID: <CAE5mzvg4j5w+-rrGXKZi+6fJrpPDvCbPdvbAKyJ=RtHTa9Vdag@mail.gmail.com>
Subject: Re: BTRFS filesystem is not mountable after crash
From: cwillu <cwillu@cwillu.com>
To: Alfred Zastrow <ml@zastrow4u.de>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 13, 2012 at 11:51 AM, Alfred Zastrow <ml@zastrow4u.de> wrote:
> Am 26.08.2012 08:17, schrieb Liu Bo:
>
>> On 08/26/2012 01:27 PM, Alfred Zastrow wrote:
>>
>>
>> Hello,
>>
>> has realy nobody a hint for me?
>>
>> Is compiling chris's latest for-linus helpful?
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>>
>> thanks,
>> liubo
>
>
> Hi dev's
>
> I was not able to install chris's latest for-linus under F17, but I tried
> with the latest 3.6.1-Kernel with was recently released.
> Same shit..  :-(

Chris's for-linus is currently all the btrfs changes that will be
going into 3.7.  3.6.1 won't likely have any of them.
