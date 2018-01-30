Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:53936 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbeA3TuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 14:50:03 -0500
Date: Tue, 30 Jan 2018 20:50:01 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130195000.GA21701@polanet.pl>
References: <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
 <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
 <f8f72b3e-e0c0-cccb-a52a-8c8568e103ba@dirtcellar.net>
 <c6b6bb8c-b4ea-07f9-400f-39d8de9c0be9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <c6b6bb8c-b4ea-07f9-400f-39d8de9c0be9@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 08:46:32 -0500, Austin S. Hemmelgarn wrote:

>> I personally think the degraded mount option is a mistake as this 
>> assumes that a lightly degraded system is not able to work which is false.
>> If the system can mount to some working state then it should mount 
>> regardless if it is fully operative or not. If the array is in a bad 
>> state you need to learn about it by issuing a command or something. The 
>> same goes for a MD array (and yes, I am aware of the block layer vs 
>> filesystem thing here).
> The problem with this is that right now, it is not safe to run a BTRFS 
> volume degraded and writable, but for an even remotely usable system 

Mounting read-only is still better than not mounting at all.

For example, my emergency.target has limited network access and starts
ssh server so I could recover from this situation remotely.

> with pretty much any modern distro, you need your root filesystem to be 
> writable (or you need to have jumped through the hoops to make sure /var 
> and /tmp are writable even if / isn't).

Easy to handle by systemd. Not only this, but much more is planned:

http://0pointer.net/blog/projects/stateless.html

-- 
Tomasz Pala <gotar@pld-linux.org>
