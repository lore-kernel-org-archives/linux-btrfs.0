Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41077 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbbDGLlh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 07:41:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YfRss-0004nu-7R
	for linux-btrfs@vger.kernel.org; Tue, 07 Apr 2015 13:41:34 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 13:41:34 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 13:41:34 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
Date: Tue, 07 Apr 2015 12:41:21 +0100
Message-ID: <mg0fp1$ep4$1@ger.gmane.org>
References: <mfcdep$d97$1@ger.gmane.org> <20150331173756.GF6821@twin.jikos.cz> <mfeo14$sib$1@ger.gmane.org> <551B98FF.8070000@oracle.com> <mfgiot$3ck$1@ger.gmane.org> <551BEF67.3040305@oracle.com> <mfh9rn$2if$1@ger.gmane.org> <55228ADB.3000404@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <55228ADB.3000404@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/15 14:32, Anand Jain wrote:
> btrfs fi show -d


That gives:

# btrfs fi show -d
warning, device 3 is missing
warning devid 3 not found already
warning, device 3 is missing
warning devid 3 not found already
Label: 'btrfs_root'  uuid: 92452e9a-2775-45c4-922c-f01b2afd51c2
        Total devices 3 FS bytes used 30.94GiB
        devid    1 size 24.00GiB used 24.00GiB path /dev/sda4
        devid    2 size 24.00GiB used 24.00GiB path /dev/sdc4
        devid    3 size 24.00GiB used 24.00GiB path /dev/sde4

Label: 'btrfs_data'  uuid: d1b96638-be89-4291-8a40-f2f2e1dc5223
        Total devices 3 FS bytes used 95.74GiB
        devid    1 size 87.24GiB used 86.48GiB path /dev/sda5
        devid    2 size 87.24GiB used 87.24GiB path /dev/sdc5
        devid    3 size 87.24GiB used 87.24GiB path /dev/sde5

Label: 'btrfs_root2'  uuid: 62603ce8-c333-4ca7-92f7-f8bdd712ab37
        Total devices 3 FS bytes used 151.60MiB
        devid    1 size 24.00GiB used 24.00GiB path /dev/sdb4
        devid    2 size 24.00GiB used 24.00GiB path /dev/sdd4
        *** Some devices missing

Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
        Total devices 3 FS bytes used 159.34GiB
        devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
        devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
        *** Some devices missing

btrfs-progs v3.19.1


And without the "-d":

# btrfs fi show
Label: 'btrfs_root'  uuid: 92452e9a-2775-45c4-922c-f01b2afd51c2
        Total devices 3 FS bytes used 30.94GiB
        devid    1 size 24.00GiB used 24.00GiB path /dev/sda4
        devid    2 size 24.00GiB used 24.00GiB path /dev/sdc4
        devid    3 size 24.00GiB used 24.00GiB path /dev/sde4

Label: 'btrfs_data'  uuid: d1b96638-be89-4291-8a40-f2f2e1dc5223
        Total devices 3 FS bytes used 95.74GiB
        devid    1 size 87.24GiB used 86.48GiB path /dev/sda5
        devid    2 size 87.24GiB used 87.24GiB path /dev/sdc5
        devid    3 size 87.24GiB used 87.24GiB path /dev/sde5

Label: 'btrfs_root2'  uuid: 62603ce8-c333-4ca7-92f7-f8bdd712ab37
        Total devices 3 FS bytes used 151.60MiB
        devid    1 size 24.00GiB used 24.00GiB path /dev/sdb4
        devid    2 size 24.00GiB used 24.00GiB path /dev/sdd4
        devid    3 size 24.00GiB used 24.00GiB path /dev/sdf4

Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
        Total devices 3 FS bytes used 159.34GiB
        devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
        devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
        devid    3 size 206.47GiB used 206.47GiB path /dev/sdf5

btrfs-progs v3.19.1


Interestingly, all the log messages about /dev/sdf are now no longer
being repeated.

(And nope, not had a chance to swap that disk yet!)


Hence, should I do a "btrfs device delete missing /mnt/data2"?

Cheers,
Martin



