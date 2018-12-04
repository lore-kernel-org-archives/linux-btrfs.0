Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F27CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 22:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D0C420850
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 22:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+8kD3by"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D0C420850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbeLDWdd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 17:33:33 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:33713 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbeLDWdc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 17:33:32 -0500
Received: by mail-it1-f195.google.com with SMTP id m8so12542468itk.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 14:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KJqqv7SzGbe1Qkku1riKWJgd9qqG6MwbK9qMKd/VTrA=;
        b=V+8kD3by5p0DkC7kaQF8sR/OQdqxJHs1E2o1pwwvBdNYDPzhqTboA+OVMPshVJeU3b
         FCpflmjSosqqwkCosgCpiGBIoTs/wyjg+P8/Ft35hY6BiA7wJWn0fOFxddR9v//uGDa4
         omSvoTUUik4UwnPgr9xWqlXi236ef9+h9DGuh1QqqbNE5S1cDRi0LQafJZFH5z+1Bu6m
         KLbyQPOVT5etTg5R0GniFXQ5EQlvRXl4+W6mD9EK0DjQG4EtGBnHXffWgHrK1+IJ6hIo
         DImWcnteYaO3Cyu2jQnTcN5wotUskLcia+tuoLdoiy0pbg9tpv85UtZgJYHP1ZLQqlqA
         ZAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KJqqv7SzGbe1Qkku1riKWJgd9qqG6MwbK9qMKd/VTrA=;
        b=KkFgn/TpsM9ZCk0wfFxT9eYMhc4kMI+yue1idtMxsTaMAR3a0bHVBpiNDxcFB68jLT
         Eg9BUOMAjWSC+yvHVq07KRqE7UOZSy58yPsS+OeON0iKHPJyXdOt2i9hY0t5jPyImaEi
         n6wK5DdPrgIGnR2DY/XDhYDbLC9alqV1DW4VNX+nv/vx00nFSIH9L+WjvSJR8SmFqhg9
         RAPkr1zG/O+oqHYg+huyO325M8UtgWV855RhSpSzBoouYAHYg2QB7qSo6zjv3P0xCPVN
         gjn+ViXpqoficyfy/aPxUf6lxcf6/ZQL460YvbT6PJt2zxdVaofZlSxNaTC8ojbgy5k8
         W0/Q==
X-Gm-Message-State: AA+aEWZmkxRu0uxSAv9Hj6pjzAghW0nd+O4VWcDyui9IdHToLBxzHKtD
        FjTczEyENMy7aCqHFtldO1Fhjbx2FFbf/Xy6oRmLAAfXdko=
X-Google-Smtp-Source: AFSGD/XM+21/bFyfL90Klr4sVK29bVe3YfH3R5cLvzBgaHD12/e+pNAs7ExqAxNJfG1T5QHsF57DUjKETek5j032VhE=
X-Received: by 2002:a24:3c3:: with SMTP id e186mr12158254ite.155.1543962811396;
 Tue, 04 Dec 2018 14:33:31 -0800 (PST)
MIME-Version: 1.0
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
 <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com>
In-Reply-To: <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com>
From:   Mike Javorski <mike.javorski@gmail.com>
Date:   Tue, 4 Dec 2018 14:33:19 -0800
Message-ID: <CAOv1SKA=psv4wu18YiWy89UAB-R+o5+2qt9jvu6TKjf9EeOvNA@mail.gmail.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 4, 2018 at 2:18 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/12/4 =E4=B8=8A=E5=8D=8811:32, Mike Javorski wrote:
> > Need a bit of advice here ladies / gents. I am running into an issue
> > which Qu Wenruo seems to have posted a patch for several weeks ago
> > (see https://patchwork.kernel.org/patch/10694997/).
> >
> > Here is the relevant dmesg output which led me to Qu's patch.
> > ----
> > [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=3D2
> > block=3D24655027060736 slot=3D20 bg_start=3D13188988928 bg_len=3D108045=
27104,
> > invalid block group size, have 10804527104 expect (0, 10737418240]
> > [   10.032493] BTRFS error (device sdb): failed to read block groups: -=
5
> > [   10.053365] BTRFS error (device sdb): open_ctree failed
> > ----
>
> Exactly the same symptom.
>
> >
> > This server has a 16 disk btrfs filesystem (RAID6) which I boot
> > periodically to btrfs-send snapshots to. This machine is running
> > ArchLinux and I had just updated  to their latest 4.19.4 kernel
> > package (from 4.18.10 which was working fine). I've tried updating to
> > the 4.19.6 kernel that is in testing, but that doesn't seem to resolve
> > the issue. From what I can see on kernel.org, the patch above is not
> > pushed to stable or to Linus' tree.
> >
> > At this point the question is what to do. Is my FS toast?
>
> If there is no other problem at all, your fs is just fine.
> It's my original patch too sensitive (the excuse for not checking chunk
> allocator carefully enough).
>
> But since you have the down time, it's never a bad idea to run a btrfs
> check --readonly to see if your fs is really OK.
>

After running for 4 hours...

UUID: 25b16375-b90b-408e-b592-fb07ed116d58
[1/7] checking root items
[2/7] checking extents
[3/7] checking free space cache
[4/7] checking fs roots
[5/7] checking only csums items (without verifying data)
[6/7] checking root refs
[7/7] checking quota groups
found 24939616169984 bytes used, no error found
total csum bytes: 24321980768
total tree bytes: 41129721856
total fs tree bytes: 9854648320
total extent tree bytes: 737804288
btree space waste bytes: 7483785005
file data blocks allocated: 212883520618496
 referenced 212876546314240

So things appear good to go. I will keep an eye out for the patch to
land before upgrading the kernel again.

> > Could I
> > revert to the 4.18.10 kernel and boot safely?
>
> If your btrfs check --readonly doesn't report any problem, then you're
> completely fine to do so.
> Although I still recommend to go RAID10 other than RAID5/6.

I understand the risk, but don't have the funds to buy sufficient
disks to operate in RAID10. The data is mostly large files and
activity is predominantly reads, so risk is currently acceptable given
the backup server. All super critical data is backed up to (very slow)
cloud storage.

>
> Thanks,
> Qu
>
> > I don't know if the 4.19
> > boot process may have flipped some bits which would make reverting
> > problematic.
> >
> > Thanks much,
> >
> > - mike
> >
>
