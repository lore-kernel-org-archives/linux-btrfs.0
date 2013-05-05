Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33783 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3EEQYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 12:24:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZ1ja-0002Cg-AW
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 18:24:22 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 18:24:22 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 18:24:22 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: exploit preload daemon to defragment most needed files
Date: Sun, 05 May 2013 18:21:45 +0200
Message-ID: <khdi5a-sfp.ln1@hurikhan.ath.cx>
References: <05mh5a-iqe.ln1@hurikhan.ath.cx> <20130505135708.GA24548@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Torcz <tomek@pipebreaker.pl> schrieb:

>> Although this is about the preload daemon, my intended audience for this
>> matter is the btrfs community. So I'm posting this here.
>> 
>> I've created a small script here[1] to read the preload daemon state file
>> and use this to run the btrfs defragmenter/compressor on these files. The
>> idea was to have some proof-of-concept to maybe integrate defragmentation
>> capabilities directly into preload.
> 
>   In similar spirit, systemd's readhead defrag files on btrfs. Here's the
>   commit:

Yes! :-) Actually that is where I had my idea from. But preload takes on 
(boot finished, preload user's enviroment) where readahead stops (readahead 
files needed by daemons, until about 10s after last daemon loaded) working 
with my files.

I think it is a great idea doing this kind of stuff in preloaders and 
"readaheaders".

If I understood it right, systemd readahead does not only just defrag the 
files, it relocates them into the order needed during boot. Actually, that 
seems pretty effective, as my system (no SSD) finishes booting all daemons 
within less than 10s (on mraid1/draid0 3 device btrfs, plain old harddisks, 
no SSD). Just lightdm/kdm then take ages to load. Still need to figure out 
why but that's another story.

Regards,
Kai

