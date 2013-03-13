Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52778 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3CMLbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 07:31:06 -0400
Message-ID: <51406375.6050502@petaramesh.org>
Date: Wed, 13 Mar 2013 12:31:01 +0100
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Bart Noordervliet <bart@noordervliet.net>
CC: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Debian 3.7.1 BTRFS crash
References: <201303131238.33692.russell@coker.com.au> <513FDE67.1050907@redhat.com> <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com> <CAGy7Uthf3P-4eefV-RbJQ=mW=OpjR3CXauPfCSbiv5eKMa5H8Q@mail.gmail.com>
In-Reply-To: <CAGy7Uthf3P-4eefV-RbJQ=mW=OpjR3CXauPfCSbiv5eKMa5H8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 13/03/2013 11:56, Bart Noordervliet a écrit :
> USB flash drives are rubbish for any filesystem except FAT32 and then
> still only gracefully accept large sequential writes. A few years ago
> I thought it would be a good idea to put the root partition of a few
> of my small Debian servers on USB flash, so that the harddisks could
> spin down at night and I could easily prepare and switch a new
> Debian-version. However, each and every USB stick got trashed within a
> year
I have an ARM box that runs a little Debian server (typically an
advanced NAS), it uses an USB key as an ext2 root filesystem. Everything
but big storage is there, and it's been up and running 24/7 for 3+ years
without any USB key incident...

The USB key is a cheap 1 GB Verbatim I purchased from the next drugstore ;-)

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

