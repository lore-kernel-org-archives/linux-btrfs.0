Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36217 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbcCNMkM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 08:40:12 -0400
Received: by mail-ob0-f173.google.com with SMTP id m7so173732383obh.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 05:40:11 -0700 (PDT)
MIME-Version: 1.0
From: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Date: Mon, 14 Mar 2016 09:39:51 -0300
Message-ID: <CAFENT7Ky+DXPSvKmMHcSW4+Nu2Fb0sAu_yZ4DPgNhHQ3bHO0jA@mail.gmail.com>
Subject: dedup and receive -p
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was trying to find a definitive information about this, but could not ...

AFAIK,  defrag breaks CoW and send/receive -p. I was wondering whether
deduplication would break it too, i.e. if doing a send/receive to
transfer a subvolume, running dedup, and then using said subvolum as a
parent with send -p would work or not.

Sylvain
