Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub3.mail.dreamhost.com ([69.163.253.7]:56865 "EHLO
	homiemail-a22.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbcGXEcu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 00:32:50 -0400
Received: from homiemail-a22.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a22.g.dreamhost.com (Postfix) with ESMTP id 6CF7F114066
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 21:32:49 -0700 (PDT)
Received: from [192.168.0.96] (31-178-200-210.dynamic.chello.pl [31.178.200.210])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: liori@exroot.org)
	by homiemail-a22.g.dreamhost.com (Postfix) with ESMTPSA id 03B0F114065
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 21:32:48 -0700 (PDT)
Subject: Re: Force recalculation of a data block checksum
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
 <CAJCQCtRHi=xJ-mP2yTg5c9sfGk+WKnjzRikT7Y-5he8s+3sSVw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Tomasz Melcer <liori@exroot.org>
Message-ID: <6699a315-17f4-9298-fb6b-64358c497be0@exroot.org>
Date: Sun, 24 Jul 2016 06:32:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRHi=xJ-mP2yTg5c9sfGk+WKnjzRikT7Y-5he8s+3sSVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24.07.2016 04:16, Chris Murphy wrote:
> On Sat, Jul 23, 2016 at 8:03 PM, Tomasz Melcer <liori@exroot.org> wrote:
>> How can I ask btrfs to recompute the checksum of a data block as it is
>> stored on the drive?
>
> Since btrfs-progs 3.17 'btrfs check --init-csum-tree' will create a
> whole new csum tree.

I can't make this command recalculate only checksum of that single file?


-- 
Tomasz Melcer
