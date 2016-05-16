Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbcEPMO7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 08:14:59 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 5C16A3DE
	for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 12:14:58 +0000 (UTC)
Date: Mon, 16 May 2016 13:14:56 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: ptoscano@redhat.com
Subject: RFE: 'btrfs' tools machine readable output
Message-ID: <20160516121456.GA16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't have time to implement this right now, so I'm just posting
this as a suggestion/request ...

It would be really helpful if the btrfs tools had a machine-readable
output.

Libguestfs parses btrfs tools output in a number of places, eg:
https://github.com/libguestfs/libguestfs/blob/master/daemon/btrfs.c
This is a massive PITA because each time a new release of btrfs-progs
comes along it changes the output slightly, and we end up having
to add all sorts of hacks.

With machine-readable output, there'd be a flag which would
change the output.  eg:

$ btrfs filesystem show
Label: 'ROOT'  uuid: af471cfc-421a-4d51-8811-ce969f76828a
        Total devices 1 FS bytes used 5.29MiB
        devid    1 size 767.97MiB used 92.00MiB path /dev/sda2

would become:

$ btrfs --json filesystem show
{
  "devices": {
     "Label": "ROOT",
     "uuid": "af471cfc-421a-4d51-8811-ce969f76828a",
     /// etc
  }
}

By this example I don't mean that JSON has to be the format -- in fact
it's a terrible format with all sorts of problems -- any format which
is parseable with C libraries would do for us.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
