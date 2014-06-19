Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64881 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbaFSHnh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 03:43:37 -0400
Received: by mail-oa0-f47.google.com with SMTP id n16so4390027oag.34
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 00:43:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140618230516.GZ1903@suse.cz>
References: <5398D475.4070309@redhat.com>
	<5398D4DF.9080508@redhat.com>
	<20140612105151.GN1903@twin.jikos.cz>
	<5399BB92.2070205@redhat.com>
	<20140618152906.GW1903@twin.jikos.cz>
	<CALOYprVo60UrZWWVk34MDur6CpDAG2a1Cg3cWd0M__gWKnQywA@mail.gmail.com>
	<20140618230516.GZ1903@suse.cz>
Date: Thu, 19 Jun 2014 08:43:36 +0100
Message-ID: <CALOYprWx6OPVK=A14yRHye1x1QuTqAu1QnH74Css=vWqjDMQoQ@mail.gmail.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 June 2014 00:05, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Jun 18, 2014 at 09:59:50PM +0100, WorMzy Tykashi wrote:
>> I think you forgot to apply the patch that adds
>> Documentation/btrfs-mount.5.txt before you tagged
>> integration-20140618, man5 (and consequently Documentation) can't be
>> made without it, causing a failed build.
>
> You're right, sorry. The file was not added after a conflict with
> git-am and I did not check afterwards. Local build test passed.
> Updated integration pushed, though it's a bit reduced. The 'next'
> sub-branch rebase had some suspicious glitch, I need to look closer
> tomorrow.

Thanks for the fast update. :)

Good luck battling that glitch!

Cheers,


WorMzy
