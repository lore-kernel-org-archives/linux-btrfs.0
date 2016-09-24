Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward5p.cmail.yandex.net ([77.88.31.20]:51004 "EHLO
        forward5p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754548AbcIXXdP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 19:33:15 -0400
From: Alexander Tomokhov <alexoundos@ya.ru>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <20160924123749.GR7138@carfax.org.uk>
References: <767591474719974@web21o.yandex.ru> <20160924123749.GR7138@carfax.org.uk>
Subject: Re: Does data checksumming remain for files with No_COW file attribute?
MIME-Version: 1.0
Message-Id: <1498471474759532@web22g.yandex.ru>
Date: Sun, 25 Sep 2016 02:25:32 +0300
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, so data checksumming does not remain for newly created empty files with No_COW attribute. I think it's an important trait of Btrfs behavior and should be added to wiki. So that users are informed that disabling CoW on a per-file basis also loses checksum correctness of such file.

24.09.2016, 15:37, "Hugo Mills" <hugo@carfax.org.uk>:
> On Sat, Sep 24, 2016 at 03:26:14PM +0300, Alexander Tomokhov wrote:
>>  There is an unanswered question at stackexchange:
>>  http://unix.stackexchange.com/q/303130/41572
>>
>>  Assume that we don't invoke mount options like nodatacow and nodatasum - operate only at file attributes level, which are controlled with lsattr/chattr. So does setting No_COW on a file (chattr +C) imply disabling data checksumming on it? The same way as mount options behave (nodatacow implies nodatasum)? Moreover may it disable checksumming only for newly written extents and keep for reading existing ones?
>
>    Yes, it does imply disabling checksums.
>
>    If you have extents in the file when +C is set, then the flag is
> ignored (even for new extents, as far as I know): you can only
> usefully set +C on a file with no extents.
>
>    So, to use +C, you either need to touch the file first, then set +C
> on it, then open the file and write to it, or you need to have +C set
> on the parent directory.
>
>    Hugo.
>
>>  --
>>  To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>  the body of a message to majordomo@vger.kernel.org
>>  More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> Hugo Mills | Comic Sans goes into a bar, and the barman says, "We
> hugo@... carfax.org.uk | don't serve your type here."
> http://carfax.org.uk/ |
> PGP: E2AB1DE4 |
