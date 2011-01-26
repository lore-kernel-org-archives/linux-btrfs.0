From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: Kernel error during btrfs balance
Date: Wed, 26 Jan 2011 10:43:09 +0100
Message-ID: <4D3FECAD.3080102@logtenberg.eu>
References: <4D344EBB.6030903@logtenberg.eu> <4D3452C9.901@logtenberg.eu> <4D3948CB.8090801@logtenberg.eu> <AANLkTinN7QYqwydzgidERhu46QTEE8bLwiRy4qjM2fyL@mail.gmail.com> <4D3FE382.6070000@logtenberg.eu> <20110126092746.GJ29985@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110126092746.GJ29985@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


>> [104178.827624] entry offset 8891924480, bytes 4096, bitmap yes
>> [104178.827626] block group has cluster?: no
>> [104178.827628] 0 blocks of free space at or bigger than bytes is
>> [104178.827631] block group 17213423616 has 5368709120 bytes, 5368709120
>> used 0 pinned 0 reserved
>> [104178.827634] block group has cluster?: no
>>
>> And so on.
>>
>> Does this indicate an error of any sort, or is this expected behaviour?
> 
>    As far as I know, it means that you've run out of space, and not
> every block group has been rewritten by the balance process.
> 
>    Hugo.
> 

It is a 300GB volume with 79GB free. So hardly out of space. Moreover, I
started the balance operation with the sole purpose of reclaiming some
free space. The volume had like 40GB less free space when balance
started, which was used by / reserved for Metadata.

Kind regards,

Erik.
