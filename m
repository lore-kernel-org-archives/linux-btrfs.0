From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs still looks for not existing devices
Date: 14 Oct 2011 17:43:00 +0200
Message-ID: <BvpRYk9D1uB@helmut.hullen.de>
References: <20111014150824.GK21931@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111014150824.GK21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 14.10.11:

>> I've just tried
>>
>>    git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
>>
>> and got the answer
>>
>> + git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
>> git.darksatanic.net[0: 212.13.194.111]: errno=Connection refused
>> git.darksatanic.net[0: 2001:ba8:1f1:f1d9:216:3eff:fe14:aef9]:
>> errno=Network is unreachable fatal: unable to connect a socket
>> (Network is unreachable)
>>
>> -----------------------------
>>
>> Have I got just another typo (or user mistake), or is there another
>> problem?

>    It seems to be OK for me from here (the server is in a totally
> different network to where I am), so I think it must be a problem
> local to you. The IP addresses (both v4 and v6) look like the right
> ones, and I'm not aware of having any blocking in place from my
> service provider. Do you have a "transparent" proxy in the way?

Changing from "git://" to "http://" solved the problem!

Compiling worked, see

  <http://arktur.shuttle.de/CD/Testpakete/btrfs-progs-20111014-i486-1Mills_hln.txz>

But "btrfs filesystem show" still shows lots of nonexistent devices -  
sorry.

Viele Gruesse!
Helmut
