Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55182 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750975Ab2JMHBp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 03:01:45 -0400
Message-ID: <50791203.6060406@gmx.net>
Date: Sat, 13 Oct 2012 09:02:27 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fits: tool to parse stream
References: <1350048772-20658-1-git-send-email-sensille@gmx.net>
In-Reply-To: <1350048772-20658-1-git-send-email-sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/12/12 15:32, Arne Jansen wrote:

> The idea of the btrfs send stream format was to generate it in a way that
> it is easy to receive on different platforms. Thus the proposed name FITS, for
> Filesystem Incremental Backup Stream. We should also build the tools to
> receive the stream on different platforms.

I meant to write 'Filesystem Incremental Transport Stream', but, as
Andrey Kuzmin pointed out, the name FITS is already taken. As the
'Backup' slipped in somehow, FIBS might be an alternative. Any
thoughts?

-Arne
