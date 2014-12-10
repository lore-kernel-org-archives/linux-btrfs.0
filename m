Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i2.italiaonline.it ([212.48.25.198]:59930 "EHLO
	smtp-18.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932527AbaLJTE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 14:04:29 -0500
Message-ID: <54889988.2080502@inwind.it>
Date: Wed, 10 Dec 2014 20:05:44 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Dongsheng Yang <dongsheng081251@gmail.com>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>	<548743CE.1020403@inwind.it>	<54879CFE.1090909@cn.fujitsu.com>	<54882634.4000809@pobox.com>	<pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net> <CA+qeAOo4NT5NEO97YJMq-asQVm4OZUdJECqqojTzjhmso_Jj4Q@mail.gmail.com>
In-Reply-To: <CA+qeAOo4NT5NEO97YJMq-asQVm4OZUdJECqqojTzjhmso_Jj4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 04:02 PM, Dongsheng Yang wrote:
> On Wed, Dec 10, 2014 at 9:21 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Robert White posted on Wed, 10 Dec 2014 02:53:40 -0800 as excerpted:
[...]
>> And in the example, the mkfs was supplied with two devices, so there's no
>> dup metadata remaining from a formerly single-device filesystem, either.
>> (Tho there will be the small single-mode stubs, empty, remaining from the
>> mkfs process, as no balance has been run to delete them yet, but those
>> are much smaller and empty.)
> 
> Yes. One question not related here: how about delete them in the end of mkfs?
> 
> Thanx

A btrfs balance should remove them. If you don't want to balance a full
filesystem, you can filter the chunk by usage (set a low usage).
Recently it was discussed in a tread...

BR
Goffredo


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
