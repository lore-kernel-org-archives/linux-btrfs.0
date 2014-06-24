Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:42644 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaFXFta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 01:49:30 -0400
Received: by mail-qa0-f52.google.com with SMTP id w8so6436118qac.25
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 22:49:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
 <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
 <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com> <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com>
 <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Tue, 24 Jun 2014 01:49:10 -0400
Message-ID: <CAB=7dh=yq-KjtHOjKPncvGziCEiJgVyMiAAY=4w=Za0Sr9geAg@mail.gmail.com>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I zeroed out the drive and ran every smartctl test on it I could find
>> and it never threw any more errors.
>
> Zeroing SSDs isn't a good way to do it. Use ATA Secure Erase instead. The drive is overprovisioned, so there are pages without LBAs assigned, which means they can't be written to by software. Plus "zeros" make SSD pages full of zeros, rather than being empty and ready to be written to. ATA Secure Erase is supposed to make them empty (write ready) and does it for all pages.
>
> http://mackonsti.wordpress.com/2011/11/22/ssd-secure-erase-ata-command/

Thanks, that's good information to have. I'll definitely do that next time.

So, setting aside potential issues with the drive itself... Anything
else you can recommend in regards to accessing the data in my image?
If I can't repair/rebuild the whole file system I can live with that,
but at the very least I have some specific files I'd like to salvage.
I've got a backup setup in place, but the files in question are pretty
big and recently modified, so the latest and greatest hadn't made it
into the backup yet.

Even if the metadata got garbled somehow, the actual data should still
be buried in there somewhere, right? Are any forensic tools up to the
task of finding it? Or is their operation so entwined with the details
of the file system that they wouldn't do me any good?
