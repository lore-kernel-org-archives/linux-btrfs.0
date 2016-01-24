Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37635 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbcAXAM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 19:12:27 -0500
Received: by mail-ig0-f181.google.com with SMTP id h5so12412933igh.0
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 16:12:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSfgXtj-vjCfj31mp0nuWcdmYOe+DhcmT0VQsaXBEGaFg@mail.gmail.com>
References: <CAJCQCtRyyu3rdyyykEjf8neLh3R+12to_gcCpU2ss51dU-_7PA@mail.gmail.com>
	<20160123235536.GZ422@carfax.org.uk>
	<CAJCQCtSfgXtj-vjCfj31mp0nuWcdmYOe+DhcmT0VQsaXBEGaFg@mail.gmail.com>
Date: Sat, 23 Jan 2016 17:12:26 -0700
Message-ID: <CAJCQCtTDF1fKBeWb0GcFFkEFxBeLzNPSiqmS2+puvm2bs9eJnQ@mail.gmail.com>
Subject: Re: [bug] btrfs send -e option always fails ERROR: unexpected EOF in stream.
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also fails using this form:


[root@f23s ~]# btrfs send /mnt/root23s/root/testsub.0 | btrfs receive /brick1/
At subvol /mnt/root23s/root/testsub.0
At subvol testsub.0
[root@f23s ~]# btrfs send -p /mnt/root23s/root/testsub.0 -e
/mnt/root23s/root/testsub.1 /mnt/root23s/root/testsub.2
/mnt/root23s/root/testsub.3 /mnt/root23s/root/testsub.4 | btrfs
receive /brick1/
At subvol /mnt/root23s/root/testsub.1
At snapshot testsub.1
At subvol /mnt/root23s/root/testsub.2
ERROR: parent determination failed for 0
ERROR: unexpected EOF in stream.
