Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35841 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbcBDSWc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 13:22:32 -0500
Received: by mail-ig0-f169.google.com with SMTP id xg9so31684914igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 10:22:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
Date: Thu, 4 Feb 2016 11:22:31 -0700
Message-ID: <CAJCQCtSrhGYOWOH=Pt4r3+YEKBxYkBGdQCYgQNd5LrhX1oq2Vg@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Chris Murphy <lists@colorremedies.com>
To: Moviuro <moviuro@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 3, 2016 at 2:54 PM, Moviuro <moviuro@gmail.com> wrote:
> Hi all,
>
> I should have done this a long time ago, so here goes.
>
> Btrfs is certainly the best FS out there but btrfs(8) is a pain to use in
> scripts. That is, it talks way too much, exposes unparseable outputs and
> has inconsistent behavior.
>
> I strongly believe that the CLI may use a complete revamp, that is: think
> of the needed/wanted output. I actually ran into this frustrating behavior
> while writing butter (https://github.com/moviuro/butter).

What about interfacing with libbtrfs? There's also libblockdev-btrfs,
and storaged-btrfs (both are not upstream, but may benefit from a
strong libbtrfs if they use it.)


-- 
Chris Murphy
