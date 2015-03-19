Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35621 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbCSTJH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 15:09:07 -0400
Received: by ykfs63 with SMTP id s63so32083817ykf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 12:09:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550A08AC.7070506@graphitesystems.com>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
	<CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
	<550A08AC.7070506@graphitesystems.com>
Date: Thu, 19 Mar 2015 13:09:06 -0600
Message-ID: <CAJCQCtSrR7tOQMkbKdk5y2FJ7J2nYNAAjowRnic2O13wa3d1PA@mail.gmail.com>
Subject: Re: syntax for deleting subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: K Richard Pixley <rpixley@graphitesystems.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 5:22 PM, K Richard Pixley
<rpixley@graphitesystems.com> wrote:
> Most of the uses I have for btrfs involve fairly dynamic use of snapshots,
> typically by non-root users.

Another thing. Some distros behave this way:

chris@linux-6gc0:~> btrfs sub list /
Absolute path to 'btrfs' is '/usr/sbin/btrfs', so running it may
require superuser privileges (eg. root).

As is the case on openSUSE. On Fedora, any user can use the btrfs
command, without sudo, and even without being in group wheel. Kindof a
stark difference, I'm vaguely curious about the security implications.
So this normal/non-admin user I'm logged in right now can create
subvolumes and snapshots at will, but I can't delete them (as
previously mentioned).

Erkki's cp --reflink idea is a good one. I've often wondered if it's a
good idea, and possible, to eventually make --reflink the default
behavior with Btrfs copies (I think some things probably first need
enhancement like the cross subvolume stuff, because otherwise cp could
fail inexplicably).

-- 
Chris Murphy
