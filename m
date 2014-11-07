Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:45027 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKGBkp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 20:40:45 -0500
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id sA71eSnP012028
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Nov 2014 01:40:37 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: non-atomic xattr replacement in btrfs => rsync random errors
References: <oroasjals2.fsf@free.home>
Date: Thu, 06 Nov 2014 23:39:02 -0200
In-Reply-To: <oroasjals2.fsf@free.home> (Alexandre Oliva's message of "Thu, 06
	Nov 2014 22:37:17 -0200")
Message-ID: <orfvdvaix5.fsf@free.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[dropping rsync@lists.samba.org, it rejects posts from non-subscribers;
 refer to https://bugzilla.samba.org/show_bug.cgi?id=10925 instead]

On Nov  6, 2014, Alexandre Oliva <oliva@gnu.org> wrote:

> What makes the problem visible is that btrfs appears to have a race in
> its handling of xattr replacement, leaving a window between the removal
> of the old value and the insertion of the new one

The bugs described above occurred with rsync-3.1.0-5.fc20.x86_64 and
kernel-libre-3.16.7-200.fc20.gnu.x86_64.  The btrfs code in kernel-libre
is unchanged from the corresponding Fedora kernel.  The distro is BLAG
200k/x86_64, under development.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
