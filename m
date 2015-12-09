Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:54896 "EHLO
	fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbbLIO6f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 09:58:35 -0500
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by fe1.digint.ch (Postfix) with ESMTPSA id 9E6991966A9
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 15:50:25 +0100 (CET)
Subject: Re: subvols and parents - how?
To: linux-btrfs@vger.kernel.org
References: <1448340960.14125.51.camel@scientia.net>
 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
 <1448400350.21291.88.camel@scientia.net>
 <pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>
From: Axel Burri <axel@tty0.ch>
Message-ID: <56683F82.5040203@tty0.ch>
Date: Wed, 9 Dec 2015 15:49:38 +0100
MIME-Version: 1.0
In-Reply-To: <pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-27 03:02, Duncan wrote:
>>> Then there's the security angle to consider.  With the (basically,
>>> possibly modified as I suggested) flat layout, mounting something
>>> doesn't automatically give people in-tree access to nested subvolumes
>>> (subject to normal file permissions, of course), like nested layout
>>> does.  And with (possibly modified) flat layout, the whole subvolume
>>> tree doesn't need to be mounted all the time either, only when you're
>>> actually working with subvolumes.
> 
>> Uhm, I don't get the big security advantage here... whether nested or
>> manually mounted to a subdir,... if the permissions are insecure I'll
>> have a problem... if they're secure, than not.
> 
> Consider a setuid-root binary with a recently publicized but patched on 
> your system vuln.  But if you have root snapshots from before the patch 
> and those snapshots are nested below root, then they're always 
> accessible.  If the path to the vulnerable setuid is as user accessible 
> as it likely was in its original location, then anyone with login access 
> to the system is likely to be able to run it from the snapshot... and 
> will be able to get root due to the vuln.
> 
> On a flat layout, a snapshot with the vuln would have to be mounted 
> before it could be accessed, as otherwise it'd be outside the mounted 
> tree.

Talking about security: If you split the "var" parts from the root, you
get a nice side-effect that the generation of the root subvolume does
not change until you update your system (e.g. by installing/updating
packages).

Consider this setup:

5
|
+--root (subvol)
|  |
|  +--var (subvol, or mounted)
|  +--tmp (subvol, or tmpfs)
|  +--run (subvol, or tmpfs)
|  +--home (subvol, or mounted)
|
+--snapshots (dir, uid=root,mode=700)
   |
   +--root.20150101
   +--root.20150102
   +--...

Now if you take a look at the output of "btrfs sub list -c /", you can
see exactly when your root subvolume has changed. This means if you
always create a new snapshot of "root" after you update your system, you
are able to spot changes to the system easily:

# btrfs sub list -c /
ID 100 gen 4242 cgen 50 top level 5 path root
ID 101 gen 4500 cgen 53 top level 5 path var
[...]
ID 5000 gen 4111 cgen 4111 top level 5 path snapshots/root.20151203
ID 5001 gen 4242 cgen 4242 top level 5 path snapshots/root.20151205
[...]

In this example, I can see that "root" has not been altered since
20151205, as "cgen" of the snapshot matches the "gen" of the root
subvolume. This is the last time I updated this system. If the "gen" of
the root subvolume would be greater than 4242, I know some changes were
made to the system root, and I can start tracking it down using "btrfs
subvol find-new".
