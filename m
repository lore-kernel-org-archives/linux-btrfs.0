Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:53022 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752605Ab2JHTvJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 15:51:09 -0400
Message-ID: <50732ED1.9030005@gmx.net>
Date: Mon, 08 Oct 2012 21:51:45 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: working quota example?
References: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com> <5072CEB6.6030709@gmx.net> <CAK=A7Ee84dXpc4DenR7-Sn8UPG-qTiRRS0fdvRCWT+hF1bPaSQ@mail.gmail.com>
In-Reply-To: <CAK=A7Ee84dXpc4DenR7-Sn8UPG-qTiRRS0fdvRCWT+hF1bPaSQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/08/12 21:31, matthieu Barthélemy wrote:

> 
> Are there any plan to maybe get a better 'btrfs quota show' output?

Definitely. The first priority was to get the kernel part running, when
that is settled, we can improve the user mode part. There's also still
some work to do to make the tracking qgroups more presentable.

> Maybe with more details, maybe a simple ' 1 subvolume + all its
> snapshots'  accounting.

Well, there's no such thing as 'the snapshot of a subvolume'. As in
btrfs each snapshot instantly is a subvolume in it's own right. Btrfs
doesn't really keep track which snapshot is a descendant of which.

> Maybe I missed something, and I admit I didn't read all the btrfs-progs
> patches related to qgroups, but there doesn't seem to have an option to
> show a subvolume's quota limit (not the referenced/exclusive usage
> counters). Am I right?

Probably, I don't remember :) That should be easy to fix anyway.

> 
> Thanks again Arne for your help!
> 
> 
> 

