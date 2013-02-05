Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:61832 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3BEOSo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 09:18:44 -0500
Received: by mail-we0-f170.google.com with SMTP id z53so167880wey.29
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Feb 2013 06:18:43 -0800 (PST)
Message-ID: <511114C0.8060008@gmail.com>
Date: Tue, 05 Feb 2013 14:18:40 +0000
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E77B.2030901@gmail.com> <20130114145904.GA1387@shiny> <50F422BC.4000901@gmail.com> <20130114155718.GC1387@shiny> <50F43319.9040009@gmail.com> <20130114163433.GD1387@shiny> <50F5E6FA.60803@gmail.com> <50F6712F.3070408@itwm.fraunhofer.de> <5110DC02.4030409@gmail.com> <20130205194623.07a9bcfd@natsu>
In-Reply-To: <20130205194623.07a9bcfd@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/13 13:46, Roman Mamedov wrote:
> On Tue, 05 Feb 2013 10:16:34 +0000
> Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
>> that I was using one of those fantastic pci 4 port ethernet cards and
>> printer was directly to it - after moving it and everything else to
>> switch all problem and issues have went away. AT the moment I'm running
>> server for 2 weeks without any corruptions, any random kernel btrfs
>> crashes etc.
> If moving the printer over to a switch helped, perhaps it is indeed an
> electrical interference problem, but if your card is an old one from Sun, keep
> in mind that they also have some problems with DMA on machines with large
> amounts of RAM:
>
>    "sunhme" experiences corrupt packets if machine has more than 2GB of memory
>    https://bugzilla.kernel.org/show_bug.cgi?id=10790
>
> Not hard to envision a horror story scenario where a rogue network card would
> shred your filesystem buffer cache with network packets DMAed all over it,
> like bullets from a machine gun :) But in reality afaik IOMMU is supposed to
> protect against this.
>
As I said in reply to Chris it was definitely and electrical issue. Back 
in the days when cat5 eth was a novelty I've learnt hard way a simple 
lesson - don't be skimp, always separate with switch. I've learnt it on 
networks where parties were not necessary powered from same circuit or 
even supply phase. Since this setup is limited to my home I've violated 
my own old rule - and it back fired on me.

Anyway thanks for info on "sunhme" - WOW ....
