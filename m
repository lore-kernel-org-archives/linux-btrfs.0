Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kwak.cryptyx.com ([176.9.47.209]:33520 "EHLO kwak.cryptyx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2LMNEF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 08:04:05 -0500
Message-ID: <50C9D085.3020305@junod.info>
Date: Thu, 13 Dec 2012 13:56:37 +0100
From: Pascal Junod <pascal@junod.info>
MIME-Version: 1.0
To: pascal@junod.info
Subject: [btrfs] is vulnerable to a hash-DoS attack
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello folk,

The btrfs file system, part of the linux kernel, is vulnerable to a
trivial hash-DoS attack. More details can be found here:

http://crypto.junod.info/2012/12/13/hash-dos-and-btrfs/

Enjoy!

Pascal Junod
--
http://crypto.junod.info
@cryptopathe
