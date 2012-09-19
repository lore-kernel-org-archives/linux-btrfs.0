Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58125 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2ISIc2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 04:32:28 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 340013EE0AE
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:28 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 1C8ED45DE4E
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:28 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 049A045DE4F
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:28 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id ED7681DB8037
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:27 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9FE8D1DB802F
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:27 +0900 (JST)
Message-ID: <50598310.9010904@jp.fujitsu.com>
Date: Wed, 19 Sep 2012 17:32:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
References: <5057CDA7.3090201@jp.fujitsu.com> <5057CEA9.3070707@jp.fujitsu.com> <5057DD0D.1070201@cn.fujitsu.com>
In-Reply-To: <5057DD0D.1070201@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/09/18 11:31), Miao Xie wrote:
> On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
>> This patch adds mount-option command.
>> The command can set/get default mount options.
>> Now, the command can set/get 24 options.
>> These options are equal to mount options which store
>> in fs_info/mount-opt.
> 
> I don't think we need implement a separate command to do this,
> we can add it into btrfstune just like ext3/4. If so, the users
> who used ext3/4 before can be familiar with btrfs command as soon
> as possible.

As some people already pointed out, I also think that the btrfstune
command is a kind of obsolete, and therefore it would be better to
improve the btrfs command as centralized utility.

> 
> Beside that, why not add a option into mkfs.btrfs?

It is planned. Once we can fix a way how to save default options,
modifying mkfs.btfs would be easy.


Thanks,
H.Seto

