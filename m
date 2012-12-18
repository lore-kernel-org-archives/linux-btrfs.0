Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64993 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2LRNb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 08:31:58 -0500
Received: by mail-oa0-f44.google.com with SMTP id n5so612212oag.17
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 05:31:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACR_K2t2uD_NjxzhTxGFMorVu_sSziv7LGbOSTafdADnFT=-mA@mail.gmail.com>
References: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
	<20121217103624.GA15304@panda>
	<201212172220.42946.russell@coker.com.au>
	<CACR_K2t2uD_NjxzhTxGFMorVu_sSziv7LGbOSTafdADnFT=-mA@mail.gmail.com>
Date: Tue, 18 Dec 2012 08:06:33 -0500
Message-ID: <CACR_K2u4gYOd9xMOS8JuPssqLBySAnW+Ubg05F1r2X=yzjMWXQ@mail.gmail.com>
Subject: Re: btrfs subvolume snapshot performance problem
From: Sylvain Alain <d2racing911@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, if I don't use the discard command, how often do I need to run the
fstrim command ?

I found this thread : https://patrick-nagel.net/blog/archives/337


Sylvain

2012/12/17 Sylvain Alain <d2racing911@gmail.com>:
> So, if I don't use the discard command, how often do I need to run the
> fstrim command ?
>
> I found this thread : https://patrick-nagel.net/blog/archives/337
>
>
> Sylvain
>
> 2012/12/17 Russell Coker <russell@coker.com.au>:
>> On Mon, 17 Dec 2012, Sander <sander@humilis.net> wrote:
>>> Let me repeat the answer cwillu gave to Russell on this, and Russell's
>>> response:
>>
>> Also tests did indicate a performance benefit on snapshots when I stopped using
>> discard.  It was as much as 15 seconds to create a snapshot and now it's
>> consistently less than 1 second.
>>
>> --
>> My Main Blog         http://etbe.coker.com.au/
>> My Documents Blog    http://doc.coker.com.au/
>
>
>
> --
> Salut
> alp
> Sylvain



-- 
Salut
alp
Sylvain
