Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaHTWVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 18:21:04 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KML3ZR003655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:21:03 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMKu6h022565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:21:03 -0400
Message-ID: <53F51F4D.2090203@redhat.com>
Date: Wed, 20 Aug 2014 17:21:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] btrfs-progs: remove full /dev scanning
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs fileystem show and btrfs device scan today both have
the "-d" option to scan everything under /dev.  But we also
have a mechanism to scan everything in /proc/partitions, which
should always be sufficient.

If anyone knows why we'd find something deep under /dev but
not in /proc/partitions, speak now or forever hold your peace...

Tested this by running through a matrix of -d, -m, or "" args
for show/scan, for a 2-device fs, with and without a symlinked
device, with and without a symlinked mountpoint.  All output was
identical.

Thanks,
-Eric
