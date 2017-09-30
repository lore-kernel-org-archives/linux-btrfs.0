Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:44578 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdI3Wdp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 18:33:45 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id D798F9B81B
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 23:33:42 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id A502A5FBB1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 23:33:42 +0100 (BST)
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
 <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
 <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
 <a6f89874-2048-6903-9ebc-d28991a00adc@applied-asynchrony.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <14a105c2-548b-39fc-97c8-6a5678549910@cobb.uk.net>
Date: Sat, 30 Sep 2017 23:33:42 +0100
MIME-Version: 1.0
In-Reply-To: <a6f89874-2048-6903-9ebc-d28991a00adc@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30/09/17 19:17, Holger Hoffstätte wrote:
> On 09/30/17 19:56, Holger Hoffstätte wrote:
>> shell hackery as alternative. Anyway, I was sure that at the time the
>> other letters sounded even worse/were taken, but that may just have been
>> in my head. ;-)
>>
>> I just rechecked and -S is still available, so that's good.
> 
> Except that it isn't really, since there is already an 'S'
> case in cmds-subvolume.c as shortcut to --sort:

That's a shame (and it is also a shame to waste a single letter option
without documenting it!).

I still would encourage you to avoid -P. I think there is user confusion
by "parent" having more than one meaning even within btrfs. And I feel
it also tends to perpetuate the mistaken belief that snapshots are
somehow "special", and different from other subvolumes (rather than just
a piece of information about how two subvolumes are related). It also
allows -P to be used one day for the "search by parent UUID" feature.

Given the constraints, I would suggest -n. It is mostly arbitrary but it
is the second letter of snapshot and also the first of "not a snapshot".

Thanks for considering.

Graham
