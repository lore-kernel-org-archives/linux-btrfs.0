Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33405 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932140AbaFXQP5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 12:15:57 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAB=7dh=yq-KjtHOjKPncvGziCEiJgVyMiAAY=4w=Za0Sr9geAg@mail.gmail.com>
Date: Tue, 24 Jun 2014 10:15:54 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <9C02AC8A-68FE-4344-A59B-7580D9E0D0C5@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com> <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com> <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com> <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com> <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com> <CAB=7dh=yq-KjtHOjKPncvGziCEiJgVyMiAAY=4w=Za0Sr9geAg@mail.gmail.com>
To: Mike Hartman <mike@hartmanipulation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 23, 2014, at 11:49 PM, Mike Hartman <mike@hartmanipulation.com> wrote:

>>> I zeroed out the drive and ran every smartctl test on it I could find
>>> and it never threw any more errors.
>> 
>> Zeroing SSDs isn't a good way to do it. Use ATA Secure Erase instead. The drive is overprovisioned, so there are pages without LBAs assigned, which means they can't be written to by software. Plus "zeros" make SSD pages full of zeros, rather than being empty and ready to be written to. ATA Secure Erase is supposed to make them empty (write ready) and does it for all pages.
>> 
>> http://mackonsti.wordpress.com/2011/11/22/ssd-secure-erase-ata-command/
> 
> Thanks, that's good information to have. I'll definitely do that next time.
> 
> So, setting aside potential issues with the drive itself... Anything
> else you can recommend in regards to accessing the data in my image?

I have no ideas.


> If I can't repair/rebuild the whole file system I can live with that,
> but at the very least I have some specific files I'd like to salvage.

https://btrfs.wiki.kernel.org/index.php/Restore

Your superblocks are good according to btrfs rescue super-recover. And various tree roots are found by btrfs-find-root including a tree root that also matches the latest latest generation:
	• Super think's the tree root is at 763420672, chunk root 20971520
	• Found tree root at 763420672 gen 214454 level 1

And yet btrfs restore fails. I'm not sure why but try:

btrfs restore -t 763420672 /dev/mapper/sda6_crypt /media/mint/usb_data/sda6_btrfs_recovery/

If that command doesn't quickly fail or spit out a bunch of messages, then it's probably restoring files. If you confirm in another shell that it is restoring, cancel the restore, and then figure out how to use the --path-regex option with the above command to just get the files you're looking for. If it fails, consider -i to ignore errors. Hopefully any errors stopping restore won't apply to the files you're looking for.

If this still fails, then go back up one generation in your btrfs-find-root list and use that tree root:
btrfs restore -t 762122240 -i --path-regex '<blah>' /dev/mapper/sda6_crypt /media/mint/usb_data/sda6_btrfs_recovery/

And so on up the list. Maybe one of them will work (?).

> Even if the metadata got garbled somehow, the actual data should still
> be buried in there somewhere, right?

Yeah but without the metadata you don't know where the data is or how to put its extents back together again if it's in multiple extents. Any file with portions being changed will have fragments on a COW file system. And while I don't know what happened or what's corrupt it's possible some tiny bit of really critical metadata is toast and that prevents locating other metadata needed to locate data.

> Are any forensic tools up to the
> task of finding it? Or is their operation so entwined with the details
> of the file system that they wouldn't do me any good?

I think you're in #btrfs channel on freenode territory. Try the above, and if all fail, head to #btrfs.


Chris Murphy