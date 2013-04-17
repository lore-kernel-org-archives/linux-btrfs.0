Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:54637 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab3DQGzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 02:55:08 -0400
Date: Wed, 17 Apr 2013 08:55:06 +0200
From: Sander <sander@humilis.net>
To: Matt Pursley <mpursley@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
Message-ID: <20130417065506.GA21083@panda>
Reply-To: sander@humilis.net
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matt Pursley wrote (ao):
> I have an LSI HBA card (LSI SAS 9207-8i) with 12 7200rpm SAS drives
> attached.  When it's formated with mdraid6+ext4 I get about 1200MB/s
> for multiple streaming random reads with iozone.  With btrfs in
> 3.9.0-rc4 I can also get about 1200MB/s, but only with one stream at a
> time.

Just curious, is that btrfs on top of mdraid6, or is this experimental
btrfs raid6 without md?
