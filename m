Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.monte-stello.com ([37.187.65.79]:55411 "EHLO
	vps.monte-stello.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbbEAUOn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 May 2015 16:14:43 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by vps.monte-stello.com (Postfix) with ESMTP id 9C6EBA243AD
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2015 22:06:52 +0200 (CEST)
Received: from vps.monte-stello.com ([127.0.0.1])
	by localhost (vps.monte-stello.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id mhqnkdfpoRm1 for <linux-btrfs@vger.kernel.org>;
	Fri,  1 May 2015 22:06:52 +0200 (CEST)
Date: Fri, 1 May 2015 22:06:48 +0200
From: Antoine Sirinelli <antoine@monte-stello.com>
To: linux-btrfs@vger.kernel.org
Subject: How to find corrupted files?
Message-ID: <20150501200648.GA4418@kabis.intra.monte-stello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I had a btrfs system running for a couple of years with an old kernel
(3.14.xx). Recently I have tried to backup it to a remote host using the
send/receive functionality. It results in a couple of kernel oops. I
decided to upgrade the kernel to 3.16 (Debian Jessie) and I was able to
use send/receive without too much problems.

Since the kernel upgrade I have notices a lot of the following lines in
the kernel log:

[145059.990123] BTRFS info (device sda4): csum failed ino 101147 off 1114112 csum 1810207416 expected csum 3082675757
[145060.500612] BTRFS info (device sda4): csum failed ino 101148 off 110592 csum 1418370968 expected csum 496354029

I understand these are corrupted file. By running btrfs scrub, I have
been able to find some of them but I still have 20 inodes with failed
csum. As I have quite a lot of subvolumes (1075, mainly for backup), it
is not easy to find the path to the corrupted files. Is there an easy
way to find these files?

A side note, I have also noticed the following line appearing regularly
in the logs:

[58562.612121] btrfs_readpage_end_io_hook: 12 callbacks suppressed

Do you know what it means?

Many thanks for your help,

Antoine


--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVQ9zYAAoJEBffEMtnGaT5fKoQAJdJbe8eqQR/tgYoii83WrD8
P4VdsHaSMQ7VTP6l6yYkZ71LQbaxOG2aITPaQbAEWPvjcZ+h14R6Wds4MKkEwTH1
dr7JmTxB61TUFY6fC52XdfMaSlOfzAMBfMdvKPvASf/DmL29VgaKUFJzaRXBDxxo
jHAivM3EdYd1yLwHb9QV+W2r5Lmeo3AW7832VXQyv4mEuAVPx/mjJR12Adq9/VzO
3x0IpDGBMY9Y7TN8xedIylju1gtTjiyRUvm7ntDHe3zmO7tDIBNC+qNVPuwGlDtB
+tnm86ypATW5ViEaZWjV0oApUGQFoQ36pQnjtRw9A8JQxdAXp1FlRbCe1JqrUA/o
FwrIS1zQtIc86wUKEwdDP6VwSRDRosgQRgseV1+BqDY8ioJuRPXTOMmCcnJObNnG
4zORoW0XIzUL0hb6MIGRF3e/AS3T3G1Sy9DmT/DkxIPlRp9nmLC+5wkbOKFvBLZ1
CDzO166jZL9lc4VYShpMxMTn6zIO5++tVXne7voemghirXhDjYrLYp99wICRdlPp
iLWZ3ad8oLyJM4M0NeWmVeluBQ6UmtGuOaubDRMtiuhVyiYkuvZVG9vZUtCwib+s
mCbVMfLCM3KNR6YDeFqSCaWzpXM7uL6jtrTojSs8TOFKs2TrHeg5DR0kOITtkRSP
j2ACUYI9c4eXSXSLhQC/
=i8LF
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
