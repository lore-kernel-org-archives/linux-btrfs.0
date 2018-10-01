Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1944C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 15:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F71F208AE
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 15:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngSBwpvy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F71F208AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbeJAVyQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:54:16 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:43616 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729480AbeJAVyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 17:54:16 -0400
Received: by mail-ed1-f44.google.com with SMTP id a4-v6so703639eds.10;
        Mon, 01 Oct 2018 08:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cA92HunPxaAhNRagBL8gsB5bGQNXlgasg2aYTCTOIVc=;
        b=ngSBwpvyQ9ZiT5TMXE9DP8Wp9Y9qQhz0TxtgIXqNlzeX9s44D8tmvqLH+U5YFxQCjs
         QufgdMJ3KDbJVpKo7eUxMnYNYE9hkYmnHxnhgvrHxpr6lOrwIP/HBNBhREjmHGFWfhQO
         hlGYhWy4XDdxNE+dRg1qWDcngMBxuh1+hHan4BW2tGX+QTlleIqaswXL6tmKR+e2hqWM
         c4C1EXCNP8fClK6pwufzwjxJtqVA/sAJqCUZjDAphxFrmR4xhP0bYZsDkpraucbm/ZbF
         TKOfCkcbDkVk/NJZ0DrmTLlWyllktI6533CiQRC/Zn34O07mKzRAWKJa/dnmmQbckp1O
         6rWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cA92HunPxaAhNRagBL8gsB5bGQNXlgasg2aYTCTOIVc=;
        b=ihS61qcghuQNHf9+A1mPDYgAK2jySklP7uqDyaoTcAL+Ln+PX8+/ABXl+NMthdEzTz
         J88q9Rm7OWvJ6kTwHwUn65rhxwqoAfDP76ikQFVOSkJgyeXW/qZpeIei70LFVH7wl0M5
         A5MQdvANEICp5tvgvsp1q/lVruJv2qnIrLm9gxBOwFJUV/YybfyJjXv0QanHdhBDPMu4
         gfxkZHGoXY2xjOGB1mA6qMjbJ8pgC/2hg7YSrMpVSK7fdm6wcgoUfw75XsP23BwJRQio
         pR4TrbhUn4CM9rdLh9wWZotI5flgRJH3P/op1bcDb6rhwsgeGy8NSnMz33XX16XGIbVv
         INgw==
X-Gm-Message-State: ABuFfogcYRHrFCrqEttBlDXVcurvH91q9JOBOPPBjzDRZK6xJf6NODAw
        xz/eZGoc59waHvdlZM3wCGdg8a/PJsCKssNEmpT2GACf
X-Google-Smtp-Source: ACcGV609+4O1yjDzdOLrjit2irfLzpDeTW9MpDmDEHSWzwQ/ua8+pwnFOOZzN57Pc/lxf7mXW48Q9xpRvrQNjKKfDOM=
X-Received: by 2002:a17:906:118b:: with SMTP id n11-v6mr14901598eja.199.1538406957610;
 Mon, 01 Oct 2018 08:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
In-Reply-To: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
From:   Joshi <joshiiitr@gmail.com>
Date:   Mon, 1 Oct 2018 20:45:45 +0530
Message-ID: <CA+1E3rJmoeVGhokE0phbH1kv_+izT0W14ZijWnjVbU0PPqRwOg@mail.gmail.com>
Subject: Re: cross-fs copy support
To:     quwenruo.btrfs@gmx.com
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sorry if my post was not clear enough. I picked the term "cross-fs"
from the implementation of vfs_copy_file_range.
Below snippet, inside vfs_copy_file_range -
1578         /* this could be relaxed once a method supports cross-fs copie=
s */
1579         if (inode_in->i_sb !=3D inode_out->i_sb)
1580                 return -EXDEV;

And I was not trying reflink for copy, rather I just used example code
for copy_file_range syscall -
http://man7.org/linux/man-pages/man2/copy_file_range.2.html
This code creates a new file first, and later issues "copy_file_range"
for copying. I was trying this sort of copy among files residing on
btrfs, ext4, and xfs.
Although vfs_copy_file_range internally uses clone_file_range (which
would be true for btrfs and xfs).
On Mon, Oct 1, 2018 at 8:18 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
> > I was wondering about the cross-fs copy through copy_file_range.
>
> The term "cross-fs" looks pretty confusing.
>
> If you mean "cross-subvolume", then it should work without problem in btr=
fs.
>
> If you mean reflink across two different file systems (not matter the
> same fs type or not).
> Then it's impossible to work.
>
> Reflink (clone_file_range) works by inserting data pointers into the
> filesystem other than really copying the data.
> Thus if the source is outside of the fs, it's really impossible to work,
> as the source pointer/data is completely out of control of the dest fs.
>
> > It seems current implement has below check, that disables such copy.
> >
> > 1577         /* this could be relaxed once a method supports cross-fs c=
opies */
> > 1578         if (inode_in->i_sb !=3D inode_out->i_sb)
> > 1579                 return -EXDEV;
> >
> > May I know what are the thoughts behind disabling cross-fs copy?
> > Code has the comment "once a method supports", but that leaves me
> > wondering exactly what 'method' is expected, and from whom.
> >
> > I disabled the check, and copy across volumes seemed to work fine. At
> > least for a single file (1G size), with no data mismatch, and faster
> > speed than regular copy.
>
> Please provide the steps or script about how you did the reflink, in
> case I misunderstand your "cross-fs" definition.
>
> And just in case you're really doing cross filesystem reflink, please
> also run "btrfs check" on both fs.
>
> Thanks,
> Qu
>
>


--=20
Joshi
