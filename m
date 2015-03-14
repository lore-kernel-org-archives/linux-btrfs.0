Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:47137 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbbCNCov (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 22:44:51 -0400
Message-ID: <5503AA56.4050407@pobox.com>
Date: Fri, 13 Mar 2015 20:26:14 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Any Arguments for/against --bind mounts?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there any practical reason to prefer bind mounts or separately 
mounting a subvolume?

e.g. assuming /locationA and /locationB are arbitrarily far apart in the 
file system tree, is there any reason to prefer one of the following 
over the other

mount -t btrfs -o subvolume=/thing /dev/sdN1 /locationA
mount --bind /locationA /locationB

vs.

mount -t btrfs -o subvolume=/thing /dev/sdN1 /locationA
mount -t btrfs -o subvolume=/thing /dev/sdN1 /locationB

Are both equally efficient and whatnot?

