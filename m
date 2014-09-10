Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s11.hotmail.com ([65.54.190.22]:52419 "EHLO
	BAY004-OMC1S11.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbaIJVAo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 17:00:44 -0400
Message-ID: <BAY168-DS1747B8D83FA04E0D49D89AC1CF0@phx.gbl>
From: Samer Al-Kiswany <samera@ece.ubc.ca>
To: <linux-btrfs@vger.kernel.org>
Subject: mkdir and fsync
Date: Wed, 10 Sep 2014 13:55:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thank you for help.

I am seeing a strange behavior when fsync()ing a directory.

Here is what I do

for (i=0; i < 100,000, i++){
	.
      mkdir(p/child_i)
      fsync(p)
}

Btrfs seems to achieve around 100k fsycs/second, which makes me believe it
is not touching the disk during these fsyncs.
After looking at the code, it seems indeed that fsync adds the inode to the
current transaction but does not sync the transaction to disk.

Is this the intended behavior for metadata fsync or is this a bug?
Is this POSIX compliant?

Thank you for your help
-samer


