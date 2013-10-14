Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50756 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151Ab3JNVoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 17:44:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VVpvi-0000h4-OK
	for linux-btrfs@vger.kernel.org; Mon, 14 Oct 2013 23:43:58 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 23:43:58 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 23:43:58 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: No apparent effect for "btrfs device delete missing"
Date: Mon, 14 Oct 2013 22:43:45 +0100
Message-ID: <l3hoi8$kqv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trying:

btrfs device delete missing /

appears not to do anything for a "/" mount for where I have swapped out
a HDD:


# btrfs filesystem show
Label: 'test_btrfs_misc_5'  uuid: 7d29d4e6-efdc-41dc-9aa8-e74dfbe13cc9
        Total devices 2 FS bytes used 28.00KB
        devid    1 size 59.74GB used 2.03GB path /dev/sdd5
        *** Some devices missing

Label: 'test_btrfs_root_4'  uuid: 269e142c-e561-4227-b2b0-fe2f9fb99391
        Total devices 3 FS bytes used 10.55GB
        devid    4 size 56.00GB used 12.03GB path /dev/sde4
        devid    1 size 56.00GB used 12.05GB path /dev/sdd4
        *** Some devices missing

Btrfs v0.20-rc1-358-g194aa4a
# btrfs device delete missing /
# btrfs filesystem show
Label: 'test_btrfs_misc_5'  uuid: 7d29d4e6-efdc-41dc-9aa8-e74dfbe13cc9
        Total devices 2 FS bytes used 28.00KB
        devid    1 size 59.74GB used 2.03GB path /dev/sdd5
        *** Some devices missing

Label: 'test_btrfs_root_4'  uuid: 269e142c-e561-4227-b2b0-fe2f9fb99391
        Total devices 3 FS bytes used 10.55GB
        devid    4 size 56.00GB used 12.03GB path /dev/sde4
        devid    1 size 56.00GB used 12.05GB path /dev/sdd4
        *** Some devices missing

Btrfs v0.20-rc1-358-g194aa4a


All on the latest "Linux 3.11.5-gentoo".

# df -h | egrep '/$'
rootfs          112G   22G   89G  20% /
/dev/sdd4       112G   22G   89G  20% /



Aside: Adding the /dev/sde4 device caused no balance action until I
deleted a device to reduce the raid1 mirror (data and metadata) down to
the two devices.

The "missing" device was an old HDD that had physically failed. No data
was lost for that example failure.


Hope of interest,
Martin


