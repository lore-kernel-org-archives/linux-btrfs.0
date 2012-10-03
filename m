Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37172 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2JCR3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 13:29:08 -0400
Received: by oagh16 with SMTP id h16so7681515oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 10:29:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506C6934.5010904@middelthun.no>
References: <506C6934.5010904@middelthun.no>
Date: Wed, 3 Oct 2012 12:29:07 -0500
Message-ID: <CAKcLGm_Y9iomb2eroXULoQPiueA9Gpx_BcJ-MeFm6V+JraXUqA@mail.gmail.com>
Subject: Re: tree root
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: =?ISO-8859-1?Q?=D8ystein_S=E6ttem_Middelthun?=
	<oystein@middelthun.no>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 3, 2012 at 11:35 AM, Øystein Sættem Middelthun
<oystein@middelthun.no> wrote:
> Hi!
>
> I have a broken btrfs unable to mount because it is unable to find the tree
> root. Using find-root I find the following:
>
> Well block 14102764707840 seems great, but generation doesn't match,
> have=109268, want=109269
>
> Because the filesystem was last in use with a pre 3.2-kernel I am unable to
> use mount -o recovery, but restore seems to work when I specify the previous
> tree-root. My problem is however that the btrfs is so large I have nowhere
> to temporarily put all the files. I am currently running kernel 3.5. Does
> mount have an option to manually tell it to use the tree root at block
> 14102764707840?
>

If you do not have a suitable backup for these files, please make an
effort to do what you can with restore.  Some of the repair methods
out there have a possibility to make the situation worse.
