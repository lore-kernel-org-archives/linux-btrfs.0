Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572C1C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 07:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2128620811
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 07:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="VPBmSti6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbfBEHht (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:37:49 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:34614 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfBEHhs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 02:37:48 -0500
Received: by mail-lj1-f174.google.com with SMTP id u89-v6so2066474lje.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2019 23:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qFXLazitmRy6bG+jjIGPhnUDtWWA7ZFGjNa8N1O2hcM=;
        b=VPBmSti65w1zqRN2EXM1aAcn+kmiOQkCmxUC+jfmmpz/O4RZh7zSbfq0u+Thodmg+E
         KuvGy6V4/7UqwNSnpepMWflyYSU1usf+c9WMkL3K9x9OqpjNLkRv58+ANBSA8aQVihDB
         DoRlLcMkT/gC8pjuoYcJ8cblDw1oe3OlhAwIAoKTMXkXFBs1P/xKU74v3MGl96b+fgY1
         IcfWfdL9c6aqThq/qMAkw2vSTGesaGH9/+sSiZnmezd85b8BS4NjUCYimSMW5Zg1bY/n
         cGaZesMSJg9aPbVqlf6z73g3jQ07TeXfjCRQHa35YUHPbZAnnwprx6gUcg/G68XaXMGb
         lSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qFXLazitmRy6bG+jjIGPhnUDtWWA7ZFGjNa8N1O2hcM=;
        b=TgKFieem+2wXPWP+h9t0csNUrfJ1i23bYGTRQuoW6YFY55yPwpWdgTOE4SH988xZe1
         Vx7lgRsp7siTHond70sZa77qajXthtuOCKC+6j3goC9d7KX6gdUMmS4xOiHlc51jhtnP
         M0AX2CBoDDaCA/NSkj8YuGfOKaalGnZ5aaU5kMyKynsAI0ZRE18rMGhdagYaSMPDKYzx
         yfS2BXBh5/NaJkgT3LYsBeRC3X++wZRpf0XFuQBUKt4LCaFkNjS2bjoU6DB5nS/6NJ78
         I99Pqc1IiuClAwcQBbgFZvtTe1VqOlbc1+JhnTmkui5tblc1DHPS6Ki++XuoAn0S3RPz
         0fZw==
X-Gm-Message-State: AHQUAuYDeflwbNY2c1RqFC375WTgTyPAnwJ18INy/zOZ3ux+n0WU/QmG
        Vfda+OW9aTR99bNrZySjLyBXhKKFMCsr/zkOYCFxrgi+M0w=
X-Google-Smtp-Source: AHgI3IbSYlIzKrB+C9J0p0mNLMEfz+K0veP7VU6mDK5fwS96If3mwBZ3GZzjAHdwV+i43fY6qK7BpK3pzGpjKQ5v3z0=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr1997196lja.24.1549352266271;
 Mon, 04 Feb 2019 23:37:46 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
 <CAA7pwKN9B7LZEo7Op0PndTnU6jo3JdtLi0vdphXZakgbKBB-9w@mail.gmail.com>
 <b879a985-c991-b4b3-590e-d2aa1a5fa5c5@gmail.com> <CAA7pwKOXcsh__Cw0WBLW8g1LA239kmcyWcDmz6ksZ+Tbu1NK-Q@mail.gmail.com>
 <CAJCQCtQh3hmShOzSCaYRjpKZ6B7rN1QPd9Ak2EyeTMKpLCy_2A@mail.gmail.com>
In-Reply-To: <CAJCQCtQh3hmShOzSCaYRjpKZ6B7rN1QPd9Ak2EyeTMKpLCy_2A@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 5 Feb 2019 00:37:34 -0700
Message-ID: <CAJCQCtQ2fzZQGQf+H-nNgbJ51pHxq0Y=FPUJvekAqaN8HZa9RA@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 4, 2019 at 11:46 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> After remounting both devices and scrubbing, it's dog slow. 14 minutes
> to scrub a 4GiB file system, complaining the whole time about
> checksums on the files not replicated. All it appears to be doing is
> replicating metadata at a snails pace, less than 2MB/s.


OK I see what's going on. The raid1 data chunk was not full, so
initially rw,degraded writes went there. New writes went to a single
chunk. Upon unmounting, restoring the missing device, and mounting
normally:

Data,single: Size:13.00GiB, Used:12.91GiB
   /dev/mapper/vg-test2      13.00GiB

Data,RAID1: Size:2.00GiB, Used:1.98GiB
   /dev/mapper/vg-test1       2.00GiB
   /dev/mapper/vg-test2       2.00GiB

Metadata,single: Size:1.00GiB, Used:0.00B
   /dev/mapper/vg-test2       1.00GiB

Metadata,RAID1: Size:1.00GiB, Used:15.91MiB
   /dev/mapper/vg-test1       1.00GiB
   /dev/mapper/vg-test2       1.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/mapper/vg-test2      32.00MiB

System,RAID1: Size:8.00MiB, Used:0.00B
   /dev/mapper/vg-test1       8.00MiB
   /dev/mapper/vg-test2       8.00MiB


So it's demoted system chunk to single profile, new data chunk is also
single profile. And even though it created a single profile metadata
chunk it's not using it, instead it continues to use the not full
raid1 profile metadata chunks, presumably until they're all full and
then only once new data chunks need to be allocated are they single
chunk.

mdadm and LVM upon assembly once all devices are present again,
detects the stale device from its lower count, and knows what blocks
to replicate from the write intent bitmap, and starts this
sync/replication right away - before even mounting the file system. So
Btrfs is neither automatic, nor obvious that you have to do a
*balance* rather than a scrub in this case, which looks like it only
happens in the single device degraded case (I assume if it were a 3
device array with a missing device, raid1 chunks can still be created
and thus this situation doesn't happen).

With a very new file system, perhaps most of the data written while
rw,degraded mounted goes to single profile chunks. That permits use of
the soft filter when converting to avoid full balance (a full sync).
However, that's not certain. So the safest single option is
unfortunately a full balance with convert filter only. The most
efficient is to use both convert and soft filter (for data only;
metadata must be hard converted); followed by a scrub.

*sigh* it's non obvious that the user must intervene, and then also
what they need to do is non-obvious. For sure mdadm and LVM are better
in this case, simply because it does the right thing to re-establish
the expected replication automatically.

-- 
Chris Murphy
