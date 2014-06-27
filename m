Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaF0Nm7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 09:42:59 -0400
Date: Fri, 27 Jun 2014 15:42:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
Message-ID: <20140627134257.GE1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53AC84C9.2080106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53AC84C9.2080106@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 26, 2014 at 03:38:33PM -0500, Eric Sandeen wrote:
> +FILE ATTRIBUTES
> +---------------
> +The btrfs filesystem supports setting the following file
> +attributes the `chattr`(1) utility
> +append only (a), no atime updates (A), compressed (c), no copy on write (C),
> +no dump (d), synchronous directory updates (d), immutable (i),
> +synchronous updates (S), and no compression (X).

The formatting is not eye-pleasing.

I've spotted a few mistakes:

* 'd' is listed twice, for sync directory updates it's 'D'

* and 'X' does not mean "no compression" and never has, although I'd
  like to see a chattr bit for that because we have the corresponding
  inode bit

I've checked your patches, the meaning of 'X' hasn't changed.

I took the opportunity and reformated the options:

@@ -183,9 +183,24 @@ FILE ATTRIBUTES
 ---------------
 The btrfs filesystem supports setting the following file
 attributes the `chattr`(1) utility
-append only (a), no atime updates (A), compressed (c), no copy on write (C),
-no dump (d), synchronous directory updates (d), immutable (i),
-synchronous updates (S), and no compression (X).
+
+*a* -- append only
+
+*A* -- no atime updates
+
+*c* -- compressed
+
+*C* -- no copy on write
+
+*d* -- no dump
+
+*D* -- synchronous directory updates
+
+*i* -- immutable
+
+*S* -- synchronous updates

 For descriptions of these attribute flags, please refer to the
 `chattr`(1) man page.
---

looks almost the same in the manpage and gives IMO a good
overview. For initial patch I'm ok with the descriptions, we can enhance it
later with btrfs specifics.

Are you ok with the proposed changes? (I don't want to bother with
resending for simple changes.)
