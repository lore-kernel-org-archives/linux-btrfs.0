Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED399C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E5521738
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="P//DqNwC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfBRVW4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:22:56 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43240 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729382AbfBRVW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 16:22:56 -0500
Received: by mail-lf1-f67.google.com with SMTP id j1so13338648lfb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 13:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=230Af2f2pAicrOcqupJbfKEhMD0axVo4gCKJYKEvIEI=;
        b=P//DqNwC1ojbQqWxzbZlLvQ+QHYSUz41kxWNdopZgaQMhWQJer2PjquW7bm1DerffR
         UjY9hu12VKxnc3sCZ+jbCybxMlVGDFBbhk5JqxbFF6BajqcE6ElrZm72wsK1ewWt1FbW
         hEg3r4oYdjmJco90bh1fIZOzmfcQy4DTTFFVHXMbMQE9D1wfJ0H+jZdKlAiOESSdDbZb
         3fz2ZAfxYTf5jeszgBBmBl+2vB8OhcW9G19SFv1oKJb+KlDpQQY4zDM0N65yXGxooDYV
         4sXBFxENwHinRfFVOg1XsNhvn44L4gKqFBAaEUP8RIcfp73OoEBwRw1+yVlMfvT59+G+
         +Img==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=230Af2f2pAicrOcqupJbfKEhMD0axVo4gCKJYKEvIEI=;
        b=cE5s14RcHMCyVseztvbfx+CwFU7+ap8zKhGu337IiWj4Pr2LYGUtpgOYiBGBiwqK1E
         cRSeUs03W5ggbfceBXHGFrfulrBY06IcQCzpHyRlDqPFJ6MWWjIwHY9/4jMh79nvSqCK
         94DcwrW4+Ov6DomKbTBA0QPralAtKl28V9Iz0utgnoMsrAJRfdodErX7SwU0NpjQNxqg
         x/Nhz+c0uFutXARBToTMhNw6earQ7reYPUy6xLKQy2vJ0ECYA0Dx2iliaqEmk+27mn0C
         roFQWXpd5mSUWxtac8q8vgBl7qS17gOGGTmVse1Tyb8kAhlUlXn7IRxjuAWDFbCUfwH4
         w2Pw==
X-Gm-Message-State: AHQUAuZEL6kfhmBrChC1fVWz4zfDCPG5Cae3cnzGpZ8/JD2XnfCXAzgb
        d6CJT+07InJv8YYR90pUoFn1IyJlVruYzMH6BGK/pcDq4B4=
X-Google-Smtp-Source: AHgI3Ib2lvYRmlFgxhNaREclC9gV/+HqpPDf/aN2ZQfXesPrirENwIX9TXk8z3dE1TQkWXWkB7NDNjXdJ/px75LrJTI=
X-Received: by 2002:ac2:4116:: with SMTP id b22mr14818884lfi.19.1550524974405;
 Mon, 18 Feb 2019 13:22:54 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org> <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org>
In-Reply-To: <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 14:22:42 -0700
Message-ID: <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 12:58 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:

> Basically what I'm trying to achieve is having a "reference" / "master"
> btrfs subvolume where i add / edit / remove files continuously. From
> where i can cp --reflink=3Dalways some of those files to new "child"
> subvolumes as needed. As long as the files are still in the master
> subvolume I'll only send the diff of the data. The plan is to have this
> master subvolume across multiple remote machines (synced with rsync or
> perhaps btrfs send / receive) and being able to update / change it as
> needed but always only sending the diffs of the child subvolumes. Maybe
> this is a bit optimistic.

I'm not sure what you get out of this method that depends on reflink
rather than just making read only snapshots.

Why don't you create subvolume A as the master, read-write. And once
it's in the "master state" you want, just snapshot it:

btrfs sub snap -r A A.20190218-master

And now continue to make changes to A subvolume, and on whatever
schedule you want:

btrfs sub snap -r A A.20190218-1412
btrfs sub snap -r A A.20190218-1850
btrfs sub snap -r A A.20190219-0920

And now you can "compare" the difference to master at anytime:

btrfs send -p A.20190218-master A.20190218-1850 -f output (or pipe to recei=
ve)

*shrug* I'm just not understanding what your use case gains out of
doing a refink copy to another subvolume rather than just make a read
only snapshot.

Is it that subvolume A must accept changes, but itself cannot be the
"master"? And you're selectively reflink copying files from A to B
such that B is the only "master"? That's fine but then I'd say you
don't need any A snapshots, you need B snapshots where:

btrfs sub snap -r B B.20190218-master
btrfs sub snap -r B B.20190219-0920
btrfs send -p B.20190218-master B.20190219-0920 -f output (or pipe to recei=
ve)

And so on...

Anyway, my point isn't that you're doing it wrong. I'm jut not
understanding the advantage of doing it the way you're doing it; and
it should be clear by now that most people on the list aren't using
'btrfs send' to compute the difference between two otherwise unrelated
subvolumes.

Part of this *might* be because of how ZFS snapshots work, and Btrfs
users maybe just adopted the same logic due in large part to more
limitations on the ZFS implementation: snapshots are always read only,
incremental send is only done between snapshots of the same dataset,
datasets can't be deleted  until all snapshots are deleted, there are
no reflinks, and no doubt some things I'm forgetting.


--=20
Chris Murphy
