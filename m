Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41022 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbANWoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 17:44:10 -0500
Date: Wed, 14 Jan 2015 14:44:06 -0800
From: Marc MERLIN <marc@merlins.org>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs on top of LUKS (dm-crypt)
Message-ID: <20150114224406.GO13806@merlins.org>
References: <CAA7pwKM9WoGy0JbOfnLc9ifACcZMxbAan4XJqAMcqnfV-cWKtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA7pwKM9WoGy0JbOfnLc9ifACcZMxbAan4XJqAMcqnfV-cWKtA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 12, 2015 at 05:02:00PM +0100, Patrik Lundquist wrote:
> Hi,
> 
> I've been looking at recommended cryptsetup options for Btrfs and I
> have one question:
> 
> Marc uses "cryptsetup luksFormat --align-payload=1024" directly on a
> disk partition and not on e.g. a striped mdraid. Is there a Btrfs
> reason for that alignment?
> 
> http://marc.merlins.org/perso/btrfs/post_2014-04-27_Btrfs-Multi-Device-Dmcrypt.html

Sorry for the delay, and greetings from linux.conf.au :)

This was discussed here some time back, see
http://comments.gmane.org/gmane.comp.file-systems.btrfs/34763
(last message on that page)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
