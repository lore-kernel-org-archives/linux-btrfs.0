Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gremlin.yadt.co.uk ([149.255.108.98]:60489 "EHLO
	gremlin.yadt.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaD3Nmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 09:42:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by gremlin.yadt.co.uk (Postfix) with ESMTP id BAFE81C412
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 14:37:24 +0100 (BST)
Received: from gremlin.yadt.co.uk ([127.0.0.1])
	by localhost (gremlin.yadt.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bxqqMxyuFiER for <linux-btrfs@vger.kernel.org>;
	Wed, 30 Apr 2014 14:37:16 +0100 (BST)
Date: Wed, 30 Apr 2014 14:37:16 +0100
From: David Taylor <davidt-btrfs@yadt.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Message-ID: <20140430133715.GA7571@yadt.co.uk>
References: <cover.1398786620.git.dsterba@suse.cz>
 <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
 <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
 <5360E0EF.8030109@libero.it>
 <20140430121140.GI5988@twin.jikos.cz>
 <5360FB26.9090009@kingswood-consulting.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5360FB26.9090009@kingswood-consulting.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Apr 2014, Frank Kingswood wrote:
> On 30/04/14 13:11, David Sterba wrote:
>> On Wed, Apr 30, 2014 at 01:39:27PM +0200, Goffredo Baroncelli wrote:
>>>
>>> I found a bit unclear the "FS occupied" terms.
>>
>> We're running out of terms to describe and distinguish the space that
>> the filesystem uses.
>> 
>> 'occupied' seemed like a good choice to me, though it may be not obvious
> 
> The space that the filesystem uses in total seems to me is called the
> "size". It has nothing to do with utilization.
> 
> /dev/sda6, ID: 2
>     Device size:            10.00GiB
>     Filesystem size:         5.00GiB

FS size was what I was about to suggest, before I saw your reply.

It makes more sense to me than 'Occupied' and seems cleaner than
'Resized To'.  It sort of mirrors how LVM describes PV / VG / LV
sizes, too.

-- 
David Taylor
