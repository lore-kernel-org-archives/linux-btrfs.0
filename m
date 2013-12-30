Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44025 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3L3BWZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 20:22:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VxRYm-0006Pc-4X
	for linux-btrfs@vger.kernel.org; Mon, 30 Dec 2013 02:22:24 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 02:22:24 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 02:22:24 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Migrate to bcache: A few questions
Date: Mon, 30 Dec 2013 02:22:55 +0100
Message-ID: <fgu6pa-f1b.ln1@hurikhan77.spdns.de>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de> <45EA1F82-A774-4729-9279-D58ACF819B05@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> I think most of these questions are better suited for the bcache list.

Ah yes, you are true. I will repost the non-btrfs related questions to the 
bcache list. But actually I am most interested in using bcache together 
btrfs, so getting a general picture of its current state in this combination 
would be nice - and so these questions may be partially appropriate here.

> I
> think there are still many uncertainties about the behavior of SSDs during
> power failures when they aren't explicitly designed with power failure
> protection in mind. At best I'd hope for a rollback involving data loss,
> but hopefully not a corrupt file system. I'd rather lose the last minute
> of data supposedly written to the drive, than have to do a fuil restore
> from backup.

These thought are actually quite interesting. So you are saying that data 
may not be fully written to SSD although the kernel thinks so? This is 
probably very dangerous. The bcache module could not ensure coherence 
between its backing devices and its own contents - and data loss will occur 
and probably destroy important file system structures.

I understand your words as "data may only partially being written". This, of 
course, may happen to HDDs as well. But usually a file system works with 
transactions so the last incomplete transaction can simply be thrown away. I 
hope bcache implements the same architecture. But what does it mean for the 
stacked write-back architecture?

As I understand, bcache may use write-through for sequential writes, but 
write-back for random writes. In this case, part of the data may have hit 
the backing device, other data does only exist in the bcache. If that last 
transaction is not closed due to power-loss, and then thrown away, we have 
part of the transaction already written to the backing device that the 
filesystem does not know of after resume.

I'd appreciate some thoughts about it but this topic is probably also best 
moved over to the bcache list.

Thanks,
Kai 

