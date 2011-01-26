From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Kernel error during btrfs balance
Date: 26 Jan 2011 10:40:00 +0100
Message-ID: <Bear5K9y1uB@helmut.hullen.de>
References: <20110126092746.GJ29985@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110126092746.GJ29985@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 26.01.11:

>> It took me a couple of days, because I needed to patch my kernel
>> first and then issue a rebalance, which ran for more than two days.
>> Nevertheless, the rebalance succeeded without any "kernel
>> BUG"-messages, so apparently your patch works!

[...]

>    As far as I know, it means that you've run out of space, and not
> every block group has been rewritten by the balance process.

Yesterday I reported a similar problem in this mailing list, in the  
thread "version".

Running kernel 2.6.37 didn't show this error, but running kernel 2.6.38- 
rc2 ended with errors.

Viele Gruesse!
Helmut
