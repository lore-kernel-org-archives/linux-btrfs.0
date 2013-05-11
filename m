Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35160 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3EKKIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 06:08:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ub6iw-0000rb-Am
	for linux-btrfs@vger.kernel.org; Sat, 11 May 2013 12:08:18 +0200
Received: from dyndsl-080-228-191-017.ewe-ip-backbone.de ([80.228.191.17])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 12:08:18 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-191-017.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 12:08:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
Date: Sat, 11 May 2013 12:01:55 +0200
Message-ID: <khh16a-3ja.ln1@hurikhan.ath.cx>
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx> <51889A4D.8000201@jan-o-sch.net> <ch7o5a-g0b.ln1@hurikhan.ath.cx> <7jio5a-b5g.ln1@hurikhan.ath.cx> <518A318A.7060105@jan-o-sch.net> <15ot5a-f1m.ln1@hurikhan.ath.cx> <518C9B55.3050008@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:

> We can try to debug that further, you can send me / upload the output of
> 
>    btrfs-image -c9 /dev/whatever blah.img
> 
> built from Josef's repository
> 
>    git://github.com/josefbacik/btrfs-progs.git
> 
> It contains all your metadata (like file names), data is omitted from the
> dump.

How do I create that image? Is it possible to use it on mounted volumes? If 
yes, is it possible to write the image to the volume I'm creating the image 
of?

Thanks,
Kai

