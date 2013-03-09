Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54861 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3CIViX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:38:23 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so2220534lbb.13
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 13:38:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
From: Harald Glatt <mail@hachre.de>
Date: Sat, 9 Mar 2013 22:38:01 +0100
Message-ID: <CAFWF=ans6uvoW7yXj_dgKsgCzTq+HpP9fAJLVaOAOzW_SuU16A@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 9, 2013 at 9:31 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>    Some time ago, and occasionally since, we've discussed altering the
> "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> number of copies, m is the number of (data) devices in a stripe per copy,
> and p is the number of parity devices in a stripe.
>
>    The current kernel implementation uses as many devices as it can in the
> striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
> written as "mS" (with a literal "m"). The mS and pP sections are omitted
> if the value is 1S or 0P.
>
>    The magic look-up table for old-style / new-style is:
>
> single           1C (or omitted, in btrfs fi df output)
> RAID-0           1CmS
> RAID-1           2C
> DUP                      2CD
> RAID-10          2CmS
> RAID-5           1CmS1P
> RAID-6           1CmS2P
>
>    The following patch set modifies userspace tools to accept C/S/P formats
> in input (mkfs and the restriper). The older formats are also accepted. It
> also prints the newer formats by default in btrfs fi df, with an option to
> show the older format for the traditionalists.
>
>    I'm not sure whether we should omit the 1C in btrfs fi df output, or
> make it explicit even in the "single" case.
>
>    Hugo.
>
> Hugo Mills (5):
>   Use nCmSpP format for mkfs
>   Move parse_profile to utils.c
>   Convert balance filter parser to use common nCmSpP replication-level
>     parser
>   Change output of btrfs fi df to report new (or old) RAID names
>   Add man page description for nCmSpP replication levels
>
>  cmds-balance.c      |   23 +++------
>  cmds-filesystem.c   |  135 +++++++++++++++++++++++++++++++++++++++++++--------
>  man/btrfs.8.in      |    9 ++++
>  man/mkfs.btrfs.8.in |   24 ++++++++-
>  mkfs.c              |   35 ++++---------
>  utils.c             |   94 +++++++++++++++++++++++++++++++++++
>  utils.h             |    1 +
>  7 files changed, 258 insertions(+), 63 deletions(-)
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I vote make it explicit to give people a chance to understand the new
way it works even with just one device. The idea for this new naming
scheme is great, I like it!! Will btrfs allow for things like 2C10SP2
too? Basically two RAID6 arrays with 12 drives each (10 for data, 2
for parity), if I understand it right with the entire array being
mirrored to another one.
