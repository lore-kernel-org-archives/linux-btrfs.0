Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:35731 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3J1Hk4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 03:40:56 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so4157783eek.32
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 00:40:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3458CB22-ED71-45F4-B688-09C0CB6F5330@colorremedies.com>
References: <20131027100022.4c76e1e7@virtall.com>
	<CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
	<CAEezp7txuxchURr1DFhFWeFjCG6_07SX78vZCeDz3sxrgz6SVw@mail.gmail.com>
	<F8C57341-B55A-49DF-BE61-AB62D9D1A869@colorremedies.com>
	<3458CB22-ED71-45F4-B688-09C0CB6F5330@colorremedies.com>
Date: Mon, 28 Oct 2013 08:40:55 +0100
Message-ID: <CAEezp7v__2EbhZ-1=FjDpfnF5b+ydKw3LRx4tW55g911804TXA@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 28, 2013 at 12:27 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 27, 2013, at 4:46 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>
>> On Oct 27, 2013, at 3:53 PM, Igor M <igork20@gmail.com> wrote:
>>
>>> I made some more tests. Disk is 3TB, first cca 225GB is copied without errors.
>>> Then errors 'No space left on device' begins.
>>
>> Post the full entire dmesg somewhere please. pastebin.com is one option.
>
>
> And on list or pasted, the output for the disk from:
>
> smartctl -x /dev/sdX
>

dmesg: http://pastebin.com/t2H1QYye
source disk: http://pastebin.com/JqKxkxKr
dest disk: http://pastebin.com/ez9jALS2
