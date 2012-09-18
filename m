Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay02.libero.it ([212.52.84.102]:37969 "EHLO
	outrelay02.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab2IRLha (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 07:37:30 -0400
Message-ID: <12787820.2107631347968234887.JavaMail.root@wmail62>
Date: Tue, 18 Sep 2012 13:37:14 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <rm@romanrm.ru>, <miaox@cn.fujitsu.com>
Subject: R: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, hugo-lkml@carfax.org.uk,
        Alexander Block <ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5057CDA7.3090201@jp.fujitsu.com>



>Da: rm@romanrm.ru
>Data: 18/09/2012 6.19
>A: <miaox@cn.fujitsu.com>
>Cc: "Hidetoshi Seto"<seto.hidetoshi@jp.fujitsu.com>, <linux-btrfs@vger.kernel.
org>
>Ogg: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
>
>On Tue, 18 Sep 2012 10:31:41 +0800
>Miao Xie <miaox@cn.fujitsu.com> wrote:
>
>> On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
>> > This patch adds mount-option command.
>> > The command can set/get default mount options.
>> > Now, the command can set/get 24 options.
>> > These options are equal to mount options which store
>> > in fs_info/mount-opt.
>> 
>> I don't think we need implement a separate command to do this,
>> we can add it into btrfstune just like ext3/4. If so, the users
>> who used ext3/4 before can be familiar with btrfs command as soon
>> as possible.
>
>btrfstune currently only does one thing:
>
>$ sudo btrfstune
>usage: btrfstune [options] device
>	-S value	enable/disable seeding
>
>To me it'd seem more logical the other way, why not move this operation to 
the
>base "btrfs" utility under some command, and remove "btrfstune" completely.

I fully agree. It doesn't make sense to have btrfstune as separate command. 
Its functionality should be integrate in Hidetoshi's patch: at the end both 
clear/set some flags.

I am not happy about the "btrfs property *" syntax, however the Hugo 
suggestion is right: these flags (with the seed one) are filesystem properties, 
and should be integrated in the Alexander work... However I don't know the 
status if its patches...


>
>-- 
>With respect,
>Roman
>
>~~~~~~~~~~~~~~~~~~~~~~~~~~~
>"Stallman had a printer,
>with code he could not see.
>So he began to tinker,
>and set the software free."
>


