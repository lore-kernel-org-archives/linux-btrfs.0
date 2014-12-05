Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:42440 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLESLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 13:11:04 -0500
Received: by mail-qa0-f50.google.com with SMTP id w8so775248qac.23
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 10:11:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWVAuiAsL_XNBH_GM1zB38KqOZfjMP3ORz3=XOjADu1t1w@mail.gmail.com>
References: <547C6922.6030206@gmail.com>
	<CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
	<20141201184621.5dd7fcd9@natsu>
	<CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
	<20141202031403.GZ17395@hungrycats.org>
	<CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
	<20141202125610.GS12140@twin.jikos.cz>
	<CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com>
	<20141203185311.GX12140@twin.jikos.cz>
	<CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
	<20141205174601.GM9754@twin.jikos.cz>
	<CAH-HCWVAuiAsL_XNBH_GM1zB38KqOZfjMP3ORz3=XOjADu1t1w@mail.gmail.com>
Date: Fri, 5 Dec 2014 23:41:01 +0530
Message-ID: <CAH-HCWVKKHs3EpxucCbF-quii3hciBfrfTyVaEJOYn5o5MLAeg@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
From: Shriramana Sharma <samjnaa@gmail.com>
To: dsterba@suse.cz, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK so from https://forums.opensuse.org/showthread.php/440209-ifconfig
I learnt that it's because /sbin, /usr/sbin etc is not on the normal
user's path on openSUSE (they are, on Kubuntu). Adding them to PATH
fixes the situation. (I wasn't even able to do ifconfig without giving
the password. No idea why this is the openSUSE default...)


-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
