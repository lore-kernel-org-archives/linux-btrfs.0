Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab3DKM3Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 08:29:16 -0400
Date: Thu, 11 Apr 2013 14:29:15 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Alex Elsayed <eternaleye@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: lvm volume like support
Message-ID: <20130411122915.GU18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
 <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
 <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
 <201302261130.31494.Martin@lichtvoll.de>
 <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
 <20130227100558.37d86d82@natsu>
 <kgkhcp$dfg$1@ger.gmane.org>
 <kgklb0$g6a$1@ger.gmane.org>
 <kgkm75$p2g$1@ger.gmane.org>
 <20130408120109.GA18193@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408120109.GA18193@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 02:01:09PM +0200, David Sterba wrote:
> problem 1: size of 'file' was 77 GB
> problem 2: umount was fine, remounted again and now size of 'file' is 0

Works fine with a recent kernel (3.9).
