Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:51275 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbAGMOk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 07:14:40 -0500
Date: Wed, 7 Jan 2015 13:14:38 +0100
From: Lennart Poettering <lennart@poettering.net>
To: Nehemiah Dacres <vivacarlie@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS_IOC_TREE_SEARCH ioctl
Message-ID: <20150107121438.GA21185@gardel-login>
References: <20150105171512.GA19126@gardel-login>
 <20150105182238.GE32182@carfax.org.uk>
 <20150105191156.GA19373@gardel-login>
 <20150105193501.GF32182@carfax.org.uk>
 <CAJSBqdfJ9EpR3AgLFkCEU+yYSPtJTyVvo5r15WaeF1UszQ_3Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJSBqdfJ9EpR3AgLFkCEU+yYSPtJTyVvo5r15WaeF1UszQ_3Yg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 05.01.15 19:14, Nehemiah Dacres (vivacarlie@gmail.com) wrote:

> Is libbtrfs documented or even stable yet? What stage of development is it
> in anyway? is there a design spec yet?

Note that the code we use in systemd is not based on libbtrfs, we just
call the ioctls directly.

Lennart

-- 
Lennart Poettering, Red Hat
