Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48272 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbaLANvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 08:51:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvRNh-0007kp-Sm
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 14:51:13 +0100
Received: from p4ff586ea.dip0.t-ipconnect.de ([79.245.134.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 14:51:13 +0100
Received: from holger.hoffstaette by p4ff586ea.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 14:51:13 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Possible to undo subvol delete?
Date: Mon, 1 Dec 2014 13:50:57 +0000 (UTC)
Message-ID: <pan.2014.12.01.13.50.56@googlemail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
	<20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com>
	<CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 01 Dec 2014 14:38:16 +0100, MegaBrutal wrote:

> I've also noticed, a subvolume can just be deleted with an "rm -r",
> just like an ordinary directory. I'd consider to only allow subvolume

Nope:

root>btrfs subvolume create foo
Create subvolume './foo'
root>touch foo/bla
root>ll foo 
total 0
-rw-r--r-- 1 root root 0 Dec  1 14:47 bla
root>rm -rf foo 
rm: cannot remove ‘foo’: Operation not permitted
root>

The files of the subvolume do get deleted though, but that's correct.

Not sure what you did, but what you want is already the case.

-h

