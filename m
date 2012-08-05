Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:52143 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab2HEI5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Aug 2012 04:57:45 -0400
Message-ID: <501E3578.4030809@csamuel.org>
Date: Sun, 05 Aug 2012 18:57:28 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Olivier Bonvalet <btrfs.list@daevel.fr>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
References: <501987FF.9080304@daevel.fr> <20120802132259.GO17430@twin.jikos.cz> <501A836F.90506@daevel.fr> <20120802135354.GQ17430@twin.jikos.cz> <501AA842.5080300@daevel.fr> <501C53B7.30601@daevel.fr>
In-Reply-To: <501C53B7.30601@daevel.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/04/2012 08:41 AM, Olivier Bonvalet wrote:

> Is there something I can do to fix that ? (the mount
> option "recovery" didn't help here)

I've seen someone (perhaps Marc Merlin) report that the
3.5.x kernel was able to mount a filesystem that 3.4.x
couldn't, so it might be worth a shot here!

Best of luck,
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
