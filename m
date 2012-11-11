Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53600 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2KKOFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 09:05:32 -0500
Received: by mail-wi0-f172.google.com with SMTP id hm6so1761959wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2012 06:05:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509ED1D6.8010903@petaramesh.org>
References: <509ED1D6.8010903@petaramesh.org>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Sun, 11 Nov 2012 15:05:11 +0100
Message-ID: <CAGy7Utg5eMfHy+6OghTTDeHznnSvv2Ze11jCecLSLsVEufugeA@mail.gmail.com>
Subject: Re: BTRFS cache problem
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Swami,

which kernel version are you running?

Regards,

Bart

On Sat, Nov 10, 2012 at 11:14 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Hi,
>
> My BTRFS is mounted with space_cache,inode_cache , and I now get at boot
> time the following message :
>
> “btrfs: free space inode generation (0) did not match free space cache
> generation (189086)”
>
> Starting once with "clear_cache" doesn't seem to be able to fix the
> issue... Any clue ?
>
> TIA.
>
> --
> Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
