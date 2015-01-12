Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:63351 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbALQCC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 11:02:02 -0500
Received: by mail-yk0-f171.google.com with SMTP id 142so9520239ykq.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 08:02:00 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Jan 2015 17:02:00 +0100
Message-ID: <CAA7pwKM9WoGy0JbOfnLc9ifACcZMxbAan4XJqAMcqnfV-cWKtA@mail.gmail.com>
Subject: Btrfs on top of LUKS (dm-crypt)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Marc MERLIN <marc@merlins.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been looking at recommended cryptsetup options for Btrfs and I
have one question:

Marc uses "cryptsetup luksFormat --align-payload=1024" directly on a
disk partition and not on e.g. a striped mdraid. Is there a Btrfs
reason for that alignment?

http://marc.merlins.org/perso/btrfs/post_2014-04-27_Btrfs-Multi-Device-Dmcrypt.html

Thanks,
Patrik
