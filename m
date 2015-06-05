Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35360 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbbFEBJ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 21:09:57 -0400
Received: by igbzc4 with SMTP id zc4so4457696igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 18:09:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABgvyo9dnX9t_cQG3t1YPLJB7G_TEp2RiOi45n0ce58hJBxdGA@mail.gmail.com>
References: <CABgvyo9DJ9Z0EyAcdFLE9w+PTpheH9EOjzNy_0EUX+kYZFedOA@mail.gmail.com>
 <CABR0jER2tmpFS4bf5jACJL3ukknjLMrRf5mP_OQjNbcrz+-VtA@mail.gmail.com> <CABgvyo9dnX9t_cQG3t1YPLJB7G_TEp2RiOi45n0ce58hJBxdGA@mail.gmail.com>
From: Paul Harvey <csirac2@gmail.com>
Date: Fri, 5 Jun 2015 11:09:34 +1000
Message-ID: <CAB3_QuLcg-r=+2q8P8xQ+5cpu7g5COSAsSjb35gWu0F7DY37CQ@mail.gmail.com>
Subject: Re: copy complete subvolume/snapshot structure
To: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Cc: Richard Michael <rmichael@edgeofthenet.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 2015-06-04 16:42 GMT+02:00 Richard Michael <rmichael@edgeofthenet.org>:
>> Hi Johan,
[snip]
>> Concerning the backup of subvolumes, Snazzer is frequently mentioned.  (I
>> have not used it myself.)
>>
>> https://github.com/csirac2/snazzer

Just a heads-up: those frequent mentions are entirely down to me
trying to gain some attention in order to get feedback and understand
how people are using btrfs so that I could get the overall shape of
snazzer right in a way that's useful/appealing to btrfs users.

I had started extracting the snazzer-receive command out of snazzer
itself and generalizing it to work with any arbitrary btrfs
filesystem. It seems this functionality is a common requirement and
perhaps it's best released as a separate stand-alone utility so that
folks don't have to worry about adopting any of snazzer's snapshot
layout idiosyncrasies.

There's not too much work left in it but as I haven't been overwhelmed
with feedback so far I've only been spending an hour or two per week
on it. If somebody would genuinely be interested in such a tool I'll
try to get a first version out this weekend :)

The working name is btrfsdup, it works much like snazzer-receive but
only tries to reproduce an entire filesystem without any snapshot
layout assumptions, doesn't try to do any on-the-fly snapshot pruning
and obviously doesn't try to append any snapshot measurement reports
to the target FS.
