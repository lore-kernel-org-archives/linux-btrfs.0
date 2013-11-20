Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3KTGlb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 01:41:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vj1Te-0008TM-15
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 07:41:30 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 07:41:30 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 07:41:30 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Date: Wed, 20 Nov 2013 06:41:18 +0000
Message-ID: <l6hli4$mae$1@ger.gmane.org>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com> <20131119090602.GV4315@carfax.org.uk> <CAEWPe=rMXVehpFNko-wZ1i4dKP21J8wJKj1R2jDSK2HsEYmduQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CAEWPe=rMXVehpFNko-wZ1i4dKP21J8wJKj1R2jDSK2HsEYmduQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/11/13 19:24, deadhorseconsulting wrote:
> Interesting, this confirms what I was observing.
> Given the wording in man pages for "-m" and "-d" which states "Specify
> how the metadata or data must be spanned across the devices
> specified."
> I took "devices specified" to literally mean the devices specified
> after the according switch.

That sounds like a hang-over from too many years use of the mdadm
command and more recently such as the sgdisk command...

;-)


Myself, I like the btrfs way to specify the list of parameters and then
they all then get applied as a whole.

The one bugbear at the moment is that for using multiple disks: Any
actions seem to be applied to the list of devices in sequence
one-by-one. There's no apparent intelligence to consider "present pool"
-> "new pool" of devices as a whole.


More development!

Regards,
Martin


