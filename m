Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35081 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbcF1Qzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 12:55:36 -0400
Received: by mail-vk0-f45.google.com with SMTP id j2so30458485vkg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 09:55:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628125639.GA6997@invalid>
References: <20160627132841.GA11661@invalid> <20160627133310.GB11661@invalid>
 <CAPmG0jbcojqdERe39Fnu20mg2e2VyxJOUi53Zy6kV_=B=q-zEA@mail.gmail.com> <20160628125639.GA6997@invalid>
From: Henk Slager <eye1tm@gmail.com>
Date: Tue, 28 Jun 2016 18:55:34 +0200
Message-ID: <CAPmG0jZCQ9WDqc3hHxp9GvZmEb=_TQ5JqUEcgfy2Vm_E42sscA@mail.gmail.com>
Subject: Re: Bug in 'btrfs filesystem du' ?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 2:56 PM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
> Hello,
>
> Am Montag, den 27. Juni schrieb Henk Slager:
>> On Mon, Jun 27, 2016 at 3:33 PM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
>> > Am Montag, den 27. Juni schrieb M G Berberich:
>> >> after a balance ‘btrfs filesystem du’ probably shows false data about
>> >> shared data.
>> >
>> > Oh, I forgot: I have btrfs-progs v4.5.2 and kernel 4.6.2.
>>
>> With  btrfs-progs v4.6.1 and kernel 4.7-rc5, the numbers are correct
>> about shared data.
>
> I tested with kernels 4.6.3 and 4.7-rc5 and with btrfs-progs 4.5.2 and
> 4.61.
Also with kernel 4.6.2-1-default and btrfs-progs v4.5.3+20160516
(current stock opensuse tumbleweed) I cannot reproduce the problem.

 The later kernel with two patches to make the kernel work:
> https://lkml.org/lkml/2016/6/1/310 https://lkml.org/lkml/2016/6/1/311 .
... so these seem to cause the problem


> You can see the script¹ I used (do-btrfs-du-test) and the logs at
> http://m-berberich.de/btrfs/
>
> In all four cases, ‘btrfs fi du -s .’ reports
>
>      Total   Exclusive  Set shared  Filename
>   59.38MiB       0.00B    29.69MiB  .
>
> befor balance and
>
>      Total   Exclusive  Set shared  Filename
>   59.38MiB    59.38MiB       0.00B  .
>
> after balance.
>
> Disclaimer: The script works for me, no guaranty at all.
>
>         MfG
>         bmg
> __________
> ¹ Disclaimer: The script works for me, no guaranty at all.
> --
> „Des is völlig wurscht, was heut beschlos- | M G Berberich
>  sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
> (SPD-Stadtrat Kurt Schindler; Regensburg)  |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
