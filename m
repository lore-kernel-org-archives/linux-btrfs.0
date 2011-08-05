From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: INSTALL hint: create device btrfs-control
Date: 05 Aug 2011 07:43:00 +0200
Message-ID: <BrHf++Ny1uB@helmut.hullen.de>
References: <20110804214950.GC8970@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804214950.GC8970@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 04.08.11:

>>>    Thanks. We can add those as symptoms to the solution later.

>> I've just run the first test - finding reliable (for only this case)
>> messages is a bad job ...

>    Well, it's probably OK just to use this particular symptom for
> now. You've generally got to run btrfs dev scan before you run
> anything else, so that message should turn up.

My usual way: "btrfs device scan" is part of a script under "/etc/ 
init.d", it's run while booting the machine, and even when I watch the  
machine while booting this special message isn't shown a long time. I'm  
searching ...

Viele Gruesse!
Helmut
