Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:53686 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbcC3GcK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 02:32:10 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1al9fk-0006wE-Bh
	for linux-btrfs@vger.kernel.org; Wed, 30 Mar 2016 08:32:08 +0200
Date: Wed, 30 Mar 2016 08:32:08 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160330063208.GH9342@torres.zugschlus.de>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <20160328184237.GA10135@torres.zugschlus.de>
 <21f3d8f6-3447-109f-d21e-0e7a696c94e2@mokrynskyi.com>
 <CAJCQCtQ-hD54h4g+pXFXXqfjk=aoC-7T3ejfeMC4AFPw8pDyjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtQ-hD54h4g+pXFXXqfjk=aoC-7T3ejfeMC4AFPw8pDyjw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 02:46:54PM -0600, Chris Murphy wrote:
> http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/tree/cmds-check.c
> line 7722 discusses this error message and it looks like there's no
> repair function for it yet; uncertain what problems can result from
> this.

This basically means that I am ripe for a new mkfs.btrfs, right?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
