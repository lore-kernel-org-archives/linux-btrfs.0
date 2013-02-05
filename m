Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64679 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3BEKQi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 05:16:38 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so3795368eek.34
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Feb 2013 02:16:36 -0800 (PST)
Message-ID: <5110DC02.4030409@gmail.com>
Date: Tue, 05 Feb 2013 10:16:34 +0000
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E77B.2030901@gmail.com> <20130114145904.GA1387@shiny> <50F422BC.4000901@gmail.com> <20130114155718.GC1387@shiny> <50F43319.9040009@gmail.com> <20130114163433.GD1387@shiny> <50F5E6FA.60803@gmail.com> <50F6712F.3070408@itwm.fraunhofer.de>
In-Reply-To: <50F6712F.3070408@itwm.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/01/13 09:21, Bernd Schubert wrote:
> On 01/16/2013 12:32 AM, Tom Kusmierz wrote:
>
>> p.s. bizzare that when I "fill" ext4 partition with test data everything
>> check's up OK (crc over all files), but with Chris tool it gets
>> corrupted - for both Adaptec crappy pcie controller and for mother board
>> built in one. Also since courses of history proven that my testing
>> facilities are crap - any suggestion's on how can I test ram, cpu &
>> controller would be appreciated.
>
> Similar issues had been the reason we wrote ql-fstest at q-leap. Maybe 
> you could try that? You can easily see the pattern of the corruption 
> with that. But maybe Chris' stress.sh also provides it.
> Anyway, I yesterday added support to specify min and max file size, as 
> it before only used 1MiB to 1GiB sizes... It's a bit cryptic with 
> bits, though, I will improve that later.
> https://bitbucket.org/aakef/ql-fstest/downloads
>
>
> Cheers,
> Bernd
>
>
> PS: But see my other thread, using ql-fstest I yesterday entirely 
> broke a btrfs test file system resulting in kernel panics.

Hi,

Its been a while, but I think I should provide a "definite anwser" or 
simply what was the cause of whole problem:

It was a printer!

Long story short, I was going nuts trying to diagnose which bit of my 
server is going bad and effectively I was down to blaming a interface 
card that connects hotswapable disks to mobo / pcie controllers. When 
I've got back from my holiday I've sat in front of server and decided to 
go with ql-fstest which in a very nice way reports errors with a very 
low lag (~2 minutes) after they occurred. At this point my printer 
kicked in with "self clean" and error just showed up after ~ two minutes 
- so I've restarted printer and while it was going through it's own post 
with self clean another error showed up. Issue here turned out to be 
that I was using one of those fantastic pci 4 port ethernet cards and 
printer was directly to it - after moving it and everything else to 
switch all problem and issues have went away. AT the moment I'm running 
server for 2 weeks without any corruptions, any random kernel btrfs 
crashes etc.


Anyway I wanted to thank again to Chris and rest of btrFS dev people for 
this fantastic filesystem that let me discover how stupid setup I was 
running and how deep into shiet I've put my self.

CHEERS LADS !



Tom.
