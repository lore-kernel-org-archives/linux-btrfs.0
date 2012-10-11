Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:53749 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2JKTyx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 15:54:53 -0400
Message-ID: <50772408.9040303@profihost.ag>
Date: Thu, 11 Oct 2012 21:54:48 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>, miaox@cn.fujitsu.com
Subject: Re: problems with btrfs send / restore
References: <50771F22.3070501@profihost.ag> <20121011194335.GE4405@twin.jikos.cz>
In-Reply-To: <20121011194335.GE4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 11.10.2012 21:43, schrieb David Sterba:
> On Thu, Oct 11, 2012 at 09:33:54PM +0200, Stefan Priebe wrote:
>> [server: /btrfs/target]# btrfs send -i /btrfs/src/\@snapshot/1
>> /btrfs/src/\@snapshot/2 | btrfs receive /btrfs/target/\@snapshot/
>> At subvol /btrfs/src/@snapshot/2
>> At subvol 2
>> ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No such file or directory
>                                        ^^^^^^^^^^^^^^^^^^^
>
> I wonder if this is the ghost snapshot dir entry that Miao fixed. Did
> somehow get into the 'send' stream and confused the receive side.
>
> david

i missed two facts:
1.) vanilla kernel 3.6.1
2.) latest btrfs tools git (cloned at 10/10/2012)

Stefan
