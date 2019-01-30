Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0F7C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 01:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E977520844
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 01:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Qr1dqOT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfA3BC5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 20:02:57 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:37408 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfA3BC5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 20:02:57 -0500
Received: by mail-lj1-f169.google.com with SMTP id t18-v6so19230398ljd.4
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 17:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gUwhbVzHMYc1fmo7FM9tqD2ZDCLQxqXwAjs7L+ph+pU=;
        b=Qr1dqOT2wzY3qo8/XSoreei9WS4LZkj+QQeBh7Az36LuyKjS0ZDexxyHOrjYkhslt5
         me2DXhM8qpbYOd7kRhbKkygMnKf3fOW9GSeclkJf35UxAkbQJqe4FEdCgGF6K1XZfGP+
         TBwLbCpE9zRWgTgftgKk198Gt6RZXf4jB/Iq0AN756Jp5ArWLJ4bC/hG0y8miwsJQ9gD
         0KI8LLvSEcs9aS1L+1i77/t8rvcfIs2Lv191O7YHuK7udsj2KP3ehCQGMeUJm33ZpFqE
         pw4LTs//6W+KARK3Gpt0POxLV1a2eO27NU0/ggrE4L/RzR+vzTsnedB0i4+vvHFa3uM5
         pMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gUwhbVzHMYc1fmo7FM9tqD2ZDCLQxqXwAjs7L+ph+pU=;
        b=uKDlGuFBe3gEyOkiTxBHz70bY43lRL9LJQzJvB1Rn70d7xD9qFrjOzLRghcLLwA/VL
         hn0r6pkrnBnjyuJtZWubg35MD2OJ1Jibbf5uq2zPydagpERF1G1DhIJhfxYXxzJBP9rt
         Drg93o+3yHvRRwK4YYgFDOZPmygYhTRUnlDl5/vGcOggbJxujMG+Jj7ZBuMmOPHVf/nW
         QJYOFBG8fhwzs3N6c27q8UQRrlpq9EQt7tJ/txxIQNQPv9nmq39Ngpf9REzjbOevffIK
         JALh+CsOqYusYrj5hnbHQ/3jTd9irMFs1mQKDQMTcpMshjqvMRQx+rmTWUvgpMu8hcgL
         GvJA==
X-Gm-Message-State: AJcUukdqX8aMYRqP1rBspz1bsABo6oiylT69z32qpnskoW/XWP0N6Y8F
        3dIWbblsd3vENG8i6lmIfmrC+6q4vassMxgJ5WJDlajRWtw=
X-Google-Smtp-Source: ALg8bN6OrvRKWMnJDUhvTxRBdPjPobO+VNQjqiHWOqzBuAcAaxuVOT9QyLUdHMwuZbCJ50oC4kbndFWwQhsMtiy1sD4=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr21931243lja.24.1548810175017;
 Tue, 29 Jan 2019 17:02:55 -0800 (PST)
MIME-Version: 1.0
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
In-Reply-To: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 29 Jan 2019 18:02:43 -0700
Message-ID: <CAJCQCtS0oSOxEg_zr5RhDZD8122Qk76_GD=+vDQMjXbMYYMDRw@mail.gmail.com>
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 4:15 PM Hans van Kranenburg
<Hans.van.Kranenburg@mendix.com> wrote:
>
> Hi,
>
> Thought experiment time...
>
> I have an HP z820 workstation here (with ECC memory, yay!) and 4x250G
> 10k SAS disks (and some spare disks). It's donated hardware, and I'm
> going to use it to replace the current server in the office of a
> non-profit organization (so it's not work stuff this time).
>
> The machine is going to run Debian/Xen and a few virtual machines
> (current one also does, but the hardware is now really starting to fall
> apart).
>
> I have been thinking a bit how to (re)organize disk storage in this
> scenario.
>
> 1. Let's use btrfs everywhere. \:D/
> 2. For running Xen virtual machines, I prefer block devices on LVM. No
> image files, no btrfs-on-btrfs etc...
> 3. Oh, and there's also 1 MS Windows VM that will be in the mix.
>
> Obviously I can't start using multi-device btrfs in each and every
> virtual machine (a big pile of horror when one disk dies or starts
> misbehaving).
>
> So, what I was thinking of is:
>
> * Use dm-integrity on partitions on the individual disks
> * Use mdadm RAID10 on top (which is then able to repair bitrot)
> * Use LVM on top
> * Etc...
>
> For all of the filesystems, I would be doing backups to a remote
> location outside of the building with send/receive.
>
> The Windows VM will be an image file on a btrfs filesystem in the Xen
> dom0. It's idle most of the time, and I think cow+autodefrag can easily
> handle it. I'd like to be able to take snapshots of it which can be sent
> to a remote location.

I'd consider thinp LV's for VM's. They are way more efficient for
snapshots than thickp (conventional) LVM snapshots. There is no
command to compute, send/receive only the LVM extents that are changed
though.  And this includes for NTFS. In effect, you can shrink any LV
without literally shrinking it, you just need to execute fstrim on the
mounted volume (you can use discard mount option from inside each VM;
or enable fstrim.timer), and this will cause unused LVM logical
extents to be returned to the thin pool, which can then be used by any
other LV that draws from that pool.

It's been a couple years since I tested NTFS in a Raw file on Btrfs
but at that time it was just pathological and I gave up. It was so
slow. Btrfs on Raw image on Btrfs was way faster. You could also
consider XFS on LVM or plain partition, with a qcow2 file as backing.
Snapshots are supported by creating a new image that points to another
as a backing file. And you can easily backup these snapshots as they
are discrete files.


> Now, to finally throw in the big question: If I use btrfs everywhere,
> can I run dm-integrity without a journal?

The documentation says if you run without a journal, dm-integrity is
no longer crash safe, i.e. it's no longer atomic operation. That to me
is the whole point of dm-integrity so I wouldn't do it even if I'm
using Btrfs on top.


>
> As far as I can reason about.. I could. As long as there's no 'nocow'
> happening, the only thing that needs to happen correctly is superblock
> writes, right?

Metadata is always cow. There is a nodatacow mount option but that
doesn't affect metadata. But in either case the whole point of having
dm-integrity in place is to have a Linux block device layer that tells
you if there has been some kind of storage stack corruption; to make
silent corruption visible. And that's not as effective if it's
possible to get such corruption in the course of a crash or power
failure of some kind. It might be useful to ask on @linux-integrity
list.

http://vger.kernel.org/vger-lists.html#linux-integrity

-- 
Chris Murphy
